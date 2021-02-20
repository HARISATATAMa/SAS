unit u_MiniMapLayerConfig;

interface

uses
  GR32,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_MiniMapLayerConfig,
  i_ActiveMapsConfig,
  u_ConfigDataElementComplexBase;

type
  TMiniMapLayerConfig = class(TConfigDataElementComplexBase, IMiniMapLayerConfig)
  private
    FWidth: Integer;
    FZoomDelta: Integer;
    FMasterAlpha: Integer;
    FVisible: Boolean;
    FDefoultMap: TCustomBitmap32;
    FPlusButton: TCustomBitmap32;
    FMinusButton: TCustomBitmap32;
    FMapsConfig: IMiniMapMapsConfig;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetWidth: Integer;
    procedure SetWidth(AValue: Integer);

    function GetZoomDelta: Integer;
    procedure SetZoomDelta(AValue: Integer);

    function GetMasterAlpha: Integer;
    procedure SetMasterAlpha(AValue: Integer);

    function GetVisible: Boolean;
    procedure SetVisible(AValue: Boolean);

    function GetDefoultMap: TCustomBitmap32;
    function GetPlusButton: TCustomBitmap32;
    function GetMinusButton: TCustomBitmap32;

    function GetMapsConfig: IMiniMapMapsConfig;
  public
    constructor Create(AMapsConfig: IMainMapsConfig);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_ConfigSaveLoadStrategyBasicProviderSubItem,
  u_GlobalState,
  u_MiniMapMapsConfig;

{ TMiniMapLayerConfig }

constructor TMiniMapLayerConfig.Create(AMapsConfig: IMainMapsConfig);
begin
  inherited Create;
  FWidth := 100;
  FZoomDelta := 4;
  FMasterAlpha := 150;
  FVisible := True;
  FDefoultMap := TCustomBitmap32.Create;
  FPlusButton := TCustomBitmap32.Create;
  FMinusButton := TCustomBitmap32.Create;

  FMapsConfig := TMiniMapMapsConfig.Create(AMapsConfig);
  Add(FMapsConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Maps'));
end;

destructor TMiniMapLayerConfig.Destroy;
begin
  FreeAndNil(FDefoultMap);
  FreeAndNil(FPlusButton);
  FreeAndNil(FMinusButton);
  inherited;
end;

procedure TMiniMapLayerConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FWidth := AConfigData.ReadInteger('Width', FWidth);
    FZoomDelta := AConfigData.ReadInteger('ZoomDelta', FZoomDelta);
    FMasterAlpha := AConfigData.ReadInteger('Alpha', FMasterAlpha);
    FVisible := AConfigData.ReadBool('Visible', FVisible);
    GState.LoadBitmapFromRes('ICONI', FPlusButton);
    GState.LoadBitmapFromRes('ICONII', FMinusButton);
    SetChanged;
  end;
end;

procedure TMiniMapLayerConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteInteger('Width', FWidth);
  AConfigData.WriteInteger('ZoomDelta', FZoomDelta);
  AConfigData.WriteInteger('Alpha', FMasterAlpha);
  AConfigData.WriteBool('Visible', FVisible);
end;

function TMiniMapLayerConfig.GetDefoultMap: TCustomBitmap32;
begin
  LockRead;
  try
    Result := FDefoultMap;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetMapsConfig: IMiniMapMapsConfig;
begin
  Result := FMapsConfig;
end;

function TMiniMapLayerConfig.GetMasterAlpha: Integer;
begin
  LockRead;
  try
    Result := FMasterAlpha;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetMinusButton: TCustomBitmap32;
begin
  LockRead;
  try
    Result := FMinusButton;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetPlusButton: TCustomBitmap32;
begin
  LockRead;
  try
    Result := FPlusButton;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetVisible: Boolean;
begin
  LockRead;
  try
    Result := FVisible;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetWidth: Integer;
begin
  LockRead;
  try
    Result := FWidth;
  finally
    UnlockRead;
  end;
end;

function TMiniMapLayerConfig.GetZoomDelta: Integer;
begin
  LockRead;
  try
    Result := FZoomDelta;
  finally
    UnlockRead;
  end;
end;

procedure TMiniMapLayerConfig.SetMasterAlpha(AValue: Integer);
begin
  LockWrite;
  try
    if FMasterAlpha <> AValue then begin
      FMasterAlpha := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMiniMapLayerConfig.SetVisible(AValue: Boolean);
begin
  LockWrite;
  try
    if FVisible <> AValue then begin
      FVisible := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMiniMapLayerConfig.SetWidth(AValue: Integer);
begin
  LockWrite;
  try
    if FWidth <> AValue then begin
      FWidth := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMiniMapLayerConfig.SetZoomDelta(AValue: Integer);
var
  VZoomDelta: Integer;
begin
  VZoomDelta := AValue;
  if VZoomDelta > 10 then begin
    VZoomDelta := 10;
  end else begin
    if VZoomDelta < -2 then begin
      VZoomDelta := -2;
    end;
  end;
  LockWrite;
  try
    if FZoomDelta <> VZoomDelta then begin
      FZoomDelta := VZoomDelta;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.