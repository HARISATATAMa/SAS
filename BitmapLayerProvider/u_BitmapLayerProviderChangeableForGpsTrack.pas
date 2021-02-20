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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_BitmapLayerProviderChangeableForGpsTrack;

interface

uses
  i_NotifierTime,
  i_MapLayerGPSTrackConfig,
  i_Bitmap32BufferFactory,
  i_GPSRecorder,
  i_InternalPerformanceCounter,
  i_SimpleFlag,
  i_ListenerNotifierLinksList,
  i_BitmapLayerProvider,
  u_BitmapLayerProviderChangeableBase;

type
  TBitmapLayerProviderChangeableForGpsTrack = class(TBitmapLayerProviderChangeableBase)
  private
    FConfig: IMapLayerGPSTrackConfig;
    FBitmapFactory: IBitmap32BufferFactory;
    FGPSRecorder: IGpsTrackRecorder;

    FGetTrackCounter: IInternalPerformanceCounter;
    FGpsPosChangeFlag: ISimpleFlag;

    procedure OnConfigChange;
    procedure OnGPSRecorderChange;
    procedure OnTimer;
  protected
    function CreateStatic: IInterface; override;
  public
    constructor Create(
      const APerfList: IInternalPerformanceCounterList;
      const ATimerNoifier: INotifierTime;
      const AConfig: IMapLayerGPSTrackConfig;
      const ABitmapFactory: IBitmap32BufferFactory;
      const AGPSRecorder: IGpsTrackRecorder
    );
  end;

implementation

uses
  u_ListenerByEvent,
  u_ListenerTime,
  u_SimpleFlagWithInterlock,
  u_BitmapLayerProviderByTrackPath;

{ TBitmapLayerProviderChangeableForGpsTrack }

constructor TBitmapLayerProviderChangeableForGpsTrack.Create(
  const APerfList: IInternalPerformanceCounterList;
  const ATimerNoifier: INotifierTime;
  const AConfig: IMapLayerGPSTrackConfig;
  const ABitmapFactory: IBitmap32BufferFactory;
  const AGPSRecorder: IGpsTrackRecorder
);
begin
  inherited Create;
  FConfig := AConfig;
  FGPSRecorder := AGPSRecorder;
  FBitmapFactory := ABitmapFactory;

  FGetTrackCounter := APerfList.CreateAndAddNewCounter('GetTrack');
  FGpsPosChangeFlag := TSimpleFlagWithInterlock.Create;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.ChangeNotifier
  );
  LinksList.Add(
    TListenerTimeCheck.Create(Self.OnTimer, 1000),
    ATimerNoifier
  );
  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnGPSRecorderChange),
    FGPSRecorder.ChangeNotifier
  );
end;

function TBitmapLayerProviderChangeableForGpsTrack.CreateStatic: IInterface;
var
  VResult: IBitmapLayerProvider;
  VTrackColorer: ITrackColorerStatic;
  VPointsCount: Integer;
  VLineWidth: Double;
  VEnum: IEnumGPSTrackPoint;
  VVisible: Boolean;
begin
  VResult := nil;
  FConfig.LockRead;
  try
    VVisible := FConfig.Visible;
    VPointsCount := FConfig.LastPointCount;
    VLineWidth := FConfig.LineWidth;
    VTrackColorer := FConfig.TrackColorerConfig.GetStatic;
  finally
    FConfig.UnlockRead
  end;

  if VVisible and (VPointsCount > 1) then begin
    VEnum := FGPSRecorder.LastPoints(VPointsCount);
    VResult :=
      TBitmapLayerProviderByTrackPath.Create(
        VPointsCount,
        VLineWidth,
        VTrackColorer,
        FBitmapFactory,
        VEnum
      );
  end;
  Result := VResult;
end;

procedure TBitmapLayerProviderChangeableForGpsTrack.OnConfigChange;
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TBitmapLayerProviderChangeableForGpsTrack.OnGPSRecorderChange;
begin
  FGpsPosChangeFlag.SetFlag;
end;

procedure TBitmapLayerProviderChangeableForGpsTrack.OnTimer;
begin
  if FGpsPosChangeFlag.CheckFlagAndReset then begin
    LockWrite;
    try
      SetChanged;
    finally
      UnlockWrite;
    end;
  end;
end;

end.
