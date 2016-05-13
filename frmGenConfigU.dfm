object frmGenConfig: TfrmGenConfig
  Left = 0
  Top = 0
  Caption = 'Property Configuration editor'
  ClientHeight = 608
  ClientWidth = 504
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
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 568
    Width = 498
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object OKBtn: TButton
      AlignWithMargins = True
      Left = 238
      Top = 3
      Width = 81
      Height = 31
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
      Left = 325
      Top = 3
      Width = 80
      Height = 31
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      AlignWithMargins = True
      Left = 411
      Top = 3
      Width = 80
      Height = 31
      Margins.Right = 7
      Align = alRight
      Caption = '&Help'
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 498
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object sbRemove: TSpeedButton
      AlignWithMargins = True
      Left = 263
      Top = 3
      Width = 114
      Height = 30
      Align = alLeft
      Caption = 'Remove prop'
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        0400000000006000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000003
        000030FBFBFBFB03000030BFBFBFBF03000030FBFBFBFB03000030BFBFBFBF03
        000030F000000B03000030BFBFBFBF03000030FBFBFBFB03000030BFBFBFBF03
        000030FBFBFBFB03000030000000000300003333333333330000}
      OnClick = sbRemoveClick
      ExplicitLeft = 247
    end
    object sbNewProp: TSpeedButton
      AlignWithMargins = True
      Left = 164
      Top = 3
      Width = 93
      Height = 30
      Align = alLeft
      Caption = 'New prop'
      Glyph.Data = {
        E6010000424DE60100000000000036000000280000000C0000000C0000000100
        180000000000B0010000120B0000120B00000000000000000000FF00FF000000
        000000000000000000000000000000000000000000000000000000000000FF00
        FF000000D2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECC00
        0000FF00FF000000D2FECCD2FECCD2FECCD2FECC000000D2FECCD2FECCD2FECC
        D2FECC000000FF00FF000000D2FECCD2FECCD2FECCD2FECC000000D2FECCD2FE
        CCD2FECCD2FECC000000FF00FF000000D2FECCD2FECCD2FECCD2FECC000000D2
        FECCD2FECCD2FECCD2FECC000000FF00FF000000D2FECC000000000000000000
        000000000000000000000000D2FECC000000FF00FF000000D2FECCD2FECCD2FE
        CCD2FECC000000D2FECCD2FECCD2FECCD2FECC000000FF00FF000000D2FECCD2
        FECCD2FECCD2FECC000000D2FECCD2FECCD2FECCD2FECC000000FF00FF000000
        D2FECCD2FECCD2FECCD2FECC000000D2FECCD2FECCD2FECCD2FECC000000FF00
        FF000000D2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECCD2FECC00
        0000FF00FF000000000000000000000000000000000000000000000000000000
        000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF}
      OnClick = sbNewPropClick
    end
    object sbSave: TSpeedButton
      AlignWithMargins = True
      Left = 81
      Top = 3
      Width = 72
      Height = 30
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
      OnClick = sbSaveClick
    end
    object sbOpen: TSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 72
      Height = 30
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
      OnClick = sbOpenClick
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
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 45
    Width = 498
    Height = 517
    Align = alClient
    BevelOuter = bvSpace
    TabOrder = 2
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 109
      Height = 515
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lbProps: TListBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 103
        Height = 471
        Align = alClient
        TabOrder = 0
        OnClick = lbPropsClick
      end
      object Panel5: TPanel
        Left = 0
        Top = 477
        Width = 109
        Height = 38
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object sbRename: TSpeedButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 71
          Height = 32
          Align = alLeft
          Caption = 'Rename'
          OnClick = sbRenameClick
        end
        object SpinButton1: TSpinButton
          AlignWithMargins = True
          Left = 78
          Top = 3
          Width = 26
          Height = 32
          Margins.Right = 5
          Align = alRight
          DownGlyph.Data = {
            0E010000424D0E01000000000000360000002800000009000000060000000100
            200000000000D800000000000000000000000000000000000000008080000080
            8000008080000080800000808000008080000080800000808000008080000080
            8000008080000080800000808000000000000080800000808000008080000080
            8000008080000080800000808000000000000000000000000000008080000080
            8000008080000080800000808000000000000000000000000000000000000000
            0000008080000080800000808000000000000000000000000000000000000000
            0000000000000000000000808000008080000080800000808000008080000080
            800000808000008080000080800000808000}
          TabOrder = 0
          UpGlyph.Data = {
            0E010000424D0E01000000000000360000002800000009000000060000000100
            200000000000D800000000000000000000000000000000000000008080000080
            8000008080000080800000808000008080000080800000808000008080000080
            8000000000000000000000000000000000000000000000000000000000000080
            8000008080000080800000000000000000000000000000000000000000000080
            8000008080000080800000808000008080000000000000000000000000000080
            8000008080000080800000808000008080000080800000808000000000000080
            8000008080000080800000808000008080000080800000808000008080000080
            800000808000008080000080800000808000}
          OnDownClick = SpinButton1DownClick
          OnUpClick = SpinButton1UpClick
        end
      end
    end
    object Panel6: TPanel
      Left = 110
      Top = 1
      Width = 387
      Height = 515
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object PageControl1: TPageControl
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 381
        Height = 441
        ActivePage = TabSheet2
        Align = alClient
        TabHeight = 25
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Integer'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object leDftInt: TLabeledEdit
            Left = 10
            Top = 40
            Width = 110
            Height = 24
            EditLabel.Width = 40
            EditLabel.Height = 16
            EditLabel.Caption = 'Default'
            NumbersOnly = True
            TabOrder = 0
          end
          object leMinInt: TLabeledEdit
            Left = 10
            Top = 104
            Width = 110
            Height = 24
            EditLabel.Width = 20
            EditLabel.Height = 16
            EditLabel.Caption = 'Min'
            NumbersOnly = True
            TabOrder = 1
          end
          object leMaxInt: TLabeledEdit
            Left = 138
            Top = 104
            Width = 110
            Height = 24
            EditLabel.Width = 23
            EditLabel.Height = 16
            EditLabel.Caption = 'Max'
            NumbersOnly = True
            TabOrder = 2
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Double'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object leDftDbl: TLabeledEdit
            Left = 10
            Top = 40
            Width = 110
            Height = 24
            EditLabel.Width = 40
            EditLabel.Height = 16
            EditLabel.Caption = 'Default'
            TabOrder = 0
          end
          object leMinDbl: TLabeledEdit
            Left = 10
            Top = 104
            Width = 110
            Height = 24
            EditLabel.Width = 20
            EditLabel.Height = 16
            EditLabel.Caption = 'Min'
            TabOrder = 1
          end
          object leMaxDbl: TLabeledEdit
            Left = 146
            Top = 104
            Width = 110
            Height = 24
            EditLabel.Width = 23
            EditLabel.Height = 16
            EditLabel.Caption = 'Max'
            TabOrder = 2
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Boolean'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object chkDftBool: TCheckBox
            Left = 10
            Top = 40
            Width = 97
            Height = 17
            Caption = 'Default'
            TabOrder = 0
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Selection'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object mmSelect: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 85
            Width = 367
            Height = 318
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 373
            Height = 82
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object leDftSel: TLabeledEdit
              Left = 10
              Top = 40
              Width = 121
              Height = 24
              EditLabel.Width = 111
              EditLabel.Height = 16
              EditLabel.Caption = 'Default (idx or text)'
              TabOrder = 0
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'String'
          ImageIndex = 4
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object leDftStr: TLabeledEdit
            Left = 10
            Top = 40
            Width = 121
            Height = 24
            EditLabel.Width = 40
            EditLabel.Height = 16
            EditLabel.Caption = 'Default'
            TabOrder = 0
          end
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 447
        Width = 387
        Height = 68
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          AlignWithMargins = True
          Left = 7
          Top = 15
          Width = 22
          Height = 16
          Margins.Left = 7
          Align = alBottom
          Caption = 'Hint'
        end
        object eHint: TEdit
          AlignWithMargins = True
          Left = 7
          Top = 37
          Width = 377
          Height = 24
          Margins.Left = 7
          Margins.Bottom = 7
          Align = alBottom
          TabOrder = 0
        end
        object chkReadOnly: TCheckBox
          AlignWithMargins = True
          Left = 61
          Top = 9
          Width = 97
          Height = 17
          Caption = 'ReadOnly'
          TabOrder = 1
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 208
    Top = 208
  end
  object SaveDialog1: TSaveDialog
    Left = 280
    Top = 216
  end
end
