object fmReport: TfmReport
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 451
    Height = 271
    ActivePage = tsOneProp
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HotTrack = True
    Images = ImageList1
    MultiLine = True
    ParentFont = False
    TabHeight = 28
    TabOrder = 0
    TabPosition = tpLeft
    TabWidth = 110
    object tsOneProp: TTabSheet
      Caption = '  One Prop'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      object Splitter1: TSplitter
        Left = 697
        Top = 0
        Height = 263
        Color = clMoneyGreen
        ParentColor = False
        ExplicitLeft = 443
        ExplicitHeight = 636
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 697
        Height = 263
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object Splitter2: TSplitter
          Left = 0
          Top = 152
          Width = 697
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          Color = clGradientActiveCaption
          ParentColor = False
          ExplicitTop = 29
          ExplicitWidth = 451
        end
        object sgOne: TStringGrid
          Left = 0
          Top = 0
          Width = 697
          Height = 152
          Align = alClient
          ColCount = 8
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
          TabOrder = 0
          OnSelectCell = sgOneSelectCell
        end
        object mmOne: TMemo
          Left = 0
          Top = 155
          Width = 697
          Height = 108
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            'Comment here')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnEnter = mmOneEnter
        end
      end
      object Panel2: TPanel
        Left = 700
        Top = 0
        Width = 180
        Height = 263
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 408
        object gbPropSelect: TGroupBox
          Left = 0
          Top = 0
          Width = 180
          Height = 77
          Align = alTop
          Caption = ' Fixed Property '
          TabOrder = 0
          ExplicitWidth = 408
          object rbSp1: TRadioButton
            AlignWithMargins = True
            Left = 14
            Top = 21
            Width = 151
            Height = 19
            Margins.Left = 12
            Align = alLeft
            Caption = 'rbSp1'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TabStop = True
            OnClick = rbSp1Click
          end
          object rbSp2: TRadioButton
            Left = 168
            Top = 18
            Width = 157
            Height = 25
            Align = alLeft
            Caption = 'rbSp2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = rbSp1Click
          end
          object TrackBar1: TTrackBar
            Left = 2
            Top = 43
            Width = 176
            Height = 32
            Align = alBottom
            Max = 100
            ShowSelRange = False
            TabOrder = 2
            ThumbLength = 18
            TickMarks = tmTopLeft
            OnChange = TrackBar1Change
            ExplicitWidth = 404
          end
          object stFixedPropValue: TStaticText
            Left = 325
            Top = 18
            Width = 90
            Height = 25
            Margins.Top = 1
            Margins.Bottom = 1
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkFlat
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object sbFixedPropValue: TSpinButton
            Left = 415
            Top = 18
            Width = 20
            Height = 25
            Align = alLeft
            DownGlyph.Data = {
              0E010000424D0E01000000000000360000002800000009000000060000000100
              200000000000D800000000000000000000000000000000000000008080000080
              8000008080000080800000808000008080000080800000808000008080000080
              8000008080000080800000808000000000000080800000808000008080000080
              8000008080000080800000808000000000000000000000000000008080000080
              8000008080000080800000808000000000000000000000000000000000000000
              0000008080000080800000808000000000000000000000000000000000000000
              0000000000000000000000808000008080000080800000808000008080000080
              800000808000008080000080800000808000}
            TabOrder = 4
            UpGlyph.Data = {
              0E010000424D0E01000000000000360000002800000009000000060000000100
              200000000000D800000000000000000000000000000000000000008080000080
              8000008080000080800000808000008080000080800000808000008080000080
              8000000000000000000000000000000000000000000000000000000000000080
              8000008080000080800000000000000000000000000000000000000000000080
              8000008080000080800000808000008080000000000000000000000000000080
              8000008080000080800000808000008080000080800000808000000000000080
              8000008080000080800000808000008080000080800000808000008080000080
              800000808000008080000080800000808000}
            OnDownClick = sbFixedPropValueDownClick
            OnUpClick = sbFixedPropValueUpClick
          end
        end
        object chartOne: TChart
          Left = 0
          Top = 77
          Width = 180
          Height = 445
          BackWall.Brush.Gradient.Direction = gdBottomTop
          BackWall.Brush.Gradient.EndColor = clWhite
          BackWall.Brush.Gradient.StartColor = 15395562
          BackWall.Brush.Gradient.Visible = True
          BackWall.Color = clWhite
          BackWall.Transparent = False
          Foot.Font.Name = 'Verdana'
          Gradient.Direction = gdBottomTop
          Gradient.EndColor = clWhite
          Gradient.MidColor = 15395562
          Gradient.StartColor = 15395562
          LeftWall.Color = 14745599
          LeftWall.Visible = False
          Legend.Alignment = laTop
          Legend.CheckBoxes = True
          Legend.CurrentPage = False
          Legend.Font.Name = 'Verdana'
          Legend.Frame.Color = clSilver
          Legend.Shadow.Visible = False
          MarginBottom = 1
          MarginLeft = 1
          MarginRight = 1
          MarginTop = 1
          RightWall.Color = 14745599
          SubFoot.Font.Name = 'Verdana'
          SubTitle.Font.Name = 'Verdana'
          Title.Font.Name = 'Verdana'
          Title.Text.Strings = (
            '')
          Title.Visible = False
          BottomAxis.Axis.Color = 4210752
          BottomAxis.Grid.Color = 11119017
          BottomAxis.LabelsFont.Name = 'Verdana'
          BottomAxis.LabelsFont.Shadow.Visible = False
          BottomAxis.LabelsOnAxis = False
          BottomAxis.StartPosition = 2.000000000000000000
          BottomAxis.EndPosition = 98.000000000000000000
          BottomAxis.TicksInner.Color = 11119017
          BottomAxis.Title.Font.Name = 'Verdana'
          DepthAxis.Axis.Color = 4210752
          DepthAxis.Grid.Color = 11119017
          DepthAxis.LabelsFont.Name = 'Verdana'
          DepthAxis.TicksInner.Color = 11119017
          DepthAxis.Title.Font.Name = 'Verdana'
          DepthTopAxis.Axis.Color = 4210752
          DepthTopAxis.Grid.Color = 11119017
          DepthTopAxis.LabelsFont.Name = 'Verdana'
          DepthTopAxis.TicksInner.Color = 11119017
          DepthTopAxis.Title.Font.Name = 'Verdana'
          CustomAxes = <
            item
              Horizontal = False
              OtherSide = False
              Visible = False
            end
            item
              Horizontal = False
              OtherSide = False
              Visible = False
              ZPosition = 100.000000000000000000
            end>
          LeftAxis.Axis.Color = 4210752
          LeftAxis.Grid.Color = 11119017
          LeftAxis.LabelsFont.Name = 'Verdana'
          LeftAxis.TicksInner.Color = 11119017
          LeftAxis.Title.Font.Name = 'Verdana'
          LeftAxis.Visible = False
          RightAxis.Axis.Color = 4210752
          RightAxis.Grid.Color = 11119017
          RightAxis.LabelsFont.Name = 'Verdana'
          RightAxis.TicksInner.Color = 11119017
          RightAxis.Title.Font.Name = 'Verdana'
          RightAxis.Visible = False
          Shadow.Visible = False
          TopAxis.Axis.Color = 4210752
          TopAxis.Grid.Color = 11119017
          TopAxis.LabelsFont.Name = 'Verdana'
          TopAxis.TicksInner.Color = 11119017
          TopAxis.Title.Font.Name = 'Verdana'
          View3D = False
          View3DWalls = False
          Zoom.Brush.Color = 14417919
          Zoom.Brush.Style = bsSolid
          Zoom.Pen.Color = 16384
          Zoom.Pen.SmallDots = True
          Align = alClient
          BevelInner = bvSpace
          BevelOuter = bvSpace
          Color = clWhite
          TabOrder = 1
          OnDblClick = chartOneDblClick
          ExplicitWidth = 408
          ExplicitHeight = 186
          PrintMargins = (
            15
            0
            15
            0)
          ColorPaletteIndex = 13
          object srsUserDefLn: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.ShapeStyle = fosRoundRectangle
            Marks.Visible = False
            SeriesColor = clBlue
            Shadow.Color = 16769216
            Shadow.HorizSize = 1
            Shadow.SmoothBlur = -2
            Shadow.VertSize = 1
            Title = 'user.def'
            Brush.BackColor = clDefault
            LinePen.Color = clBlue
            Pointer.Brush.Gradient.EndColor = clBlue
            Pointer.Gradient.EndColor = clBlue
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object srsOnTargetLn: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.ShapeStyle = fosRoundRectangle
            Marks.Visible = False
            SeriesColor = 27090
            Shadow.HorizSize = 1
            Shadow.VertSize = 1
            Title = 'on.target'
            VertAxis = aRightAxis
            Brush.BackColor = clDefault
            LinePen.Color = 19946
            Pointer.Brush.Gradient.EndColor = 3513587
            Pointer.Gradient.EndColor = 3513587
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object srsIterCountLn: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.ShapeStyle = fosRoundRectangle
            Marks.Visible = False
            SeriesColor = 221
            Shadow.Color = 11272191
            Shadow.HorizSize = 1
            Shadow.VertSize = 1
            Title = 'iter.count'
            VertAxis = aCustomVertAxis
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
            CustomVertAxis = 0
          end
          object srsOutCountLn: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.ShapeStyle = fosRoundRectangle
            Marks.Visible = False
            SeriesColor = 11048782
            Shadow.Color = 15000776
            Shadow.HorizSize = 1
            Shadow.VertSize = 1
            Title = 'out.count'
            VertAxis = aCustomVertAxis
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
            CustomVertAxis = 1
          end
          object srsUserDefBr: TBarSeries
            BarPen.Color = clBlue
            BarPen.Width = 3
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = clBlue
            Title = 'user.def'
            BarWidthPercent = 30
            Emboss.Color = 8487297
            OffsetPercent = -60
            Shadow.Color = 8487297
            SideMargins = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
          end
          object srsOnTargetBr: TBarSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 170
            Title = 'on.target'
            VertAxis = aRightAxis
            BarWidthPercent = 30
            Emboss.Color = 8947848
            OffsetPercent = -20
            Shadow.Color = 8947848
            Shadow.Visible = False
            SideMargins = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
          end
          object srsOutCountBr: TBarSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 4227072
            Title = 'out.count'
            VertAxis = aCustomVertAxis
            BarWidthPercent = 30
            Emboss.Color = 8882055
            OffsetPercent = 20
            Shadow.Color = 8882055
            Shadow.Visible = False
            SideMargins = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
            CustomVertAxis = 0
          end
          object srsIterCountBr: TBarSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 11141290
            Title = 'iter.count'
            VertAxis = aCustomVertAxis
            BarWidthPercent = 30
            Emboss.Color = 8882055
            OffsetPercent = 60
            Shadow.Color = 8882055
            Shadow.Visible = False
            SideMargins = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
            CustomVertAxis = 1
          end
          object ChartTool1: TColorLineTool
            Pen.Color = 6579300
            Pen.Width = 2
            Value = 10.000000000000000000
            AxisID = 0
          end
        end
      end
    end
    object tsTwoProps: TTabSheet
      Caption = ' Two Props'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter5: TSplitter
        Left = 449
        Top = 0
        Height = 522
        Color = clMoneyGreen
        ParentColor = False
        ExplicitLeft = 443
        ExplicitHeight = 636
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 449
        Height = 522
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = Panel3Resize
        object Splitter4: TSplitter
          Left = 0
          Top = 317
          Width = 449
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          Color = clGradientActiveCaption
          ParentColor = False
          ExplicitTop = 619
        end
        object sgTwo: TStringGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 443
          Height = 311
          Align = alClient
          BorderStyle = bsNone
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goFixedHotTrack]
          TabOrder = 0
          OnSelectCell = sgTwoSelectCell
        end
        object vleTwo: TValueListEditor
          AlignWithMargins = True
          Left = 3
          Top = 323
          Width = 443
          Height = 196
          Align = alBottom
          BorderStyle = bsNone
          TabOrder = 1
          ColWidths = (
            104
            337)
        end
      end
      object Panel4: TPanel
        Left = 452
        Top = 0
        Width = 428
        Height = 522
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Splitter3: TSplitter
          Left = 0
          Top = 65
          Width = 428
          Height = 3
          Cursor = crVSplit
          Align = alTop
          Color = clGradientActiveCaption
          ParentColor = False
          ExplicitLeft = -3
          ExplicitTop = 144
          ExplicitWidth = 529
        end
        object rgSelParam: TRadioGroup
          Left = 0
          Top = 0
          Width = 428
          Height = 65
          Align = alTop
          Caption = ' Select a parameter for the table '
          Columns = 5
          ItemIndex = 0
          Items.Strings = (
            'User.Def'
            'Best.Fit'
            'Swarm.Size '
            'Iter.Count'
            'Out.Count'
            'Term.Cond')
          TabOrder = 0
          OnClick = rgSelParamClick
        end
        object chartTwo: TChart
          Left = 0
          Top = 101
          Width = 428
          Height = 421
          BackWall.Brush.Gradient.Direction = gdBottomTop
          BackWall.Brush.Gradient.EndColor = 15395562
          BackWall.Brush.Gradient.Visible = True
          BackWall.Color = clWhite
          BackWall.Transparent = False
          BottomWall.Color = 15532027
          Foot.Font.Name = 'Verdana'
          Gradient.Direction = gdBottomTop
          Gradient.EndColor = clWhite
          Gradient.MidColor = 15395562
          Gradient.StartColor = 15395562
          LeftWall.Color = 14745599
          LeftWall.Visible = False
          Legend.CheckBoxes = True
          Legend.CurrentPage = False
          Legend.Font.Name = 'Verdana'
          Legend.Visible = False
          MarginBottom = 1
          MarginLeft = 1
          MarginRight = 1
          MarginTop = 1
          RightWall.Color = 14745599
          SubFoot.Font.Name = 'Verdana'
          SubTitle.Font.Name = 'Verdana'
          Title.Font.Name = 'Verdana'
          Title.Text.Strings = (
            '-=-=-=-=-=-=-=-')
          Title.Visible = False
          BottomAxis.Axis.Color = 4210752
          BottomAxis.Grid.Color = 11119017
          BottomAxis.LabelsFont.Name = 'Verdana'
          BottomAxis.LabelsFont.Shadow.Visible = False
          BottomAxis.LabelsOnAxis = False
          BottomAxis.TicksInner.Color = 11119017
          BottomAxis.Title.Font.Name = 'Verdana'
          Chart3DPercent = 60
          DepthAxis.Axis.Color = 4210752
          DepthAxis.Grid.Color = 11119017
          DepthAxis.LabelsFont.Name = 'Verdana'
          DepthAxis.TicksInner.Color = 11119017
          DepthAxis.Title.Font.Name = 'Verdana'
          DepthAxis.Visible = True
          DepthTopAxis.Axis.Color = 4210752
          DepthTopAxis.Grid.Color = 11119017
          DepthTopAxis.LabelsFont.Name = 'Verdana'
          DepthTopAxis.TicksInner.Color = 11119017
          DepthTopAxis.Title.Font.Name = 'Verdana'
          LeftAxis.Axis.Color = 4210752
          LeftAxis.Grid.Color = 11119017
          LeftAxis.LabelsFont.Name = 'Verdana'
          LeftAxis.TicksInner.Color = 11119017
          LeftAxis.Title.Font.Name = 'Verdana'
          RightAxis.Axis.Color = 4210752
          RightAxis.Grid.Color = 11119017
          RightAxis.LabelsFont.Name = 'Verdana'
          RightAxis.TicksInner.Color = 11119017
          RightAxis.Title.Font.Name = 'Verdana'
          Shadow.Visible = False
          TopAxis.Axis.Color = 4210752
          TopAxis.Grid.Color = 11119017
          TopAxis.LabelsFont.Name = 'Verdana'
          TopAxis.TicksInner.Color = 11119017
          TopAxis.Title.Font.Name = 'Verdana'
          View3DOptions.Elevation = 340
          View3DOptions.Orthogonal = False
          View3DOptions.Perspective = 17
          View3DOptions.Rotation = 320
          View3DOptions.Zoom = 85
          Zoom.Brush.Color = 14417919
          Zoom.Brush.Style = bsSolid
          Zoom.Pen.Color = 16384
          Zoom.Pen.SmallDots = True
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
          OnDblClick = chartTwoDblClick
          PrintMargins = (
            15
            0
            15
            0)
          ColorPaletteIndex = 8
          object srsPoint: TPoint3DSeries
            ColorEachPoint = True
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            LinePen.Visible = False
            Pointer.Brush.Gradient.EndColor = clWhite
            Pointer.Gradient.EndColor = clWhite
            Pointer.InflateMargins = True
            Pointer.Style = psCircle
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
            ZValues.Name = 'Z'
            ZValues.Order = loNone
          end
          object srsVector: TVector3DSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            EndColor = clNavy
            Pen.Width = 2
            PaletteStyle = psRainbow
            StartColor = 16777088
            UseColorRange = False
            UsePalette = True
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
            ZValues.Name = 'Z'
            ZValues.Order = loNone
            ArrowHeight = 1
            ArrowWidth = 1
            EndArrow.Color = clDefault
            EndXValues.Name = 'EndX'
            EndXValues.Order = loNone
            EndYValues.Name = 'EndY'
            EndYValues.Order = loNone
            EndZValues.Name = 'EndZ'
            EndZValues.Order = loNone
            StartArrow.Color = clDefault
          end
        end
        object TeeCommander1: TTeeCommander
          Left = 0
          Top = 68
          Width = 428
          Height = 33
          Panel = chartTwo
          Align = alTop
          ParentShowHint = False
          TabOrder = 2
          ChartEditor = ChartEditor2
          object chkPointSrs: TCheckBox
            Left = 330
            Top = 1
            Width = 97
            Height = 31
            Align = alRight
            Caption = 'Point Series'
            TabOrder = 0
            OnClick = rgSelParamClick
          end
        end
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object lbRetr: TLabel
      AlignWithMargins = True
      Left = 902
      Top = 7
      Width = 4
      Height = 16
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlProps: TPanel
      Left = 0
      Top = 0
      Width = 202
      Height = 33
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object lbProp1: TLabel
        AlignWithMargins = True
        Left = 7
        Top = 7
        Width = 43
        Height = 16
        Margins.Left = 7
        Margins.Top = 7
        Align = alLeft
        Caption = 'lbProp1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbSeparator: TLabel
        AlignWithMargins = True
        Left = 56
        Top = 3
        Width = 7
        Height = 22
        Align = alLeft
        Caption = '\'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbProp2: TLabel
        AlignWithMargins = True
        Left = 69
        Top = 7
        Width = 43
        Height = 16
        Margins.Top = 7
        Align = alLeft
        Caption = 'lbProp2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbUserDef: TLabel
        AlignWithMargins = True
        Left = 131
        Top = 7
        Width = 55
        Height = 16
        Margins.Top = 7
        Align = alLeft
        Caption = 'lbUserDef'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 17920
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 118
        Top = 3
        Width = 7
        Height = 22
        Align = alLeft
        Caption = '|'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 192
        Top = 3
        Width = 7
        Height = 22
        Align = alLeft
        Caption = '|'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlBtns: TPanel
      Left = 202
      Top = 0
      Width = 207
      Height = 33
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object sbCopyTable: TSpeedButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 97
        Height = 27
        Align = alLeft
        Caption = 'Copy Table '
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFA47874A47874A47874A47874A47874A47874A47874A478
          74A478748C5D5CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA87C75FEE5CBFF
          E2C4FFDFBEFFDCB8FFD9B1FED6ACFFD4A6FFD1A28C5D5CFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFAD8078FFEAD4E5A657E5A657E5A657E5A657E5A657E5A6
          57FFD4A88C5D5CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB4867AFEEEDDFF
          EBD6FFE8CFFFE4C9FEE1C2FEDDBBFFDBB5FFD8AF8C5D5CFF00FFA47874A47874
          A47874A47874A47874BA8D7DFEF2E5E5A657E5A657E5A657E5A657E5A657E5A6
          57FEDCB78C5D5CFF00FFA87C75FEE5CBFFE2C4FFDFBEFFDCB8C29581FEF6ECFE
          F3E6FEEFE1FFEDDAFEE9D4FEE6CCFFE2C6FEDFBF8C5D5CFF00FFAD8078FFEAD4
          E5A657E5A657E5A657CA9B83FFF9F3E5A657E5A657E5A657E5A657E5A657E5A6
          57FEE3C88C5D5CFF00FFB4867AFEEEDDFFEBD6FFE8CFFFE4C9D1A286FEFBF9FE
          F9F4FEF7EFFEF5EAFEF1E4FEEEDEFEEBD7FEE8D08C5D5CFF00FFBA8D7DFEF2E5
          E5A657E5A657E5A657D8A98AFEFEFDFEFCFAFEFAF6FEF8F1FEF5ECEBDFDBD3C2
          C0BAA9AA8C5D5CFF00FFC29581FEF6ECFEF3E6FEEFE1FFEDDADFB08DFEFEFEFE
          FEFEFEFCFBFEFBF7FEF8F2B48176B48176B48176B17F74FF00FFCA9B83FFF9F3
          E5A657E5A657E5A657E4B58EFEFEFEFEFEFEFEFEFEFEFDFCFEFBF8B48176EBB5
          6FE49B42FF00FFFF00FFD1A286FEFBF9FEF9F4FEF7EFFEF5EAE8B890DCA887DC
          A887DCA887DCA887DCA887B48176F0B25EFF00FFFF00FFFF00FFD8A98AFEFEFD
          FEFCFAFEFAF6FEF8F1FEF5ECEBDFDBD3C2C0BAA9AA8C5D5CFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFDFB08DFEFEFEFEFEFEFEFCFBFEFBF7FEF8F2B48176B4
          8176B48176B17F74FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE4B58EFEFEFE
          FEFEFEFEFEFEFEFDFCFEFBF8B48176EBB56FE49B42FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFE8B890DCA887DCA887DCA887DCA887DCA887B48176F0
          B25EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Margin = 5
        OnClick = sbCopyTableClick
        ExplicitLeft = 695
        ExplicitTop = 4
      end
      object spCopyChart: TSpeedButton
        AlignWithMargins = True
        Left = 106
        Top = 3
        Width = 98
        Height = 27
        Align = alLeft
        Caption = ' Copy Chart '
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          0800000000000001000000000000000000000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
          0707070707070707070707A4A4A4A4A4A4A4A4A4A4A4A4A4A4A407D900000000
          000000000000000000A407D9D907FFFFFFFF0707FFFFFFFF00A40700D9D907FF
          FF07D9D907FFFFFF00A40700FFD9D90707D9D9D9D907FFFF00A407000707D9D9
          D9D90707D9D9070400A40700FFFFFFD9D9FFFFFFFFD9D9D900A40700FFFFFFFF
          FFFFFFFFFFD9D9D900A4070007FFFFFFFFFFFFFFD9D9D9D900A4070700000007
          070707070707070700A4070707FF00FFFFFFFFFFFFFFFFFF00A40707070700FF
          FFFFFFFFFFFFFFFF00A4070707070000000000000000000000A4070707070707
          0707070707070707070707070707070707070707070707070707}
        Margin = 3
        OnClick = spCopyChartClick
        ExplicitTop = 4
      end
    end
    object pnlProgress: TPanel
      Left = 409
      Top = 0
      Width = 354
      Height = 33
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object lbStatCount: TLabel
        AlignWithMargins = True
        Left = 346
        Top = 4
        Width = 5
        Height = 18
        Margins.Left = 7
        Margins.Top = 4
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 26058
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object tbProgress: TTrackBar
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 333
        Height = 27
        Align = alLeft
        DoubleBuffered = True
        Max = 100
        ParentDoubleBuffered = False
        PageSize = 1
        SliderVisible = False
        SelEnd = 20
        TabOrder = 0
        TickMarks = tmTopLeft
        TickStyle = tsNone
      end
    end
  end
  object ChartEditor1: TChartEditor
    Chart = chartOne
    HideTabs = [cetPaging, cetWalls, cet3D, cetTools, cetAnimations, cetPrintPreview]
    Options = [ceAdd, ceDelete, ceChange, ceClone, ceDataSource, ceTitle, ceHelp]
    Title = 'Chart Editor'
    TreeView = True
    GalleryHeight = 0
    GalleryWidth = 0
    Height = 0
    Width = 0
    Left = 688
    Top = 352
  end
  object ChartEditor2: TChartEditor
    Chart = chartTwo
    HideTabs = [cetPaging, cetWalls, cet3D, cetTools, cetAnimations, cetPrintPreview]
    Options = [ceAdd, ceDelete, ceChange, ceClone, ceDataSource, ceTitle, ceHelp]
    Title = 'Chart Editor'
    TreeView = True
    GalleryHeight = 0
    GalleryWidth = 0
    Height = 0
    Width = 0
    Left = 792
    Top = 352
  end
  object ImageList1: TImageList
    Height = 17
    Width = 17
    Left = 56
    Top = 160
    Bitmap = {
      494C010105002000B00011001100FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000440000002200000001002000000000002024
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4787400A4787400A478
      7400A4787400A4787400A4787400A4787400A4787400A47874008C5D5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A87C7500FEE5CB00FFE2C400FFDFBE00FFDCB800FFD9B100FED6
      AC00FFD4A600FFD1A2008C5D5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AD807800FFEAD400E5A6
      5700E5A65700E5A65700E5A65700E5A65700E5A65700FFD4A8008C5D5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B4867A00FEEEDD00FFEBD600FFE8CF00FFE4C900FEE1C200FEDD
      BB00FFDBB500FFD8AF008C5D5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4787400A4787400A4787400A4787400A4787400BA8D7D00FEF2E500E5A6
      5700E5A65700E5A65700E5A65700E5A65700E5A65700FEDCB7008C5D5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A87C7500FEE5CB00FFE2C400FFDF
      BE00FFDCB800C2958100FEF6EC00FEF3E600FEEFE100FFEDDA00FEE9D400FEE6
      CC00FFE2C600FEDFBF008C5D5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AD807800FFEAD400E5A65700E5A65700E5A65700CA9B8300FFF9F300E5A6
      5700E5A65700E5A65700E5A65700E5A65700E5A65700FEE3C8008C5D5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B4867A00FEEEDD00FFEBD600FFE8
      CF00FFE4C900D1A28600FEFBF900FEF9F400FEF7EF00FEF5EA00FEF1E400FEEE
      DE00FEEBD700FEE8D0008C5D5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BA8D7D00FEF2E500E5A65700E5A65700E5A65700D8A98A00FEFEFD00FEFC
      FA00FEFAF600FEF8F100FEF5EC00EBDFDB00D3C2C000BAA9AA008C5D5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C2958100FEF6EC00FEF3E600FEEF
      E100FFEDDA00DFB08D00FEFEFE00FEFEFE00FEFCFB00FEFBF700FEF8F200B481
      7600B4817600B4817600B17F7400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CA9B8300FFF9F300E5A65700E5A65700E5A65700E4B58E00FEFEFE00FEFE
      FE00FEFEFE00FEFDFC00FEFBF800B4817600EBB56F00E49B4200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1A28600FEFBF900FEF9F400FEF7
      EF00FEF5EA00E8B89000DCA88700DCA88700DCA88700DCA88700DCA88700B481
      7600F0B25E000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D8A98A00FEFEFD00FEFCFA00FEFAF600FEF8F100FEF5EC00EBDFDB00D3C2
      C000BAA9AA008C5D5C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DFB08D00FEFEFE00FEFEFE00FEFC
      FB00FEFBF700FEF8F200B4817600B4817600B4817600B17F7400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E4B58E00FEFEFE00FEFEFE00FEFEFE00FEFDFC00FEFBF800B4817600EBB5
      6F00E49B42000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E8B89000DCA88700DCA88700DCA8
      8700DCA88700DCA88700B4817600F0B25E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FEFCFC00FFFEFD00FFFFFB00E9E5E000B0AAA3006E675E00423B
      320029221900403930006D676000AEAAA500EAE7E300FFFFFE00FFFFFF00FFFF
      FF00FFFFFF00FFFEFF00FEFBFD00FCFEFF00F8FFFF00D7E6E90096AAAF004E66
      6C001F393F00021F24001E383E0050666B0096A7AA00D8E4E600F8FFFF00FBFF
      FF00FDFDFD00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF7FF00FFF2FD00FFF7FA00B4AB
      A800534D4200312D1A0026250B002E2D1100241D1A0024231500111700002D33
      22004A4D4B00AFACB500FFFBFF00FFFCFF00FDFFFF00F8FFFC00ECF9F700ECFF
      FF008DB4B600255658000021240013262B00252329000C212300061926000314
      29001523350038484F0099B0AB00DCFFF600D1FFF500FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000FFF3FB00FFFCFF00B1A5A5004E443D003D3528003F39260034301700322F
      1300FFFCF900AAA99B002C2F1900181B0B00161713003D3B41009C989E00FCFA
      FA00FCFCFC00F0FCFE00F3FFFF008BA1A700264B530000292F001B454C00CBDE
      E500FDFCFF00F1FFFF00EAF9FF00EFFBFF00E5F1FF0069788100233B3B007A9C
      9600D9FFFD00F7FCFD0000000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF0000000000000000000000FF00000080008000800080008000
      8000800080008000800080008000800080008000800080008000800080008000
      80008000800080008000FF00000000FF0000FFF5F300DCCDCA0062554D00382C
      200053493700473F2800413A1F00423B2000FFFFFC00A8A7990021230D001E20
      0D00201D18000502040038363600B7B6B200FFFFFC00D1F1FC00B4D6E300264D
      5C00002131000747520000353F00678E9700DBEFFA00CED8D800767D86006267
      7600757D8E001C2C380000000800203C430099B6BF00F0FFFF0000000000BF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BF000000000000000000
      0000FF000000FFFFFF008000800080008000FFFFFF00FFFFFF0080008000FFFF
      FF0080008000FFFFFF00FFFFFF0080008000FFFFFF0080008000FF00000000FF
      0000FFEFDF00958575005848370070614E006A5C450053462C005D5036005347
      2B00FFFDFC00ADABA0002D2C1700302C19003B362D001D1817001A1A1400565A
      4E00F4F0EB00C5EDFF004E768F0016405D001C536E0025657D00023F53001A45
      5600647E8F00F2FEFF00A3A6AE001C1C28001A1F2E001D2D3D00061F2F00000F
      2100374A5F00DAF3F70000000000BF000000FFFFFF0000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00BF0000000000000000000000FF000000FFFFFF0080008000FFFF
      FF00FFFFFF00FFFFFF0080008000FFFFFF0080008000FFFFFF00FFFFFF008000
      8000FFFFFF00FFFFFF00FF00000000FF0000E5D0B400806B4F007B664A008570
      540066513500725D41007B664B005F4A2F00FFFEFF00B4B0A5003E392400332C
      1800342B1E0029231C001E1E120020261300C3BEB50082CEF200175E8400135C
      820011658900004B6A0000546D00176278000E495D007F99A000F1FCFF008B8B
      97001C213000182A3B0000162B000017310013213D009CBCC20000000000BF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BF000000000000000000
      0000FF000000FFFFFF0080008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080008000FFFFFF00FFFFFF0080008000FFFFFF00FFFFFF00FF00000000FF
      0000CBB58B008F794F00917A54008C745000806745008C7254007D6247007156
      3B00FFFCFE00B2ADA400504935004A3F290036291B002A22150026281500232C
      11008A827500449BCD001C6FA2001E6FA2000F67960000608800066788000A5E
      7A000E546C00154654009DB9C400EFF5FF00585D6C00081E300000152E00001B
      360000102D00587C860000000000BF000000FFFFFF0000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00BF0000000000000000000000FF000000FFFFFF0080008000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0080008000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF00000000FF0000BFA97500A58E5C009F885800A58C
      6200A3886300967A580086684B0085674C00FFFEFF00B8B3AA00574E3A005A4C
      35004E3E2D00372F1E00252910001D2A0A00584D3F001D91CA00016FA9000A75
      AE000C7CB100007AA60000739700006583000768820016637600204E5F00D2DF
      ED00B0B9C700213A4E00082D470000193600061B3700284E5A0000000000BF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BF000000000000000000
      0000FF00000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00000000FF
      0000BCA46A00BDA46C00B2976400B3966900A0815A0099785700AA886B00906D
      5300FFFBFF00C4BDB4005C513D005747300056473400453B29002B2E14002432
      0E0031271600138ECC00188AC9001180BE001185BE00007DAD00007BA2000E82
      A10000617E00025F780027617400ABBECB00E7F2FF0026415500002841000025
      3F00081F390000212F0000000000BF000000FFFFFF0000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00BF0000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FF0000C5BC8300C1B67A00BEAC6D00BDA6
      6800BCA06A00B3946D00A6877000A1827300FFFFFB00BAB4A9006D624C006D5E
      3E005E502C0047401F0036381B00232912005D5342002DA3DE001B9BD6000292
      CC000095CC000094C6000082AE0007799E002285A500008383000B68690094C4
      C800DEFEFF001B445A0002354F00042E450005233600254E5D0000000000BF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BF000000000000000000
      0000FF0000000000800000008000000080000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000FF00000000FF
      0000E1D2A100D1BF8A00C2AE7500C3AD7300D6BE8A00EED5AD00FCE6CA00FFEA
      D500FFFFF800C7BEB0007D6F58007E6C4D0070614000504628003B3A20003537
      23008A7F71003BCAF70025B3E200089FCC0000A5CE000BBCDD0031CAE5006CD0
      E9009DD4EF006F9CAA009BB5C300E4EDFB00C4D5E80025516900023C5900002E
      4A0005294100537A880000000000BF000000FFFFFF0000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00BF0000000000000000000000FF00000000008000FFFFFF000000
      8000FFFFFF000000800000008000FFFFFF00FFFFFF0000008000FFFFFF000000
      8000FFFFFF0000008000FF00000000FF0000FFEFC600E6D3A600D2BE8E00D8C3
      8F00EEDAAA00FFF7CC00FFF7D600F2E1C600FFFDEB00DBCAB5008D7B5E007863
      430074624300605438004A432F003D3A2B00C7BFB2006EDEFF0053C3E70036AE
      D10028B7D30038D3EA0064EEFF0096EFFF00AEE0F600E1FAFF00E8F9FF00BCD1
      E700497289000E506900074D6A00033957000E304E009DBDCA0000000000BF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BF000000000000000000
      0000FF00000000008000FFFFFF00FFFFFF00FFFFFF0000008000FFFFFF00FFFF
      FF00FFFFFF0000008000FFFFFF00FFFFFF00FFFFFF0000008000FF00000000FF
      0000FFF9DC00F1E2C100E3D4AD00E8D8AD00F9EABC00FFFFD500FFF8D200E9D7
      B200AC977B00A38E6F0087705000877050008570540061533C0053493800645E
      5300F4EFE60090EAFF0074DAF10055CFE50040CFE4003FDAEF004EEFFF004EED
      FF0036D3E700208EAC002185A2001A738E00035A7400186E8600044E66000C3B
      56003F587200D4EEF50000000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF0000000000000000000000FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000008000FFFFFF00FFFFFF00FFFFFF0000008000FFFFFF00FFFF
      FF00FFFFFF0000008000FF00000000FF0000FFFFEE00FEFAE200F8F4D700F1E9
      C400EBDFB500F5E5B700F6DFB100E0C69800BAA17700B2996F00A78D6800A690
      6D0088755A00504230006C635600C3BBB400FFFFFB00D7F8FF00C1EFFF00A1E9
      FB0075DBF1004ECFEA0041D8FA0031D6FD0012BDE900009BC3000087B000037F
      A7002487A70021718800013D4D00315B6800A5C0CE00EDFDFF0000000000BF00
      0000FFFFFF00BF000000BF000000BF000000FFFFFF00BF000000BF000000BF00
      0000FFFFFF00BF000000BF000000BF000000FFFFFF00BF000000000000000000
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00000000FF
      0000F6F9F000FBFDF100FFFFEE00F9F9DB00EFE8C100EBDDAD00E0CA9600CCB1
      7900C5AA7200BCA16E00A58E6100887451007A6A53007D726400BEB4AD00FFFF
      FC00FFFFFB00D0FFFC00CDFFFF00B9FFFF007EF3FC0038DCEF0019D3F20012C1
      F30009A5E10006A1D8000F96CE000C74A9001C689200275F780046737E0088AE
      B200D6FCFE00F8FFFF0000000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF000000BF0000000000000000000000FF00000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF00000000FF0000FFFEFE00FFFFFC00FFFFF700FFFF
      EB00FFFFDD00FFF7C700F0E0A500D9C58400D1B77500C7AF7300B19D6D009383
      5F00A2978100D0C8BB00FBF5F000FFFFFE00FCFCFC00EAF8EC00EBFAF200E0FF
      FC00B6FFFF007AF4FF0051E3FF003CC8F7002FA9E500199DD900279FDB001D80
      BA002E78A2005F93AA00A3CAD200D3F5F500E1FFFF00FDFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      0000FFF9FF00FFFCFD00FBFCF300FAFCE800FFFFDF00FFFECD00F4EBAC00E5D9
      9300DFC67E00C9B37200D5C28F00E8DAB600FCF4DD00FEFAEF00FFFFFC00FFFE
      FE00FDFFFF00FFFFF200F5FFEF00E0FFF000C6FFF900A2FDFF0077F3FF0047DC
      FE0022C4EE001CAEE2001CA7DF0032AFE2006DD0F600ADF2FF00C9F3F800E8FF
      FF00EBFEFF00FFFDFC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF0000424D3E000000000000003E000000
      2800000044000000220000000100010000000000980100000000000000000000
      000000000000000000000000FFFFFF00FFFF80000000000000000000F8018000
      0000000000000000F80180000000000000000000F80180000000000000000000
      F801800000000000000000000001800000000000000000000001800000000000
      0000000000018000000000000000000000018000000000000000000000018000
      0000000000000000000180000000000000000000000380000000000000000000
      000780000000000000000000003F80000000000000000000003F800000000000
      00000000007F8000000000000000000000FF8000000000000000000000000000
      3FFFFFFFF0000000000000003FFFF00010000000000000002000300000000000
      0000000020003000000000000000000020003000000000000000000020003000
      0000000000000000200030000000000000000000200034000000000000000000
      2000300000000000000000002000300000000000000000002000300000000000
      0000000020003000000000000000000020003000000000000000000020003000
      00000000000000002000340000000000000000003FFFF0000000000000000000
      3FFFF8000000000000000000000000000000000000000000000000000000}
  end
end
