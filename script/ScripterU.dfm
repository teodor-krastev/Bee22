object frmScripter: TfrmScripter
  Left = 0
  Top = 0
  Caption = 'Scripter Test'
  ClientHeight = 469
  ClientWidth = 697
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
    Top = 275
    Width = 697
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 205
  end
  object Panel1: TPanel
    Left = 0
    Top = 428
    Width = 697
    Height = 41
    Align = alBottom
    TabOrder = 0
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
  object mmOut: TMemo
    Left = 0
    Top = 0
    Width = 697
    Height = 275
    Align = alClient
    TabOrder = 1
  end
  object seIn: TSynEdit
    Left = 0
    Top = 278
    Width = 697
    Height = 150
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 2
    Gutter.Color = 16316664
    Gutter.DigitCount = 3
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -12
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 3
    Gutter.ShowLineNumbers = True
    Lines.Strings = (
      'import spam'
      'spam.DVar.SValue = '#39'hhh'#39
      'print spam.DVar.SValue'
      'spam.DVar.IValue = 12'
      'print spam.DVar.IValue'
      'print spam.DVar.DescribeMe()')
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
  object PythonModule: TPythonModule
    Engine = py
    ModuleName = 'spam'
    Errors = <>
    Left = 48
    Top = 144
  end
  object PyDelphiWrapper1: TPyDelphiWrapper
    Engine = py
    Module = PythonModule
    Left = 176
    Top = 144
  end
end
