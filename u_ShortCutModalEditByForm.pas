unit u_ShortCutModalEditByForm;

interface

uses
  Windows,
  i_LanguageManager,
  i_ShortCutSingleConfig,
  i_ShortCutModalEdit,
  frm_ShortCutEdit;

type
  TShortCutModalEditByForm = class(TInterfacedObject, IShortCutModalEdit)
  private
    FLanguageManager: ILanguageManager;
    FEditCounter: Longint;
    FfrmShortCutEdit: TfrmShortCutEdit;
  protected
    function EditShortCut(AShortCutInfo: IShortCutSingleConfig): Boolean;
  public
    constructor Create(
      ALanguageManager: ILanguageManager
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TShortCutModalEditByForm }

constructor TShortCutModalEditByForm.Create(
  ALanguageManager: ILanguageManager
);
begin
  FLanguageManager := ALanguageManager;
  FEditCounter := 0;
end;

destructor TShortCutModalEditByForm.Destroy;
begin
  Assert(FEditCounter = 0);
  if FfrmShortCutEdit <> nil then begin
    FreeAndNil(FfrmShortCutEdit);
  end;

  inherited;
end;

function TShortCutModalEditByForm.EditShortCut(AShortCutInfo: IShortCutSingleConfig): Boolean;
var
  VCounter: Longint;
begin
  VCounter := InterlockedIncrement(FEditCounter);
  try
    if VCounter = 1 then begin
      if FfrmShortCutEdit = nil then begin
        FfrmShortCutEdit := TfrmShortCutEdit.Create(FLanguageManager);
      end;
      Result := FfrmShortCutEdit.EditHotKeyModal(AShortCutInfo);
    end else begin
      Result := False;
    end;
  finally
    InterlockedDecrement(FEditCounter);
  end;
end;

end.