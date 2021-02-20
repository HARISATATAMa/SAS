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

unit i_SimpleTileStorageConfig;

interface

uses
  i_CoordConverter,
  i_ConfigDataElement;

type
  ISimpleTileStorageConfigStatic = interface
    ['{594D2502-ACE4-4986-9459-DFD4B75C052D}']
    function GetCoordConverter: ICoordConverter;
    property CoordConverter: ICoordConverter read GetCoordConverter;

    function GetCacheTypeCode: Integer;
    property CacheTypeCode: Integer read GetCacheTypeCode;

    function GetNameInCache: string;
    property NameInCache: string read GetNameInCache;

    function GetTileFileExt: string;
    property TileFileExt: string read GetTileFileExt;

    function GetIsStoreFileCache: Boolean;
    property IsStoreFileCache: Boolean read GetIsStoreFileCache;

    function GetIsReadOnly: boolean;
    property IsReadOnly: Boolean read GetIsReadOnly;

    function GetAllowDelete: boolean;
    property AllowDelete: Boolean read GetAllowDelete;

    function GetAllowAdd: boolean;
    property AllowAdd: Boolean read GetAllowAdd;

    function GetAllowReplace: boolean;
    property AllowReplace: Boolean read GetAllowReplace;
  end;

  ISimpleTileStorageConfig = interface(IConfigDataElement)
    ['{536CD168-FDBE-43F8-B090-E3B5FCE97ACE}']
    function GetCoordConverter: ICoordConverter;
    property CoordConverter: ICoordConverter read GetCoordConverter;

    function GetCacheTypeCode: Integer;
    procedure SetCacheTypeCode(AValue: Integer);
    property CacheTypeCode: Integer read GetCacheTypeCode write SetCacheTypeCode;

    function GetNameInCache: string;
    procedure SetNameInCache(AValue: string);
    property NameInCache: string read GetNameInCache write SetNameInCache;

    function GetTileFileExt: string;
    property TileFileExt: string read GetTileFileExt;

    function GetIsStoreFileCache: Boolean;
    property IsStoreFileCache: Boolean read GetIsStoreFileCache;

    function GetIsReadOnly: boolean;
    procedure SetIsReadOnly(AValue: Boolean);
    property IsReadOnly: Boolean read GetIsReadOnly write SetIsReadOnly;

    function GetAllowDelete: boolean;
    procedure SetAllowDelete(AValue: Boolean);
    property AllowDelete: Boolean read GetAllowDelete write SetAllowDelete;

    function GetAllowAdd: boolean;
    procedure SetAllowAdd(AValue: Boolean);
    property AllowAdd: Boolean read GetAllowAdd write SetAllowAdd;

    function GetAllowReplace: boolean;
    procedure SetAllowReplace(AValue: Boolean);
    property AllowReplace: Boolean read GetAllowReplace write SetAllowReplace;

    function GetStatic: ISimpleTileStorageConfigStatic;
  end;

implementation

end.