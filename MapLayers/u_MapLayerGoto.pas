unit u_MapLayerGoto;

interface

uses
  Windows,
  Types,
  GR32,
  GR32_Image,
  t_GeoTypes,
  i_ViewPortState,
  u_MapLayerBasic;

type
  TGotoLayer = class(TMapLayerFixedWithBitmap)
  private
    FHideAfterTime: Cardinal;
    FGoToSelIcon: TCustomBitmap32;
  protected
    procedure DoUpdateLayerLocation(ANewLocation: TFloatRect); override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: IViewPortState);
    destructor Destroy; override;
    procedure ShowGotoIcon(APoint: TDoublePoint);
  end;



implementation

uses
  SysUtils,
  u_GlobalState;

{ TGotoLayer }

constructor TGotoLayer.Create(AParentMap: TImage32; AViewPortState: IViewPortState);
var
  VBitmapSize: TPoint;
begin
  inherited;
  FGoToSelIcon := TCustomBitmap32.Create;
  FGoToSelIcon.DrawMode := dmBlend;
  GState.LoadBitmapFromRes('ICONIII', FGoToSelIcon);
  VBitmapSize.X := FGoToSelIcon.Width;
  VBitmapSize.Y := FGoToSelIcon.Height;
  FLayer.Bitmap.Assign(FGoToSelIcon);
  FFixedOnBitmap.X := 7;
  FFixedOnBitmap.Y := 6;
  DoUpdateLayerSize(VBitmapSize);
end;

destructor TGotoLayer.Destroy;
begin
  FreeAndNil(FGoToSelIcon);
  inherited;
end;

procedure TGotoLayer.DoUpdateLayerLocation(ANewLocation: TFloatRect);
var
  VCurrTime: Cardinal;
begin
  if FHideAfterTime <> 0 then begin
    VCurrTime := GetTickCount;
    if (VCurrTime < FHideAfterTime) then begin
      if (VCurrTime < FHideAfterTime) then begin
        inherited;
      end else begin
        Visible := False;
      end;
    end else begin
      Visible := False;
    end;
  end else begin
    Visible := False;
  end;
end;

procedure TGotoLayer.ShowGotoIcon(APoint: TDoublePoint);
begin
  FFixedLonLat := APoint;
  FHideAfterTime := GetTickCount + 100000;
  Visible := True;
  UpdateLayerLocation;
end;

end.