unit fr_MarkDescription;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  TB2Item,
  TBX,
  TB2Dock,
  TB2Toolbar,
  StdCtrls,
  ExtCtrls,
  u_CommonFormAndFrameParents;

type
  TfrMarkDescription = class(TFrame)
    EditComment: TMemo;
    pnlDescriptionTop: TPanel;
    Label2: TLabel;
    TBXToolbar1: TTBXToolbar;
    TBXItem3: TTBXItem;
    TBXItem2: TTBXItem;
    TBXItem1: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXItem4: TTBXItem;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXItem7: TTBXItem;
    tbxtmInsertUrl: TTBXItem;
    procedure TBXItem1Click(Sender: TObject);
    procedure EditCommentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetDescription: string;
    procedure SetDescription(const Value: string);
  public
    property Description: string read GetDescription write SetDescription;
  end;

implementation

uses
  frm_Main;

{$R *.dfm}

type
  TEditBtn = (ebB,ebI,ebU,ebLeft,ebCenter,ebRight,ebImg, ebUrl);

procedure TfrMarkDescription.EditCommentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:string;
  VSelStart:integer;
  Form: TCustomForm;
begin
  if (Key=VK_RETURN) then begin
    if not(ssCtrl in Shift) then begin
      Key:=0;
      s:=EditComment.Text;
      VSelStart:=EditComment.SelStart;
      Insert('<BR>', s, VSelStart+1);
      EditComment.Text := s;
      EditComment.SelStart := VSelStart+4;
    end;
  end else if Key = VK_ESCAPE then begin
    Form := GetParentForm(Self);
    if Form <> nil then Form.ModalResult := mrCancel;
  end;
end;

function TfrMarkDescription.GetDescription: string;
begin
  Result := EditComment.Text;
end;

procedure TfrMarkDescription.SetDescription(const Value: string);
begin
  EditComment.Text := Value;
end;

procedure TfrMarkDescription.TBXItem1Click(Sender: TObject);
var
  s:string;
  VSelStart:integer;
  VSelLen:integer;
  VSelectedText: string;
  VTextBeforeSelection: string;
  VTextAfterSelection: string;
begin
  s := EditComment.Text;
  VSelStart := EditComment.SelStart;
  VSelLen := EditComment.SelLength;
  VSelectedText := EditComment.SelText;
  VTextBeforeSelection := '';
  VTextAfterSelection := '';
  case TEditBtn(TTBXItem(sender).Tag) of
  ebB: begin
        VTextBeforeSelection := '<b>';
        VTextAfterSelection := '</b>';
       end;
  ebI: begin
        VTextBeforeSelection := '<i>';
        VTextAfterSelection := '</i>';
       end;
  ebU: begin
        VTextBeforeSelection := '<u>';
        VTextAfterSelection := '</u>';
       end;
  ebUrl: begin
        if VSelLen = 0 then begin
          VTextBeforeSelection := '<a href=""></a>';
          VTextAfterSelection := '';
        end else begin
          VTextBeforeSelection := '<a href="'+VSelectedText+'">';
          VTextAfterSelection := '</a>';
        end;
       end;
  ebImg:
       if (frmMain.OpenPictureDialog.Execute)and(frmMain.OpenPictureDialog.FileName<>'') then begin
          VTextBeforeSelection := '<img src="'+frmMain.OpenPictureDialog.FileName+'"/>';
          VTextAfterSelection := '';
       end;
  ebCenter:
       begin
        VTextBeforeSelection := '<CENTER>';
        VTextAfterSelection := '</CENTER>';
       end;
  ebLeft:
       begin
        VTextBeforeSelection := '<div ALIGN=LEFT>';
        VTextAfterSelection := '</div>';
       end;
  ebRight:
       begin
        VTextBeforeSelection := '<div ALIGN=RIGHT>';
        VTextAfterSelection := '</div>';
       end;
  end;
  if (VTextBeforeSelection <> '') or (VTextAfterSelection <> '') then begin
    Insert(VTextBeforeSelection, s, VSelStart+1);
    Insert(VTextAfterSelection, s, VSelStart + VSelLen+length(VTextBeforeSelection)+1);
    EditComment.Text:=s;
    EditComment.SelStart :=
      VSelStart +
      VSelLen +
      length(VTextBeforeSelection) +
      Length(VTextAfterSelection);
  end;

end;

end.