object AboutForm: TAboutForm
  Left = 273
  Top = 175
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'О программе'
  ClientHeight = 206
  ClientWidth = 308
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
  object Label1: TLabel
    Left = 30
    Top = 9
    Width = 245
    Height = 55
    AutoSize = False
    Caption = 'SublinioW'
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -48
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentColor = False
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 26
    Top = 6
    Width = 254
    Height = 62
  end
  object OKButton: TButton
    Left = 123
    Top = 175
    Width = 64
    Height = 23
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKButtonClick
    OnKeyPress = OKButtonKeyPress
  end
  object AuthorText: TStaticText
    Left = 12
    Top = 100
    Width = 293
    Height = 20
    Alignment = taCenter
    Caption = 'Автор программы: Владимир Иванов, 0000'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
  end
  object UrlText: TStaticText
    Left = 105
    Top = 145
    Width = 104
    Height = 19
    Cursor = crHandPoint
    Caption = 'http://vgiv.narod.ru'
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic, fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnClick = UrlTextClick
  end
  object EmailText: TStaticText
    Left = 103
    Top = 123
    Width = 91
    Height = 19
    Cursor = crHandPoint
    Caption = 'vgi@gao.spb.ru'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic, fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = EmailTextClick
  end
  object VersionText: TStaticText
    Left = 130
    Top = 72
    Width = 58
    Height = 27
    Caption = 'v.0.00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 57
    Top = 125
    Width = 44
    Height = 19
    Caption = 'E-mail:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 5
  end
  object StaticText2: TStaticText
    Left = 69
    Top = 146
    Width = 33
    Height = 19
    Caption = 'URL:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 6
  end
end
