unit i_PoolElement;

interface

uses
  Types;

type
  IPoolElement = interface
    ['{12ACB7F4-7806-46DC-9AE5-4117864856AF}']
    function GetLastUseTime: Cardinal;
    function GetObject: IUnknown;
  end;

implementation

end.