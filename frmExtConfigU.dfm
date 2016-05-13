object frmExtConfig: TfrmExtConfig
  Left = 0
  Top = 0
  Caption = 'External Function Configuration Utility for SIMION'
  ClientHeight = 540
  ClientWidth = 537
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 106
  TextHeight = 16
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 531
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    object sbLuaScript: TSpeedButton
      AlignWithMargins = True
      Left = 239
      Top = 3
      Width = 90
      Height = 30
      Align = alLeft
      Caption = 'Lua script'
      OnClick = sbLuaScriptClick
    end
    object sbSimion: TSpeedButton
      AlignWithMargins = True
      Left = 164
      Top = 3
      Width = 69
      Height = 30
      Align = alLeft
      Caption = 'Simion'
      OnClick = sbSimionClick
    end
    object sbSave: TSpeedButton
      AlignWithMargins = True
      Left = 81
      Top = 3
      Width = 72
      Height = 30
      Hint = 'Save configuration file'
      Align = alLeft
      Caption = 'Save'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FE3D3D3DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D3D3DBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FE3D3D3DFFFFFFFF0000FF0000FF
        0000FF0000FFFFFFFFFFFF3D3D3DBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FE3D3D3DFFFFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFF3D3D3DBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEC0C0C0FFFFFFFF0000FF0000FF
        0000FF0000FFFFFFFFFFFF3D3D3D3D3D3D3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        C0C0C0C0C0C0FF0000FF0000FF0000FFFFFFFF0000FFFFFFFFFFFF3D3D3D8080
        803D3D3DC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0000FF0000FF0000C0C0C0C0
        C0C0C0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3DC0C0C0C0C0C0C0C0C0C0C0C0
        FF0000FF0000FF0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0000C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
    end
    object sbOpen: TSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 72
      Height = 30
      Hint = 'Open configuration file'
      Align = alLeft
      Caption = 'Open'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FE3D3D3DC0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4FEBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FEBAF4FE3D3D3D3D3D3D3D3D3D3D
        3D3D3D3D3D3D3D3D3D3D3DBAF4FEBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FE3D3D3DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D3D3DBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FE3D3D3DFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFF3D3D3DBAF4FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3D
        BAF4FE3D3D3DFFFFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFF3D3D3DBAF4
        FE3D3D3DC0C0C0C0C0C0C0C0C03D3D3DBAF4FE3D3D3DFFFFFFFFFFFFFFFFFFFF
        0000FF0000FF0000FFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C03D3D3D
        BAF4FE3D3D3DFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000C0C0C0FF00
        00C0C0C0C0C0C0C0C0C0C0C0C03D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3DC0
        C0C0C0C0C0FF0000FF0000FF0000FF0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0000FF0000FF00
        00C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0FF0000FF0000FF0000FF0000C0C0C0C0C0C0C0C0C0}
    end
    object Shape1: TShape
      Left = 156
      Top = 0
      Width = 5
      Height = 36
      Align = alLeft
      Pen.Style = psClear
      ExplicitLeft = 92
      ExplicitTop = -4
      ExplicitHeight = 31
    end
    object chkNoGUI: TCheckBox
      AlignWithMargins = True
      Left = 335
      Top = 3
      Width = 66
      Height = 30
      Align = alLeft
      Caption = ' noGUI'
      TabOrder = 0
    end
  end
  object StatusBar1: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 517
    Width = 531
    Height = 22
    Margins.Bottom = 1
    AutoHint = True
    Color = clWhite
    Panels = <>
    SimplePanel = True
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 472
    Width = 531
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object OKBtn: TButton
      AlignWithMargins = True
      Left = 271
      Top = 3
      Width = 81
      Height = 33
      Align = alRight
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object CancelBtn: TButton
      AlignWithMargins = True
      Left = 358
      Top = 3
      Width = 80
      Height = 33
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      AlignWithMargins = True
      Left = 444
      Top = 3
      Width = 80
      Height = 33
      Margins.Right = 7
      Align = alRight
      Caption = '&Help'
      TabOrder = 2
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 42
    Width = 537
    Height = 427
    ActivePage = tsFeatures
    Align = alClient
    TabHeight = 24
    TabOrder = 3
    object tsFeatures: TTabSheet
      Caption = ' Features '
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbFeats: TListBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 110
        Height = 368
        Align = alLeft
        TabOrder = 0
        OnClick = lbFeatsClick
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 529
        Height = 19
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Adujstable features of the external function (object) '
        Color = 15925247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object leDftDbl: TLabeledEdit
        Left = 130
        Top = 56
        Width = 110
        Height = 24
        EditLabel.Width = 40
        EditLabel.Height = 16
        EditLabel.Caption = 'Default'
        TabOrder = 2
      end
      object leMinDbl: TLabeledEdit
        Left = 130
        Top = 112
        Width = 110
        Height = 24
        EditLabel.Width = 20
        EditLabel.Height = 16
        EditLabel.Caption = 'Min'
        TabOrder = 3
      end
      object leMaxDbl: TLabeledEdit
        Left = 262
        Top = 112
        Width = 110
        Height = 24
        EditLabel.Width = 23
        EditLabel.Height = 16
        EditLabel.Caption = 'Max'
        TabOrder = 4
      end
      object chkEnabled: TCheckBox
        Left = 357
        Top = 48
        Width = 97
        Height = 17
        Caption = 'Enabled'
        TabOrder = 5
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 472
    Top = 40
    object pmRunSimion: TMenuItem
      Caption = 'Run Simion'
      OnClick = pmRunSimionClick
    end
    object pmPokeWithDatum: TMenuItem
      Caption = 'Poke with datum'
      OnClick = pmPokeWithDatumClick
    end
    object pmCloseSimion: TMenuItem
      Caption = 'Close Simion'
      OnClick = pmCloseSimionClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 192
  end
end
