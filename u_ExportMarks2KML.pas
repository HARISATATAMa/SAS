unit u_ExportMarks2KML;

interface

uses
  Forms,
  Classes,
  SysUtils,
  Windows,
  GR32,
  XMLIntf,
  msxmldom,
  XMLDoc,
  KaZip,
  ActiveX,
  i_MarksSimple,
  i_MarkCategory,
  u_GlobalState,
  u_GeoToStr,
  u_GeoFun;

type
  TExportMarks2KML = class
  private
    kmldoc:TXMLDocument;
    filename:string;
    inKMZ:boolean;
    doc:iXMLNode;
    Zip: TKaZip;
    OnlyVisible:boolean;
    procedure AddMark(Mark:iMarkFull;inNode:iXMLNode);
    function SaveMarkIcon(Mark:IMarkFull): string;
    procedure AddFolders(ACategoryList: IInterfaceList);
    function AddMarks(ACategoryList: IInterfaceList; inNode:iXMLNode): Boolean;
    function Color32toKMLColor(Color32:TColor32):string;
  public
    constructor Create(AOnlyVisible:boolean);
    destructor Destroy; override;

    procedure ExportToKML(AFileName:string);
    procedure ExportCategoryToKML(ACategory: IMarkCategory; AFileName: string);
    procedure ExportMarkToKML(Mark:iMarkFull;AFileName:string);
  end;

implementation

constructor TExportMarks2KML.Create(AOnlyVisible:boolean);
var child:iXMLNode;
begin
  OnlyVisible:=AOnlyVisible;
  kmldoc:=TXMLDocument.Create(Application);
  kmldoc.Options:=kmldoc.Options + [doNodeAutoIndent];
  kmldoc.Active:=true;
  kmldoc.Version:='1.0';
  kmldoc.Encoding:='UTF-8';
  child:=kmldoc.AddChild('kml');
  child.Attributes['xmlns']:='http://earth.google.com/kml/2.2';
  doc:=child.AddChild('Document');
  Zip := TKaZip.Create(nil);
end;

procedure TExportMarks2KML.ExportToKML(AFileName:string);
var
  VCategoryList: IInterfaceList;
  KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  VCategoryList := GState.MarksDb.CategoryDB.GetCategoriesList;
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddFolders(VCategoryList);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddFolders(VCategoryList);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.ExportCategoryToKML(ACategory: IMarkCategory; AFileName: string);
var
  VCategoryList: IInterfaceList;
  KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  VCategoryList:=TInterfaceList.Create;
  VCategoryList.Add(ACategory);
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddFolders(VCategoryList);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddFolders(VCategoryList);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.ExportMarkToKML(Mark:iMarkFull;AFileName:string);
var KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddMark(Mark,doc);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddMark(Mark,doc);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.AddFolders(ACategoryList: IInterfaceList);

  function AddItem(AParentNode: IXMLNode; ACategoryNamePostfix: string; AData: IMarkCategory):boolean;
    function FindNodeWithText(AParent: iXMLNode; const ACategoryNameElement: string): IXMLNode;
    var
      i: Integer;
      tmpNode: IXMLNode;
    begin
      if AParent.HasChildNodes then begin
        for i:=0 to AParent.ChildNodes.Count-1 do begin
          tmpNode :=AParent.ChildNodes.Get(i);
          if (tmpNode.NodeName='Folder')and(tmpNode.ChildValues['name'] = ACategoryNameElement) then begin
            Result := tmpNode;
            break;
          end;
        end;
      end;
    end;

  var
    VCatgoryNamePrefix: string;
    VCatgoryNamePostfix: string;
    VDelimiterPos: Integer;
    VNode: IXMLNode;
    VCatIdList: IInterfaceList;
    VCreatedNode: Boolean;
  begin
    //Result := False; // [DCC Warning] u_ExportMarks2KML.pas(171): H2077 Value assigned to 'AddItem' never used
    if ACategoryNamePostfix='' then begin
      VCatIdList:=TInterfaceList.Create;
      VCatIdList.Add(AData);
      Result := AddMarks(VCatIdList, AParentNode);
      VCatIdList := nil;
    end else begin
      VDelimiterPos:=Pos('\', ACategoryNamePostfix);
      if VDelimiterPos > 0 then begin
        VCatgoryNamePrefix := Copy(ACategoryNamePostfix, 1, VDelimiterPos - 1);
        VCatgoryNamePostfix := Copy(ACategoryNamePostfix, VDelimiterPos + 1, Length(ACategoryNamePostfix))
      end else begin
        VCatgoryNamePrefix:=ACategoryNamePostfix;
        VCatgoryNamePostfix := '';
      end;
      VCreatedNode := False;
      if VCatgoryNamePrefix = '' then begin
        VNode := AParentNode;
      end else begin
        VNode := FindNodeWithText(AParentNode, VCatgoryNamePrefix);
        if (VNode = nil) then begin
          VNode := AParentNode.AddChild('Folder');
          VNode.ChildValues['name']:=VCatgoryNamePrefix;
          VNode.ChildValues['open']:=1;
          with VNode.AddChild('Style').AddChild('ListStyle') do begin
            ChildValues['listItemType']:='check';
            ChildValues['bgColor']:='00ffffff';
          end;
          VCreatedNode := True;
        end;
      end;
      Result := AddItem(VNode, VCatgoryNamePostfix, AData);
      if (not Result) and (VCreatedNode) then begin
        AParentNode.ChildNodes.Remove(VNode);
      end;
    end;
  end;

var
  K: Integer;
  VCategory: IMarkCategory;
begin
  for K := 0 to ACategoryList.Count - 1 do begin
    VCategory := IMarkCategory(Pointer(ACategoryList.Items[K]));
    if (VCategory.Visible) or (not OnlyVisible) then begin
      AddItem(doc, VCategory.name, VCategory);
    end;
  end;
end;

function TExportMarks2KML.SaveMarkIcon(Mark:iMarkFull): string;
var
  VSourceFileName: string;
  VTargetPath: string;
  VTargetFullName: string;
  VPicName: string;
begin
  Result := '';
  if Mark.Pic <> nil then begin
    VPicName := Mark.Pic.GetName;
    VSourceFileName := GState.ProgramPath + 'marksicons' + PathDelim + VPicName;
    VTargetPath := 'files' + PathDelim;
    Result := VTargetPath  + VPicName;
    if inKMZ then begin
      Zip.AddFile(VSourceFileName, Result);
    end else begin
      VTargetPath := ExtractFilePath(filename) + VTargetPath;
      VTargetFullName := VTargetPath + VPicName;
      CreateDir(VTargetPath);
      CopyFile(PChar(VSourceFileName),PChar(VTargetFullName),false);
    end;
  end;
end;

function TExportMarks2KML.AddMarks(ACategoryList: IInterfaceList; inNode:iXMLNode): Boolean;
var MarksList:IMarksSubset;
    Mark:iMarkFull;
    VEnumMarks:IEnumUnknown;
    i:integer;
begin
  Result := False;
  MarksList:=GState.MarksDb.MarksDb.GetMarksSubset(DoubleRect(-180,90,180,-90), ACategoryList, (not OnlyVisible));
  VEnumMarks := MarksList.GetEnum;
  while (VEnumMarks.Next(1, Mark, @i) = S_OK) do begin
    AddMark(Mark,inNode);
    Result := True;
  end;
end;

procedure TExportMarks2KML.AddMark(Mark:iMarkFull;inNode:iXMLNode);
var
  j,width:integer;
  currNode:IXMLNode;
  coordinates:string;
  VFileName: string;
begin
      currNode:=inNode.AddChild('Placemark');
      currNode.ChildValues['name']:=Mark.name;
      currNode.ChildValues['description']:=Mark.Desc;
      if Mark.IsLine then begin
        with currNode.AddChild('Style') do begin
          with AddChild('LineStyle') do begin
            ChildValues['color']:=Color32toKMLColor(Mark.Color1);
            ChildValues['width']:=R2StrPoint(Mark.Scale1);
          end;
        end;
        currNode:=currNode.AddChild('LineString');
      end;

      if Mark.IsPoint then begin
        with currNode.AddChild('Style') do begin
          with AddChild('LabelStyle') do begin
            ChildValues['color']:=Color32toKMLColor(Mark.Color1);
            ChildValues['scale']:=R2StrPoint(Mark.Scale1/14);
          end;
          if Mark.Pic <> nil then begin
            with AddChild('IconStyle') do begin
              VFileName := SaveMarkIcon(Mark);
              width:=Mark.Pic.GetBitmapSize.X;
              ChildValues['scale']:=R2StrPoint(Mark.Scale2/width);
              with AddChild('Icon') do begin
                ChildValues['href']:=VFileName;
              end;
              with AddChild('hotSpot') do begin
                Attributes['x']:='0.5';
                Attributes['y']:=0;
                Attributes['xunits']:='fraction';
                Attributes['yunits']:='fraction';
              end;
            end;
          end;
        end;
        currNode:=currNode.AddChild('Point');
      end;

      if Mark.isPoly then begin
        with currNode.AddChild('Style') do begin
          with AddChild('LineStyle') do begin
            ChildValues['color']:=Color32toKMLColor(Mark.Color1);
            ChildValues['width']:=R2StrPoint(Mark.Scale1);
          end;
          with AddChild('PolyStyle') do begin
            ChildValues['color']:=Color32toKMLColor(Mark.Color2);
            ChildValues['fill']:=1;
          end;
        end;
        currNode:=currNode.AddChild('Polygon').AddChild('outerBoundaryIs').AddChild('LinearRing');
      end;

      currNode.ChildValues['extrude']:=1;
      coordinates:='';
      for j := 0 to length(Mark.Points) - 1 do begin
        coordinates:=coordinates+R2StrPoint(Mark.Points[j].X)+','+R2StrPoint(Mark.Points[j].Y)+',0 ';
      end;
      currNode.ChildValues['coordinates']:=coordinates;
end;

function TExportMarks2KML.Color32toKMLColor(Color32:TColor32):string;
begin
  result:=IntToHex(AlphaComponent(Color32),2)+
          IntToHex(BlueComponent(Color32),2)+
          IntToHex(GreenComponent(Color32),2)+
          IntToHex(RedComponent(Color32),2);
end;

destructor TExportMarks2KML.Destroy;
begin
  Zip.Active := false;
  Zip.Close;
  Zip.Free;
  kmldoc.Free;
  inherited;
end;

end.
