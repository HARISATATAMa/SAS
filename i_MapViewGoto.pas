unit i_MapViewGoto;

interface

uses
  t_GeoTypes;

type
  IMapViewGoto = interface
    ['{33FDD537-B089-4ED6-8AB4-720E47B3C8B8}']
    procedure GotoPos(ALonLat: TDoublePoint; AZoom: Byte);
  end;

implementation

end.
 