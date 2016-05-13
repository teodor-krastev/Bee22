object fmScanProp: TfmScanProp
  Left = 0
  Top = 0
  Width = 451
  Height = 172
  Align = alTop
  AutoSize = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 35
    Width = 451
    Height = 26
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lbStyle: TLabel
      AlignWithMargins = True
      Left = 405
      Top = 5
      Width = 39
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 7
      Align = alRight
      Caption = 'of type'
      ExplicitHeight = 16
    end
    object cbModel: TComboBox
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 86
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 2
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbModelChange
    end
    object cbProp: TComboBox
      AlignWithMargins = True
      Left = 95
      Top = 0
      Width = 302
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 2
      Align = alClient
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbPropChange
    end
  end
  object sgProp: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 64
    Width = 445
    Height = 57
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    ColCount = 4
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
    TabOrder = 1
    ColWidths = (
      64
      64
      64
      64)
  end
  object stCaption: TStaticText
    AlignWithMargins = True
    Left = 3
    Top = 12
    Width = 445
    Height = 20
    Margins.Top = 12
    Align = alTop
    Alignment = taCenter
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Caption = 'stCaption'
    Color = clMoneyGreen
    ParentColor = False
    TabOrder = 2
    ExplicitWidth = 57
  end
  object chkSelect: TCheckListBox
    Left = 0
    Top = 124
    Width = 451
    Height = 48
    OnClickCheck = chkSelectClickCheck
    Align = alTop
    BevelKind = bkTile
    BorderStyle = bsNone
    Columns = 2
    DoubleBuffered = True
    ParentDoubleBuffered = False
    ScrollWidth = 10
    TabOrder = 3
    Visible = False
  end
end
