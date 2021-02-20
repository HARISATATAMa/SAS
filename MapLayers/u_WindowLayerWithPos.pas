unit u_WindowLayerWithPos;

interface

uses
  Windows,
  GR32,
  GR32_Layers,
  GR32_Image,
  i_LocalCoordConverter,
  i_ViewPortState,
  u_WindowLayerBasic;

type
  TWindowLayerBasic = class(TWindowLayerAbstract)
  private
    FVisible: Boolean;
    FLayer: TPositionedLayer;
  protected
    function GetVisible: Boolean; virtual;
    procedure SetVisible(const Value: Boolean); virtual;

    function GetVisibleForNewPos(ANewVisualCoordConverter: ILocalCoordConverter): Boolean; virtual;
    procedure PosChange(ANewVisualCoordConverter: ILocalCoordConverter); override;

    procedure UpdateLayerLocation(ANewLocation: TFloatRect); virtual;
    procedure DoUpdateLayerLocation(ANewLocation: TFloatRect); virtual;
    procedure DoShow; virtual;
    procedure DoHide; virtual;
    procedure DoRedraw; virtual; abstract;
    function GetMapLayerLocationRect: TFloatRect; virtual; abstract;

    property LayerPositioned: TPositionedLayer read FLayer;
    property Visible: Boolean read GetVisible write SetVisible;
  protected
    procedure AfterPosChange; override;
  public
    constructor Create(ALayer: TPositionedLayer; AViewPortState: IViewPortState);
    destructor Destroy; override;
    procedure Redraw; virtual;
    procedure Show; virtual;
    procedure Hide; virtual;
  end;

  TWindowLayerWithBitmap = class(TWindowLayerBasic)
  protected
    FLayer: TBitmapLayer;
    procedure UpdateLayerSize(ANewVisualCoordConverter: ILocalCoordConverter); virtual;
    procedure DoUpdateLayerSize(ANewSize: TPoint); virtual;
    function GetLayerSizeForViewSize(ANewVisualCoordConverter: ILocalCoordConverter): TPoint; virtual; abstract;
  protected
    procedure DoShow; override;
    procedure AfterPosChange; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState);
  end;

  TWindowLayerFixedSizeWithBitmap = class(TWindowLayerWithBitmap)
  protected
    function GetLayerSizeForViewSize(ANewVisualCoordConverter: ILocalCoordConverter): TPoint; override;
    procedure DoRedraw; override;
  end;

implementation

uses
  Types,
  Graphics;

{ TWindowLayerBasic }

procedure TWindowLayerBasic.AfterPosChange;
begin
  inherited;
  UpdateLayerLocation(GetMapLayerLocationRect);
end;

constructor TWindowLayerBasic.Create(ALayer: TPositionedLayer; AViewPortState: IViewPortState);
begin
  inherited Create(AViewPortState);
  FLayer := ALayer;

  FLayer.MouseEvents := false;
  FLayer.Visible := false;
  FVisible := False;
end;

destructor TWindowLayerBasic.Destroy;
begin
  FLayer := nil;
  inherited;
end;

procedure TWindowLayerBasic.DoHide;
begin
  FVisible := False;
  FLayer.Visible := False;
end;

procedure TWindowLayerBasic.DoShow;
begin
  FVisible := True;
  FLayer.Visible := True;
end;

procedure TWindowLayerBasic.DoUpdateLayerLocation(ANewLocation: TFloatRect);
begin
  FLayer.Location := ANewLocation;
end;

function TWindowLayerBasic.GetVisible: Boolean;
begin
  Result := FVisible;
end;

function TWindowLayerBasic.GetVisibleForNewPos(
  ANewVisualCoordConverter: ILocalCoordConverter): Boolean;
begin
  Result := FVisible;
end;

procedure TWindowLayerBasic.Hide;
begin
  if FVisible then begin
    DoHide;
  end;
end;

procedure TWindowLayerBasic.PosChange(
  ANewVisualCoordConverter: ILocalCoordConverter
);
var
  VNewVisible: Boolean;
begin
  PreparePosChange(ANewVisualCoordConverter);
  VNewVisible := GetVisibleForNewPos(ANewVisualCoordConverter);
  SetVisible(VNewVisible);
  if Visible then begin
    AfterPosChange;
  end;
end;

procedure TWindowLayerBasic.UpdateLayerLocation(ANewLocation: TFloatRect);
begin
  if FVisible then begin
    DoUpdateLayerLocation(ANewLocation);
  end;
end;

procedure TWindowLayerBasic.Redraw;
var
  VPerformanceCounterBegin: Int64;
  VPerformanceCounterEnd: Int64;
  VPerformanceCounterFr: Int64;
  VUpdateTime: TDateTime;
begin
  if FVisible then begin
    try
      QueryPerformanceCounter(VPerformanceCounterBegin);
      DoRedraw;
    finally
      QueryPerformanceCounter(VPerformanceCounterEnd);
      QueryPerformanceFrequency(VPerformanceCounterFr);
      VUpdateTime := (VPerformanceCounterEnd - VPerformanceCounterBegin) / VPerformanceCounterFr/24/60/60;
      IncRedrawCounter(VUpdateTime);
    end;
  end;
end;

procedure TWindowLayerBasic.SetVisible(const Value: Boolean);
begin
  if Value then begin
    Show;
  end else begin
    Hide;
  end;
end;

procedure TWindowLayerBasic.Show;
begin
  if not Visible then begin
    DoShow;
    UpdateLayerLocation(GetMapLayerLocationRect);
  end;
end;

{ TWindowLayerWithBitmap }

constructor TWindowLayerWithBitmap.Create(AParentMap: TImage32;
  AViewPortState: IViewPortState);
begin
  FLayer := TBitmapLayer.Create(AParentMap.Layers);
  inherited Create(FLayer, AViewPortState);

  FLayer.Bitmap.DrawMode := dmBlend;
  FLayer.Bitmap.CombineMode := cmMerge;
  FLayer.bitmap.Font.Charset := RUSSIAN_CHARSET;
end;

procedure TWindowLayerWithBitmap.AfterPosChange;
begin
  inherited;
  UpdateLayerSize(VisualCoordConverter);
end;

procedure TWindowLayerWithBitmap.DoShow;
begin
  inherited;
  UpdateLayerSize(VisualCoordConverter);
end;

procedure TWindowLayerWithBitmap.DoUpdateLayerSize(ANewSize: TPoint);
begin
  FLayer.Bitmap.Lock;
  try
    FLayer.Bitmap.SetSize(ANewSize.X, ANewSize.Y);
  finally
    FLayer.Bitmap.Unlock;
  end;
end;

procedure TWindowLayerWithBitmap.UpdateLayerSize(ANewVisualCoordConverter: ILocalCoordConverter);
var
  VNewSize: TPoint;
begin
  if FVisible then begin
    VNewSize := GetLayerSizeForViewSize(ANewVisualCoordConverter);
    if (FLayer.Bitmap.Width <> VNewSize.X) or (FLayer.Bitmap.Height <> VNewSize.Y) then begin
      DoUpdateLayerSize(VNewSize);
      UpdateLayerLocation(GetMapLayerLocationRect);
    end;
  end;
end;

{ TWindowLayerFixedSizeWithBitmap }

procedure TWindowLayerFixedSizeWithBitmap.DoRedraw;
begin
  // ��-��������� ������ �� ������.
end;

function TWindowLayerFixedSizeWithBitmap.GetLayerSizeForViewSize(
  ANewVisualCoordConverter: ILocalCoordConverter): TPoint;
begin
  Result := Point(FLayer.Bitmap.Width, FLayer.Bitmap.Height);
end;

end.