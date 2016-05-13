object frmPyTest: TfrmPyTest
  Left = 0
  Top = 0
  Caption = 'Py.Test'
  ClientHeight = 690
  ClientWidth = 651
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 106
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 0
    Top = 422
    Width = 651
    Height = 3
    Cursor = crVSplit
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    ExplicitLeft = -8
    ExplicitTop = 456
  end
  object mmScript: TMemo
    Left = 0
    Top = 425
    Width = 651
    Height = 265
    Align = alClient
    BorderStyle = bsNone
    Lines.Strings = (
      'print 2+2')
    TabOrder = 0
    ExplicitTop = 423
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 422
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object mmOut: TMemo
      Left = 0
      Top = 0
      Width = 651
      Height = 372
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 372
      Width = 651
      Height = 50
      Align = alBottom
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = 16514043
      ParentBackground = False
      TabOrder = 1
      object Button1: TButton
        AlignWithMargins = True
        Left = 526
        Top = 7
        Width = 114
        Height = 32
        Margins.Left = 7
        Margins.Top = 7
        Margins.Right = 7
        Margins.Bottom = 7
        Align = alRight
        Caption = 'Execute'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = True
    Output = mmOut
    Left = 112
    Top = 72
  end
end
