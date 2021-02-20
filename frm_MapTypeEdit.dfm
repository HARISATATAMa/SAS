object frmMapTypeEdit: TfrmMapTypeEdit
  Left = 198
  Top = 305
  BorderIcons = [biSystemMenu]
  ClientHeight = 273
  ClientWidth = 452
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 460
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 236
    Width = 452
    Height = 37
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    ExplicitTop = 248
    ExplicitWidth = 508
    object btnByDefault: TButton
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 105
      Height = 23
      Align = alLeft
      Caption = #1042#1089#1077' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      TabOrder = 0
      OnClick = btnByDefaultClick
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 290
      Top = 6
      Width = 75
      Height = 23
      Align = alRight
      Caption = #1055#1088#1080#1085#1103#1090#1100
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOkClick
      ExplicitLeft = 346
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 371
      Top = 6
      Width = 75
      Height = 23
      Align = alRight
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ModalResult = 2
      TabOrder = 2
      ExplicitLeft = 427
    end
  end
  object pnlSeparator: TPanel
    Left = 0
    Top = 194
    Width = 452
    Height = 42
    Align = alBottom
    BevelEdges = []
    BevelKind = bkTile
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    ExplicitTop = 206
    ExplicitWidth = 508
    object CheckBox1: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 3
      Width = 440
      Height = 17
      Margins.Top = 0
      Align = alTop
      Caption = #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1074' '#1084#1077#1085#1102' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1087#1086#1089#1083#1077' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1101#1090#1086#1081' '#1082#1072#1088#1090#1099
      TabOrder = 0
      ExplicitWidth = 496
    end
    object CheckEnabled: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 23
      Width = 440
      Height = 17
      Margins.Top = 0
      Align = alTop
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1082#1072#1088#1090#1091
      TabOrder = 1
      ExplicitWidth = 496
    end
  end
  object pnlCacheType: TPanel
    Left = 0
    Top = 161
    Width = 452
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 2
    ExplicitTop = 173
    ExplicitWidth = 508
    object Label5: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 46
      Height = 21
      Align = alLeft
      Caption = #1058#1080#1087' '#1082#1101#1096#1072
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object CBCacheType: TComboBox
      AlignWithMargins = True
      Left = 58
      Top = 6
      Width = 361
      Height = 21
      Align = alClient
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        'GoogleMV'
        'SAS.'#1055#1083#1072#1085#1077#1090#1072
        'EarthSlicer 1.95'
        'Googe maps tiles'
        'Google Earth')
      ExplicitWidth = 417
    end
    object Button9: TButton
      AlignWithMargins = True
      Left = 425
      Top = 6
      Width = 21
      Height = 21
      Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Align = alRight
      Caption = '<>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button9Click
      ExplicitLeft = 481
    end
  end
  object pnlParentItem: TPanel
    Left = 0
    Top = 128
    Width = 452
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    ExplicitTop = 140
    ExplicitWidth = 508
    object Label3: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 135
      Height = 21
      Align = alLeft
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1087#1091#1085#1082#1090' '#1084#1077#1085#1102
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object EditParSubMenu: TEdit
      AlignWithMargins = True
      Left = 147
      Top = 6
      Width = 272
      Height = 21
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 328
    end
    object Button5: TButton
      AlignWithMargins = True
      Left = 425
      Top = 6
      Width = 21
      Height = 21
      Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Align = alRight
      Caption = '<>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button5Click
      ExplicitLeft = 481
    end
  end
  object pnlCacheName: TPanel
    Left = 0
    Top = 95
    Width = 452
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 4
    ExplicitTop = 107
    ExplicitWidth = 508
    object Label2: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 85
      Height = 21
      Align = alLeft
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074' '#1082#1101#1096#1077
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object EditNameinCache: TEdit
      AlignWithMargins = True
      Left = 97
      Top = 6
      Width = 322
      Height = 21
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 378
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 425
      Top = 6
      Width = 21
      Height = 21
      Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Align = alRight
      Caption = '<>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button4Click
      ExplicitLeft = 481
    end
  end
  object pnlUrl: TPanel
    Left = 0
    Top = 20
    Width = 452
    Height = 42
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 5
    ExplicitWidth = 508
    ExplicitHeight = 54
    object Label1: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 19
      Height = 30
      Align = alLeft
      Caption = 'URL'
      ExplicitHeight = 13
    end
    object pnlUrlRight: TPanel
      Left = 422
      Top = 3
      Width = 27
      Height = 36
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 478
      ExplicitHeight = 48
      object Button6: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 21
        Height = 21
        Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        Align = alTop
        Caption = '<>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = Button6Click
      end
    end
    object EditURL: TMemo
      AlignWithMargins = True
      Left = 31
      Top = 6
      Width = 388
      Height = 30
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 1
      WantReturns = False
      ExplicitWidth = 444
      ExplicitHeight = 42
    end
  end
  object grdpnlSleepAndKey: TGridPanel
    Left = 0
    Top = 62
    Width = 452
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = grdpnlHotKey
        Row = 0
      end
      item
        Column = 1
        Control = grdpnlSleep
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 6
    ExplicitTop = 74
    ExplicitWidth = 508
    object grdpnlHotKey: TGridPanel
      Left = 3
      Top = 3
      Width = 222
      Height = 25
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAuto
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAuto
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 27.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 1
          Control = EditHotKey
          Row = 0
        end
        item
          Column = 2
          Control = Button7
          Row = 0
        end
        item
          Column = 0
          Control = Label4
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      DesignSize = (
        222
        25)
      object EditHotKey: THotKey
        Left = 94
        Top = 2
        Width = 96
        Height = 21
        Anchors = []
        HotKey = 0
        Modifiers = []
        TabOrder = 0
      end
      object Button7: TButton
        AlignWithMargins = True
        Left = 193
        Top = 3
        Width = 21
        Height = 19
        Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        Caption = '<>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button7Click
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 6
        Width = 88
        Height = 13
        Anchors = []
        Caption = #1043#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072
      end
    end
    object grdpnlSleep: TGridPanel
      Left = 296
      Top = 3
      Width = 153
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAuto
          Value = 50.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 27.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Label6
          Row = 0
        end
        item
          Column = 1
          Control = SESleep
          Row = 0
        end
        item
          Column = 2
          Control = Button8
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      ExplicitLeft = 352
      DesignSize = (
        153
        27)
      object Label6: TLabel
        Left = 0
        Top = 7
        Width = 30
        Height = 13
        Anchors = []
        Caption = #1055#1072#1091#1079#1072
        ExplicitLeft = -3
        ExplicitTop = 3
      end
      object SESleep: TSpinEdit
        AlignWithMargins = True
        Left = 33
        Top = 3
        Width = 89
        Height = 22
        Anchors = []
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object Button8: TButton
        AlignWithMargins = True
        Left = 129
        Top = 3
        Width = 21
        Height = 21
        Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        Anchors = []
        Caption = '<>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button8Click
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 452
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    ExplicitWidth = 508
    object lblZmpName: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 20
      Height = 14
      Align = alLeft
      Caption = 'Zmp'
      ExplicitHeight = 13
    end
    object edtZmp: TEdit
      AlignWithMargins = True
      Left = 29
      Top = 3
      Width = 420
      Height = 14
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      ExplicitWidth = 476
    end
  end
end