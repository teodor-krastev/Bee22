object fmVisual: TfmVisual
  Left = 0
  Top = 0
  Width = 891
  Height = 687
  Align = alClient
  TabOrder = 0
  Visible = False
  ExplicitWidth = 451
  ExplicitHeight = 304
  object Splitter1: TSplitter
    Left = 691
    Top = 0
    Height = 687
    Align = alRight
    ExplicitLeft = 480
    ExplicitTop = 584
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 694
    Top = 0
    Width = 197
    Height = 687
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = 254
    ExplicitHeight = 304
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 195
      Height = 302
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 105
        Width = 195
        Height = 56
        Align = alTop
        Caption = '                '
        TabOrder = 0
        object chkChart: TCheckBox
          Left = 16
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Chart'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chkChartClick
        end
        object chkOutside: TCheckBox
          Left = 23
          Top = 26
          Width = 65
          Height = 17
          Caption = 'Outside'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = chkChartClick
        end
        object chkInside: TCheckBox
          Left = 110
          Top = 25
          Width = 57
          Height = 17
          Caption = 'Inside'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = chkChartClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 161
        Width = 195
        Height = 135
        Align = alTop
        Caption = '                    '
        TabOrder = 1
        object chkIters: TCheckBox
          Left = 14
          Top = 1
          Width = 91
          Height = 17
          Caption = 'Iteractions'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object vleIters: TValueListEditor
          Left = 2
          Top = 16
          Width = 191
          Height = 117
          Align = alClient
          TabOrder = 1
          ExplicitHeight = 70
          ColWidths = (
            84
            101)
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 195
        Height = 105
        Align = alTop
        Caption = ' Control '
        TabOrder = 2
        object sbPause: TSpeedButton
          Left = 2
          Top = 78
          Width = 191
          Height = 25
          Align = alBottom
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Pause'
          ExplicitLeft = 0
          ExplicitTop = 137
          ExplicitWidth = 234
        end
        object Label1: TLabel
          Left = 120
          Top = 24
          Width = 30
          Height = 14
          Caption = 'Every'
        end
        object chkTrace: TCheckBox
          Left = 16
          Top = 23
          Width = 57
          Height = 17
          Caption = 'Trace'
          TabOrder = 0
        end
        object btnStep: TButton
          Left = 13
          Top = 46
          Width = 75
          Height = 25
          Caption = 'Step'
          TabOrder = 1
          OnClick = btnStepClick
        end
        object seEvery: TSpinEdit
          Left = 117
          Top = 46
          Width = 57
          Height = 23
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 5
        end
      end
    end
    inline fmLog: TfmConsole
      Left = 1
      Top = 303
      Width = 195
      Height = 383
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 1
      ExplicitTop = 257
      ExplicitWidth = 195
      ExplicitHeight = 429
      inherited Splitter1: TSplitter
        Top = -68
        Width = 195
        Height = 451
        ExplicitTop = -325
        ExplicitWidth = 195
        ExplicitHeight = 451
      end
      inherited ToolBar1: TToolBar
        Width = 195
        ExplicitWidth = 195
      end
      inherited Memo1: TMemo
        Width = 195
        Height = 21
        ExplicitWidth = 195
        ExplicitHeight = 21
      end
      inherited PageControl1: TPageControl
        Top = -124
        Width = 195
        ExplicitTop = -461
        ExplicitWidth = 195
        inherited tsEval: TTabSheet
          ExplicitWidth = 187
          inherited cbCmd: TComboBox
            Width = 133
            ExplicitWidth = 133
          end
          inherited StaticText1: TStaticText
            ExplicitHeight = 27
          end
          inherited bbRollCmd: TBitBtn
            Left = 149
            ExplicitLeft = 149
            ExplicitTop = 1
            ExplicitHeight = 25
          end
        end
        inherited tsExec: TTabSheet
          ExplicitLeft = 4
          ExplicitTop = 25
          ExplicitWidth = 443
          ExplicitHeight = 27
          inherited BitBtn1: TBitBtn
            ExplicitHeight = 27
          end
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 691
    Height = 687
    ActivePage = tsOutside
    Align = alClient
    TabHeight = 23
    TabOrder = 1
    TabWidth = 56
    OnChange = chkChartClick
    ExplicitWidth = 251
    ExplicitHeight = 304
    object tsOutside: TTabSheet
      Caption = ' Outside '
      ExplicitWidth = 243
      ExplicitHeight = 271
    end
    object tsInside: TTabSheet
      Caption = 'Inside'
      ImageIndex = 1
    end
  end
end
