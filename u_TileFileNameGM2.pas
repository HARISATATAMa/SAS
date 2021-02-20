unit u_TileFileNameGM2;

interface

uses
  Types,
  i_TileFileNameGenerator;

type
  TTileFileNameGM2 = class(TInterfacedObject, ITileFileNameGenerator)
  public
    function GetTileFileName(AXY: TPoint; Azoom: byte): string;
  end;

implementation

uses
  SysUtils;

{ TTileFileNameGM2 }

function TTileFileNameGM2.GetTileFileName(AXY: TPoint;
  Azoom: byte): string;
begin
  result := format('z%d' + PathDelim + '%d_%d', [
    Azoom,
    AXY.y,
    AXY.x
    ]);
end;

end.