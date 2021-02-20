unit i_ListOfObjectsWithTTL;

interface

uses
  i_ObjectWithTTL;

type
  IListOfObjectsWithTTL = interface
    ['{25465366-07F9-459A-9D54-1597E4BD6306}']
    procedure AddObject(AObj: IObjectWithTTL);
    procedure RemoveObject(AObj: IObjectWithTTL);
    procedure ProcessObjectsTrim;
    function GetNextCheck: Cardinal;
  end;

implementation

end.