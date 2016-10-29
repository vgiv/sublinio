object GotoLineForm: TGotoLineForm
  Left = 238
  Top = 239
  Width = 178
  Height = 101
  BorderIcons = []
  Caption = 'Перейти к строке'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lGotoLine: TLabel
    Left = 6
    Top = 16
    Width = 75
    Height = 13
    Caption = 'Номер строки:'
  end
  object bOK: TButton
    Left = 14
    Top = 44
    Width = 67
    Height = 22
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 90
    Top = 44
    Width = 67
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = bCancelClick
  end
  object eGoto: TEdit
    Left = 85
    Top = 13
    Width = 48
    Height = 21
    TabOrder = 0
  end
end
