{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_MarkTemplates;

interface

uses
  GR32,
  i_Category,
  i_MarkTemplate,
  i_MarkNameGenerator,
  u_BaseInterfacedObject;

type
  TMarkTemplateBase = class(TBaseInterfacedObject, IMarkTemplate)
  private
    FNameGenerator: IMarkNameGenerator;
    FCategory: ICategory;
    function IsSameInternal(const ATemplate: IMarkTemplate): Boolean;
  protected
    function GetNewName: string;
    function GetCategory: ICategory;
  public
    constructor Create(
      const ANameGenerator: IMarkNameGenerator;
      const ACategory: ICategory
    );
  end;

  TMarkTemplatePoint = class(TMarkTemplateBase, IMarkTemplatePoint)
  private
    FTextColor: TColor32;
    FTextBgColor: TColor32;
    FFontSize: Integer;
    FMarkerSize: Integer;
    FPicName: string;
  protected
    function GetTextColor: TColor32;
    function GetTextBgColor: TColor32;
    function GetFontSize: Integer;
    function GetMarkerSize: Integer;
    function GetPicName: string;
    function IsSame(const ATemplate: IMarkTemplatePoint): Boolean;
  public
    constructor Create(
      const ANameGenerator: IMarkNameGenerator;
      const ACategory: ICategory;
      ATextColor: TColor32;
      ATextBgColor: TColor32;
      AFontSize: Integer;
      AMarkerSize: Integer;
      const APicName: string
    );
  end;

  TMarkTemplateLine = class(TMarkTemplateBase, IMarkTemplateLine)
  private
    FLineColor: TColor32;
    FLineWidth: Integer;
  protected
    function GetLineColor: TColor32;
    function GetLineWidth: Integer;
    function IsSame(const ATemplate: IMarkTemplateLine): Boolean;
  public
    constructor Create(
      const ANameGenerator: IMarkNameGenerator;
      const ACategory: ICategory;
      ALineColor: TColor32;
      ALineWidth: Integer
    );
  end;

  TMarkTemplatePoly = class(TMarkTemplateBase, IMarkTemplatePoly)
  private
    FLineColor: TColor32;
    FFillColor: TColor32;
    FLineWidth: Integer;
  protected
    function GetLineColor: TColor32;
    function GetFillColor: TColor32;
    function GetLineWidth: Integer;
    function IsSame(const ATemplate: IMarkTemplatePoly): Boolean;
  public
    constructor Create(
      const ANameGenerator: IMarkNameGenerator;
      const ACategory: ICategory;
      ALineColor: TColor32;
      AFillColor: TColor32;
      ALineWidth: Integer
    );
  end;

implementation

{ FMarkTemplateBase }

constructor TMarkTemplateBase.Create(
  const ANameGenerator: IMarkNameGenerator;
  const ACategory: ICategory
);
begin
  Assert(ANameGenerator <> nil);
  Assert(ACategory <> nil);
  inherited Create;
  FNameGenerator := ANameGenerator;
  FCategory := ACategory;
end;

function TMarkTemplateBase.GetCategory: ICategory;
begin
  Result := FCategory;
end;

function TMarkTemplateBase.GetNewName: string;
begin
  Result := FNameGenerator.GetNewName;
end;

function TMarkTemplateBase.IsSameInternal(
  const ATemplate: IMarkTemplate
): Boolean;
begin
  Result := False;
  if ATemplate <> nil then begin
    if FCategory = nil then begin
      Result := ATemplate.Category = nil;
    end else begin
      Result := FCategory.IsEqual(ATemplate.Category);
    end;
  end;
end;

{ TMarkTemplatePoint }

constructor TMarkTemplatePoint.Create(
  const ANameGenerator: IMarkNameGenerator;
  const ACategory: ICategory;
  ATextColor, ATextBgColor: TColor32;
  AFontSize, AMarkerSize: Integer;
  const APicName: string
);
begin
  inherited Create(ANameGenerator, ACategory);
  FTextColor := ATextColor;
  FTextBgColor := ATextBgColor;
  FFontSize := AFontSize;
  FMarkerSize := AMarkerSize;
  FPicName := APicName;
end;

function TMarkTemplatePoint.GetTextColor: TColor32;
begin
  Result := FTextColor;
end;

function TMarkTemplatePoint.GetTextBgColor: TColor32;
begin
  Result := FTextBgColor;
end;

function TMarkTemplatePoint.GetPicName: string;
begin
  Result := FPicName;
end;

function TMarkTemplatePoint.GetFontSize: Integer;
begin
  Result := FFontSize;
end;

function TMarkTemplatePoint.GetMarkerSize: Integer;
begin
  Result := FMarkerSize;
end;

function TMarkTemplatePoint.IsSame(const ATemplate: IMarkTemplatePoint): Boolean;
begin
  Result := IsSameInternal(ATemplate);
  if Result then begin
    Result :=
      (FTextColor = ATemplate.TextColor) and
      (FTextBgColor = ATemplate.TextBgColor) and
      (FFontSize = ATemplate.FontSize) and
      (FMarkerSize = ATemplate.MarkerSize) and
      (FPicName = ATemplate.PicName);
  end;
end;

{ TMarkTemplateLine }

constructor TMarkTemplateLine.Create(
  const ANameGenerator: IMarkNameGenerator;
  const ACategory: ICategory;
  ALineColor: TColor32;
  ALineWidth: Integer
);
begin
  inherited Create(ANameGenerator, ACategory);
  FLineColor := ALineColor;
  FLineWidth := ALineWidth;
end;

function TMarkTemplateLine.GetLineColor: TColor32;
begin
  Result := FLineColor;
end;

function TMarkTemplateLine.GetLineWidth: Integer;
begin
  Result := FLineWidth;
end;

function TMarkTemplateLine.IsSame(const ATemplate: IMarkTemplateLine): Boolean;
begin
  Result := IsSameInternal(ATemplate);
  if Result then begin
    Result :=
      (FLineColor = ATemplate.LineColor) and
      (FLineWidth = ATemplate.LineWidth);
  end;
end;

{ TMarkTemplatePoly }

constructor TMarkTemplatePoly.Create(
  const ANameGenerator: IMarkNameGenerator;
  const ACategory: ICategory;
  ALineColor, AFillColor: TColor32;
  ALineWidth: Integer
);
begin
  inherited Create(ANameGenerator, ACategory);
  FLineColor := ALineColor;
  FFillColor := AFillColor;
  FLineWidth := ALineWidth;
end;

function TMarkTemplatePoly.GetLineColor: TColor32;
begin
  Result := FLineColor;
end;

function TMarkTemplatePoly.GetFillColor: TColor32;
begin
  Result := FFillColor;
end;

function TMarkTemplatePoly.GetLineWidth: Integer;
begin
  Result := FLineWidth;
end;

function TMarkTemplatePoly.IsSame(const ATemplate: IMarkTemplatePoly): Boolean;
begin
  Result := IsSameInternal(ATemplate);
  if Result then begin
    Result :=
      (FLineColor = ATemplate.LineColor) and
      (FFillColor = ATemplate.FillColor) and
      (FLineWidth = ATemplate.LineWidth);
  end;
end;

end.