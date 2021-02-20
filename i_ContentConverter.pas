unit i_ContentConverter;

interface

uses
  Classes,
  i_ContentTypeInfo;

type
  IContentConverter = interface
    ['{62D759E7-20C4-4FB1-B384-49D51127A615}']
    function GetSource: IContentTypeInfoBasic;
    function GetTarget: IContentTypeInfoBasic;
    function GetIsSimpleCopy: Boolean;
    procedure ConvertStream(ASource, ATarget: TStream);
  end;

implementation

end.