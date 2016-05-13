object frmClientBee22: TfrmClientBee22
  Left = 0
  Top = 0
  Caption = 'Client for Bee22 COM server'
  ClientHeight = 528
  ClientWidth = 473
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 106
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 269
    Width = 473
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 272
  end
  object Panel1: TPanel
    Left = 0
    Top = 272
    Width = 473
    Height = 256
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object mmIn: TMemo
      Left = 0
      Top = 37
      Width = 473
      Height = 219
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 473
      Height = 37
      Align = alTop
      TabOrder = 1
      object btnConfog: TButton
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 75
        Height = 29
        Align = alLeft
        Caption = 'Config'
        TabOrder = 0
        OnClick = btnConfogClick
      end
      object cbExpr: TComboBox
        AlignWithMargins = True
        Left = 85
        Top = 6
        Width = 222
        Height = 24
        Margins.Top = 5
        Align = alClient
        TabOrder = 1
      end
      object btnEval: TButton
        AlignWithMargins = True
        Left = 313
        Top = 4
        Width = 75
        Height = 29
        Align = alRight
        Caption = 'Eval'
        TabOrder = 2
        OnClick = btnEvalClick
      end
      object btnExec: TButton
        AlignWithMargins = True
        Left = 394
        Top = 4
        Width = 75
        Height = 29
        Align = alRight
        Caption = 'Exec'
        TabOrder = 3
        OnClick = btnExecClick
      end
    end
  end
  object mmOut: TMemo
    Left = 0
    Top = 0
    Width = 473
    Height = 269
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
  end
end
