unit u_MapLayerTileGrid;

interface

uses
  Types,
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_ViewPortState,
  i_LocalCoordConverter,
  i_MapLayerGridsConfig,
  u_MapLayerBasic;

type
  TMapLayerTileGrid = class(TMapLayerBasicNoBitmap)
  private
    FConfig: ITileGridConfig;
    procedure OnConfigChange(Sender: TObject);
  protected
    function GetVisibleForNewPos(ANewVisualCoordConverter: ILocalCoordConverter): Boolean; override;
    procedure PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter); override;
  public
    procedure StartThreads; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState; AConfig: ITileGridConfig);
  end;

implementation

uses
  SysUtils,
  i_CoordConverter,
  u_NotifyEventListener;

{ TMapLayerTileGrid }

constructor TMapLayerTileGrid.Create(AParentMap: TImage32;
  AViewPortState: IViewPortState; AConfig: ITileGridConfig);
begin
  inherited Create(AParentMap, AViewPortState);
  FConfig := AConfig;

  LinksList.Add(
    TNotifyEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );
end;

function TMapLayerTileGrid.GetVisibleForNewPos(
  ANewVisualCoordConverter: ILocalCoordConverter): Boolean;
var
  VConverter: ILocalCoordConverter;
  VGeoConverter: ICoordConverter;
  VZoom: Byte;
  VTileGridZoom: Byte;
begin
  Result := false;
  VConverter := ANewVisualCoordConverter;
  if VConverter <> nil then begin
    VGeoConverter := VConverter.GetGeoConverter;
    VZoom := VConverter.GetZoom;
    FConfig.LockRead;
    try
      if FConfig.Visible then begin
        if FConfig.UseRelativeZoom then begin
          VTileGridZoom := VZoom + FConfig.Zoom;
        end else begin
          VTileGridZoom := FConfig.Zoom;
        end;
        if VGeoConverter.CheckZoom(VTileGridZoom) then begin
          Result := (VTileGridZoom >= VZoom - 2) and (VTileGridZoom <= VZoom + 5);
        end;
      end;
    finally
      FConfig.UnlockRead;
    end;
  end;
end;

procedure TMapLayerTileGrid.OnConfigChange(Sender: TObject);
begin
  ViewUpdateLock;
  try
    SetNeedRedraw;
    SetVisible(GetVisibleForNewPos(ViewPortState.GetVisualCoordConverter));
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TMapLayerTileGrid.PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter);
var
  i, j: integer;
  VVisible: Boolean;
  VColor: TColor32;
  VLoadedRect: TDoubleRect;
  VLoadedRelativeRect: TDoubleRect;
  VCurrentZoom: Byte;
  VTilesRect: TRect;
  VTileRelativeRect: TDoubleRect;
  VTileRect: TRect;
  VTileScreenRect: TRect;
  VGridZoom: Byte;
  VTilesLineRect: TRect;
  VGeoConvert: ICoordConverter;
  VLocalRect: TRect;
begin
  inherited;
  VGeoConvert := ALocalConverter.GetGeoConverter;
  VCurrentZoom := ALocalConverter.GetZoom;

  FConfig.LockRead;
  try
    VVisible := FConfig.Visible;
    VColor := FConfig.GridColor;
    if FConfig.UseRelativeZoom then begin
      VGridZoom := VCurrentZoom + FConfig.Zoom;
    end else begin
      VGridZoom := FConfig.Zoom;
    end;
  finally
    FConfig.UnlockRead;
  end;
  if VVisible then begin
    VLocalRect := ALocalConverter.GetLocalRect;
    VLoadedRect := ALocalConverter.LocalRect2MapRectFloat(VLocalRect);
    VGeoConvert.CheckPixelRectFloat(VLoadedRect, VCurrentZoom);

    VLoadedRelativeRect := VGeoConvert.PixelRectFloat2RelativeRect(VLoadedRect, VCurrentZoom);
    VTilesRect := VGeoConvert.RelativeRect2TileRect(VLoadedRelativeRect, VGridZoom);

    VTilesLineRect.Left := VTilesRect.Left;
    VTilesLineRect.Right := VTilesRect.Right;
    for i := VTilesRect.Top to VTilesRect.Bottom do begin
      VTilesLineRect.Top := i;
      VTilesLineRect.Bottom := i;

      VTileRelativeRect := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, VGridZoom);
      VTileRect := VGeoConvert.RelativeRect2PixelRect(VTileRelativeRect, VCurrentZoom);
      VTileScreenRect.TopLeft := ALocalConverter.MapPixel2LocalPixel(VTileRect.TopLeft);
      VTileScreenRect.BottomRight := ALocalConverter.MapPixel2LocalPixel(VTileRect.BottomRight);

      VTileScreenRect.Left := VLocalRect.Left;
      VTileScreenRect.Right := VLocalRect.Right;

      if VTileScreenRect.Top < VLocalRect.Top then begin
        VTileScreenRect.Top := VLocalRect.Top;
        VTileScreenRect.Bottom := VTileScreenRect.Top;
      end;

      if VTileScreenRect.Top > VLocalRect.Bottom then begin
        VTileScreenRect.Top := VLocalRect.Bottom;
        VTileScreenRect.Bottom := VTileScreenRect.Top;
      end;

      ABuffer.LineTS(VTileScreenRect.Left, VTileScreenRect.Top,
        VTileScreenRect.Right, VTileScreenRect.Top, VColor);
    end;

    VTilesLineRect.Top := VTilesRect.Top;
    VTilesLineRect.Bottom := VTilesRect.Bottom;
    for j := VTilesRect.Left to VTilesRect.Right do begin
      VTilesLineRect.Left := j;
      VTilesLineRect.Right := j;

      VTileRelativeRect := VGeoConvert.TileRect2RelativeRect(VTilesLineRect, VGridZoom);
      VTileRect := VGeoConvert.RelativeRect2PixelRect(VTileRelativeRect, VCurrentZoom);
      VTileScreenRect.TopLeft := ALocalConverter.MapPixel2LocalPixel(VTileRect.TopLeft);
      VTileScreenRect.BottomRight := ALocalConverter.MapPixel2LocalPixel(VTileRect.BottomRight);

      VTileScreenRect.Top := VLocalRect.Top;
      VTileScreenRect.Bottom := VLocalRect.Bottom;

      if VTileScreenRect.Left < VLocalRect.Left then begin
        VTileScreenRect.Left := VLocalRect.Left;
        VTileScreenRect.Right := VTileScreenRect.Left;
      end;

      if VTileScreenRect.Left > VLocalRect.Right then begin
        VTileScreenRect.Left := VLocalRect.Right;
        VTileScreenRect.Right := VTileScreenRect.Left;
      end;

      ABuffer.LineTS(VTileScreenRect.Left, VTileScreenRect.Top,
        VTileScreenRect.Left, VTileScreenRect.Bottom, VColor);
    end;
  end;
end;

procedure TMapLayerTileGrid.StartThreads;
begin
  inherited;
  OnConfigChange(nil);
end;

end.