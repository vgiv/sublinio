object Form1: TForm1
  Left = 121
  Top = 149
  Width = 545
  Height = 345
  Caption = 'SublinioW'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'russian.hlp'
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object UWWSplitter: TSplitter
    Left = 0
    Top = 244
    Width = 537
    Height = 3
    Cursor = crVSplit
    Align = alTop
    OnMoved = UWWSplitterMoved
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 537
    Height = 244
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
    OnChange = RichEdit1Change
    OnKeyPress = RichEdit1KeyPress
    OnSelectionChange = RichEdit1SelectionChange
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 280
    Width = 537
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 17
      end
      item
        Width = 100
      end
      item
        Text = 'TS:'
        Width = 140
      end
      item
        Text = '1:1'
        Width = 70
      end
      item
        Style = psOwnerDraw
        Width = 140
      end
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = False
    SimplePanel = False
    OnDblClick = StatusBar1DblClick
    OnMouseMove = StatusBar1MouseMove
    OnDrawPanel = StatusBar1DrawPanel
    OnResize = StatusBar1Resize
  end
  inline UWWFrame1: TUWWFrame
    Top = 247
    Width = 537
    Height = 33
    Align = alClient
    TabOrder = 2
    inherited UWWBevel: TBevel
      Height = 33
    end
    inherited UWW: TRichEdit
      Width = 530
      Height = 33
      PopupMenu = PopupMenu2
      OnMouseUp = UWWFrame1UWWMouseUp
    end
    inherited UWWButton: TButton
      TabStop = False
      OnClick = UWWFrame1UWWButtonClick
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 496
    Top = 24
    object File1: TMenuItem
      Caption = 'Файл'
      object Open1: TMenuItem
        Caption = 'Открыть'
        ShortCut = 16463
        OnClick = Open1Click
      end
      object New1: TMenuItem
        Caption = 'Очистить окно'
        Enabled = False
        ShortCut = 16474
        OnClick = New1Click
      end
      object Save1: TMenuItem
        Caption = 'Сохранить'
        Enabled = False
        ShortCut = 16467
        OnClick = Save1Click
      end
      object ClearList1: TMenuItem
        Caption = 'Очистить список'
        OnClick = ClearList1Click
      end
      object HideUWW1: TMenuItem
        Caption = 'Закрыть окно неизвестных слов'
        Enabled = False
        ShortCut = 16469
        OnClick = HideUWW1Click
      end
      object Exit1: TMenuItem
        Caption = 'Выход'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Текст'
      object Undo1: TMenuItem
        Caption = 'Отменить'
        Enabled = False
        ShortCut = 32776
        OnClick = Undo1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Caption = 'Вырезать'
        Enabled = False
        ShortCut = 16472
        OnClick = Cut1Click
      end
      object Copy1: TMenuItem
        Caption = 'Копировать'
        Enabled = False
        ShortCut = 16451
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = 'Вставить'
        ShortCut = 16470
        OnClick = Paste1Click
      end
      object SelectAll1: TMenuItem
        Caption = 'Выделить всё'
        Enabled = False
        ShortCut = 16449
        OnClick = SelectAll1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object GotoLine1: TMenuItem
        Caption = 'Перейти'
        Enabled = False
        ShortCut = 16455
        OnClick = GotoLine1Click
      end
      object Find1: TMenuItem
        Caption = 'Найти'
        Enabled = False
        ShortCut = 16454
        OnClick = Find1Click
      end
      object FindMore1: TMenuItem
        Caption = 'Найти снова'
        Enabled = False
        ShortCut = 114
        OnClick = FindMore1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object IsReadOnly1: TMenuItem
        Caption = 'Режим "Редактирование"'
        ShortCut = 16466
        OnClick = IsReadOnly1Click
      end
    end
    object Translation1: TMenuItem
      Caption = 'Перевод'
      object Translate1: TMenuItem
        Caption = 'Перевести текст'
        Enabled = False
        ShortCut = 120
        OnClick = Translate1Click
      end
      object Untranslate1: TMenuItem
        Caption = 'Вернуться к оригиналу'
        Enabled = False
        ShortCut = 8312
        OnClick = Untranslate1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object TranslateWord1: TMenuItem
        Caption = 'Перевести слово'
        Enabled = False
        ShortCut = 16504
        OnClick = TranslateWord1Click
      end
    end
    object Configuration1: TMenuItem
      Caption = 'Установки'
      ShortCut = 16465
      OnClick = Configuration1Click
    end
    object Help1: TMenuItem
      Caption = 'Помощь'
      object Content1: TMenuItem
        Caption = 'Содержание'
        ShortCut = 112
        OnClick = Content1Click
      end
      object AboutAffixes1: TMenuItem
        Caption = 'Аффиксы Эсперанто'
        ShortCut = 8304
        OnClick = AboutAffixes1Click
      end
      object Dictionary1: TMenuItem
        Caption = 'Внешний словарь'
        OnClick = Dictionary1Click
      end
      object About1: TMenuItem
        Caption = 'О программе'
        ShortCut = 16496
        OnClick = About1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 496
    Top = 118
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files|*.txt'
    Left = 496
    Top = 166
  end
  object PopupMenu1: TPopupMenu
    Left = 496
    Top = 70
    object Paste2: TMenuItem
      Caption = 'Вставить'
      ShortCut = 16470
      OnClick = Paste2Click
    end
    object TranslateWord2: TMenuItem
      Caption = 'Перевести слово'
      Enabled = False
      ShortCut = 16504
      OnClick = TranslateWord2Click
    end
    object Debug2: TMenuItem
      Caption = 'Debug'
      ShortCut = 113
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 416
    Top = 24
    object FindUnknownWord1: TMenuItem
      Caption = 'Найти неизвестное слово'
      OnClick = FindUnknownWord1Click
    end
  end
end
