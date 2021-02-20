unit u_SimpleHttpDownloader;

interface

uses
  i_NotifierOperation,
  i_Downloader,
  i_InetConfig,
  i_SimpleHttpDownloader,
  u_BaseInterfacedObject;

type
  TSimpleHttpDownloader = class(TBaseInterfacedObject, ISimpleHttpDownloader)
  private
    FDownloader: IDownloader;
    FInetConfig: IInetConfigStatic;
    FCancelNotifier: INotifierOperation;
    FOperationID: Integer;
  private
    function DoHttpRequest(
      const ARequestUrl, ARequestHeader, APostData: AnsiString;
      out AResponseHeader, AResponseData: AnsiString
    ): Cardinal;
  public
    constructor Create(
      const ADownloader: IDownloader;
      const AInetConfig: IInetConfigStatic;
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer
    );
  end;

implementation

uses
  SysUtils,
  i_BinaryData,
  u_BinaryDataByMemStream,
  i_DownloadRequest,
  i_DownloadResult,
  u_DownloadRequest;

{ TSimpleHttpDownloader }

constructor TSimpleHttpDownloader.Create(
  const ADownloader: IDownloader;
  const AInetConfig: IInetConfigStatic;
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer
);
begin
  inherited Create;
  FDownloader := ADownloader;
  FInetConfig := AInetConfig;
  FCancelNotifier := ACancelNotifier;
  FOperationID := AOperationID;
end;

function TSimpleHttpDownloader.DoHttpRequest(
  const ARequestUrl, ARequestHeader, APostData: AnsiString;
  out AResponseHeader, AResponseData: AnsiString
): Cardinal;
var
  VRequest: IDownloadRequest;
  VResult: IDownloadResult;
  VResultOk: IDownloadResultOk;
  VResultWithRespond: IDownloadResultWithServerRespond;
  VPostData: IBinaryData;
begin
  Result := 0;
  AResponseHeader := '';
  AResponseData := '';
  if not FCancelNotifier.IsOperationCanceled(FOperationID) then begin
    if Length(APostData) > 0 then begin
      VPostData :=
        TBinaryDataByMemStream.CreateFromMem(
          Length(APostData),
          Addr(APostData[1])
        );
      VRequest :=
        TDownloadPostRequest.Create(
          ARequestUrl,
          ARequestHeader,
          VPostData,
          FInetConfig
        );
    end else begin
      VRequest :=
        TDownloadRequest.Create(
          ARequestUrl,
          ARequestHeader,
          FInetConfig
        );
    end;
    VResult := FDownloader.DoRequest(VRequest, FCancelNotifier, FOperationID);
    if VRequest <> nil then begin
      if Supports(VResult, IDownloadResultWithServerRespond, VResultWithRespond) then begin
        AResponseHeader := VResultWithRespond.RawResponseHeader;
        Result := VResultWithRespond.StatusCode;
        if Supports(VResult, IDownloadResultOk, VResultOk) then begin
          AResponseHeader := VResultOk.RawResponseHeader;
          SetLength(AResponseData, VResultOk.Data.Size);
          Move(VResultOk.Data.Buffer^, AResponseData[1], VResultOk.Data.Size);
        end;
      end;
    end;
  end;
end;

end.