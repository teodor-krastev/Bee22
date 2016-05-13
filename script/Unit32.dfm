object TestForm: TTestForm
  Left = 213
  Top = 114
  Caption = 'Test Form'
  ClientHeight = 460
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 106
  TextHeight = 14
  object CheckBox1: TCheckBox
    Left = 103
    Top = 17
    Width = 105
    Height = 19
    Caption = 'CheckBox1'
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 103
    Top = 60
    Width = 105
    Height = 19
    Caption = 'CheckBox2'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 95
    Top = 276
    Width = 81
    Height = 27
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object Edit1: TEdit
    Left = 103
    Top = 103
    Width = 131
    Height = 22
    TabOrder = 3
    Text = 'Edit1'
  end
  object ListBox1: TListBox
    Left = 353
    Top = 52
    Width = 268
    Height = 182
    ItemHeight = 14
    TabOrder = 4
  end
  object btnAdd: TButton
    Left = 112
    Top = 138
    Width = 81
    Height = 27
    Caption = 'Add'
    TabOrder = 5
  end
end
