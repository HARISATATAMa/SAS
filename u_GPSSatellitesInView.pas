unit u_GPSSatellitesInView;

interface

uses
  Classes,
  SysUtils,
  i_GPS;

type
  TGPSSatellitesInView = class(TInterfacedObject, IGPSSatellitesInView)
  private
    FFixCount: Integer;
    FItems: IInterfaceList;
  protected
    function GetCount: Integer; stdcall;
    function GetFixCount: Integer; stdcall;
    function GetItem(AIndex: Integer): IGPSSatelliteInfo; stdcall;
  public
    constructor Create(
      AFixCount: Integer;
      AItems: IInterfaceList
    );
    destructor Destroy; override;
  end;

implementation
{ TGPSSatellitesInView }

constructor TGPSSatellitesInView.Create(
  AFixCount: Integer; AItems: IInterfaceList);
begin
  FItems := AItems;
  if FItems <> nil then begin
    FFixCount := AFixCount;
    if FItems.Count < FFixCount then begin
      FFixCount := FItems.Count;
    end;
  end else begin
    FFixCount := 0;
  end;
end;

destructor TGPSSatellitesInView.Destroy;
begin
  FItems := nil;
  inherited;
end;

function TGPSSatellitesInView.GetCount: Integer;
begin
  if FItems <> nil then begin
    Result := FItems.Count;
  end else begin
    Result := 0;
  end;
end;

function TGPSSatellitesInView.GetFixCount: Integer;
begin
  Result := FFixCount;
end;

function TGPSSatellitesInView.GetItem(AIndex: Integer): IGPSSatelliteInfo;
begin
  if FItems <> nil then begin
    Result := IGPSSatelliteInfo(FItems[AIndex]);
  end else begin
    Result := nil;
  end;
end;

end.