object ConfigForm: TConfigForm
  Left = 223
  Top = 150
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 307
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bOK: TButton
    Left = 19
    Top = 272
    Width = 88
    Height = 25
    Caption = 'Применить'
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 320
    Top = 272
    Width = 88
    Height = 25
    Cancel = True
    Caption = 'Отменить'
    TabOrder = 3
    OnClick = bCancelClick
  end
  object pcConfig: TPageControl
    Left = 0
    Top = 0
    Width = 417
    Height = 265
    ActivePage = tsTranslation
    TabOrder = 0
    object tsTranslation: TTabSheet
      Caption = 'Перевод'
      ImageIndex = 1
      object lMarkStr: TLabel
        Left = 3
        Top = 154
        Width = 138
        Height = 13
        Caption = 'Маркер неизвестных слов:'
      end
      object lSubst: TLabel
        Left = 0
        Top = 180
        Width = 70
        Height = 13
        Caption = 'Подстановки:'
      end
      object cbAlign: TCheckBox
        Left = 2
        Top = 3
        Width = 361
        Height = 17
        Caption = 'Выравнивание'
        TabOrder = 0
      end
      object cbComplex: TCheckBox
        Left = 2
        Top = 25
        Width = 361
        Height = 17
        Caption = 'Разбор составных слов'
        TabOrder = 1
      end
      object cbLogUW: TCheckBox
        Left = 2
        Top = 46
        Width = 361
        Height = 17
        Caption = 'Лог неизвестных слов'
        TabOrder = 2
        OnClick = cbLogUWClick
      end
      object cbDebug: TCheckBox
        Left = 2
        Top = 90
        Width = 361
        Height = 17
        Caption = 'Отладочный лог'
        TabOrder = 4
      end
      object cbBL: TCheckBox
        Left = 2
        Top = 111
        Width = 361
        Height = 17
        Caption = 'Разбиение строк'
        TabOrder = 5
      end
      object cbTAF9: TCheckBox
        Left = 2
        Top = 132
        Width = 361
        Height = 17
        Caption = 'Переводить аффиксы при Ctrl-F9'
        TabOrder = 6
      end
      object eMarkStr: TEdit
        Left = 144
        Top = 152
        Width = 21
        Height = 21
        TabOrder = 7
      end
      object cbShowUnknown: TCheckBox
        Left = 2
        Top = 67
        Width = 361
        Height = 17
        Caption = 'Открывать окно неизвестных слов'
        TabOrder = 3
      end
      object eSubst: TEdit
        Left = 72
        Top = 176
        Width = 297
        Height = 21
        TabOrder = 8
      end
      object cbIntSub: TCheckBox
        Left = 2
        Top = 207
        Width = 361
        Height = 17
        Caption = 'Интеллектуальная замена'
        TabOrder = 9
      end
    end
    object tsInterface: TTabSheet
      Caption = 'Интерфейс'
      ImageIndex = 2
      object cbConfirm: TCheckBox
        Left = 2
        Top = 26
        Width = 369
        Height = 17
        Caption = 'Подтверждение операций'
        TabOrder = 1
      end
      object cbRestorePosition: TCheckBox
        Left = 2
        Top = 5
        Width = 369
        Height = 17
        Caption = 'Помнить позицию курсора'
        TabOrder = 0
      end
      object cbOpenRO: TCheckBox
        Left = 2
        Top = 46
        Width = 369
        Height = 17
        Caption = 'Открывать в режиме "Только чтение"'
        TabOrder = 2
      end
    end
    object tsFiles: TTabSheet
      Caption = 'Файлы'
      object lConfFile: TLabel
        Left = 6
        Top = 7
        Width = 107
        Height = 13
        Caption = 'Файл конфигурации:'
      end
      object lConfName: TLabel
        Left = 6
        Top = 33
        Width = 100
        Height = 13
        Caption = 'Имя конфигурации:'
      end
      object lMainDic: TLabel
        Left = 6
        Top = 64
        Width = 98
        Height = 13
        Caption = 'Основной словарь:'
      end
      object lPrefDic: TLabel
        Left = 6
        Top = 89
        Width = 105
        Height = 13
        Caption = 'Словарь префиксов:'
      end
      object lSuffDic: TLabel
        Left = 6
        Top = 114
        Width = 106
        Height = 13
        Caption = 'Словарь суффиксов:'
      end
      object lLangFile: TLabel
        Left = 4
        Top = 150
        Width = 84
        Height = 13
        Caption = 'Языковой файл:'
      end
      object lExtDic: TLabel
        Left = 4
        Top = 176
        Width = 93
        Height = 13
        Caption = 'Внешний словарь:'
      end
      object lUW: TLabel
        Left = 5
        Top = 200
        Width = 118
        Height = 13
        Caption = 'Лог неизвестных слов:'
      end
      object Bevel1: TBevel
        Left = -1
        Top = 54
        Width = 410
        Height = 83
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = -1
        Top = 140
        Width = 410
        Height = 84
        Shape = bsFrame
      end
      object eLangFile: TEdit
        Left = 167
        Top = 146
        Width = 202
        Height = 21
        TabOrder = 8
      end
      object bLangFile: TButton
        Left = 377
        Top = 146
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 9
        OnClick = bLangFileClick
      end
      object eExtDic: TEdit
        Left = 167
        Top = 172
        Width = 202
        Height = 21
        TabOrder = 10
      end
      object bExtDic: TButton
        Left = 377
        Top = 172
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 11
        OnClick = bExtDicClick
      end
      object eConfFile: TEdit
        Left = 167
        Top = 5
        Width = 202
        Height = 21
        Color = clMenu
        Enabled = False
        TabOrder = 0
      end
      object eMainDic: TEdit
        Left = 167
        Top = 60
        Width = 202
        Height = 21
        TabOrder = 2
      end
      object bMainDic: TButton
        Left = 377
        Top = 60
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 3
        OnClick = bMainDicClick
      end
      object ePrefDic: TEdit
        Left = 167
        Top = 85
        Width = 202
        Height = 21
        TabOrder = 4
      end
      object bPrefDic: TButton
        Left = 377
        Top = 85
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 5
        OnClick = bPrefDicClick
      end
      object eSuffDic: TEdit
        Left = 167
        Top = 110
        Width = 202
        Height = 21
        TabOrder = 6
      end
      object bSuffDic: TButton
        Left = 377
        Top = 110
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 7
        OnClick = bSuffDicClick
      end
      object eConfName: TEdit
        Left = 167
        Top = 30
        Width = 202
        Height = 21
        TabOrder = 1
      end
      object eUW: TEdit
        Left = 167
        Top = 198
        Width = 202
        Height = 21
        TabOrder = 12
      end
      object bUW: TButton
        Left = 377
        Top = 198
        Width = 21
        Height = 20
        Caption = '...'
        TabOrder = 13
        OnClick = bUWClick
      end
    end
  end
  object bRestore: TButton
    Left = 170
    Top = 272
    Width = 88
    Height = 25
    Caption = 'Восстановить'
    TabOrder = 2
    OnClick = bRestoreClick
  end
  object FilesDialog: TOpenDialog
    Left = 284
    Top = 275
  end
end
