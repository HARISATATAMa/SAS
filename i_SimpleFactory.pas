unit i_SimpleFactory;

interface

type
  ISimpleFactory = interface
    ['{AD906C40-4D3F-4CEC-82EE-CCEDF23AF9DE}']
    function CreateInstance: IInterface;
  end;

implementation

end.
