object frmScripter: TfrmScripter
  Left = 0
  Top = 0
  Caption = 'Scripter Test example 32'
  ClientHeight = 571
  ClientWidth = 935
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 106
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 0
    Top = 264
    Width = 935
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 205
  end
  object mmOut: TMemo
    Left = 0
    Top = 0
    Width = 561
    Height = 264
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 301
  end
  object seIn: TSynEdit
    Left = 0
    Top = 267
    Width = 935
    Height = 263
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    Gutter.Color = clSilver
    Gutter.DigitCount = 3
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -12
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 3
    Gutter.ShowLineNumbers = True
    Gutter.Gradient = True
    Lines.Strings = (
      'import spam'
      ''
      'class MyPoint(spam.Point):'
      '  def Foo(Self, v):'
      '    Self.OffsetBy(v, v)'
      ''
      'p = spam.Point(2, 5)'
      'print p, type(p)'
      'p.OffsetBy( 3, 3 )'
      'print p.x, p.y'
      'print "Name =", p.Name'
      'p.Name = '#39'Hello world!'#39
      'print "Name =", p.Name'
      '"""'
      'p = spam.Point(2, 5) '
      'print p, type(p)'
      'p.OffsetBy( 3, 3 )'
      'print p.x, p.y'
      ''
      '# create a subtype instance'
      'p = MyPoint(2, 5)'
      'print p, type(p)'
      'p.OffsetBy( 3, 3 )'
      'print p.x, p.y'
      'p.Foo( 4 )'
      'print p.x, p.y'
      'print "dir=",dir(spam)'
      'print spam.Point'
      'print "p = ", p, "  --> ",'
      'if type(p) is spam.Point:'
      '  print "p is a Point"'
      'else:'
      '  print "p is not a point"'
      'p = 2'
      'print "p = ", p, "  --> ",'
      'if type(p) is spam.Point:'
      '  print "p is a Point"'
      'else:'
      '  print "p is not a point"'
      ''
      '# You can raise error from a Python script to !'
      
        'print "---------------------------------------------------------' +
        '---------"'
      'print "Errors in a Python script"'
      'try:'
      '  raise spam.EBadPoint, "this is a test !"'
      'except:'
      '  pass'
      ''
      'try:'
      '  err = spam.EBadPoint()'
      '  err.a = 1'
      '  err.b = 2'
      '  err.c = 3'
      '  raise err'
      
        'except spam.PointError, what: #it shows you that you can interce' +
        'pt a parent class'
      '  print "Catched an error dirived from PointError"'
      
        '  print "Error class = ", what.__class__, "     a =", what.a, " ' +
        '  b =", what.b, "   c =", what.c'
      ''
      'if p == spam.Point(2, 5): '
      '  print "Equal"'
      'else:'
      '  print "Not equal"'
      '"""')
    ExplicitTop = 304
    ExplicitWidth = 934
  end
  object Panel1: TPanel
    Left = 0
    Top = 530
    Width = 935
    Height = 41
    Align = alBottom
    TabOrder = 2
    OnDblClick = Panel1DblClick
    ExplicitTop = 567
    ExplicitWidth = 934
    object sbExecute: TSpeedButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 85
      Height = 33
      Align = alLeft
      Caption = 'Execute'
      OnClick = sbExecuteClick
    end
  end
  object TeeInspector1: TTeeInspector
    Left = 705
    Top = 0
    Width = 230
    Height = 264
    Align = alRight
    RowCount = 4
    Options = [goFixedVertLine, goVertLine, goHorzLine, goColSizing, goThumbTracking]
    TabOrder = 3
    Items = <
      item
        Caption = 'ttt'
        Expanded = True
        Style = iiButton
        Value = Null
        OnChange = TeeInspector1Items0Change
        OnGetItems = TeeInspector1Items0GetItems
      end
      item
        Caption = 'kkk'
        Expanded = True
        Style = iiBrush
      end
      item
        Caption = 'tttt'
        Expanded = True
        Style = iiPen
      end>
    Header.Font.Color = clNavy
    ExplicitLeft = 704
    ExplicitHeight = 301
    ColWidths = (
      82
      144)
  end
  object AdvGlassButton1: TAdvGlassButton
    Left = 584
    Top = 82
    Width = 102
    Height = 47
    BackColor = clMoneyGreen
    Caption = 'AdvGlassButton1'
    CornerRadius = 8
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ForeColor = clWhite
    ForceTransparent = True
    GlowColor = 16760205
    InnerBorderColor = clBlack
    OuterBorderColor = clNone
    ParentFont = False
    ShineColor = clYellow
    ShowFocusRect = True
    TabOrder = 4
    Version = '1.3.0.0'
    OnMouseMove = AdvGlassButton1MouseMove
    OnMouseLeave = AdvGlassButton1MouseLeave
  end
  object AdvGlowButton1: TAdvGlowButton
    Left = 584
    Top = 175
    Width = 102
    Height = 41
    Caption = 'MasterBtn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -12
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    ParentFont = False
    InitRepeatPause = 1400
    TabOrder = 5
    AllowAllUp = True
    Appearance.BorderColor = clGray
    Appearance.BorderColorDown = clMaroon
    Appearance.ColorChecked = 16111818
    Appearance.ColorCheckedTo = 16111818
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 12910591
    Appearance.ColorDownTo = 12910591
    Appearance.ColorHot = 16114899
    Appearance.ColorHotTo = 16114899
    Appearance.ColorMirrorHot = 15386015
    Appearance.ColorMirrorHotTo = 16114899
    Appearance.ColorMirrorDown = 12910591
    Appearance.ColorMirrorDownTo = 12903167
    Appearance.ColorMirrorChecked = 16506322
    Appearance.ColorMirrorCheckedTo = 16768988
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
    Appearance.GradientHot = ggVertical
    Appearance.GradientMirrorHot = ggVertical
    Appearance.GradientDown = ggVertical
    Appearance.SystemFont = False
  end
  object py: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 48
    Top = 40
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = mmOut
    Left = 176
    Top = 40
  end
  object PyDelphiWrapper1: TPyDelphiWrapper
    Engine = py
    OnInitialization = PyDelphiWrapper1Initialization
    Module = PythonModule
    Left = 176
    Top = 144
  end
  object PythonModule: TPythonModule
    Engine = py
    ModuleName = 'spam'
    Errors = <>
    Left = 48
    Top = 144
  end
end
