{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_TileStorageInfo;

interface

uses
  i_CoordConverter,
  i_ContentTypeInfo,
  i_TileStorageTypeInfo,
  i_TileStorageInfo;

type
  TTileStorageInfo = class(TInterfacedObject, ITileStorageInfo)
  private
    FTypeInfo: ITileStorageTypeInfo;
    FMainContentType: IContentTypeInfoBasic;
    FAllowDifferentContentTypes: Boolean;

    FAllowDelete: boolean;
    FAllowSave: boolean;
    FIsReadOnly: boolean;
    FCoordConverter: ICoordConverter;
  protected
    function GetTypeInfo: ITileStorageTypeInfo;
    function GetMainContentType: IContentTypeInfoBasic;
    function GetAllowDifferentContentTypes: Boolean;

    function GetAllowDelete: boolean;
    function GetAllowSave: boolean;
    function GetIsReadOnly: boolean;
    function GetCoordConverter: ICoordConverter;
  public
    constructor Create(
      ATypeInfo: ITileStorageTypeInfo;
      AMainContentType: IContentTypeInfoBasic;
      AAllowDifferentContentTypes: Boolean;
      AAllowDelete: boolean;
      AAllowSave: boolean;
      AIsReadOnly: boolean;
      ACoordConverter: ICoordConverter
    );
  end;

implementation

{ TTileStorageInfo }

constructor TTileStorageInfo.Create(
  ATypeInfo: ITileStorageTypeInfo;
  AMainContentType: IContentTypeInfoBasic; AAllowDifferentContentTypes,
  AAllowDelete, AAllowSave, AIsReadOnly: boolean;
  ACoordConverter: ICoordConverter
);
begin
  FTypeInfo := ATypeInfo;
  FMainContentType := AMainContentType;
  FAllowDifferentContentTypes := AAllowDifferentContentTypes;
  FAllowDelete := AAllowDelete;
  FAllowSave := AAllowSave;
end;

function TTileStorageInfo.GetAllowDelete: boolean;
begin
  Result := FAllowDelete;
end;

function TTileStorageInfo.GetAllowDifferentContentTypes: Boolean;
begin
  Result := FAllowDifferentContentTypes;
end;

function TTileStorageInfo.GetAllowSave: boolean;
begin
  Result := FAllowSave;
end;

function TTileStorageInfo.GetCoordConverter: ICoordConverter;
begin
  Result := FCoordConverter;
end;

function TTileStorageInfo.GetIsReadOnly: boolean;
begin
  Result := FIsReadOnly;
end;

function TTileStorageInfo.GetMainContentType: IContentTypeInfoBasic;
begin
  Result := FMainContentType;
end;

function TTileStorageInfo.GetTypeInfo: ITileStorageTypeInfo;
begin
  Result := FTypeInfo;
end;

end.