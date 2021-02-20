unit u_SelectionLayer;

interface

uses
  Types,
  GR32,
  GR32_Polygons,
  GR32_Image,
  i_JclNotify,
  t_GeoTypes,
  i_ViewPortState,
  i_LocalCoordConverter,
  i_LastSelectionLayerConfig,
  i_LastSelectionInfo,
  u_MapLayerBasic;

type
  TSelectionLayer = class(TMapLayerBasicFullView)
  private
    FConfig: ILastSelectionLayerConfig;
    FLastSelectionInfo: ILastSelectionInfo;

    FLineColor: TColor32;
    FLineWidth: Integer;

    FSourcePolygon: TArrayOfDoublePoint;
    FPointsOnBitmap: TArrayOfDoublePoint;
    FPolygon: TPolygon32;
    FLinePolygon: TPolygon32;

    procedure PreparePolygon(ALocalConverter: ILocalCoordConverter);
    procedure PaintLayer(Sender: TObject; Buffer: TBitmap32);
    function LonLatArrayToVisualFloatArray(
      ALocalConverter: ILocalCoordConverter;
      APolygon: TArrayOfDoublePoint
    ): TArrayOfDoublePoint;
    procedure OnChangeSelection(Sender: TObject);
    procedure OnConfigChange(Sender: TObject);
  protected
    procedure DoRedraw; override;
    procedure DoScaleChange(ANewVisualCoordConverter: ILocalCoordConverter); override;
    procedure AfterPosChange; override;
  public
    procedure StartThreads; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState; AConfig: ILastSelectionLayerConfig; ALastSelectionInfo: ILastSelectionInfo);
    destructor Destroy; override;    
  end;


implementation

uses
  SysUtils,
  GR32_Layers,
  i_CoordConverter,
  u_NotifyEventListener,
  u_ClipPolygonByRect;

{ TSelectionLayer }

constructor TSelectionLayer.Create(
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  AConfig: ILastSelectionLayerConfig;
  ALastSelectionInfo: ILastSelectionInfo
);
begin
  inherited Create(TPositionedLayer.Create(AParentMap.Layers), AViewPortState);
  FConfig := AConfig;
  FLastSelectionInfo := ALastSelectionInfo;

  FPolygon := TPolygon32.Create;
  FPolygon.Closed := True;
  FPolygon.Antialiased := true;
  FPolygon.AntialiasMode := am4times;

  FLinePolygon := TPolygon32.Create;

  LinksList.Add(
    TNotifyEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );
  LinksList.Add(
    TNotifyEventListener.Create(Self.OnChangeSelection),
    FLastSelectionInfo.GetChangeNotifier
  );
end;

destructor TSelectionLayer.Destroy;
begin
  FreeAndNil(FLinePolygon);
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TSelectionLayer.AfterPosChange;
begin
  inherited;
  Redraw;
end;

procedure TSelectionLayer.DoRedraw;
begin
  inherited;
  FSourcePolygon := Copy(FLastSelectionInfo.Polygon);
  PreparePolygon(VisualCoordConverter);
  LayerPositioned.Changed;
end;

procedure TSelectionLayer.DoScaleChange(
  ANewVisualCoordConverter: ILocalCoordConverter);
begin
  inherited;
  Redraw;
end;

function TSelectionLayer.LonLatArrayToVisualFloatArray(
  ALocalConverter: ILocalCoordConverter;
  APolygon: TArrayOfDoublePoint
): TArrayOfDoublePoint;
var
  i: Integer;
  VPointsCount: Integer;
  VCoordConverter: ICoordConverter;
  VLonLat: TDoublePoint;
begin
  VCoordConverter := ALocalConverter.GetGeoConverter;
  VPointsCount := Length(APolygon);
  SetLength(Result, VPointsCount);
  for i := 0 to VPointsCount - 1 do begin
    VLonLat := APolygon[i];
    VCoordConverter.CheckLonLatPos(VLonLat);
    Result[i] := ALocalConverter.LonLat2LocalPixelFloat(VLonLat);
  end;
end;

procedure TSelectionLayer.OnConfigChange(Sender: TObject);
var
  VVisible: Boolean;
begin
  FConfig.LockRead;
  try
    VVisible := FConfig.Visible;
    FLineWidth := FConfig.LineWidth;
    FLineColor := FConfig.LineColor
  finally
    FConfig.UnlockRead;
  end;

  if VVisible then begin
    Redraw;
    Show;
  end else begin
    Hide;
  end;
end;

procedure TSelectionLayer.OnChangeSelection(Sender: TObject);
begin
  Redraw;
end;

procedure TSelectionLayer.PaintLayer(Sender: TObject; Buffer: TBitmap32);
var
  VPointsCount: Integer;
begin
  VPointsCount := Length(FPointsOnBitmap);
  if VPointsCount > 0 then begin
    if FLinePolygon <> nil then begin
      FLinePolygon.DrawFill(Buffer, FLineColor);
    end;
  end;
end;

procedure TSelectionLayer.PreparePolygon(ALocalConverter: ILocalCoordConverter);
var
  VPointsCount: Integer;
  VPolygonOutline: TPolygon32;
  VPolygonGrow: TPolygon32;
  i: Integer;
  VPathFixedPoints: TArrayOfFixedPoint;
  VBitmapClip: IPolygonClip;
  VPointsProcessedCount: Integer;
  VPointsOnBitmapPrepared: TArrayOfDoublePoint;
  VLocalRect: TRect;
begin
  VPointsCount := Length(FSourcePolygon);
  if VPointsCount > 0 then begin
    VLocalRect := ALocalConverter.GetLocalRect;
    Dec(VLocalRect.Left, 10);
    Dec(VLocalRect.Top, 10);
    Inc(VLocalRect.Right, 10);
    Inc(VLocalRect.Bottom, 10);
    VBitmapClip := TPolygonClipByRect.Create(VLocalRect);
    FPointsOnBitmap := LonLatArrayToVisualFloatArray(ALocalConverter, FSourcePolygon);
    FPolygon.Clear;
    FLinePolygon.Clear;
    VPointsProcessedCount := VBitmapClip.Clip(FPointsOnBitmap[0], VPointsCount, VPointsOnBitmapPrepared);
    if VPointsProcessedCount > 0 then begin
      SetLength(VPathFixedPoints, VPointsProcessedCount);
      for i := 0 to VPointsProcessedCount - 1 do begin
        VPathFixedPoints[i] := FixedPoint(VPointsOnBitmapPrepared[i].X, VPointsOnBitmapPrepared[i].Y);
      end;
      FPolygon.AddPoints(VPathFixedPoints[0], VPointsProcessedCount);

      VPolygonOutline := FPolygon.Outline;
      try
        VPolygonGrow := VPolygonOutline.Grow(Fixed(FLineWidth / 2), 0.5);
        try
          FLinePolygon.Assign(VPolygonGrow);
        finally
          VPolygonGrow.Free;
        end;
      finally
        VPolygonOutline.Free;
      end;
    end;
  end;
end;

procedure TSelectionLayer.StartThreads;
begin
  inherited;
  OnConfigChange(nil);
  LayerPositioned.OnPaint := PaintLayer;
end;

end.