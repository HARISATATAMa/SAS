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

unit u_TileDownloaderConfig;

interface

uses
  Types,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_InetConfig,
  i_TileDownloaderConfig,
  u_ConfigDataElementComplexBase;

type
  TTileDownloaderConfig = class(TConfigDataElementComplexBase, ITileDownloaderConfig)
  private
    FDefConfig: ITileDownloaderConfigStatic;
    FIntetConfig: IInetConfig;
    FWaitInterval: Cardinal;
    FMaxConnectToServerCount: Cardinal;
    FIgnoreMIMEType: Boolean;
    FExpectedMIMETypes: string;
    FDefaultMIMEType: string;
    FIteratorSubRectSize: TPoint;

    FStatic: ITileDownloaderConfigStatic;
    function CreateStatic: ITileDownloaderConfigStatic;
  protected
    procedure DoBeforeChangeNotify; override;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetInetConfigStatic: IInetConfigStatic;

    function GetWaitInterval: Cardinal;
    procedure SetWaitInterval(AValue: Cardinal);

    function GetMaxConnectToServerCount: Cardinal;
    procedure SetMaxConnectToServerCount(AValue: Cardinal);

    function GetIgnoreMIMEType: Boolean;
    procedure SetIgnoreMIMEType(AValue: Boolean);

    function GetExpectedMIMETypes: string;
    procedure SetExpectedMIMETypes(AValue: string);

    function GetDefaultMIMEType: string;
    procedure SetDefaultMIMEType(AValue: string);

    function GetIteratorSubRectSize: TPoint;
    procedure SetIteratorSubRectSize(AValue: TPoint);

    function GetStatic: ITileDownloaderConfigStatic;
  public
    constructor Create(AIntetConfig: IInetConfig; ADefault: ITileDownloaderConfigStatic);
  end;

implementation

uses
  u_TileDownloaderConfigStatic;

{ TTileDownloaderConfig }

constructor TTileDownloaderConfig.Create(AIntetConfig: IInetConfig; ADefault: ITileDownloaderConfigStatic);
begin
  inherited Create;
  FDefConfig := ADefault;
  FIntetConfig := AIntetConfig;
  FWaitInterval := FDefConfig.WaitInterval;
  FMaxConnectToServerCount := FDefConfig.MaxConnectToServerCount;
  FIgnoreMIMEType := FDefConfig.IgnoreMIMEType;
  FDefaultMIMEType := FDefConfig.DefaultMIMEType;
  FExpectedMIMETypes := FDefConfig.ExpectedMIMETypes;
  FIteratorSubRectSize := FDefConfig.IteratorSubRectSize;

  Add(FIntetConfig, nil, False, False, False, True);
end;

function TTileDownloaderConfig.CreateStatic: ITileDownloaderConfigStatic;
begin
  FIntetConfig.LockRead;
  try
  Result :=
    TTileDownloaderConfigStatic.Create(
      FIntetConfig.GetStatic,
      FWaitInterval,
      FMaxConnectToServerCount,
      FIgnoreMIMEType,
      FExpectedMIMETypes,
      FDefaultMIMEType,
      FIteratorSubRectSize
    );
  finally
    FIntetConfig.UnlockRead;
  end;
end;

procedure TTileDownloaderConfig.DoBeforeChangeNotify;
begin
  inherited;
  LockWrite;
  try
    FStatic := CreateStatic;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FIgnoreMIMEType := AConfigData.ReadBool('IgnoreContentType', FIgnoreMIMEType);
    FDefaultMIMEType := AConfigData.ReadString('DefaultContentType', FDefaultMIMEType);
    FExpectedMIMETypes := AConfigData.ReadString('ContentType', FExpectedMIMETypes);
    FWaitInterval := AConfigData.ReadInteger('Sleep', FWaitInterval);
    SetMaxConnectToServerCount(AConfigData.ReadInteger('MaxConnectToServerCount', FMaxConnectToServerCount));
    SetChanged;
  end;
end;

procedure TTileDownloaderConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  if FWaitInterval <> FDefConfig.WaitInterval then begin
    AConfigData.WriteInteger('Sleep', FWaitInterval);
  end else begin
    AConfigData.DeleteValue('Sleep');
  end;

  if FMaxConnectToServerCount <> FDefConfig.MaxConnectToServerCount then begin
    AConfigData.WriteInteger('MaxConnectToServerCount', FMaxConnectToServerCount);
  end else begin
    AConfigData.DeleteValue('MaxConnectToServerCount');
  end;
end;

function TTileDownloaderConfig.GetIteratorSubRectSize: TPoint;
begin
  LockRead;
  try
    Result := FIteratorSubRectSize;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderConfig.GetDefaultMIMEType: string;
begin
  LockRead;
  try
    Result := FDefaultMIMEType;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderConfig.GetExpectedMIMETypes: string;
begin
  LockRead;
  try
    Result := FExpectedMIMETypes;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderConfig.GetIgnoreMIMEType: Boolean;
begin
  LockRead;
  try
    Result := FIgnoreMIMEType;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderConfig.GetInetConfigStatic: IInetConfigStatic;
begin
  Result := FIntetConfig.GetStatic;
end;

function TTileDownloaderConfig.GetMaxConnectToServerCount: Cardinal;
begin
  LockRead;
  try
    Result := FMaxConnectToServerCount;
  finally
    UnlockRead;
  end;
end;

function TTileDownloaderConfig.GetStatic: ITileDownloaderConfigStatic;
begin
  Result := FStatic;
end;

function TTileDownloaderConfig.GetWaitInterval: Cardinal;
begin
  LockRead;
  try
    Result := FWaitInterval;
  finally
    UnlockRead;
  end;
end;

procedure TTileDownloaderConfig.SetIteratorSubRectSize(AValue: TPoint);
begin
  LockWrite;
  try
    if (FIteratorSubRectSize.x <> AValue.x)or
       (FIteratorSubRectSize.y <> AValue.y) then begin
      FIteratorSubRectSize := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.SetDefaultMIMEType(AValue: string);
begin
  LockWrite;
  try
    if FDefaultMIMEType <> AValue then begin
      FDefaultMIMEType := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.SetExpectedMIMETypes(AValue: string);
begin
  LockWrite;
  try
    if FExpectedMIMETypes <> AValue then begin
      FExpectedMIMETypes := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.SetIgnoreMIMEType(AValue: Boolean);
begin
  LockWrite;
  try
    if FIgnoreMIMEType <> AValue then begin
      FIgnoreMIMEType := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.SetMaxConnectToServerCount(AValue: Cardinal);
var
  VValue: Cardinal;
begin
  VValue := AValue;
  if VValue > 64 then begin
    VValue := 64;
  end;
  if VValue <= 0 then begin
    VValue := 1;
  end;

  LockWrite;
  try
    if FMaxConnectToServerCount <> VValue then begin
      FMaxConnectToServerCount := VValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TTileDownloaderConfig.SetWaitInterval(AValue: Cardinal);
begin
  LockWrite;
  try
    if FWaitInterval <> AValue then begin
      FWaitInterval := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.