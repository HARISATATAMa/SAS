object frmGoTo: TfrmGoTo
  Left = 295
  Top = 179
  AlphaBlendValue = 220
  Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082'...'
  ClientHeight = 233
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object grpMarks: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 325
    Height = 45
    Align = alTop
    Caption = ' '
    TabOrder = 0
    ExplicitWidth = 331
    object cbbAllMarks: TComboBox
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 315
      Height = 21
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbbAllMarksDropDown
      OnDropDown = cbbAllMarksDropDown
      OnEnter = cbbAllMarksEnter
      ExplicitWidth = 321
    end
  end
  object grpGeoCode: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 54
    Width = 325
    Height = 49
    Align = alTop
    Caption = ' '
    TabOrder = 1
    ExplicitWidth = 331
    object edtGeoCode: TEdit
      AlignWithMargins = True
      Left = 7
      Top = 18
      Width = 311
      Height = 24
      Margins.Left = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
      OnClick = edtGeoCodeClick
      ExplicitWidth = 317
      ExplicitHeight = 21
    end
  end
  object grpLonLat: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 109
    Width = 325
    Height = 90
    Align = alClient
    Caption = ' '
    TabOrder = 2
    OnEnter = grpLonLatEnter
    ExplicitWidth = 331
    ExplicitHeight = 87
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 202
    Width = 331
    Height = 31
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 199
    ExplicitWidth = 337
    object lblZoom: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 58
      Height = 20
      Margins.Bottom = 8
      Align = alLeft
      Alignment = taRightJustify
      Caption = #1052#1072#1089#1096#1090#1072#1073': x'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object cbbZoom: TComboBox
      AlignWithMargins = True
      Left = 67
      Top = 3
      Width = 41
      Height = 21
      Align = alLeft
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '01'
      Items.Strings = (
        '01'
        '02'
        '03'
        '04'
        '05'
        '06'
        '07'
        '08'
        '09'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16'
        '17'
        '18'
        '19'
        '20'
        '21'
        '22'
        '23'
        '24')
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 253
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 259
    end
    object btnGoTo: TButton
      AlignWithMargins = True
      Left = 172
      Top = 3
      Width = 75
      Height = 25
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1076#1072#1085#1085#1091#1102' '#1090#1086#1095#1082#1091
      Align = alRight
      Caption = #1055#1077#1088#1077#1081#1090#1080
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnGoToClick
      ExplicitLeft = 178
    end
  end
  object RB3: TRadioButton
    Left = 13
    Top = 1
    Width = 124
    Height = 17
    Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1084#1077#1090#1082#1080
    TabOrder = 4
  end
  object RB2: TRadioButton
    Left = 13
    Top = 51
    Width = 62
    Height = 17
    Caption = 'Google!'
    Checked = True
    TabOrder = 5
    TabStop = True
  end
  object RB4: TRadioButton
    Left = 72
    Top = 51
    Width = 58
    Height = 17
    Caption = #1071#1085#1076#1077#1082#1089
    TabOrder = 6
  end
  object RB1: TRadioButton
    Left = 13
    Top = 106
    Width = 85
    Height = 17
    Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
    TabOrder = 7
  end
end