object frmOptions: TfrmOptions
  Left = 195
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Bee22 Control Center Options'
  ClientHeight = 478
  ClientWidth = 467
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 106
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 457
      Height = 431
      ActivePage = tsGeneral
      Align = alClient
      TabHeight = 25
      TabOrder = 0
      object tsGeneral: TTabSheet
        Caption = ' General '
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object GroupBox1: TGroupBox
          Left = 3
          Top = 0
          Width = 185
          Height = 105
          Caption = ' Properties on-start loading '
          TabOrder = 0
          object rbFactory: TRadioButton
            Left = 16
            Top = 24
            Width = 113
            Height = 17
            Caption = 'Factory setting'
            TabOrder = 0
          end
          object rbDefaults: TRadioButton
            Left = 16
            Top = 47
            Width = 113
            Height = 17
            Caption = '"Defaults" setting'
            Checked = True
            TabOrder = 1
            TabStop = True
          end
          object rbCustom: TRadioButton
            Left = 16
            Top = 73
            Width = 17
            Height = 17
            TabOrder = 2
          end
          object cbCustomSettings: TComboBox
            Left = 33
            Top = 70
            Width = 114
            Height = 24
            Style = csDropDownList
            ParentColor = True
            TabOrder = 3
          end
        end
        object chkSaveProps: TCheckBox
          Left = 19
          Top = 120
          Width = 150
          Height = 17
          Caption = 'Save props on close'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object stRootPath: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 360
          Width = 443
          Height = 33
          Align = alBottom
          AutoSize = False
          Caption = 'stRootPath'
          TabOrder = 2
        end
      end
      object tsBlocks: TTabSheet
        Caption = ' Blocks '
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 236
          Width = 425
          Height = 16
          Margins.Left = 5
          Align = alTop
          Caption = 
            'Values are from 1 to 8; 0 - invisible block (restart app to see ' +
            'the changes)'
        end
        object Label2: TLabel
          Left = 12
          Top = 320
          Width = 66
          Height = 16
          Caption = 'Stack width'
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 449
          Height = 233
          Align = alTop
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object Panel4: TPanel
            Left = 1
            Top = 1
            Width = 184
            Height = 231
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object Panel5: TPanel
              Left = 112
              Top = 17
              Width = 56
              Height = 214
              Align = alLeft
              ParentColor = True
              TabOrder = 0
              object Panel6: TPanel
                Left = 1
                Top = 1
                Width = 54
                Height = 41
                Align = alTop
                Caption = '6 (0)'
                ParentBackground = False
                ParentColor = True
                TabOrder = 0
              end
              object Panel7: TPanel
                Left = 1
                Top = 83
                Width = 54
                Height = 41
                Align = alTop
                Caption = '8 (0)'
                TabOrder = 1
              end
              object Panel8: TPanel
                Left = 1
                Top = 42
                Width = 54
                Height = 41
                Align = alTop
                Caption = '7 (0)'
                TabOrder = 2
              end
            end
            object Panel9: TPanel
              Left = 56
              Top = 17
              Width = 56
              Height = 214
              Align = alLeft
              ParentColor = True
              TabOrder = 1
              object Panel10: TPanel
                Left = 1
                Top = 1
                Width = 54
                Height = 41
                Align = alTop
                Caption = '3 (0)'
                ParentBackground = False
                ParentColor = True
                TabOrder = 0
              end
              object Panel11: TPanel
                Left = 1
                Top = 83
                Width = 54
                Height = 41
                Align = alTop
                Caption = '5 (0)'
                TabOrder = 1
              end
              object Panel12: TPanel
                Left = 1
                Top = 42
                Width = 54
                Height = 41
                Align = alTop
                Caption = '4 (0)'
                TabOrder = 2
              end
            end
            object Panel13: TPanel
              Left = 0
              Top = 17
              Width = 56
              Height = 214
              Align = alLeft
              TabOrder = 2
              object Panel14: TPanel
                Left = 1
                Top = 1
                Width = 54
                Height = 41
                Align = alTop
                Caption = 'Console'
                Color = 14671839
                ParentBackground = False
                TabOrder = 0
              end
              object Panel15: TPanel
                Left = 1
                Top = 83
                Width = 54
                Height = 41
                Align = alTop
                Caption = '2 (0)'
                TabOrder = 1
              end
              object Panel16: TPanel
                Left = 1
                Top = 42
                Width = 54
                Height = 41
                Align = alTop
                Caption = '1 (0)'
                TabOrder = 2
              end
            end
            object Panel17: TPanel
              Left = 0
              Top = 0
              Width = 184
              Height = 17
              Align = alTop
              BevelKind = bkFlat
              BevelOuter = bvNone
              Caption = 'Blocks location'
              TabOrder = 3
            end
          end
          object vleBlockLocation: TValueListEditor
            Left = 185
            Top = 1
            Width = 263
            Height = 231
            Align = alClient
            ParentColor = True
            TabOrder = 1
            OnSetEditText = vleBlockLocationSetEditText
            ColWidths = (
              71
              186)
          end
        end
        object seStackWidth: TSpinEdit
          Left = 93
          Top = 312
          Width = 57
          Height = 26
          MaxValue = 400
          MinValue = 200
          TabOrder = 1
          Value = 200
          OnChange = seStackWidthChange
        end
      end
      object tsTracker: TTabSheet
        Caption = 'Tracker'
        ImageIndex = 2
        inline fmTracker1: TfmTracker
          Left = 0
          Top = 0
          Width = 449
          Height = 396
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 449
          ExplicitHeight = 396
          inherited Panel1: TPanel
            Width = 449
            ExplicitWidth = 415
            inherited Label1: TLabel
              Top = 19
              Width = 87
              Height = 16
              Caption = 'Track first iters'
              ExplicitLeft = 247
              ExplicitTop = 19
              ExplicitWidth = 87
              ExplicitHeight = 16
            end
            inherited seNumbIters: TSpinEdit
              Height = 26
              ExplicitLeft = 343
              ExplicitHeight = 26
            end
          end
          inherited GroupBox1: TGroupBox
            Width = 449
            ExplicitWidth = 449
            inherited chkPSO: TCheckListBox
              Top = 23
              Width = 434
              Height = 85
              ItemHeight = 16
              ExplicitTop = 23
              ExplicitWidth = 434
              ExplicitHeight = 85
            end
          end
          inherited GroupBox2: TGroupBox
            Width = 449
            ExplicitWidth = 449
            inherited chkPart: TCheckListBox
              Top = 23
              Width = 434
              Height = 87
              ItemHeight = 16
              ExplicitTop = 23
              ExplicitWidth = 434
              ExplicitHeight = 87
            end
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 441
    Width = 467
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 201
      Top = 2
      Width = 81
      Height = 27
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 288
      Top = 2
      Width = 80
      Height = 27
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      Left = 374
      Top = 2
      Width = 80
      Height = 27
      Caption = '&Help'
      TabOrder = 2
    end
  end
end
