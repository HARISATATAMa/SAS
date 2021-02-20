{*******************************************************************************

    Version: 0.1
    Copyright (C) 2009 Demydov Viktor
    mailto:vdemidov@gmail.com
    http://viktor.getcv.ru/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*******************************************************************************}
unit i_GUIDList;

interface
uses
  ActiveX;

type
  IGUIDInterfaceList = interface(IInterface)
  ['{BA17FFE8-E281-4E2E-8B92-8F39ACC67036}']
    // ���������� �������. ���� ������ � ����� GUID ��� ����, �� ���������� �� �����
    // ���������� �������� ������
    function Add(AGUID: TGUID; AInterface: IInterface): IInterface;

    // �������� ������� GUID � ������
    function IsExists(AGUID: TGUID): boolean;

    // ��������� ������� �� GUID
    function GetByGUID(AGUID: TGUID): IInterface;

    // ������ ������������� ������� �����, ���� �����������, �� ������ ���������
    procedure Replace(AGUID: TGUID; AInterface: IInterface);

    // �������� �������, ���� ��� � ����� GUID, �� ������ �� ����� �����������
    procedure Remove(AGUID: TGUID);

    // ������� ������
    procedure Clear;

    // ��������� ��������� GUID-��
    function GetGUIDEnum(): IEnumGUID;

    procedure SetCount(NewCount: Integer);
    function GetCount: Integer;
    property Count: Integer read GetCount write SetCount;
  end;

  IGUIDObjectList = interface(IInterface)
  ['{9E176E50-3182-455C-AF58-9B6FB8E30E15}']
    // ���������� �������. ���� ������ � ����� GUID ��� ����, �� ���������� �� �����
    // ���� ������ �������� ���������� �������� � ���������� ������ �� ����� ���������, �� �� ����� ������
    // ���������� �������� ������
    function Add(AGUID: TGUID; AObj: TObject): TObject;

    // �������� ������� GUID � ������
    function IsExists(AGUID: TGUID): boolean;

    // ��������� ������� �� GUID
    function GetByGUID(AGUID: TGUID): TObject;

    // ������ ������������� ������� �����, ���� �����������, �� ������ ���������
    procedure Replace(AGUID: TGUID; AObj: TObject);

    // �������� �������, ���� ��� � ����� GUID, �� ������ �� ����� �����������
    procedure Remove(AGUID: TGUID);

    // ������� ������
    procedure Clear;

    // ��������� ��������� GUID-��
    function GetGUIDEnum(): IEnumGUID;

    // �������� �� ���� ������ ���������� ��������
    function GetIsObjectOwner: Boolean;

    procedure SetCount(NewCount: Integer);
    function GetCount: Integer;
    property Count: Integer read GetCount write SetCount;
  end;

implementation

end.
 