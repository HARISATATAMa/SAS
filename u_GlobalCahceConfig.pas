unit u_GlobalCahceConfig;

interface

uses
  i_JclNotify,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider;

type
  TGlobalCahceConfig = class
  private
    //������ ������� ���� ��-���������.
    FDefCache: byte;

    //���� � ����� ������ �����
    FNewCPath: string;
    FOldCPath: string;
    FESCpath: string;
    FGMTilespath: string;
    FGECachepath: string;

    FCacheChangeNotifier: IJclNotifier;
    procedure SetDefCache(const Value: byte);
    procedure SetESCpath(const Value: string);
    procedure SetGECachepath(const Value: string);
    procedure SetGMTilespath(const Value: string);
    procedure SetNewCPath(const Value: string);
    procedure SetOldCPath(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadConfig(AConfigProvider: IConfigDataProvider);
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider);

    //������ ������� ���� ��-���������.
    property DefCache: byte read FDefCache write SetDefCache;

    //���� � ����� ������ �����
    property NewCPath: string read FNewCPath write SetNewCPath;
    property OldCPath: string read FOldCPath write SetOldCPath;
    property ESCpath: string read FESCpath write SetESCpath;
    property GMTilespath: string read FGMTilespath write SetGMTilespath;
    property GECachepath: string read FGECachepath write SetGECachepath;

    property CacheChangeNotifier: IJclNotifier read FCacheChangeNotifier;
  end;

implementation

uses
  SysUtils,
  u_JclNotify;

{ TGlobalCahceConfig }

constructor TGlobalCahceConfig.Create;
begin
  FDefCache := 2;
  FCacheChangeNotifier := TJclBaseNotifier.Create;
  FOldCpath := 'cache_old' + PathDelim;
  FNewCpath := 'cache' + PathDelim;
  FESCpath := 'cache_ES' + PathDelim;
  FGMTilesPath := 'cache_gmt' + PathDelim;
  FGECachePath := 'cache_GE' + PathDelim;
end;

destructor TGlobalCahceConfig.Destroy;
begin
  FCacheChangeNotifier := nil;
  inherited;
end;

procedure TGlobalCahceConfig.LoadConfig(AConfigProvider: IConfigDataProvider);
var
  VViewConfig: IConfigDataProvider;
  VPathConfig: IConfigDataProvider;
begin
  VViewConfig := AConfigProvider.GetSubItem('VIEW');
  if VViewConfig <> nil then begin
    DefCache := VViewConfig.ReadInteger('DefCache', FDefCache);
  end;

  VPathConfig := AConfigProvider.GetSubItem('PATHtoCACHE');
  if VPathConfig <> nil then begin
    OldCpath := VPathConfig.ReadString('GMVC', OldCpath);
    NewCpath := VPathConfig.ReadString('SASC', NewCpath);
    ESCpath := VPathConfig.ReadString('ESC', ESCpath);
    GMTilesPath := VPathConfig.ReadString('GMTiles', GMTilesPath);
    GECachePath := VPathConfig.ReadString('GECache', GECachePath);
  end;
end;

procedure TGlobalCahceConfig.SaveConfig(
  AConfigProvider: IConfigDataWriteProvider);
var
  VViewConfig: IConfigDataWriteProvider;
  VPathConfig: IConfigDataWriteProvider;
begin
  VViewConfig := AConfigProvider.GetOrCreateSubItem('VIEW');
  VPathConfig := AConfigProvider.GetOrCreateSubItem('PATHtoCACHE');
  VViewConfig.WriteInteger('DefCache', FDefCache);

  VPathConfig.WriteString('GMVC', OldCpath);
  VPathConfig.WriteString('SASC', NewCpath);
  VPathConfig.WriteString('ESC', ESCpath);
  VPathConfig.WriteString('GMTiles', GMTilesPath);
  VPathConfig.WriteString('GECache', GECachePath);
end;

procedure TGlobalCahceConfig.SetDefCache(const Value: byte);
begin
  if FDefCache <> Value then begin
    FDefCache := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

procedure TGlobalCahceConfig.SetESCpath(const Value: string);
begin
  if FESCpath <> Value then begin
    FESCpath := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

procedure TGlobalCahceConfig.SetGECachepath(const Value: string);
begin
  if FGECachepath <> Value then begin
    FGECachepath := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

procedure TGlobalCahceConfig.SetGMTilespath(const Value: string);
begin
  if FGMTilespath <> Value then begin
    FGMTilespath := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

procedure TGlobalCahceConfig.SetNewCPath(const Value: string);
begin
  if FNewCPath <> Value then begin
    FNewCPath := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

procedure TGlobalCahceConfig.SetOldCPath(const Value: string);
begin
  if FOldCPath <> Value then begin
    FOldCPath := Value;
    FCacheChangeNotifier.Notify(nil);
  end;
end;

end.