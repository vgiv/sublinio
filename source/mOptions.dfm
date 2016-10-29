object OptionsForm: TOptionsForm
  Left = 194
  Top = 106
  Width = 383
  Height = 334
  Caption = 'Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object bApply: TButton
    Left = 24
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 0
  end
  object bCancel: TButton
    Left = 277
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 374
    Height = 265
    ActivePage = TabSheet2
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Files'
    end
    object TabSheet2: TTabSheet
      Caption = 'Translation'
      ImageIndex = 1
      object cbAlign: TCheckBox
        Left = 2
        Top = 3
        Width = 97
        Height = 17
        Caption = 'cbAlign'
        TabOrder = 0
      end
    end
  end
  object bRestore: TButton
    Left = 152
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Restore'
    TabOrder = 3
  end
end
