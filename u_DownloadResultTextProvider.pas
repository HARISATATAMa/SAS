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

unit u_DownloadResultTextProvider;

interface

uses
  i_JclNotify,
  i_LanguageManager,
  i_DownloadResultTextProvider;

type
  TDownloadResultTextProvider = class(TInterfacedObject, IDownloadResultTextProvider)
  private
    FLangManager: ILanguageManager;
    FLangListener: IJclListener;

    FMessageBadContentType: string;
    FMessageBadProxyAuth: string;
    FMessageBanned: string;
    FMessageDataNotExistsByStatusCode: string;
    FMessageDataNotExistsZeroSize: string;
    FMessageLoadErrorByErrorCode: string;
    FMessageLoadErrorByStatusCode: string;
    FMessageLoadErrorByUnknownStatusCode: string;
    FMessageNoConnetctToServerByErrorCode: string;
    FMessageUnexpectedProxyAuth: string;

    procedure OnLangChange(Sender: TObject);
  protected
    function GetMessageBadContentType: string;
    function GetMessageBadProxyAuth: string;
    function GetMessageBanned: string;
    function GetMessageDataNotExistsByStatusCode: string;
    function GetMessageDataNotExistsZeroSize: string;
    function GetMessageLoadErrorByErrorCode: string;
    function GetMessageLoadErrorByStatusCode: string;
    function GetMessageLoadErrorByUnknownStatusCode: string;
    function GetMessageNoConnetctToServerByErrorCode: string;
    function GetMessageUnexpectedProxyAuth: string;
  public
    constructor Create(
      ALangManager: ILanguageManager
    );
    destructor Destroy; override;
  end;

implementation

uses
  gnugettext,
  u_NotifyEventListener;

{ TDownloadResultTextProvider }

constructor TDownloadResultTextProvider.Create(ALangManager: ILanguageManager);
begin
  FLangManager := ALangManager;
  FLangListener := TNotifyEventListener.Create(Self.OnLangChange);
  FLangManager.GetChangeNotifier.Add(FLangListener);

  OnLangChange(nil);
end;

destructor TDownloadResultTextProvider.Destroy;
begin
  FLangManager.GetChangeNotifier.Remove(FLangListener);
  FLangManager := nil;
  FLangListener := nil;
  inherited;
end;

function TDownloadResultTextProvider.GetMessageBadContentType: string;
begin
  Result := FMessageBadContentType;
end;

function TDownloadResultTextProvider.GetMessageBadProxyAuth: string;
begin
  Result := FMessageBadProxyAuth
end;

function TDownloadResultTextProvider.GetMessageBanned: string;
begin
  Result := FMessageBanned;
end;

function TDownloadResultTextProvider.GetMessageDataNotExistsByStatusCode: string;
begin
  Result := FMessageDataNotExistsByStatusCode;
end;

function TDownloadResultTextProvider.GetMessageDataNotExistsZeroSize: string;
begin
  Result := FMessageDataNotExistsZeroSize;
end;

function TDownloadResultTextProvider.GetMessageLoadErrorByErrorCode: string;
begin
  Result := FMessageLoadErrorByErrorCode;
end;

function TDownloadResultTextProvider.GetMessageLoadErrorByStatusCode: string;
begin
  Result := FMessageLoadErrorByStatusCode;
end;

function TDownloadResultTextProvider.GetMessageLoadErrorByUnknownStatusCode: string;
begin
  Result := FMessageLoadErrorByUnknownStatusCode;
end;

function TDownloadResultTextProvider.GetMessageNoConnetctToServerByErrorCode: string;
begin
  Result := FMessageNoConnetctToServerByErrorCode;
end;

function TDownloadResultTextProvider.GetMessageUnexpectedProxyAuth: string;
begin
  Result := FMessageUnexpectedProxyAuth;
end;

procedure TDownloadResultTextProvider.OnLangChange(Sender: TObject);
begin
  FMessageBadContentType := _('Server returned unexpected type "%0:s"');
  FMessageBadProxyAuth := _('Proxy authorization error');
  FMessageBanned := _('Most likely you''ve been banned by the server!');
  FMessageDataNotExistsByStatusCode := _('Tile is not found! Status code %d');
  FMessageDataNotExistsZeroSize := _('Tile is not found! Zero result size');
  FMessageLoadErrorByErrorCode := _('Download error. Error code %d');
  FMessageLoadErrorByStatusCode := _('Download error. Status code %d');
  FMessageLoadErrorByUnknownStatusCode := _('Download error. Unknown status code %d');
  FMessageNoConnetctToServerByErrorCode := _('Connct to server error. Error code %d');
  FMessageUnexpectedProxyAuth := _('Unexpected proxy authorization');
end;

end.