unit u_CoordConverterAbstract;

interface

uses
  Types,
  t_GeoTypes,
  i_Datum,
  i_CoordConverter;

type
  TCoordConverterAbstract = class(TInterfacedObject, ICoordConverter)
  protected
    FDatum: IDatum;
    FProjEPSG: integer;
    FCellSizeUnits: TCellSizeUnits;

    procedure CheckZoomInternal(var AZoom: Byte); virtual; stdcall; abstract;

    procedure CheckPixelPosInternal(var XY: TPoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckPixelPosStrictInternal(var XY: TPoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckPixelPosFloatInternal(var XY: TDoublePoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckPixelRectInternal(var XY: TRect; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckPixelRectFloatInternal(var XY: TDoubleRect; var Azoom: byte); virtual; stdcall; abstract;

    procedure CheckTilePosInternal(var XY: TPoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckTilePosStrictInternal(var XY: TPoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckTilePosFloatInternal(var XY: TDoublePoint; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckTileRectInternal(var XY: TRect; var Azoom: byte); virtual; stdcall; abstract;
    procedure CheckTileRectFloatInternal(var XY: TDoubleRect; var Azoom: byte); virtual; stdcall; abstract;

    procedure CheckRelativePosInternal(var XY: TDoublePoint); virtual; stdcall; abstract;
    procedure CheckRelativeRectInternal(var XY: TDoubleRect); virtual; stdcall; abstract;

    procedure CheckLonLatPosInternal(var XY: TDoublePoint); virtual; stdcall; abstract;
    procedure CheckLonLatRectInternal(var XY: TDoubleRect); virtual; stdcall; abstract;

    function LonLat2MetrInternal(const Ll: TDoublePoint): TDoublePoint; virtual; stdcall; abstract;

    function TilesAtZoomInternal(AZoom: byte): Longint; virtual; stdcall; abstract;
    function TilesAtZoomFloatInternal(AZoom: byte): Double; virtual; stdcall; abstract;
    function PixelsAtZoomInternal(AZoom: byte): Longint; virtual; stdcall; abstract;
    function PixelsAtZoomFloatInternal(AZoom: byte): Double; virtual; stdcall; abstract;


    function PixelPos2TilePosInternal(const XY: TPoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function PixelPos2TilePosFloatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function PixelPos2RelativeInternal(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function PixelPos2LonLatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;

    function PixelPosFloat2PixelPosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function PixelPosFloat2TilePosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function PixelPosFloat2TilePosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function PixelPosFloat2RelativeInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function PixelPosFloat2LonLatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;

    function PixelRect2TileRectInternal(const XY: TRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function PixelRect2TileRectFloatInternal(const XY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function PixelRect2RelativeRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function PixelRect2LonLatRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;

    function PixelRectFloat2PixelRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function PixelRectFloat2TileRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function PixelRectFloat2TileRectFloatInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function PixelRectFloat2RelativeRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function PixelRectFloat2LonLatRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;

    function TilePos2PixelPosInternal(const XY: TPoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function TilePos2PixelRectInternal(const XY: TPoint; Azoom: byte): TRect; virtual; stdcall; abstract;
    function TilePos2LonLatRectInternal(const XY: TPoint; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function TilePos2LonLatInternal(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function TilePos2RelativeInternal(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function TilePos2RelativeRectInternal(const XY: TPoint; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;

    function TilePosFloat2TilePosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function TilePosFloat2PixelPosInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function TilePosFloat2PixelPosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function TilePosFloat2RelativeInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function TilePosFloat2LonLatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;

    function TileRect2PixelRectInternal(const XY: TRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function TileRect2RelativeRectInternal(const XY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function TileRect2LonLatRectInternal(const XY: TRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;

    function TileRectFloat2TileRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function TileRectFloat2PixelRectInternal(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall; abstract;
    function TileRectFloat2PixelRectFloatInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function TileRectFloat2RelativeRectInternal(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function TileRectFloat2LonLatRectInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;

    function Relative2PixelInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function Relative2PixelPosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function Relative2TileInternal(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function Relative2TilePosFloatInternal(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function Relative2LonLatInternal(const XY: TDoublePoint): TDoublePoint; virtual; stdcall; abstract;

    function RelativeRect2LonLatRectInternal(const XY: TDoubleRect): TDoubleRect; virtual; stdcall; abstract;
    function RelativeRect2TileRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall; abstract;
    function RelativeRect2TileRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function RelativeRect2PixelRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall; abstract;
    function RelativeRect2PixelRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;


    function LonLat2PixelPosInternal(const Ll: TDoublePoint; Azoom: byte): Tpoint; virtual; stdcall; abstract;
    function LonLat2PixelPosFloatInternal(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function LonLat2TilePosInternal(const Ll: TDoublePoint; Azoom: byte): Tpoint; virtual; stdcall; abstract;
    function LonLat2TilePosFloatInternal(const Ll: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall; abstract;
    function LonLat2RelativeInternal(const XY: TDoublePoint): TDoublePoint; virtual; stdcall; abstract;

    function LonLatRect2RelativeRectInternal(const XY: TDoubleRect): TDoubleRect; virtual; stdcall; abstract;
    function LonLatRect2PixelRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall; abstract;
    function LonLatRect2PixelRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;
    function LonLatRect2TileRectInternal(const XY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall; abstract;
    function LonLatRect2TileRectFloatInternal(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall; abstract;
  public
    constructor Create(ADatum: IDatum);
    function GetDatum: IDatum; stdcall;

    function TilesAtZoom(AZoom: byte): Longint; stdcall;
    function TilesAtZoomFloat(AZoom: byte): Double; stdcall;
    function PixelsAtZoom(AZoom: byte): Longint; stdcall;
    function PixelsAtZoomFloat(AZoom: byte): Double; stdcall;


    function PixelPos2LonLat(const AXY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function PixelPos2TilePos(const AXY: TPoint; Azoom: byte): TPoint; virtual; stdcall;
    function PixelPos2Relative(const AXY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function PixelPos2TilePosFloat(const XY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;

    function PixelPosFloat2PixelPos(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function PixelPosFloat2TilePos(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function PixelPosFloat2TilePosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function PixelPosFloat2Relative(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function PixelPosFloat2LonLat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;

    function PixelRect2TileRect(const AXY: TRect; AZoom: byte): TRect; virtual; stdcall;
    function PixelRect2RelativeRect(const AXY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function PixelRect2LonLatRect(const AXY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function PixelRect2TileRectFloat(const XY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall;

    function PixelRectFloat2PixelRect(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall;
    function PixelRectFloat2TileRect(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall;
    function PixelRectFloat2TileRectFloat(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function PixelRectFloat2RelativeRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function PixelRectFloat2LonLatRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall;

    function TilePos2PixelPos(const AXY: TPoint; Azoom: byte): TPoint; virtual; stdcall;
    function TilePos2PixelRect(const AXY: TPoint; Azoom: byte): TRect; virtual; stdcall;
    function TilePos2LonLatRect(const AXY: TPoint; Azoom: byte): TDoubleRect; virtual; stdcall;
    function TilePos2LonLat(const AXY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function TilePos2Relative(const AXY: TPoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function TilePos2RelativeRect(const AXY: TPoint; Azoom: byte): TDoubleRect; virtual; stdcall;

    function TilePosFloat2TilePos(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function TilePosFloat2PixelPos(const XY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function TilePosFloat2PixelPosFloat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function TilePosFloat2Relative(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function TilePosFloat2LonLat(const XY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;

    function TileRect2PixelRect(const AXY: TRect; AZoom: byte): TRect; virtual; stdcall;
    function TileRect2RelativeRect(const AXY: TRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function TileRect2LonLatRect(const AXY: TRect; Azoom: byte): TDoubleRect; virtual; stdcall;

    function TileRectFloat2TileRect(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall;
    function TileRectFloat2PixelRect(const XY: TDoubleRect; AZoom: byte): TRect; virtual; stdcall;
    function TileRectFloat2PixelRectFloat(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function TileRectFloat2RelativeRect(const XY: TDoubleRect; AZoom: byte): TDoubleRect; virtual; stdcall;
    function TileRectFloat2LonLatRect(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall;

    function LonLat2PixelPos(const AXY: TDoublePoint; Azoom: byte): Tpoint; virtual; stdcall;
    function LonLat2PixelPosFloat(const AXY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function LonLat2TilePos(const AXY: TDoublePoint; Azoom: byte): Tpoint; virtual; stdcall;
    function LonLat2TilePosFloat(const AXY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function LonLat2Relative(const AXY: TDoublePoint): TDoublePoint; virtual; stdcall;

    function LonLatRect2RelativeRect(const AXY: TDoubleRect): TDoubleRect; virtual; stdcall;
    function LonLatRect2PixelRect(const AXY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall;//TODO: ��������
    function LonLatRect2PixelRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall;
    function LonLatRect2TileRect(const AXY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall;//TODO: ��������
    function LonLatRect2TileRectFloat(const XY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall;

    function Relative2Pixel(const AXY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function Relative2PixelPosFloat(const AXY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function Relative2Tile(const AXY: TDoublePoint; Azoom: byte): TPoint; virtual; stdcall;
    function Relative2TilePosFloat(const AXY: TDoublePoint; Azoom: byte): TDoublePoint; virtual; stdcall;
    function Relative2LonLat(const AXY: TDoublePoint): TDoublePoint; virtual; stdcall;

    function RelativeRect2LonLatRect(const AXY: TDoubleRect): TDoubleRect; virtual; stdcall;
    function RelativeRect2TileRect(const AXY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall;
    function RelativeRect2TileRectFloat(const AXY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall;
    function RelativeRect2PixelRect(const AXY: TDoubleRect; Azoom: byte): TRect; virtual; stdcall;
    function RelativeRect2PixelRectFloat(const AXY: TDoubleRect; Azoom: byte): TDoubleRect; virtual; stdcall;

    function LonLatArray2PixelArray(APolyg: TArrayOfDoublePoint; AZoom: byte): TArrayOfPoint; virtual; stdcall;
    function LonLatArray2PixelArrayFloat(APolyg: TArrayOfDoublePoint; AZoom: byte): TArrayOfDoublePoint; virtual; stdcall;

    function GetTileSize(const XY: TPoint; Azoom: byte): TPoint; virtual; stdcall; abstract;
    function PixelPos2OtherMap(XY: TPoint; Azoom: byte; AOtherMapCoordConv: ICoordConverter): TPoint; virtual; stdcall;

    function CheckZoom(var AZoom: Byte): boolean; virtual; stdcall; abstract;
    function CheckTilePos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckTilePosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckTileRect(var XY: TRect; var Azoom: byte): boolean; virtual; stdcall; abstract;

    function CheckPixelPos(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckPixelPosFloat(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckPixelPosStrict(var XY: TPoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckPixelPosFloatStrict(var XY: TDoublePoint; var Azoom: byte; ACicleMap: Boolean): boolean; virtual; stdcall; abstract;
    function CheckPixelRect(var XY: TRect; var Azoom: byte): boolean; virtual; stdcall; abstract;
    function CheckPixelRectFloat(var XY: TDoubleRect; var Azoom: byte): boolean; virtual; stdcall; abstract;

    function CheckRelativePos(var XY: TDoublePoint): boolean; virtual; stdcall; abstract;
    function CheckRelativeRect(var XY: TDoubleRect): boolean; virtual; stdcall; abstract;

    function CheckLonLatPos(var XY: TDoublePoint): boolean; virtual; stdcall; abstract;
    function CheckLonLatRect(var XY: TDoubleRect): boolean; virtual; stdcall; abstract;

    function GetProjectionEPSG: Integer; virtual; stdcall;
    function GetCellSizeUnits: TCellSizeUnits; virtual; stdcall;
    function GetTileSplitCode: Integer; virtual; stdcall; abstract;
    function IsSameConverter(AOtherMapCoordConv: ICoordConverter): Boolean; virtual; stdcall;

    function LonLat2Metr(const AXY: TDoublePoint): TDoublePoint; virtual; stdcall;
  end;

implementation

uses
  u_GeoFun,
  SysUtils;

{ TCoordConverterAbstract }

function TCoordConverterAbstract.LonLatArray2PixelArray(
  APolyg: TArrayOfDoublePoint; AZoom: byte): TArrayOfPoint;
var
  i: integer;
  VPoint: TDoublePoint;
begin
  SetLength(Result, length(APolyg));
  for i := 0 to length(APolyg) - 1 do begin
    VPoint := Apolyg[i];
    if PointIsEmpty(VPoint) then begin
      Result[i] := Point(MaxInt, MaxInt);
    end else begin
      CheckLonLatPosInternal(VPoint);
      Result[i] := LonLat2PixelPosInternal(VPoint, AZoom);
    end;
  end;
end;

function TCoordConverterAbstract.LonLatArray2PixelArrayFloat(
  APolyg: TArrayOfDoublePoint; AZoom: byte): TArrayOfDoublePoint;
var
  i: integer;
  VPoint: TDoublePoint;
begin
  SetLength(Result, length(APolyg));
  for i := 0 to length(APolyg) - 1 do begin
    VPoint := Apolyg[i];
    if PointIsEmpty(VPoint) then begin
      Result[i] := VPoint;
    end else begin
      CheckLonLatPosInternal(VPoint);
      Result[i] := LonLat2PixelPosFloatInternal(VPoint, AZoom);
    end;
  end;
end;

function TCoordConverterAbstract.PixelPos2OtherMap(XY: TPoint; Azoom: byte;
  AOtherMapCoordConv: ICoordConverter): TPoint;
var
  VLonLat: TDoublePoint;
begin
  if (Self = nil) or (AOtherMapCoordConv = nil) then begin
    Result := XY;
  end else begin
    if (AOtherMapCoordConv.GetTileSplitCode = Self.GetTileSplitCode) and
      (AOtherMapCoordConv.GetProjectionEPSG <> 0) and
      (Self.GetProjectionEPSG <> 0) and
      (AOtherMapCoordConv.GetProjectionEPSG = Self.GetProjectionEPSG) then begin
      Result := XY;
    end else begin
      CheckPixelPosInternal(XY, Azoom);
      VLonLat := PixelPos2LonLatInternal(XY, Azoom);
      AOtherMapCoordConv.CheckLonLatPos(VLonLat);
      Result := AOtherMapCoordConv.LonLat2PixelPos(VLonLat, Azoom);
    end;
  end;
end;


//------------------------------------------------------------------------------
function TCoordConverterAbstract.TilePos2PixelRect(const AXY: TPoint;
  Azoom: byte): TRect;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosStrictInternal(VXY, VZoom);
  Result := TilePos2PixelRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePos2LonLatRect(const AXY: TPoint;
  Azoom: byte): TDoubleRect;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosStrictInternal(VXY, VZoom);
  Result := TilePos2LonLatRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelsAtZoom(AZoom: byte): Longint;
var
  VZoom: Byte;
begin
  VZoom := AZoom;
  CheckZoomInternal(VZoom);
  Result := PixelsAtZoomInternal(Vzoom);
end;

function TCoordConverterAbstract.PixelsAtZoomFloat(AZoom: byte): Double;
var
  VZoom: Byte;
begin
  VZoom := AZoom;
  CheckZoomInternal(VZoom);
  Result := PixelsAtZoomFloatInternal(Vzoom);
end;

function TCoordConverterAbstract.TilesAtZoom(AZoom: byte): Longint;
var
  VZoom: Byte;
begin
  VZoom := AZoom;
  CheckZoomInternal(VZoom);
  Result := TilesAtZoomInternal(Vzoom);
end;

function TCoordConverterAbstract.TilesAtZoomFloat(AZoom: byte): Double;
var
  VZoom: Byte;
begin
  VZoom := AZoom;
  CheckZoomInternal(VZoom);
  Result := TilesAtZoomFloatInternal(Vzoom);
end;

function TCoordConverterAbstract.PixelPos2Relative(const AXY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelPosInternal(VXY, VZoom);
  Result := PixelPos2RelativeInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.Relative2LonLat(
  const AXY: TDoublePoint): TDoublePoint;
var
  VXY: TDoublePoint;
begin
  VXY := AXY;
  CheckRelativePosInternal(VXY);
  Result := Relative2LonLatInternal(VXY);
end;

function TCoordConverterAbstract.Relative2Pixel(const AXY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativePosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := Relative2PixelInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.Relative2PixelPosFloat(
  const AXY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativePosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := Relative2PixelPosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLat2Metr(
  const AXY: TDoublePoint): TDoublePoint;
var
  VXY: TDoublePoint;
begin
  VXY := AXY;
  CheckLonLatPosInternal(VXY);
  Result := LonLat2MetrInternal(VXY);
end;

function TCoordConverterAbstract.LonLat2PixelPos(const AXY: TDoublePoint;
  Azoom: byte): Tpoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatPosInternal(VXY);
  Result := LonLat2PixelPosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLat2PixelPosFloat(const AXY: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatPosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLat2PixelPosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPos2LonLat(const AXY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelPosInternal(VXY, VZoom);
  Result := PixelPos2LonLatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePos2LonLat(const AXY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosInternal(VXY, VZoom);
  Result := TilePos2LonLatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePos2Relative(const AXY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosInternal(VXY, VZoom);
  Result := TilePos2RelativeInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePos2RelativeRect(const AXY: TPoint;
  Azoom: byte): TDoubleRect;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosStrictInternal(VXY, VZoom);
  Result := TilePos2RelativeRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePosFloat2LonLat(const XY: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTilePosFloatInternal(VXY, VZoom);
  Result := TilePosFloat2LonLatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePosFloat2PixelPos(const XY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTilePosFloatInternal(VXY, VZoom);
  Result := TilePosFloat2PixelPosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePosFloat2PixelPosFloat(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTilePosFloatInternal(VXY, VZoom);
  Result := TilePosFloat2PixelPosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePosFloat2Relative(const XY: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTilePosFloatInternal(VXY, VZoom);
  Result := TilePosFloat2RelativeInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePosFloat2TilePos(const XY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTilePosFloatInternal(VXY, VZoom);
  Result := TilePosFloat2TilePosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLatRect2RelativeRect(
  const AXY: TDoubleRect): TDoubleRect;
var
  VXY: TDoubleRect;
begin
  VXY := AXY;
  CheckLonLatRectInternal(VXY);
  Result := LonLatRect2RelativeRectInternal(VXY);
end;

function TCoordConverterAbstract.Relative2Tile(const AXY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativePosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := Relative2TileInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.Relative2TilePosFloat(
  const AXY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativePosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := Relative2TilePosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.RelativeRect2LonLatRect(
  const AXY: TDoubleRect): TDoubleRect;
var
  VXY: TDoubleRect;
begin
  VXY := AXY;
  CheckRelativeRectInternal(VXY);
  Result := RelativeRect2LonLatRectInternal(VXY);
end;

function TCoordConverterAbstract.RelativeRect2PixelRect(const AXY: TDoubleRect;
  Azoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativeRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := RelativeRect2PixelRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.RelativeRect2PixelRectFloat(
  const AXY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativeRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := RelativeRect2PixelRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.RelativeRect2TileRect(const AXY: TDoubleRect;
  Azoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativeRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := RelativeRect2TileRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.RelativeRect2TileRectFloat(
  const AXY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckRelativeRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := RelativeRect2TileRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPos2TilePos(const AXY: TPoint;
  Azoom: byte): TPoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelPosInternal(VXY, VZoom);
  Result := PixelPos2TilePosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPos2TilePosFloat(const XY: TPoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelPosInternal(VXY, VZoom);
  Result := PixelPos2TilePosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPosFloat2LonLat(const XY: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelPosFloatInternal(VXY, VZoom);
  Result := PixelPosFloat2LonLatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPosFloat2PixelPos(
  const XY: TDoublePoint; Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelPosFloatInternal(VXY, VZoom);
  Result := PixelPosFloat2PixelPosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPosFloat2Relative(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelPosFloatInternal(VXY, VZoom);
  Result := PixelPosFloat2RelativeInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPosFloat2TilePos(const XY: TDoublePoint;
  Azoom: byte): TPoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelPosFloatInternal(VXY, VZoom);
  Result := PixelPosFloat2TilePosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelPosFloat2TilePosFloat(
  const XY: TDoublePoint; Azoom: byte): TDoublePoint;
begin

end;

function TCoordConverterAbstract.PixelRect2LonLatRect(const AXY: TRect;
  AZoom: byte): TDoubleRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelRectInternal(VXY, VZoom);
  Result := PixelRect2LonLatRectInternal(VXY, Vzoom);
end;


function TCoordConverterAbstract.PixelRect2TileRect(const AXY: TRect;
  AZoom: byte): TRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelRectInternal(VXY, VZoom);
  Result := PixelRect2TileRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRect2TileRectFloat(const XY: TRect;
  AZoom: byte): TDoubleRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectInternal(VXY, VZoom);
  Result := PixelRect2TileRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRectFloat2LonLatRect(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectFloatInternal(VXY, VZoom);
  Result := PixelRectFloat2LonLatRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRectFloat2PixelRect(
  const XY: TDoubleRect; AZoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectFloatInternal(VXY, VZoom);
  Result := PixelRectFloat2PixelRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRectFloat2RelativeRect(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectFloatInternal(VXY, VZoom);
  Result := PixelRectFloat2RelativeRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRectFloat2TileRect(
  const XY: TDoubleRect; AZoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectFloatInternal(VXY, VZoom);
  Result := PixelRectFloat2TileRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRectFloat2TileRectFloat(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckPixelRectFloatInternal(VXY, VZoom);
  Result := PixelRectFloat2TileRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRect2PixelRect(const AXY: TRect;
  AZoom: byte): TRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTileRectInternal(VXY, VZoom);
  Result := TileRect2PixelRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.PixelRect2RelativeRect(const AXY: TRect;
  AZoom: byte): TDoubleRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckPixelRectInternal(VXY, VZoom);
  Result := PixelRect2RelativeRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TilePos2PixelPos(const AXY: TPoint;
  Azoom: byte): TPoint;
var
  VXY: TPoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTilePosInternal(VXY, VZoom);
  Result := TilePos2PixelPosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLat2TilePos(const AXY: TDoublePoint;
  Azoom: byte): Tpoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatPosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLat2TilePosInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLat2TilePosFloat(const AXY: TDoublePoint;
  Azoom: byte): TDoublePoint;
var
  VXY: TDoublePoint;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatPosInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLat2TilePosFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLat2Relative(
  const AXY: TDoublePoint): TDoublePoint;
var
  VXY: TDoublePoint;
begin
  VXY := AXY;
  CheckLonLatPosInternal(VXY);
  Result := LonLat2RelativeInternal(VXY);
end;

function TCoordConverterAbstract.TileRect2LonLatRect(const AXY: TRect;
  Azoom: byte): TDoubleRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTileRectInternal(VXY, VZoom);
  Result := TileRect2LonLatRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRect2RelativeRect(const AXY: TRect;
  AZoom: byte): TDoubleRect;
var
  VXY: TRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckTileRectInternal(VXY, VZoom);
  Result := TileRect2RelativeRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRectFloat2LonLatRect(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTileRectFloatInternal(VXY, VZoom);
  Result := TileRectFloat2LonLatRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRectFloat2PixelRect(
  const XY: TDoubleRect; AZoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTileRectFloatInternal(VXY, VZoom);
  Result := TileRectFloat2PixelRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRectFloat2PixelRectFloat(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTileRectFloatInternal(VXY, VZoom);
  Result := TileRectFloat2PixelRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRectFloat2RelativeRect(
  const XY: TDoubleRect; AZoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTileRectFloatInternal(VXY, VZoom);
  Result := TileRectFloat2RelativeRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.TileRectFloat2TileRect(const XY: TDoubleRect;
  AZoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckTileRectFloatInternal(VXY, VZoom);
  Result := TileRectFloat2TileRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLatRect2TileRect(const AXY: TDoubleRect;
  Azoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLatRect2TileRectInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLatRect2TileRectFloat(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckLonLatRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLatRect2TileRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.LonLatRect2PixelRect(const AXY: TDoubleRect;
  Azoom: byte): TRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := AXY;
  VZoom := AZoom;
  CheckLonLatRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLatRect2PixelRectInternal(VXY, Vzoom);
end;


function TCoordConverterAbstract.LonLatRect2PixelRectFloat(
  const XY: TDoubleRect; Azoom: byte): TDoubleRect;
var
  VXY: TDoubleRect;
  VZoom: Byte;
begin
  VXY := XY;
  VZoom := AZoom;
  CheckLonLatRectInternal(VXY);
  CheckZoomInternal(VZoom);
  Result := LonLatRect2PixelRectFloatInternal(VXY, Vzoom);
end;

function TCoordConverterAbstract.GetDatum: IDatum;
begin
  Result := FDatum;
end;

function TCoordConverterAbstract.GetProjectionEPSG: Integer;
begin
  Result := FProjEPSG;
end;

constructor TCoordConverterAbstract.Create(ADatum: IDatum);
begin
  FDatum := ADatum;
end;

function TCoordConverterAbstract.GetCellSizeUnits: TCellSizeUnits;
begin
  Result := FCellSizeUnits;
end;

function TCoordConverterAbstract.IsSameConverter(
  AOtherMapCoordConv: ICoordConverter): Boolean;
begin
  Result :=
    (Self.GetTileSplitCode <> 0) and
    (AOtherMapCoordConv.GetTileSplitCode <> 0) and
    (AOtherMapCoordConv.GetTileSplitCode = Self.GetTileSplitCode) and
    (AOtherMapCoordConv.GetProjectionEPSG <> 0) and
    (Self.GetProjectionEPSG <> 0) and
    (AOtherMapCoordConv.GetProjectionEPSG = Self.GetProjectionEPSG);
end;

end.