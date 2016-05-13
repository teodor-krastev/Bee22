object frmExtFnConfig: TfrmExtFnConfig
  Left = 0
  Top = 0
  Caption = 'ExtFn - Configuration editor'
  ClientHeight = 492
  ClientWidth = 565
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
    Left = 0
    Top = 455
    Width = 565
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object OKBtn: TButton
      AlignWithMargins = True
      Left = 305
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
      Left = 392
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
      Left = 478
      Top = 3
      Width = 80
      Height = 31
      Margins.Right = 7
      Align = alRight
      Caption = '&Help'
      TabOrder = 2
    end
  end
end
