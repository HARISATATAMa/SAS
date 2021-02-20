unit u_ValueToStringConverterConfig;

interface

uses
  i_JclNotify,
  t_CommonTypes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ConfigDataElement,
  i_ValueToStringConverter,
  u_ConfigDataElementBase;

type
  TValueToStringConverterConfig = class(TConfigDataElementBase, IValueToStringConverterConfig)
  private
    FDependentOnElement: IConfigDataElement;
    FDependentOnElementListener: IJclListener;

    FDistStrFormat: TDistStrFormat;
    FIsLatitudeFirst: Boolean;
    FDegrShowFormat: TDegrShowFormat;
    FConverter: IValueToStringConverter;
    procedure OnDependentOnElementChange(Sender: TObject);
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
    procedure SetChanged; override;
  protected
    function GetDistStrFormat: TDistStrFormat;
    procedure SetDistStrFormat(AValue: TDistStrFormat);

    function GetIsLatitudeFirst: Boolean;
    procedure SetIsLatitudeFirst(AValue: Boolean);

    function GetDegrShowFormat: TDegrShowFormat;
    procedure SetDegrShowFormat(AValue: TDegrShowFormat);

    function GetStaticConverter: IValueToStringConverter;
  public
    constructor Create(ADependentOnElement: IConfigDataElement);
    destructor Destroy; override;
  end;


implementation

uses
  u_NotifyEventListener,
  u_ValueToStringConverter;

{ TValueToStringConverterConfig }

constructor TValueToStringConverterConfig.Create(ADependentOnElement: IConfigDataElement);
begin
  inherited Create;
  FIsLatitudeFirst := True;
  FDistStrFormat := dsfKmAndM;
  FDegrShowFormat := dshCharDegrMinSec;
  FDependentOnElement := ADependentOnElement;
  FDependentOnElementListener := TNotifyEventListener.Create(Self.OnDependentOnElementChange);
  FDependentOnElement.GetChangeNotifier.Add(FDependentOnElementListener);
  SetChanged;
end;

destructor TValueToStringConverterConfig.Destroy;
begin
  FDependentOnElement.GetChangeNotifier.Remove(FDependentOnElementListener);
  FDependentOnElementListener := nil;
  FDependentOnElement := nil;
  inherited;
end;

procedure TValueToStringConverterConfig.DoReadConfig(
  AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FIsLatitudeFirst := AConfigData.ReadBool('FirstLat', FIsLatitudeFirst);
    FDistStrFormat := TDistStrFormat(AConfigData.ReadInteger('DistFormat', Integer(FDistStrFormat)));
    FDegrShowFormat := TDegrShowFormat(AConfigData.ReadInteger('DegrisShowFormat', Integer(FDegrShowFormat)));
    SetChanged;
  end;
end;

procedure TValueToStringConverterConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteBool('FirstLat', FIsLatitudeFirst);
  AConfigData.WriteInteger('DistFormat', Integer(FDistStrFormat));
  AConfigData.WriteInteger('DegrisShowFormat', Integer(FDegrShowFormat));
end;

function TValueToStringConverterConfig.GetDegrShowFormat: TDegrShowFormat;
begin
  LockRead;
  try
    Result := FDegrShowFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetDistStrFormat: TDistStrFormat;
begin
  LockRead;
  try
    Result := FDistStrFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetIsLatitudeFirst: Boolean;
begin
  LockRead;
  try
    Result := FIsLatitudeFirst;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetStaticConverter: IValueToStringConverter;
begin
  LockRead;
  try
    Result := FConverter;
  finally
    UnlockRead;
  end;
end;

procedure TValueToStringConverterConfig.OnDependentOnElementChange(
  Sender: TObject);
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetChanged;
begin
  inherited;
  FConverter := TValueToStringConverter.Create(FDistStrFormat, FIsLatitudeFirst, FDegrShowFormat);
end;

procedure TValueToStringConverterConfig.SetDegrShowFormat(
  AValue: TDegrShowFormat);
begin
  LockWrite;
  try
    if FDegrShowFormat <> AValue then begin
      FDegrShowFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetDistStrFormat(
  AValue: TDistStrFormat);
begin
  LockWrite;
  try
    if FDistStrFormat <> AValue then begin
      FDistStrFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetIsLatitudeFirst(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsLatitudeFirst <> AValue then begin
      FIsLatitudeFirst := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.