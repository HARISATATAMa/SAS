unit i_CoordConverterFactory;

interface

uses
  i_CoordConverter,
  i_ConfigDataProvider;

type
  ICoordConverterFactory = interface
    ['{399F7734-B79E-44E0-9A5A-A6BA38E9125A}']
    function GetCoordConverterByConfig(AConfig: IConfigDataProvider): ICoordConverter;
    function GetCoordConverterByCode(AProjectionEPSG: Integer; ATileSplitCode: Integer): ICoordConverter;
  end;
implementation

end.