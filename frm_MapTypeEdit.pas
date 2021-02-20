unit frm_MapTypeEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Spin,
  u_CommonFormAndFrameParents,
  u_MapType,
  u_ResStrings;

type
  TfrmMapTypeEdit = class(TCommonFormParent)
    EditNameinCache: TEdit;
    EditParSubMenu: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    EditHotKey: THotKey;
    btnOk: TButton;
    btnCancel: TButton;
    btnByDefault: TButton;
    Button6: TButton;
    Button4: TButton;
    Button5: TButton;
    Button7: TButton;
    EditURL: TMemo;
    SESleep: TSpinEdit;
    Label6: TLabel;
    Button8: TButton;
    CBCacheType: TComboBox;
    Label5: TLabel;
    Button9: TButton;
    pnlBottomButtons: TPanel;
    pnlSeparator: TPanel;
    pnlCacheType: TPanel;
    grdpnlHotKey: TGridPanel;
    grdpnlSleep: TGridPanel;
    grdpnlSleepAndKey: TGridPanel;
    pnlParentItem: TPanel;
    pnlCacheName: TPanel;
    pnlUrl: TPanel;
    pnlUrlRight: TPanel;
    Label4: TLabel;
    CheckEnabled: TCheckBox;
    pnlTop: TPanel;
    lblZmpName: TLabel;
    edtZmp: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnByDefaultClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    FMapType: TMapType;
  public
    function EditMapModadl(AMapType: TMapType): Boolean;
  end;

var
  frmMapTypeEdit: TfrmMapTypeEdit;

implementation

{$R *.dfm}

procedure TfrmMapTypeEdit.btnOkClick(Sender: TObject);
begin
 FmapType.UrlGenerator.URLBase:=EditURL.Text;
 FmapType.TileStorage.CacheConfig.NameInCache:=EditNameinCache.Text;
 FmapType.ParentSubMenu:=EditParSubMenu.Text;
 FmapType.DownloaderFactory.WaitInterval:=SESleep.Value;
 FmapType.HotKey:=EditHotKey.HotKey;
 FMapType.Enabled:=CheckEnabled.Checked;
 if CBCacheType.ItemIndex > 0 then begin
   FmapType.TileStorage.CacheConfig.cachetype:=CBCacheType.ItemIndex;
 end else begin
   FmapType.TileStorage.CacheConfig.cachetype:=0;
 end;
 FmapType.separator:=CheckBox1.Checked;
 ModalResult := mrOk;
end;

procedure TfrmMapTypeEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FmapType:=nil;
end;

procedure TfrmMapTypeEdit.btnByDefaultClick(Sender: TObject);
begin
 EditURL.Text:=FmapType.UrlGenerator.DefURLBase;
 EditNameinCache.Text:=FmapType.TileStorage.CacheConfig.DefNameInCache;
 EditParSubMenu.Text:=FmapType.DefParentSubMenu;
 SESleep.Value:=FmapType.DownloaderFactory.WaitInterval;
 EditHotKey.HotKey:=FmapType.DefHotKey;
 CBCacheType.ItemIndex:=FmapType.TileStorage.CacheConfig.CacheType;
 CheckBox1.Checked:=FmapType.Defseparator;
 CheckEnabled.Checked:=FMapType.Enabled;
end;

procedure TfrmMapTypeEdit.Button6Click(Sender: TObject);
begin
 EditURL.Text := FMapType.UrlGenerator.DefURLBase;
end;

procedure TfrmMapTypeEdit.Button4Click(Sender: TObject);
begin
 EditNameinCache.Text := FMapType.TileStorage.CacheConfig.DefNameInCache;
end;

procedure TfrmMapTypeEdit.Button5Click(Sender: TObject);
begin
 EditParSubMenu.Text := FMapType.DefParentSubMenu;
end;

procedure TfrmMapTypeEdit.Button7Click(Sender: TObject);
begin
 EditHotKey.HotKey := FMapType.DefHotKey;
end;

procedure TfrmMapTypeEdit.Button8Click(Sender: TObject);
begin
 SESleep.Value := FMapType.DefSleep;
end;

procedure TfrmMapTypeEdit.Button9Click(Sender: TObject);
begin
  CBCacheType.ItemIndex := FMapType.TileStorage.CacheConfig.defcachetype;
end;

function TfrmMapTypeEdit.EditMapModadl(AMapType: TMapType): Boolean;
begin
  FMapType := AMapType;

  Caption:=SAS_STR_EditMap+' '+FmapType.name;
  edtZmp.Text := AMapType.ZmpFileName;
  EditURL.Text:=FMapType.UrlGenerator.URLBase;
  EditNameinCache.Text:=FMapType.TileStorage.CacheConfig.NameInCache;
  SESleep.Value:=FMapType.DownloaderFactory.WaitInterval;
  EditParSubMenu.Text:=FMapType.ParentSubMenu;
  EditHotKey.HotKey:=FMapType.HotKey;
  CBCacheType.ItemIndex:=FMapType.TileStorage.CacheConfig.cachetype;
  CheckBox1.Checked:=FMapType.separator;
  CheckEnabled.Checked:=FMapType.Enabled;

  Result := ShowModal = mrOk;
end;

end.