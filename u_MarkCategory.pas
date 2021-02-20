unit u_MarkCategory;

interface

uses
  i_MarkCategory;

type
  TMarkCategory = class(TInterfacedObject, IMarkCategory)
  private
    FId: Integer;
    FName: string;
    FVisible: Boolean;
    FAfterScale: integer;
    FBeforeScale: integer;
  protected
    function GetId: integer; stdcall;
    function GetName: string; stdcall;
    function GetVisible: boolean; stdcall;
    function GetAfterScale: integer; stdcall;
    function GetBeforeScale: integer; stdcall;
    function IsNew: Boolean;
    function IsSame(ACategory: IMarkCategory): Boolean;
  public
    constructor Create(
      AId: Integer;
      AName: string;
      AVisible: Boolean;
      AAfterScale: integer;
      ABeforeScale: integer
    );
  end;

implementation

{ TMarkCategory }

constructor TMarkCategory.Create(AId: Integer; AName: string; AVisible: Boolean;
  AAfterScale, ABeforeScale: integer);
begin
  FId := AId;
  FName := AName;
  FVisible := AVisible;
  FAfterScale := AAfterScale;
  FBeforeScale := ABeforeScale;
end;

function TMarkCategory.GetAfterScale: integer;
begin
  Result := FAfterScale;
end;

function TMarkCategory.GetBeforeScale: integer;
begin
  Result := FBeforeScale;
end;

function TMarkCategory.GetId: integer;
begin
  Result := FId;
end;

function TMarkCategory.GetName: string;
begin
  Result := FName;
end;

function TMarkCategory.GetVisible: boolean;
begin
  Result := FVisible;
end;

function TMarkCategory.IsNew: Boolean;
begin
  Result := FId < 0;
end;

function TMarkCategory.IsSame(ACategory: IMarkCategory): Boolean;
begin
  Result := False;
  if ACategory <> nil then begin
    Result := FId = ACategory.Id;
  end;
end;

end.