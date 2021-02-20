unit u_TileStorageTypeDBMS;

interface

uses
  i_CoordConverter,
  i_ContentTypeInfo,
  i_ContentTypeManager,
  i_NotifierTime,
  i_MapVersionConfig,
  i_TileStorage,
  i_TileStorageAbilities,
  i_TileStorageTypeConfig,
  i_TileInfoBasicMemCache,
  u_TileStorageTypeBase;

type
  TTileStorageTypeDBMS = class(TTileStorageTypeBase)
  private
    FGCNotifier: INotifierTime;
    FContentTypeManager: IContentTypeManager;
  protected
    function BuildStorageInternal(
      const AForceAbilities: ITileStorageAbilities;
      const AGeoConverter: ICoordConverter;
      const AMainContentType: IContentTypeInfoBasic;
      const APath: string;
      const ACacheTileInfo: ITileInfoBasicMemCache
    ): ITileStorage; override;
  public
    constructor Create(
      const AGCNotifier: INotifierTime;
      const AContentTypeManager: IContentTypeManager;
      const AMapVersionFactory: IMapVersionFactory;
      const AConfig: ITileStorageTypeConfig
    );
  end;

implementation

uses
  u_TileStorageTypeAbilities,
  u_TileStorageDBMS;

{ TTileStorageTypeDBMS }

constructor TTileStorageTypeDBMS.Create(
  const AGCNotifier: INotifierTime;
  const AContentTypeManager: IContentTypeManager;
  const AMapVersionFactory: IMapVersionFactory;
  const AConfig: ITileStorageTypeConfig
);
begin
  inherited Create(
    TTileStorageTypeAbilitiesDBMS.Create,
    AMapVersionFactory,
    AConfig
  );
  FGCNotifier := AGCNotifier;
  FContentTypeManager := AContentTypeManager;
end;

function TTileStorageTypeDBMS.BuildStorageInternal(
  const AForceAbilities: ITileStorageAbilities;
  const AGeoConverter: ICoordConverter;
  const AMainContentType: IContentTypeInfoBasic;
  const APath: string;
  const ACacheTileInfo: ITileInfoBasicMemCache
): ITileStorage;
begin
  Result :=
    TTileStorageDBMS.Create(
      AGeoConverter,
      GetConfig.BasePath.Path,
      APath,
      FGCNotifier,
      ACacheTileInfo,
      FContentTypeManager,
      GetMapVersionFactory,
      AMainContentType
    );
end;

end.
