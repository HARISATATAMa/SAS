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

unit u_TileErrorLogProviedrStuped;

interface

uses
  i_JclNotify,
  i_TileError,
  i_TileErrorLogProviedrStuped;

type
  TTileErrorLogProviedrStuped = class(TInterfacedObject, ITileErrorLogProviedrStuped, ITileErrorLogger)
  private
    FLastErrorInfo: ITileErrorInfo;
    FNotifier: IJclNotifier;
  protected
    function GetLastErrorInfo: ITileErrorInfo;
    function GetNotifier: IJclNotifier;
  protected
    procedure LogError(AValue: ITileErrorInfo);
  public
    constructor Create();
  end;

implementation

uses
  u_JclNotify;

{ TTileErrorLogProviedrStuped }

constructor TTileErrorLogProviedrStuped.Create;
begin
  FNotifier := TJclBaseNotifier.Create;
end;

function TTileErrorLogProviedrStuped.GetLastErrorInfo: ITileErrorInfo;
begin
  Result := FLastErrorInfo;
end;

function TTileErrorLogProviedrStuped.GetNotifier: IJclNotifier;
begin
  Result := FNotifier;
end;

procedure TTileErrorLogProviedrStuped.LogError(AValue: ITileErrorInfo);
begin
  FLastErrorInfo := AValue;
  FNotifier.Notify(nil);
end;

end.