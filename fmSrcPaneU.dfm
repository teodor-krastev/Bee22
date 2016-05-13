object fmSrcPane: TfmSrcPane
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  DoubleBuffered = True
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  ParentDoubleBuffered = False
  TabOrder = 0
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 18
    Top = 0
    Width = 433
    Height = 33
    Margins.Left = 18
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 1
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Panel1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object sbGoLeft: TSpeedButton
      AlignWithMargins = True
      Left = 406
      Top = 4
      Width = 23
      Height = 25
      Align = alRight
      Glyph.Data = {
        DE000000424DDE0000000000000076000000280000000D0000000D0000000100
        04000000000068000000120B0000120B00001000000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7000777777077777700077777007777770007777060777777080777066000007
        7000770666666607700070666666660770007706666666077000777066000007
        7000777706077777700077777007777770007777770777777000777777777777
        7080}
      ExplicitLeft = 395
      ExplicitTop = 2
      ExplicitHeight = 20
    end
    object chkEnabled: TCheckBox
      AlignWithMargins = True
      Left = 338
      Top = 4
      Width = 62
      Height = 25
      Align = alRight
      Caption = 'Enabled'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object seCode: TSynEdit
    Left = 0
    Top = 34
    Width = 451
    Height = 270
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    BorderStyle = bsNone
    Gutter.Color = clSilver
    Gutter.DigitCount = 3
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -12
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 0
    Gutter.ShowLineNumbers = True
    Gutter.Gradient = True
    Gutter.GradientEndColor = 16250871
    Highlighter = SynPythonSyn1
    ScrollBars = ssVertical
  end
  object SynPythonSyn1: TSynPythonSyn
    Left = 232
    Top = 152
  end
end
