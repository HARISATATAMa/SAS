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

unit u_MapViewPortState;

interface

uses
  Types,
  i_JclNotify,
  t_GeoTypes,
  i_CoordConverter,
  i_LocalCoordConverter,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_InternalPerformanceCounter,
  i_ViewPortState,
  i_ActiveMapsConfig,
  i_MapZoomingConfig,
  i_LocalCoordConverterFactorySimpe,
  u_ConfigDataElementBase;

type
  TMapViewPortState = class(TConfigDataElementBase, IViewPortState)
  private
    FMapZoomingConfig: IMapZoomingConfig;
    FScaleChangeNotifier: IJclNotifier;
    FMainCoordConverter: ICoordConverter;
    FVisibleCoordConverter: ILocalCoordConverter;
    FVisibleCoordConverterFactory: ILocalCoordConverterFactorySimpe;
    FMainMapConfig: IMainMapsConfig;

    FActiveCoordConverter: ICoordConverter;
    FCenterPos: TDoublePoint;
    FZoom: Byte;
    FViewSize: TPoint;

    FVisibleMove: TDoublePoint;
    FBaseScale: TDoublePoint;
    FMapScale: TDoublePoint;

    FPosChangeCounter: IInternalPerformanceCounter;
    FScaleChangeCounter: IInternalPerformanceCounter;
    FMainMapChangeListener: IJclListener;
    procedure SetActiveCoordConverter;
    procedure CreateVisibleCoordConverter;
    procedure OnMainMapChange(Sender: TObject);
    procedure ResetScaleAndMove;
    procedure NotifyChangeScale;
  protected
    procedure DoChangeNotify; override;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetMainCoordConverter: ICoordConverter;
    procedure SetMainCoordConverter(AValue: ICoordConverter);
    property MainCoordConverter: ICoordConverter read GetMainCoordConverter write SetMainCoordConverter;

    function GetCurrentCoordConverter: ICoordConverter;
    function GetCurrentZoom: Byte;

    function GetVisualCoordConverter: ILocalCoordConverter;

    procedure ChangeViewSize(ANewSize: TPoint);
    procedure ChangeMapPixelByDelta(ADelta: TDoublePoint);
    procedure ChangeMapPixelToVisualPoint(AVisualPoint: TPoint);
    procedure ChangeZoomWithFreezeAtVisualPoint(AZoom: Byte; AFreezePoint: TPoint);
    procedure ChangeZoomWithFreezeAtCenter(AZoom: Byte);

    procedure ChangeLonLat(ALonLat: TDoublePoint);

    procedure MoveTo(Pnt: TPoint);
    procedure ScaleTo(AScale: Double; ACenterPoint: TPoint); overload;
    procedure ScaleTo(AScale: Double); overload;

    function GetScaleChangeNotifier: IJclNotifier;
  public
    constructor Create(
      ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
      AMapZoomingConfig: IMapZoomingConfig;
      AMainMapConfig: IMainMapsConfig;
      APerfCounterList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_JclNotify,
  i_MapTypes,
  u_NotifyEventListener,
  u_GeoFun;

{ TMapViewPortStateNew }

constructor TMapViewPortState.Create(
  ACoordConverterFactory: ILocalCoordConverterFactorySimpe;
  AMapZoomingConfig: IMapZoomingConfig;
  AMainMapConfig: IMainMapsConfig;
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create;
  FPosChangeCounter := APerfCounterList.CreateAndAddNewCounter('PosChange');
  FScaleChangeCounter := APerfCounterList.CreateAndAddNewCounter('ScaleChange');

  FScaleChangeNotifier := TJclBaseNotifier.Create;
  FVisibleCoordConverterFactory := ACoordConverterFactory;
  FMainMapConfig := AMainMapConfig;
  FMapZoomingConfig := AMapZoomingConfig;
  FMainCoordConverter := nil;
  FCenterPos := DoublePoint(128, 128);
  FZoom := 0;
  FViewSize := Point(1024, 768);
  FBaseScale.X := 1;
  FBaseScale.Y := 1;
  ResetScaleAndMove;
  SetActiveCoordConverter;
  CreateVisibleCoordConverter;
  FMainMapChangeListener := TNotifyEventListener.Create(Self.OnMainMapChange);
  FMainMapConfig.GetChangeNotifier.Add(FMainMapChangeListener);
end;

destructor TMapViewPortState.Destroy;
begin
  FMainMapConfig.GetChangeNotifier.Remove(FMainMapChangeListener);
  FMainMapChangeListener := nil;
  FMainMapConfig := nil;
  FScaleChangeNotifier := nil;
  FVisibleCoordConverterFactory := nil;
  inherited;
end;

procedure TMapViewPortState.ChangeLonLat(ALonLat: TDoublePoint);
var
  VLonLat: TDoublePoint;
  VPixelPos: TDoublePoint;
  VPosChanged: Boolean;
begin
  LockWrite;
  try
    VLonLat := ALonLat;
    FActiveCoordConverter.CheckLonLatPos(VLonLat);
    VPixelPos := FActiveCoordConverter.LonLat2PixelPosFloat(VLonLat, FZoom);
    VPosChanged := not DoublePointsEqual(FCenterPos, VPixelPos);
    FCenterPos := VPixelPos;
    ResetScaleAndMove;
    if VPosChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeMapPixelByDelta(ADelta: TDoublePoint);
var
  VNewPos: TDoublePoint;
  VZoom: Byte;
  VChanged: Boolean;
begin
  LockWrite;
  try
    VZoom := FZoom;
    VNewPos.X := FCenterPos.X + ADelta.X / FBaseScale.X;
    VNewPos.Y := FCenterPos.Y + ADelta.Y / FBaseScale.Y;
    ResetScaleAndMove;
    FActiveCoordConverter.CheckPixelPosFloatStrict(VNewPos, VZoom, True);
    VChanged := not DoublePointsEqual(FCenterPos, VNewPos);
    FCenterPos := VNewPos;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeMapPixelToVisualPoint(
  AVisualPoint: TPoint);
var
  VNewPos: TDoublePoint;
  VZoom: Byte;
  VChanged: Boolean;
begin
  LockWrite;
  try
    VZoom := FZoom;
    VNewPos := FVisibleCoordConverter.LocalPixel2MapPixelFloat(AVisualPoint);
    FActiveCoordConverter.CheckPixelPosFloatStrict(VNewPos, VZoom, True);
    VChanged := not DoublePointsEqual(FCenterPos, VNewPos);;
    ResetScaleAndMove;
    FCenterPos := VNewPos;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeViewSize(ANewSize: TPoint);
var
  VChanged: Boolean;
begin
  if ANewSize.X <= 0 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  if ANewSize.X > 4096 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  if ANewSize.Y <= 0 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  if ANewSize.Y > 4096 then begin
    raise Exception.Create('��������� ������ ������������ �����');
  end;
  LockWrite;
  try
    VChanged := (FViewSize.X <> ANewSize.X) or (FViewSize.Y <> ANewSize.Y);
    ResetScaleAndMove;
    FViewSize := ANewSize;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeZoomWithFreezeAtCenter(AZoom: Byte);
var
  VRelativePoint: TDoublePoint;
  VZoom: Byte;
  VZoomOld: Byte;
  VChanged: Boolean;
begin
  VChanged := False;
  LockWrite;
  try
    VZoom := AZoom;
    FActiveCoordConverter.CheckZoom(VZoom);
    if FZoom <> VZoom then begin
      VChanged := True;
      VZoomOld := FZoom;
      ResetScaleAndMove;
      VRelativePoint := FActiveCoordConverter.PixelPosFloat2Relative(FCenterPos, VZoomOld);
      FCenterPos := FActiveCoordConverter.Relative2PixelPosFloat(VRelativePoint, VZoom);
      FZoom := VZoom;
    end;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.ChangeZoomWithFreezeAtVisualPoint(AZoom: Byte;
  AFreezePoint: TPoint);
var
  VZoom: Byte;
  VZoomOld: Byte;
  VMapFreezePoint: TDoublePoint;
  VRelativeFreezePoint: TDoublePoint;
  VMapFreezPointAtNewZoom: TDoublePoint;
  VNewCenterPos: TDoublePoint;
  VChanged: Boolean;
  VViewCenter: TPoint;
begin
  VChanged := False;
  LockWrite;
  try
    VZoom := AZoom;
    FActiveCoordConverter.CheckZoom(VZoom);
    if FZoom <> VZoom then begin
      VChanged := True;
      VZoomOld := FZoom;
      VMapFreezePoint := FVisibleCoordConverter.LocalPixel2MapPixelFloat(AFreezePoint);
      FActiveCoordConverter.CheckPixelPosFloat(VMapFreezePoint, VZoomOld, False);
      VRelativeFreezePoint := FActiveCoordConverter.PixelPosFloat2Relative(VMapFreezePoint, VZoomOld);
      VMapFreezPointAtNewZoom := FActiveCoordConverter.Relative2PixelPosFloat(VRelativeFreezePoint, VZoom);
      VViewCenter := Point(FViewSize.X div 2, FViewSize.Y div 2);

      VNewCenterPos.X := VMapFreezPointAtNewZoom.X - (AFreezePoint.X - VViewCenter.X) / FBaseScale.X;
      VNewCenterPos.Y := VMapFreezPointAtNewZoom.Y - (AFreezePoint.Y - VViewCenter.Y) / FBaseScale.Y;
      ResetScaleAndMove;
      FZoom := VZoom;

      FActiveCoordConverter.CheckPixelPosFloatStrict(VNewCenterPos, VZoom, False);
      FCenterPos := VNewCenterPos;
    end;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.CreateVisibleCoordConverter;
var
  VViewCenter: TPoint;
  VLocalTopLeftAtMap: TDoublePoint;
begin
  VViewCenter := Point(FViewSize.X div 2, FViewSize.Y div 2);
  VLocalTopLeftAtMap.X := (-VViewCenter.X + FVisibleMove.X) / FMapScale.X + FCenterPos.X;
  VLocalTopLeftAtMap.Y := (-VViewCenter.Y + FVisibleMove.Y) / FMapScale.Y + FCenterPos.Y;

  FVisibleCoordConverter := FVisibleCoordConverterFactory.CreateConverter(
    Rect(0, 0, FViewSize.X, FViewSize.Y),
    FZoom,
    FActiveCoordConverter,
    FMapScale,
    VLocalTopLeftAtMap
  );
end;

procedure TMapViewPortState.DoChangeNotify;
var
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FPosChangeCounter.StartOperation;
  try
    inherited;
  finally
    FPosChangeCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TMapViewPortState.DoReadConfig(AConfigData: IConfigDataProvider);
var
  VLonLat: TDoublePoint;
  VZoom: Byte;
begin
  inherited;
  if AConfigData <> nil then begin
    VZoom := AConfigData.ReadInteger('Zoom', FZoom);
    FActiveCoordConverter.CheckZoom(VZoom);
    VLonLat := FVisibleCoordConverter.GetCenterLonLat;
    VLonLat.X := AConfigData.ReadFloat('X', VLonLat.X);
    VLonLat.Y := AConfigData.ReadFloat('Y', VLonLat.Y);
    FActiveCoordConverter.CheckLonLatPos(VLonLat);
    if FZoom <> VZoom then begin
      FZoom := VZoom;
      SetChanged;
    end;
    ChangeLonLat(VLonLat);
  end;
end;

procedure TMapViewPortState.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
var
  VLonLat: TDoublePoint;
begin
  inherited;
  VLonLat := FVisibleCoordConverter.GetCenterLonLat;
  AConfigData.WriteInteger('Zoom', FZoom);
  AConfigData.WriteFloat('X', VLonLat.X);
  AConfigData.WriteFloat('Y', VLonLat.Y);
end;

function TMapViewPortState.GetCurrentCoordConverter: ICoordConverter;
begin
  LockRead;
  try
    Result := FActiveCoordConverter;
  finally
    UnlockRead;
  end;
end;

function TMapViewPortState.GetCurrentZoom: Byte;
begin
  LockRead;
  try
    Result := FZoom;
  finally
    UnlockRead;
  end;
end;

function TMapViewPortState.GetMainCoordConverter: ICoordConverter;
begin
  LockRead;
  try
    Result := FMainCoordConverter;
  finally
    UnlockRead;
  end;
end;

function TMapViewPortState.GetScaleChangeNotifier: IJclNotifier;
begin
  Result := FScaleChangeNotifier;
end;

function TMapViewPortState.GetVisualCoordConverter: ILocalCoordConverter;
begin
  LockRead;
  try
    Result := FVisibleCoordConverter;
  finally
    UnlockRead;
  end;
end;

procedure TMapViewPortState.MoveTo(Pnt: TPoint);
var
  VChanged: Boolean;
  VVisibleMove: TDoublePoint;
begin
  VChanged := False;
  LockWrite;
  try
    if not DoublePointsEqual(FMapScale, FBaseScale) then begin
      FMapScale := FBaseScale;
      VChanged := True;
    end;
    VVisibleMove.X := Pnt.X;
    VVisibleMove.Y := Pnt.Y;
    if not DoublePointsEqual(FVisibleMove, VVisibleMove) then begin
      FVisibleMove := VVisibleMove;
      VChanged := True;
    end;

    if VChanged then begin
      CreateVisibleCoordConverter;
    end;
  finally
    UnlockWrite;
  end;
  if VChanged then begin
    NotifyChangeScale;
  end;
end;

procedure TMapViewPortState.NotifyChangeScale;
var
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FScaleChangeCounter.StartOperation;
  try
    DoBeforeChangeNotify;
    try
      FScaleChangeNotifier.Notify(nil);
    finally
      DoAfterChangeNotify;
    end;
  finally
    FScaleChangeCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TMapViewPortState.OnMainMapChange(Sender: TObject);
begin
  SetActiveCoordConverter;
end;

procedure TMapViewPortState.ResetScaleAndMove;
begin
  FMapScale := FBaseScale;
  FVisibleMove.X := 0;
  FVisibleMove.Y := 0;
end;

procedure TMapViewPortState.ScaleTo(AScale: Double; ACenterPoint: TPoint);
var
  VVisiblePointFixed: TDoublePoint;
  VMapPointFixed: TDoublePoint;
  VNewVisualPoint: TDoublePoint;
  VNewMapScale: TDoublePoint;
  VNewVisibleMove: TDoublePoint;
  VChanged: Boolean;
  VViewCenter: TPoint;
begin
  VChanged := False;
  VVisiblePointFixed.X := ACenterPoint.X;
  VVisiblePointFixed.Y := ACenterPoint.Y;
  LockWrite;
  try
    if not DoublePointsEqual(FVisibleMove, DoublePoint(0,0)) then begin
      FVisibleMove.X := 0;
      FVisibleMove.Y := 0;
      VChanged := True;
    end;

    VNewMapScale.X := FBaseScale.X * AScale;
    VNewMapScale.Y := FBaseScale.X * AScale;
    if not DoublePointsEqual(FMapScale, VNewMapScale) then begin
      FMapScale := VNewMapScale;
      VChanged := True;
    end;
    VMapPointFixed := FVisibleCoordConverter.LocalPixelFloat2MapPixelFloat(VVisiblePointFixed);
    VViewCenter := Point(FViewSize.X div 2, FViewSize.Y div 2);
    VNewVisualPoint.X := (VMapPointFixed.X - FCenterPos.X) * FMapScale.X + VViewCenter.X;
    VNewVisualPoint.Y := (VMapPointFixed.Y - FCenterPos.Y) * FMapScale.Y + VViewCenter.Y;

    VNewVisibleMove.X := VNewVisualPoint.X - VVisiblePointFixed.X;
    VNewVisibleMove.Y := VNewVisualPoint.Y - VVisiblePointFixed.Y;
    if not DoublePointsEqual(FVisibleMove, VNewVisibleMove) then begin
      FVisibleMove := VNewVisibleMove;
      VChanged := True;
    end;
    if VChanged then begin
      CreateVisibleCoordConverter;
    end;
  finally
    UnlockWrite;
  end;
  if VChanged then begin
    NotifyChangeScale;
  end;
end;

procedure TMapViewPortState.ScaleTo(AScale: Double);
var
  VVisiblePointFixed: TDoublePoint;
  VMapPointFixed: TDoublePoint;
  VNewVisualPoint: TDoublePoint;
  VViewCenter: TPoint;
  VNewMapScale: TDoublePoint;
  VNewVisibleMove: TDoublePoint;
  VChanged: Boolean;
begin
  VChanged := False;
  LockWrite;
  try
    VViewCenter := Point(FViewSize.X div 2, FViewSize.Y div 2);
    VVisiblePointFixed.X := VViewCenter.X;
    VVisiblePointFixed.Y := VViewCenter.Y;
    VMapPointFixed := FVisibleCoordConverter.LocalPixelFloat2MapPixelFloat(VVisiblePointFixed);
    if not DoublePointsEqual(FVisibleMove, DoublePoint(0,0)) then begin
      FVisibleMove.X := 0;
      FVisibleMove.Y := 0;
      VChanged := True;
    end;

    VNewMapScale.X := FBaseScale.X * AScale;
    VNewMapScale.Y := FBaseScale.X * AScale;
    if not DoublePointsEqual(FMapScale, VNewMapScale) then begin
      FMapScale := VNewMapScale;
      VChanged := True;
    end;

    VNewVisualPoint.X := (VMapPointFixed.X - FCenterPos.X) * FMapScale.X + VViewCenter.X;
    VNewVisualPoint.Y := (VMapPointFixed.Y - FCenterPos.Y) * FMapScale.Y + VViewCenter.Y;
    VNewVisibleMove.X := VNewVisualPoint.X - VVisiblePointFixed.X;
    VNewVisibleMove.Y := VNewVisualPoint.Y - VVisiblePointFixed.Y;
    if not DoublePointsEqual(FVisibleMove, VNewVisibleMove) then begin
      FVisibleMove := VNewVisibleMove;
      VChanged := True;
    end;
    if VChanged then begin
      CreateVisibleCoordConverter;
    end;
  finally
    UnlockWrite;
  end;
  if VChanged then begin
    NotifyChangeScale;
  end;
end;

procedure TMapViewPortState.SetActiveCoordConverter;
var
  VNewConverter: ICoordConverter;
  VMap: IMapType;
  VCenterLonLat: TDoublePoint;
  VChanged: Boolean;
begin
  VChanged := False;
  LockWrite;
  try
    if FMainCoordConverter <> nil then begin
      VNewConverter := FMainCoordConverter;
    end else begin
      VMap := FMainMapConfig.GetSelectedMapType;
      if VMap <> nil then begin
        VNewConverter := VMap.MapType.ViewGeoConvert;
      end;
    end;
    if VNewConverter <> nil then begin
      if FActiveCoordConverter <> nil then begin
        if not FActiveCoordConverter.IsSameConverter(VNewConverter) then begin
          VCenterLonLat := FActiveCoordConverter.PixelPosFloat2LonLat(FCenterPos, FZoom);
          VNewConverter.CheckLonLatPos(VCenterLonLat);
          FCenterPos := VNewConverter.LonLat2PixelPosFloat(VCenterLonLat, FZoom);
          FActiveCoordConverter := VNewConverter;
          VChanged := True;
        end;
      end else begin
        FActiveCoordConverter := VNewConverter;
        VChanged := True;
      end;
    end;
    if VChanged then begin
      CreateVisibleCoordConverter;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TMapViewPortState.SetMainCoordConverter(AValue: ICoordConverter);
begin
  LockWrite;
  try
    if FMainCoordConverter <> AValue then begin
      FMainCoordConverter := AValue;
      SetActiveCoordConverter;
    end;
  finally
    UnlockWrite;
  end;
end;

end.