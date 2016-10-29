object UWWFrame: TUWWFrame
  Left = 0
  Top = 0
  Width = 541
  Height = 47
  TabOrder = 0
  object UWWBevel: TBevel
    Left = 0
    Top = 0
    Width = 7
    Height = 47
    Align = alLeft
    Shape = bsFrame
    Style = bsRaised
  end
  object UWW: TRichEdit
    Left = 7
    Top = 0
    Width = 534
    Height = 47
    Align = alClient
    Color = clInfoBk
    ParentShowHint = False
    ReadOnly = True
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 0
  end
  object UWWButton: TButton
    Left = 0
    Top = 0
    Width = 8
    Height = 10
    Caption = 'x'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
end
