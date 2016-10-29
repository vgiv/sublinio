object MyMsgBox: TMyMsgBox
  Left = 255
  Top = 261
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 78
  ClientWidth = 177
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object l: TLabel
    Left = 51
    Top = 16
    Width = 27
    Height = 13
    Caption = '---------'
  end
  object Icon: TImage
    Left = 8
    Top = 8
    Width = 32
    Height = 32
  end
  object b1: TButton
    Left = 6
    Top = 48
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'OK'
    TabOrder = 0
    OnClick = b1Click
  end
  object b2: TButton
    Left = 96
    Top = 48
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = b2Click
  end
end
