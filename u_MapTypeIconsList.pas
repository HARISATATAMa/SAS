unit u_MapTypeIconsList;

interface

uses
  Windows,
  Types,
  ActiveX,
  Graphics,
  ImgList,
  i_GUIDList,
  i_MapTypeIconsList;

type
  TMapTypeIconsList = class(TInterfacedObject, IMapTypeIconsList)
  private
    FList: IGUIDObjectList;
    FImageList: TCustomImageList;
    function GetImageList: TCustomImageList;
    function GetIconIndexByGUID(AGUID: TGUID): Integer;
    function GetIterator: IEnumGUID;
  public
    procedure Add(AGUID: TGUID; ABmp: TBitmap);
    constructor Create(AWidth, AHeight: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_GUIDObjectList;

{ TMapTypeIconsList }

procedure TMapTypeIconsList.Add(AGUID: TGUID; ABmp: TBitmap);
var
  VIndex: Integer;
begin
  VIndex := GetIconIndexByGUID(AGUID);
  if VIndex < 0 then begin
    VIndex := FImageList.AddMasked(Abmp, RGB(255, 0, 255));
    FList.Add(AGUID, Pointer(VIndex + 1));
  end else begin
    FImageList.ReplaceMasked(VIndex, ABmp, RGB(255, 0, 255));
  end;
end;

constructor TMapTypeIconsList.Create(AWidth, AHeight: Integer);
begin
  FImageList := TCustomImageList.Create(nil);
  FImageList.Height := AHeight;
  FImageList.Width := AWidth;
  FList := TGUIDObjectList.Create(True);
end;

destructor TMapTypeIconsList.Destroy;
begin
  FreeAndNil(FImageList);
  FList := nil;
  inherited;
end;

function TMapTypeIconsList.GetImageList: TCustomImageList;
begin
  Result := FImageList;
end;

function TMapTypeIconsList.GetIterator: IEnumGUID;
begin
  Result := FList.GetGUIDEnum;
end;

function TMapTypeIconsList.GetIconIndexByGUID(AGUID: TGUID): Integer;
begin
  Result := Integer(Flist.GetByGUID(AGUID)) - 1;
end;

end.