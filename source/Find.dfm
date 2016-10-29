object FindForm: TFindForm
  Left = 189
  Top = 178
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 80
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lFind: TLabel
    Left = 5
    Top = 12
    Width = 40
    Height = 13
    Caption = 'Искать:'
  end
  object bOK: TButton
    Left = 63
    Top = 45
    Width = 75
    Height = 22
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 199
    Top = 45
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = bCancelClick
  end
  object FindText: TComboBox
    Left = 51
    Top = 8
    Width = 270
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
end
