object fmTracker: TfmTracker
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      451
      57)
    object Label1: TLabel
      Left = 292
      Top = 16
      Width = 85
      Height = 14
      Anchors = [akTop, akRight]
      Caption = 'Number of iters'
      ExplicitLeft = 256
    end
    object chkTrackNext: TCheckBox
      Left = 24
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Track next PSO run'
      TabOrder = 0
    end
    object seNumbIters: TSpinEdit
      Left = 388
      Top = 16
      Width = 49
      Height = 23
      Anchors = [akTop, akRight]
      MaxValue = 20
      MinValue = 1
      TabOrder = 1
      Value = 5
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 57
    Width = 451
    Height = 115
    Align = alTop
    Caption = ' PSO properties traced '
    TabOrder = 1
    object chkPSO: TCheckListBox
      AlignWithMargins = True
      Left = 10
      Top = 21
      Width = 436
      Height = 87
      Margins.Left = 8
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Columns = 3
      ItemHeight = 14
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 182
    Width = 451
    Height = 117
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Align = alTop
    Caption = ' Particle properties traced '
    TabOrder = 2
    object chkPart: TCheckListBox
      AlignWithMargins = True
      Left = 10
      Top = 21
      Width = 436
      Height = 89
      Margins.Left = 8
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Columns = 3
      ItemHeight = 14
      TabOrder = 0
    end
  end
end
