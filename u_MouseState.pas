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

unit u_MouseState;

interface

uses
  Windows,
  Types,
  SyncObjs,
  Classes,
  Controls,
  t_GeoTypes,
  i_MouseState,
  i_MouseHandler;

const
  CPrevSpeedCount = 8;

type
  TMouseState = class(TInterfacedObject, IMouseState, IMouseHandler)
  private
    FCS: TCriticalSection;
    FMinTime: Double;
    FMaxTime: Double;
    FUsedTime: Double;

    FPrevSpeedUsed: Integer;
    FPrevPoints: array[0..CPrevSpeedCount-1] of TPoint;
    FPrevTime: array[0..CPrevSpeedCount-1] of Double;

    FCurentPos: TPoint;
    FCurentTime: TLargeInteger;
    FCurrentSpeed: TDoublePoint;

    FCurrentShift: TShiftState;
    FLastDownPos: array [TMouseButton] of TPoint;
    FLastDownShift: array [TMouseButton] of TShiftState;
    FLastUpPos: array [TMouseButton] of TPoint;
    FLastUpShift: array [TMouseButton] of TShiftState;

    procedure SetCurrentPos(
      const APosition: TPoint
    );
  protected
    function GetCurentPos: TPoint;
    function GetCurentSpeed: TDoublePoint;
    function GetCurrentShift: TShiftState;

    function GetLastDownShift(AButton: TMouseButton): TShiftState;
    function GetLastDownPos(AButton: TMouseButton): TPoint;
    function GetLastUpShift(AButton: TMouseButton): TShiftState;
    function GetLastUpPos(AButton: TMouseButton): TPoint;
  protected
    procedure OnMouseMove(
      AShift: TShiftState;
      const APosition: TPoint
    );
    procedure OnMouseDown(
      AButton: TMouseButton;
      AShift: TShiftState;
      const APosition: TPoint
    );
    procedure OnMouseUp(
      AButton: TMouseButton;
      AShift: TShiftState;
      const APosition: TPoint
    );
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TMouseState }

constructor TMouseState.Create;
begin
  FCS := TCriticalSection.Create;
  FCurentTime := 0;
  FMinTime := 0.001;
  FMaxTime := 3;
  FUsedTime := 0.1;
  FPrevSpeedUsed := 0;
end;

destructor TMouseState.Destroy;
begin
  FreeAndNil(FCS);
  inherited;
end;

function TMouseState.GetCurentPos: TPoint;
begin
  FCS.Acquire;
  try
    Result := FCurentPos;
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetCurentSpeed: TDoublePoint;
begin
  FCS.Acquire;
  try
    Result := FCurrentSpeed;
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetCurrentShift: TShiftState;
begin
  FCS.Acquire;
  try
    Result := FCurrentShift;
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetLastDownPos(AButton: TMouseButton): TPoint;
begin
  FCS.Acquire;
  try
    Result := FLastDownPos[AButton];
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetLastDownShift(AButton: TMouseButton): TShiftState;
begin
  FCS.Acquire;
  try
    Result := FLastDownShift[AButton];
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetLastUpPos(AButton: TMouseButton): TPoint;
begin
  FCS.Acquire;
  try
    Result := FLastUpPos[AButton];
  finally
    FCS.Release;
  end;
end;

function TMouseState.GetLastUpShift(AButton: TMouseButton): TShiftState;
begin
  FCS.Acquire;
  try
    Result := FLastUpShift[AButton];
  finally
    FCS.Release;
  end;
end;

procedure TMouseState.OnMouseDown(
  AButton: TMouseButton;
  AShift: TShiftState;
  const APosition: TPoint
);
begin
  FCS.Acquire;
  try
    SetCurrentPos(APosition);
    FCurrentShift := AShift;
    FLastDownPos[AButton] := APosition;
    FLastDownShift[AButton] := AShift;
    FLastUpPos[AButton] := APosition;
    FLastUpShift[AButton] := AShift;
  finally
    FCS.Release;
  end;
end;

procedure TMouseState.OnMouseMove(
  AShift: TShiftState;
  const APosition: TPoint
);
begin
  FCS.Acquire;
  try
    SetCurrentPos(APosition);
    FCurrentShift := AShift;
  finally
    FCS.Release;
  end;
end;

procedure TMouseState.OnMouseUp(
  AButton: TMouseButton;
  AShift: TShiftState;
  const APosition: TPoint
);
begin
  FCS.Acquire;
  try
    SetCurrentPos(APosition);
    FCurrentShift := AShift;
    FLastUpPos[AButton] := APosition;
    FLastUpShift[AButton] := AShift;
  finally
    FCS.Release;
  end;
end;

procedure TMouseState.SetCurrentPos(
  const APosition: TPoint
);
var
  VCurrTime: TLargeInteger;
  VFrequency: TLargeInteger;
  VTimeFromLastMove: Double;
  VCurrentDelta: TPoint;
  VCurrentSpeed: TDoublePoint;
  VNotUsedTime: Double;
  VUsedTime: Double;
  VAvgDelta: TDoublePoint;
  VAvgSpeed: TDoublePoint;
  VFirstPoint, VSecondPoint: TPoint;
  i: Integer;
begin
  QueryPerformanceCounter(VCurrTime);
  if FCurentTime <> 0 then begin
    QueryPerformanceFrequency(VFrequency);
    VTimeFromLastMove := (VCurrTime - FCurentTime) / VFrequency;
    if VTimeFromLastMove < FMaxTime then begin
      if VTimeFromLastMove > FMinTime then begin
        VCurrentDelta.X := FCurentPos.X - APosition.X;
        VCurrentDelta.Y := FCurentPos.Y - APosition.Y;

        VCurrentSpeed.X := VCurrentDelta.X / VTimeFromLastMove;
        VCurrentSpeed.Y := VCurrentDelta.Y / VTimeFromLastMove;

        VNotUsedTime := FUsedTime - VTimeFromLastMove;
        if (VNotUsedTime > 0) and (FPrevSpeedUsed > 0) then begin
          VAvgDelta.X := VCurrentDelta.X;
          VAvgDelta.Y := VCurrentDelta.Y;
          i := 0;
          while ((i < FPrevSpeedUsed) and (FPrevTime[i] < VNotUsedTime)) do begin
            VNotUsedTime := VNotUsedTime - FPrevTime[i];
            Inc(i);
          end;
          if (i < FPrevSpeedUsed) then begin
            if (VNotUsedTime > 0) then begin
              VFirstPoint := FPrevPoints[i];
              if i = 0 then begin
                VSecondPoint := FCurentPos;
              end else begin
                VSecondPoint := FPrevPoints[i - 1];
              end;
              VAvgDelta.X := VSecondPoint.X - (VSecondPoint.X - VFirstPoint.X) * VNotUsedTime / FPrevTime[i] - APosition.X;
              VAvgDelta.Y := VSecondPoint.Y - (VSecondPoint.Y - VFirstPoint.Y) * VNotUsedTime / FPrevTime[i] - APosition.Y;
              VNotUsedTime := 0;
            end else begin
              VAvgDelta.X := FPrevPoints[i].X - APosition.X;
              VAvgDelta.Y := FPrevPoints[i].Y - APosition.Y;
            end;
          end else begin
            VAvgDelta.X := FPrevPoints[i - 1].X - APosition.X;
            VAvgDelta.Y := FPrevPoints[i - 1].Y - APosition.Y;
          end;
          VUsedTime := FUsedTime - VNotUsedTime;
          VAvgSpeed.X := VAvgDelta.X / VUsedTime;
          VAvgSpeed.Y := VAvgDelta.Y / VUsedTime;
        end else begin
          VAvgSpeed := VCurrentSpeed;
        end;
        FCurrentSpeed := VAvgSpeed;
        if FPrevSpeedUsed < CPrevSpeedCount then begin
          Inc(FPrevSpeedUsed);
        end;
        for i := FPrevSpeedUsed - 1 downto 1 do begin
          FPrevPoints[i] := FPrevPoints[i - 1];
          FPrevTime[i] := FPrevTime[i - 1];
        end;
        FPrevPoints[0] := FCurentPos;
        FPrevTime[0] := VTimeFromLastMove;
      end;
    end else begin
      FCurrentSpeed.X := 0;
      FCurrentSpeed.Y := 0;
      FPrevSpeedUsed := 0;
    end;
  end else begin
    FCurrentSpeed.X := 0;
    FCurrentSpeed.Y := 0;
  end;

  FCurentPos := APosition;
  FCurentTime := VCurrTime;
end;

end.