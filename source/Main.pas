unit Main;

{$I defs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, Clipbrd, slKernel, ExtCtrls, ToolWin, Buttons,
  UWW;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Translation1: TMenuItem;
    Edit1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    New1: TMenuItem;
    Configuration1: TMenuItem;
    Cut1: TMenuItem;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    Find1: TMenuItem;
    FindMore1: TMenuItem;
    SelectAll1: TMenuItem;
    GotoLine1: TMenuItem;
    ClearList1: TMenuItem;
    TranslateWord1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TranslateWord2: TMenuItem;
    Paste2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Undo1: TMenuItem;
    N3: TMenuItem;
    Translate1: TMenuItem;
    Untranslate1: TMenuItem;
    IsReadOnly1: TMenuItem;
    N4: TMenuItem;
    RichEdit1: TRichEdit;
    UWWSplitter: TSplitter;
    Debug2: TMenuItem;
    PopupMenu2: TPopupMenu;
    FindUnknownWord1: TMenuItem;
    UWWFrame1: TUWWFrame;
    Help1: TMenuItem;
    Content1: TMenuItem;
    AboutAffixes1: TMenuItem;
    About1: TMenuItem;
    Dictionary1: TMenuItem;
    HideUWW1: TMenuItem;
    N5: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindMore1Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure RichEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SelectAll1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Content1Click(Sender: TObject);
    procedure AboutAffixes1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure RichEdit1SelectionChange(Sender: TObject);
    procedure GotoLine1Click(Sender: TObject);
    procedure ClearList1Click(Sender: TObject);
    procedure TranslateWord1Click(Sender: TObject);
    procedure TranslateWord2Click(Sender: TObject);
    procedure AboutMenu1Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure Manual1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Translate1Click(Sender: TObject);
    procedure Untranslate1Click(Sender: TObject);
    procedure IsReadOnly1Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure StatusBar1Resize(Sender: TObject);
    procedure Dictionary1Click(Sender: TObject);
    procedure UWWSplitterMoved(Sender: TObject);
    procedure UWWButtonClick(Sender: TObject);
    procedure FindUnknownWord1Click(Sender: TObject);
    procedure UWWMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UWWFrame1UWWButtonClick(Sender: TObject);
    procedure UWWFrame1UWWMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure About1Click(Sender: TObject);
    procedure Configuration1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StatusBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure HideUWW1Click(Sender: TObject);
  private
    { Private declarations }
//    FCanBeTranslated: boolean;
    FAfterFind: boolean;
    FReadOnlyState: boolean;
//    clBeforeSelection: TColor;
    FWasTranslated: boolean;
    UWWHeight: integer;
    StringFound: boolean;
    FTextWasChanged: boolean;
//    Initialized: boolean;
    procedure DoTranslate;
    procedure DoRestore;
//    procedure SetCanBeTranslated( const Value: boolean );
//    property CanBeTranslated: boolean read FCanBeTranslated write SetCanBeTranslated;
    procedure SetAfterFind( const Value: boolean );
    property AfterFind: boolean read FAfterFind write SetAfterFind;
    procedure OpenFile( const FileName: string );
    procedure SaveFile( const FileName: string );
    procedure UpdateCaption;
    procedure FindString( const Pos: integer );
    procedure SetTextState;
    procedure GoAndShowPosition( const i: integer );
    procedure GoToLineN( const LineN: integer );
    function  FileNameExists( s: string ): boolean;
    procedure AddFileName( s: string );
    procedure OpenFileName(Sender: TObject);
    procedure SetFindSelLength( const Value: integer );
    property FindSelLength: integer write SetFindSelLength;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure GetCursorPos( Var LineN, LinePos: integer );
    function WordNumberFromBegin( RedLines: boolean ): integer;
    procedure GotoWordNumberFromBegin( WordN: integer; RedLines: boolean );
    procedure GotoOriginalWord;
    procedure UpdateCursorPos;
    procedure LoadParameters;
    procedure SaveParameters;
    procedure ToTranslateWord;
    procedure NoUndo;
    procedure SetReadOnlyState( const Value: boolean );
    property ReadOnlyState: boolean read FReadOnlyState write SetReadOnlyState;
    procedure LoadBitmaps;
    procedure ShowUWW;
    procedure HideUWW;
    procedure ShowUnkWords;
    procedure SetWasTranslated( const Value: boolean );
    property WasTranslated: boolean read FWasTranslated write SetWasTranslated;
    procedure UpdateMsgs;
    function ForgetChangedText: boolean;
    procedure SetTextWasChanged( Value: boolean );
    property TextWasChanged: boolean read FTextWasChanged write SetTextWasChanged;
//    procedure WinFromDosRichEdit;
  public
    { Public declarations }
    procedure Initialize;
    procedure InitMsgs;
  end;

var
  Form1: TForm1;

implementation

uses Find, About, ShellAPI, Math, GotoLine, mCommon, mOptions, mConfig;

const
  PanelRO = 0;
  PanelDS = 1;
  PanelTS = 2;
  PanelPos = 3;
  PanelProgress = 4;
  PanelConf = 5;

  EM_EXLINEFROMCHAR = 1078; { in order not to include RichEdit module, for
                            it redefines EM_SCROLLCARET}

  CurrentFileName: string = '';
  WindowHeight: integer = 0;
  WindowWidth: integer = 0;
  WindowTop: integer = 0;
  WindowLeft: integer = 0;
  UWWHeight: integer = 60;

Var
  BeforeFindReadOnly: boolean;
  OriginalReadOnlyState: boolean;
  ManualChange: boolean;
  StatusBarX{, StatusBarY}: integer;
  StatusPanelLeft, StatusPanelRight: array[0..PanelConf] of integer;

{$R *.DFM}
{$R BITMAP.RES}

procedure GUIShowDictSizes( Const n1, n2, n3: integer );
begin
  Form1.StatusBar1.Panels[PanelDS].Text := Format( 'DS: %d/%d/%d', [n1,n2,n3] );
end;

procedure GUIShowTransStat( Const n1, n2, n3, n4: integer );
begin
  Form1.StatusBar1.Panels[PanelTS].Text := Format( 'TS: %d/%d(%d)/%d', [n1,n2,n3,n4] );
end;

{---------------}

procedure TForm1.SetAfterFind( const Value: boolean );
begin
  if Value then
  begin
    BeforeFindReadOnly := RichEdit1.ReadOnly;
    RichEdit1.ReadOnly := True;
  end else
    RichEdit1.ReadOnly := BeforeFindReadOnly;
  FAfterFind := Value;
end;

procedure TForm1.DoTranslate;
Var
  WordN: integer;
begin
  with RichEdit1 do
  begin
    Visible := False;
    ManualChange := False;
    WordN := WordNumberFromBegin( False );
    FileLines.Text := Lines.Text;
    Clear;
    CurrLineN := 0;
    StatusBar1.Repaint;
    Form1.Cursor := crHourGlass;
    BeginTranslate;
    Translate;
    EndTranslate;
    GUIShowTransStat( KnownWords, UnknownWords, DiffUnknownWords, AllWords );
    Form1.Cursor := crDefault;
    WasTranslated := True;
    OriginalReadOnlyState := ReadOnlyState;
    ReadOnlyState := True;
    if RestorePosition then
      GotoWordNumberFromBegin( WordN, True )
    else
      GoAndShowPosition( 0 );
    Visible := True;
    ManualChange := True;
    SetFocus;
    UpdateCursorPos;
  end;
end;

procedure TForm1.DoRestore;
Var
  WordN: integer;
begin
  with RichEdit1 do
  begin
    Visible := False;
    ManualChange := False;
    GotoOriginalWord;
    WordN := WordNumberFromBegin( True );
    DefAttributes.Color := clBlack;
    Lines := FileLines;
//    CanBeTranslated := True;
    WasTranslated := False;
    ReadOnlyState := OriginalReadOnlyState;
    if RestorePosition then
    begin
    { Restore cursor position }
      GotoWordNumberFromBegin( WordN, False )
    end else
      GoAndShowPosition( 0 );
    Visible := True;
    ManualChange := True;
    SetFocus;
    UpdateCursorPos;
  end;
end;

procedure TForm1.OpenFile( const FileName: string );
begin
  if not FileExists(FileName) then
  begin
    Warning( 'Файл '+FileName+' не найден' );
    Exit;
  end;
  RichEdit1.Lines.LoadFromFile( FileName );
  AddFileName( FileName );
  CurrentFileName := ExtractFileName( FileName );
  UpdateCaption;
  WasTranslated := False;
  SetTextState;
  ReadOnlyState := OpenReadOnly;
end;

procedure TForm1.SaveFile( const FileName: string );
begin
  if FileExists(FileName) then
    if
      {Application.}MyMessageBox( PChar(Format(M('mFileExists'), [FileName])), M('mWrn'),
      MB_OKCANCEL or MB_ICONQUESTION or MB_DEFBUTTON2 ) <> ID_OK
    then
      Exit;
  RichEdit1.Lines.SaveToFile( FileName );
  CurrentFileName := ExtractFileName( FileName );
  UpdateCaption;
end;

procedure TForm1.UpdateCaption;
Var
  c: string[1];
begin
  if TextWasChanged then
    c := '*'
  else
    c := '';
  if CurrentFileName <> '' then
    Caption := ProgramName + ':   ' + CurrentFileName + ' '+ c
  else
    Caption := ProgramName + ' ' + c;
end;

procedure TForm1.FindString( const Pos: integer );
Var
  i: integer;
begin
  with RichEdit1 do
  begin
    Cursor := crHourGlass;
    FindSelLength := 0;
    i := FindText( StringToFind, Pos, Length(Lines.Text), [] );
    if i>=0 then
    begin
      GoAndShowPosition( i );
      FindSelLength := Length( StringToFind );
      AfterFind := True;
      StringFound := True;
    end else begin
      FindSelLength := 0;
      StringFound := False;
    end;
    Cursor := crDefault;
  end;
end;

procedure TForm1.SetTextState;
Var
  IsText: boolean;
begin
  IsText := RichEdit1.Lines.Count>0;
  Translate1.Enabled := IsText and not WasTranslated;
  Untranslate1.Enabled := IsText and WasTranslated;
  TranslateWord1.Enabled := IsText;
  TranslateWord2.Enabled := IsText;
  New1.Enabled := IsText;
  Save1.Enabled := IsText;
  Cut1.Enabled := IsText;
  Copy1.Enabled := IsText;
  SelectAll1.Enabled := IsText;
  GotoLine1.Enabled := IsText;
  Find1.Enabled := IsText;
  FindMore1.Enabled := (StringToFind<>'') and IsText;
  if not IsText then
    Statusbar1.Panels[PanelTS].Text := 'TS:';
end;

procedure TForm1.GoAndShowPosition( const i: integer );
begin
  if i<0 then
    Exit;
  with RichEdit1 do
  begin
    SelStart := i;
    SelLength := 0;
    RichEdit1.Perform(EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TForm1.GoToLineN( const LineN: integer );
begin
  GoAndShowPosition( RichEdit1.Perform(EM_LINEINDEX, LineN-1, 0) );
end;

function TForm1.FileNameExists( s: string ): boolean;
Var
  i: integer;
begin
  for i := FileNamesFirstitemN to File1.Count-1 do
    if File1.Items[i].Caption = s then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TForm1.AddFileName( s: string );
Var
  NewItem: TMenuItem;
begin
  if (FileNames > MaxFileNames) or FileNameExists( s ) then
    Exit;
  ClearList1.Enabled := True;
  if FileNames=0 then
  begin
    File1.Add(NewLine);
    FileNamesFirstItemN := File1.Count;
  end;
  Inc( FileNames );
  NewItem := TMenuItem.Create(Self);
  NewItem.Caption := s;
  NewItem.OnClick := OpenFileName;
  NewItem.ShortCut := ShortCut(Word(Ord('0')+FileNames), [ssCtrl]);
  NewItem.Bitmap.LoadFromResourceName( HInstance, 'OPENFILENAME' );
  File1.Add( NewItem );
end;

procedure TForm1.OpenFileName(Sender: TObject);
Var
  FileName: string;
begin
//  Sender := Sender;
  if not ForgetChangedText then
    Exit;
  with Sender as TMenuItem do begin
    FileName := Caption;
    OpenFile( FileName );
    TextWasChanged := False;
  end;
end;

procedure TForm1.SetFindSelLength( const Value: integer );
begin
  with RichEdit1 do
  begin
(*    if SelLength<>0 then
      SelAttributes.Color := clBeforeSelection;*)
    SelLength := Value;
(*    if SelLength<>0 then
    begin
      clBeforeSelection := SelAttributes.Color;
      SelAttributes.Color := clFound;
    end;*)
  end;
end;

procedure TForm1.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      OpenFile( CFileName );
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TForm1.GetCursorPos( Var LineN, LinePos: integer );
begin
  with RichEdit1 do
  begin
    LineN := RichEdit1.Perform( EM_EXLINEFROMCHAR, 0, SelStart);
    LinePos := (RichEdit1.SelStart - RichEdit1.Perform( EM_LINEINDEX{187}, LineN, 0));
    Inc(LineN);
    Inc(LinePos);
  end;
end;

function TForm1.WordNumberFromBegin( RedLines: boolean ): integer;
Var
  LineN, LinePos, i, j, l, Parity: integer;
  s: string;
  WasWord: boolean;
begin
  with RichEdit1 do
  begin
    GetCursorPos( LineN, LinePos );
    Result := 0;
    Parity := (LineN-1) mod 2;
    for i := 0 to LineN-1 do
    begin
      if RedLines and (i mod 2 <> Parity) then
        Continue;
      s := Lines.Strings[i];
      l := Length(s);
      if (i=LineN-1) and (l>0) then
        l := LinePos;
      Inc(Result);
      if l=0 then
        Continue;
      j := 1;
      WasWord := False;
      while j<=l do
      begin
        while (j<=l) and not Alpha(s[j]) do
          Inc(j);
        if j>l then
          Continue;
        while (j<=l) and Alpha(s[j]) do
          Inc(j);
        if WasWord then
          Inc( Result );
        WasWord := True;
      end;
    end;
  end;
end;

procedure TForm1.GotoWordNumberFromBegin( WordN: integer; RedLines: boolean );
Var
  i, j, l, p: integer;
  s: string;
  WasWord: boolean;
begin
  with RichEdit1 do
  begin
    p := 0;
    for i := 0 to Lines.Count-1 do
    begin
      s := Lines.Strings[i];
      l := Length(s);
      if RedLines and ( (i mod 2) = 1 ) then
      begin
        Inc( p, l+1 );
        Continue;
      end;
      if not RedLines then
        Dec( p, 1 );
      j := 1;
      WasWord := False;
      while (j<=l) and (WordN>0) do
      begin
        while (j<=l) and not Alpha(s[j]) do
          Inc(j);
        if j<=l then
          Dec( WordN );
        if (j>l) or (WordN<=0) then
          Break;
        while (j<=l) and Alpha(s[j]) do
          Inc(j);
        WasWord := True;
      end;
      if not WasWord then
        Dec( WordN );
      Inc( p, j );
      if WordN<=0 then
        Break;
      Inc( p, 2 );
    end;
    if RedLines then
      Dec( p, 1 );
    GoAndShowPosition( p );
  end;
end;

procedure TForm1.GotoOriginalWord;
Var
  LineN, LinePos: integer;
begin
  GetCursorPos( LineN, LinePos );
  if LineN mod 2 = 1 then
    Exit;
  GoToLineN( LineN-1 );
  with RichEdit1 do
    SelStart := SelStart + LinePos - 1;
end;

procedure TForm1.UpdateCursorPos;
var
  LineN, LinePos: integer;
begin
  GetCursorPos( LineN, LinePos );
  if RichEdit1.Visible then
    StatusBar1.Panels[PanelPos].Text := Format('%d:%d', [LineN, LinePos]);
end;

procedure TForm1.LoadParameters;
Var
  f: TextFile;
  s: string;
  p: integer;
  Name: string;
  Val: boolean;
begin
  if FileExists( ProgramIniFile ) then
  begin
    AssignFile( f, ProgramIniFile );
    Reset( f );
    while not SeekEof(f) do
    begin
      ReadLn( f, s );
      if Pos( 'FILE=', s ) = 1 then
      begin
        Delete( s, 1, 5 );
        AddFileName( s );
      end else
      begin
        p := Pos( '=', s );
        if p<>0 then
        begin
          Name := UpperCase(Copy( s, 1, p-1 ));
          Delete( s, 1, Length(Name)+1 );
          if Name = 'CONFNAME' then
            ConfigurationName := s
          else if Name = 'DICFILE' then
            DictName := s
          else if Name = 'PFXDICFILE' then
            PrefixesName := s
          else if Name = 'SFXDICFILE' then
            SuffixesName := s
          else if Name = 'SUPPDICFILE' then
            AddDictName := s
          else if Name = 'UWLOG' then
            UnknownWordsLog := s
          else if Name = 'SEPARATORS' then
            Separators := s
          else if Name = 'SUBSTITUTIONS' then
            Substitutions := LowerCase(s)
          else if Name='DICTIONARYPROGRAM' then
            DictionaryProgram := s
          else if Name='LANGFILENAME' then
            LangFileName := s
          else if Name='WINDOWWIDTH' then
            WindowWidth := StrToInt(s)
          else if Name='WINDOWHEIGHT' then
            WindowHeight := StrToInt(s)
          else if Name='WINDOWTOP' then
            WindowTop := StrToInt(s)
          else if Name='WINDOWLEFT' then
            WindowLeft := StrToInt(s)
          else if Name='UWWHEIGHT' then
            UWWHeight := StrToInt(s)
          else if Name='MARKSTR' then
            MarkStr := s
          else begin
            if s='' then
              s := '0';
            Val := s[1]='1';
            if Name='ALIGN' then
              NoAlign := not Val
            else if Name='COMPLEX' then
              NoComplex := not Val
            else if Name='UNKNOWN' then
              LogUnknownWords := Val
            else if Name='DEBUG' then
              Debug := Val
            else if Name='BREAKLINES' then
              NoBreakLines := not Val
            else if Name='RESTOREPOS' then
              RestorePosition := Val
            else if Name='TRANSLATEAFF' then
              ToTAF9 := Val
            else if Name='CONFIRMATIONS' then
              Confirmations := Val
            else if Name='INTELLECTUALSUBST' then
              IntellectualSubst := Val
            else if Name='OPENREADONLY' then
              OpenReadOnly := Val
            else if Name='SHOWUNKNOWN' then
              ShowUnknown := Val;
          end;
        end;
      end;
    end;
    CloseFile( f );
  end;
end;

procedure TForm1.SaveParameters;
Var
  i: integer;
  f: TextFile;

function B(Val: boolean): string;
begin
  if Val then
    Result := '1'
  else
    Result := '0';
end;

procedure SaveParameter( Name: string; Val: boolean );
begin
  WriteLn( f, Name, '=', B(Val) );
end;

begin
  AssignFile( f, ProgramIniFile );
  Rewrite( f );
  WriteLn( f, 'CONFNAME=', ConfigurationName );
  WriteLn( f, 'DICFILE=', DictName );
  WriteLn( f, 'PFXDICFILE=', PrefixesName );
  WriteLn( f, 'SFXDICFILE=', SuffixesName );
  WriteLn( f, 'SUPPDICFILE=', AddDictName );
  WriteLn( f, 'UWLOG=', UnknownWordsLog );
  WriteLn( f, 'SEPARATORS=', Separators );
  WriteLn( f, 'SUBSTITUTIONS=', Substitutions );
  WriteLn( f, 'DICTIONARYPROGRAM=', DictionaryProgram );
  WriteLn( f, 'LANGFILENAME=', LangFileName );
  WriteLn( f, 'MARKSTR=', MarkStr );
  SaveParameter( 'ALIGN', not NoAlign );
  SaveParameter( 'COMPLEX', not NoComplex );
  SaveParameter( 'UNKNOWN', LogUnknownWords );
  SaveParameter( 'DEBUG', Debug );
  SaveParameter( 'BREAKLINES', not NoBreakLines );
  SaveParameter( 'RESTOREPOS', RestorePosition );
  SaveParameter( 'TRANSLATEAFF', ToTAF9 );
  SaveParameter( 'CONFIRMATIONS', Confirmations );
  SaveParameter( 'INTELLECTUALSUBST', IntellectualSubst );
  SaveParameter( 'OPENREADONLY', OpenReadOnly );
  SaveParameter( 'SHOWUNKNOWN', ShowUnknown );
  WriteLn( f, 'WINDOWWIDTH=', Form1.Width );
  WriteLn( f, 'WINDOWHEIGHT=', Form1.Height );
  WriteLn( f, 'WINDOWTOP=', Form1.Top );
  WriteLn( f, 'WINDOWLEFT=', Form1.Left );
  WriteLn( f, 'UWWHEIGHT=', UWWHeight );
  if FileNamesFirstItemN<>0 then
  begin
    for i := FileNamesFirstitemN to File1.Count-1 do
      WriteLn( f, 'FILE=', File1.Items[i].Caption );
  end;
  CloseFile( f );
  {$IFDEF SaveMsgs}
  if AllMsgTranslated <> 0 then
    WriteMsgs( LangFileName );
  {$ENDIF}
end;

procedure TForm1.ToTranslateWord;
Var
  l, p1, p2: integer;
  OrigWord, TransWord: string;
begin
  with RichEdit1 do
  begin
    l := Length(Text);
    p1 := SelStart;
    while (p1>0) and Alpha(Text[p1]) do
      Dec(p1);
    if not Alpha(Text[p1]) then
    begin
      Inc(p1);
      if not Alpha(Text[p1]) then
        Exit;
    end;
    p2 := p1;
    while (p2<l) and Alpha(Text[p2]) do
      Inc(p2);
    if p2<>l then
      Dec(p2);
    OrigWord := Copy( Text, p1, p2-p1+1 );
    ToTranslateAffixes := ToTAF9;
    TransWord := TranslateWord( OrigWord );
    ToTranslateAffixes := False;
    if TransWord='' then
      TransWord := OrigWord + ' ?';
    {Application.}MyMessageBox( PChar(TransWord), PChar(OrigWord), MB_OK );
  end;
end;

procedure TForm1.NoUndo;
begin
  RichEdit1.ClearUndo;
  Undo1.Enabled := False;
end;

procedure TForm1.SetReadOnlyState( const Value: boolean );
begin
  FReadOnlyState := Value;
  IsReadOnly1.Checked := Value;
  if Value then
  begin
    IsReadOnly1.Bitmap.LoadFromResourceName(HInstance,'READONLY');
    IsReadOnly1.Caption := M('cIsReadOnly1');
    StatusBar1.Panels[PanelRO].Text := 'x';
  end else begin
    IsReadOnly1.Bitmap.LoadFromResourceName(HInstance,'NOTREADONLY');
    IsReadOnly1.Caption := M('cIsReadOnly0');
    StatusBar1.Panels[PanelRO].Text := 'o';
  end;
  RichEdit1.ReadOnly := Value;
end;

procedure TForm1.LoadBitmaps;
begin
  Open1.Bitmap.LoadFromResourceName( HInstance, 'OPEN' );
  New1.Bitmap.LoadFromResourceName( HInstance, 'NEW' );
  Save1.Bitmap.LoadFromResourceName( HInstance, 'SAVE' );
  ClearList1.Bitmap.LoadFromResourceName( HInstance, 'CLEARLIST' );
  Exit1.Bitmap.LoadFromResourceName( HInstance, 'EXIT' );
  Cut1.Bitmap.LoadFromResourceName( HInstance, 'CUT' );
  Undo1.Bitmap.LoadFromResourceName( HInstance, 'UNDO' );
  Copy1.Bitmap.LoadFromResourceName( HInstance, 'COPY' );
  Paste1.Bitmap.LoadFromResourceName( HInstance, 'PASTE' );
  SelectAll1.Bitmap.LoadFromResourceName( HInstance, 'SELECTALL' );
  GotoLine1.Bitmap.LoadFromResourceName( HInstance, 'GOTOLINE' );
  Find1.Bitmap.LoadFromResourceName( HInstance, 'FIND' );
  FindMore1.Bitmap.LoadFromResourceName( HInstance, 'FINDMORE' );
  Translate1.Bitmap.LoadFromResourceName( HInstance, 'TRANSLATE' );
  Untranslate1.Bitmap.LoadFromResourceName( HInstance, 'UNTRANSLATE' );
  TranslateWord1.Bitmap.LoadFromResourceName( HInstance, 'TRANSLATEWORD' );
  Content1.Bitmap.LoadFromResourceName( HInstance, 'CONTENT' );
  About1.Bitmap.LoadFromResourceName( HInstance, 'ABOUT' );
  Dictionary1.Bitmap.LoadFromResourceName( HInstance, 'DICTIONARY' );
  AboutAffixes1.Bitmap.LoadFromResourceName( HInstance, 'ABOUTAFFIXES' );
  HideUWW1.Bitmap.LoadFromResourceName( HInstance, 'HIDEUWW' );
end;

procedure TForm1.ShowUWW;
begin
  if not UWWFrame1.Visible then
  begin
    UWWFrame1.Show;
    UWWSplitter.Height := 3;
    RichEdit1.Height := Form1.ClientHeight-StatusBar1.Height-UWWHeight;
    FindUnknownWord1.Caption := ' ';
    HideUWW1.Enabled := True;
  end;
end;

procedure TForm1.HideUWW;
begin
  if UWWFrame1.Visible then
  begin
    UWWFrame1.Hide;
    UWWSplitter.Height := 0;
    RichEdit1.Height := Form1.ClientHeight-StatusBar1.Height;
    HideUWW1.Enabled := False;
  end;
end;

procedure TForm1.ShowUnkWords;
begin
  if ShowUnknownWords and (UnknownWords>0) and FileExists(UnknownWordsLog) then
  begin
    ShowUWW;
    UWWFrame1.UWW.Lines.LoadFromFile( UnknownWordsLog );
  end;
end;

procedure TForm1.SetWasTranslated( const Value: boolean );
begin
  FWasTranslated := Value;
  if Value and ShowUnknown then
    ShowUnkWords
  else
    HideUWW;
end;

procedure TForm1.UpdateMsgs;
begin
  File1.Caption := M('cFile');
  Open1.Caption := M('cOpen');
  New1.Caption := M('cNew');
  Save1.Caption := M('cSave');
  ClearList1.Caption := M('cClearList');
  Exit1.Caption := M('cExit');
  Edit1.Caption := M('cEdit');
  Undo1.Caption := M('cUndo');
  Cut1.Caption := M('cCut');
  Copy1.Caption := M('cCopy');
  Paste1.Caption := M('cPaste');
  SelectAll1.Caption := M('cSelectAll');
  GotoLine1.Caption := M('cGotoLine');
  Find1.Caption := M('cFind');
  FindMore1.Caption := M('cFindMore');
  IsReadOnly1.Caption := M('cIsReadOnly0');
  Translation1.Caption := M('cTranslation');
  Translate1.Caption := M('cTranslate');
  Untranslate1.Caption := M('cUntranslate');
  TranslateWord1.Caption := M('cTranslateWord');
  Configuration1.Caption := M('cConfig');
  Help1.Caption := M('cHelp');
  About1.Caption := M('cAbout');
  Content1.Caption := M('cContent');
  Dictionary1.Caption := M('cDictionary');
  AboutAffixes1.Caption := M('cAboutAffixes');
  Paste2.Caption := M('pPaste');
  TranslateWord2.Caption := M('pTranslateWord');
  FindUnknownWord1.Caption := M('pFindUnknownWord');
  Application.HelpFile := M('fHelp');
  HideUWW1.Caption := M('cHideUWW');
end;

function TForm1.ForgetChangedText: boolean;
begin
  if not (TextWasChanged and Confirmations) then
    Result := True
  else
    Result := {Application.}MyMessageBox( M('mRemember'), M('mWrn'), MB_OKCANCEL or MB_ICONQUESTION or MB_DEFBUTTON2 ) = ID_OK;
end;

procedure TForm1.SetTextWasChanged( Value: boolean );
begin
  if Value<>FTextWasChanged then
  begin
    FTextWasChanged := Value;
    UpdateCaption;
  end;
end;

{--------------}

procedure TForm1.Open1Click(Sender: TObject);
begin
  if not ForgetChangedText then
    Exit;
  OpenDialog1.InitialDir := GetFilePath(InFileName);
  if OpenDialog1.Execute then
  begin
    OpenFile( OpenDialog1.FileName );
    SetTextState;
    NoUndo;
    TextWasChanged := False;
  end;
  SetCurrentDir( WorkingDir );
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
//  RichEdit1.CopyToClipboard;
  Clipboard.AsText := RichEdit1.SelText;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  if not ForgetChangedText then
    Exit;
  RichEdit1.DefAttributes.Color := clBlack;
  RichEdit1.Clear;
  WasTranslated := False;
  SetTextState;
  CurrentFileName := '';
  UpdateCaption;
  NoUndo;
  ReadOnlyState := False;
  TextWasChanged := False;
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
//  RichEdit1.CutToClipboard;
  Clipboard.AsText := RichEdit1.SelText;
  RichEdit1.ClearSelection;
  SetTextState;
end;

Procedure GetCSParameters;
begin
  if (ParamCount>=1) then
    ProgramIniFile := ParamStr(1);
end; { GetParameters }

procedure TForm1.Initialize;
Var
  OldLangFileName: string;
begin
  WereErrors := False;
  WorkingDir := GetCurrentDir;
  InitMsgs;
  GetMsgs( LangFileName );
  GetCSParameters;
  if InFileName<>'' then
    OpenFile( InFileName );
  ClearList1.Enabled := False;
  FileLines := TStringList.Create;
  OldLangFileName := LangFileName;
  LoadParameters;
  if (LangFileName<>OldLangFileName) and FileExists( LangFileName ) then
    GetMsgs( LangFileName );
  UpdateMsgs;
  CheckMsgs;
  if WindowWidth>0 then
    Form1.Width := WindowWidth;
  if WindowHeight>0 then
    Form1.Height := WindowHeight;
  if WindowTop>0 then
    Form1.Top := WindowTop;
  if WindowLeft>0 then
    Form1.Left := WindowLeft;
  if (DictionaryProgram<>'') and not FileExists(DictionaryProgram) then
  begin
    Warning( Format( 'NoExtDic', [DictionaryProgram]) );
    DictionaryProgram := '';
  end;
//  clBeforeSelection :=  RichEdit1.DefAttributes.Color;
  DragAcceptFiles(Handle, True);
  StatusBar1.Panels[PanelConf].Text := ConfigurationName;
  WasTranslated := False;
  ReadOnlyState := False;
  ManualChange := True;
  TextWasChanged := False;
  LoadBitMaps;
  HideUWW;
  MFStatusbar := Statusbar1;
  MFRichedit := Richedit1;
  InitTranslate;
  GUIShowDictSizes( DictWordsQ, PrefixesQ, SuffixesQ );
//  Initialized := not WereErrors;
end;

procedure TForm1.InitMsgs;
begin
  MsgsQ := 0;
  AddMsg( 'Language', 'Русский' );
  AddMsg( 'fHelp', 'russian.hlp' );
  AddMsg('mOK','Да');
  AddMsg('mCancel','Нет');
  AddMsg('mErr','Ошибка');
  AddMsg('mWrn','Предупреждение');
  AddMsg('mOpn','Файл не найден');
  AddMsg('mAlp','MALP=Алфавитный порядок в словаре %s нарушен после слова %s. Некоторые слова не будут найдены');
  AddMsg('mAff','Слишком много аффиксов');
  AddMsg('mLng','Слишком длинный словарь');
  AddMsg('mKey','Неизвестный ключ');
  AddMsg('mNms','Слишком много имен файлов');
  AddMsg('mTol','Корень "%s" длиннее %d символов');
  AddMsg('mTola','Перевод корня "%s" длиннее %d символов');
  AddMsg('mListCut','>>> СПИСОК УРЕЗАН <<<');
  AddMsg('mOlder11','Используется устаревший словарь суффиксов (версии <=1.1xx)');
  AddMsg('mGost','Подразумевается старая (Alt-ГОСТ) кодировка словаря');
  AddMsg('mFromGost','Проведена перекодировка');
  AddMsg( 'mNolang', 'Языковой файл %s не найден' );
  AddMsg( 'mNotTrMsg', 'По крайней мере одно сообщение (%s) не переведено в языковом файле' );
  AddMsg( 'mNoExtDic', 'Внешний словарь %s не найден' );
  AddMsg( 'mRemember', 'Текст был изменен. Продолжить?' );
  AddMsg( 'mFileExists', 'Файл %s существует. Переписать его?' );
  AddMsg( 'mClearList', 'Очистить список файлов?' );
  AddMsg( 'cFile', File1.Caption );
  AddMsg( 'cOpen', Open1.Caption );
  AddMsg( 'cNew', New1.Caption );
  AddMsg( 'cSave', Save1.Caption );
  AddMsg( 'cClearList', ClearList1.Caption );
  AddMsg( 'cExit', Exit1.Caption );
  AddMsg( 'cEdit', Edit1.Caption );
  AddMsg( 'cUndo', Undo1.Caption );
  AddMsg( 'cCut', Cut1.Caption );
  AddMsg( 'cCopy', Copy1.Caption );
  AddMsg( 'cPaste', Paste1.Caption );
  AddMsg( 'cSelectAll', SelectAll1.Caption );
  AddMsg( 'cGotoLine', GotoLine1.Caption );
  AddMsg( 'cFind', Find1.Caption );
  AddMsg( 'cFindMore', FindMore1.Caption );
  AddMsg( 'cIsReadOnly0', 'Режим "Только чтение"' );
  AddMsg( 'cIsReadOnly1', IsReadOnly1.Caption );
  AddMsg( 'cTranslation', Translation1.Caption );
  AddMsg( 'cTranslate', Translate1.Caption );
  AddMsg( 'cUntranslate', Untranslate1.Caption );
  AddMsg( 'cTranslateWord', TranslateWord1.Caption );
  AddMsg( 'cAlign', ConfigForm.cbAlign.Caption );
  AddMsg( 'cComplex', ConfigForm.cbComplex.Caption );
  AddMsg( 'cUnknown', ConfigForm.cbLogUW.Caption );
  AddMsg( 'cDebug', ConfigForm.cbDebug.Caption );
  AddMsg( 'cMarkStr', ConfigForm.lMarkStr.Caption );
  AddMsg( 'cBreakLines', ConfigForm.cbBL.Caption );
  AddMsg( 'cIntellectualSubst', ConfigForm.cbIntSub.Caption );
  AddMsg( 'cRestorePosition', ConfigForm.cbRestorePosition.Caption );
  AddMsg( 'cTranslateAffixes', ConfigForm.cbTAF9.Caption );
  AddMsg( 'cConfirmations', ConfigForm.cbConfirm.Caption );
  AddMsg( 'cOpenReadOnly', ConfigForm.cbOpenRO.Caption );
  AddMsg( 'cShowUnknown', ConfigForm.cbShowUnknown.Caption );
  AddMsg( 'cDictionaryFile', ConfigForm.lExtDic.Caption );
  AddMsg( 'cLangFile', ConfigForm.lLangFile.Caption );
  AddMsg( 'cConfig', Configuration1.Caption );
  AddMsg( 'cHelp', Help1.Caption );
  AddMsg( 'cContent', Content1.Caption );
  AddMsg( 'cAbout', About1.Caption );
  AddMsg( 'cDictionary', Dictionary1.Caption );
  AddMsg( 'cAboutAffixes', AboutAffixes1.Caption );
  AddMsg( 'pPaste', Paste1.Caption );
  AddMsg( 'pTranslateWord', TranslateWord1.Caption );
  AddMsg( 'pFindUnknownWord', FindUnknownWord1.Caption );
  AddMsg( 'cLineN', GotoLineForm.lGotoLine.Caption );
  AddMsg( 'cFindString', FindForm.lFind.Caption );
  AddMsg( 'cConfFile', ConfigForm.lConfFile.Caption );
  AddMsg( 'cConfName', ConfigForm.lConfName.Caption );
  AddMsg( 'cOK', ConfigForm.bOK.Caption );
  AddMsg( 'cCancel', ConfigForm.bCancel.Caption );
  AddMsg( 'cRestore', ConfigForm.bRestore.Caption );
  AddMsg( 'cTranslation2', ConfigForm.tsTranslation.Caption );
  AddMsg( 'cInterface', ConfigForm.tsInterface.Caption );
  AddMsg( 'cFiles', ConfigForm.tsFiles.Caption );
  AddMsg( 'cMainDic', ConfigForm.lMainDic.Caption );
  AddMsg( 'cPrefDic', ConfigForm.lPrefDic.Caption );
  AddMsg( 'cSuffDic', ConfigForm.lSuffDic.Caption );
  AddMsg( 'mReload', 'Программу нужно перезапустить для загрузки новых словарей' );
  AddMsg( 'pFindWord', FindUnknownWord1.Caption );
  AddMsg( 'cSubst', ConfigForm.lSubst.Caption );
  AddMsg( 'cUW', ConfigForm.lUW.Caption );
  AddMsg( 'cHideUWW', HideUWW1.Caption );
  AddMsg( 'cAuthor', 'Автор программы: Владимир Иванов, %s' );
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  SaveDialog1.FileName := CurrentFileName;
  if SaveDialog1.Execute then
    SaveFile( SaveDialog1.FileName )
end;

procedure TForm1.RichEdit1Change(Sender: TObject);
begin
  if ManualChange then
    SetTextState;
  TextWasChanged := True;
end;

procedure TForm1.Find1Click(Sender: TObject);
begin
  if (FindForm.ShowModal = mrOK) and (StringToFind<>'') then
  begin
    FindString( RichEdit1.SelStart );
    FindMore1.Enabled := True;
  end;
end;

procedure TForm1.FindMore1Click(Sender: TObject);
begin
  if RichEdit1.SelLength<>0 then
    FindString( RichEdit1.SelStart+1 )
  else
    FindString( RichEdit1.SelStart )
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
Var
  R: TRect;
begin
  if Panel = StatusBar1.Panels[PanelProgress] then
  begin
    R := Rect;
    with StatusBar1.Canvas do
    begin
      Brush.Color := StatusBar1.Color;
      Brush.Style := bsSolid;
      FillRect(R);
      R.Right := R.Left+(R.Right-R.Left)*ProgressFrac div 100;
      Brush.Color := clBlue;
      FillRect(R);
      Font.Color := clYellow;
      Font.Style := [fsBold];
      TextRect( R, (R.Right+R.Left) div 2, R.Top, Format( '%d%%', [ProgressFrac]) );
    end;
  end
  else if Panel = StatusBar1.Panels[PanelRO] then
    with StatusBar1.Canvas do
      BrushCopy( Rect, IsReadOnly1.Bitmap, Rect, StatusBar1.Color );
end;

procedure TForm1.RichEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if AfterFind then
  begin
    if RichEdit1.SelLength>0 then
      FindSelLength := 0
    else
      AfterFind := False
  end else begin
    SetTextState;
    Undo1.Enabled := True;
  end;
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  RichEdit1.SelectAll;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if Initialized then
  SaveParameters;
end;

procedure TForm1.Content1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TForm1.AboutAffixes1Click(Sender: TObject);
begin
  Application.HelpJump('Affixes');
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.RichEdit1SelectionChange(Sender: TObject);
begin
  UpdateCursorPos;
end;

procedure TForm1.GotoLine1Click(Sender: TObject);
begin
  if (GotoLineForm.ShowModal = mrOK) then
    GotoLineN( LineNToGo );
end;

procedure TForm1.ClearList1Click(Sender: TObject);
Var
  i: integer;
begin
  if TextWasChanged and Confirmations
    and
    ( {Application.}MyMessageBox( m('mClearList'),
      M('mWrn'), MB_OKCANCEL or MB_ICONQUESTION or MB_DEFBUTTON2 ) <> ID_OK )
  then
    Exit;
  for i :=  File1.Count-1 downto FileNamesFirstItemN do
    File1.Items[i].Free;
  FileNames := 0;
  ClearList1.Enabled := False;
end;

procedure TForm1.TranslateWord1Click(Sender: TObject);
begin
  ToTranslateWord;
end;

procedure TForm1.TranslateWord2Click(Sender: TObject);
begin
  TranslateWord1Click(Sender);
end;

procedure TForm1.AboutMenu1Click(Sender: TObject);
begin
  Application.HelpJump('Menu');
end;

procedure TForm1.Paste2Click(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TForm1.Manual1Click(Sender: TObject);
begin
  Application.HelpJump('Manual');
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  RichEdit1.Undo;
end;

procedure TForm1.Translate1Click(Sender: TObject);
begin
  if not WasTranslated then
  begin
    DoTranslate;
    SetTextState;
  end;
  NoUndo;
end;

procedure TForm1.Untranslate1Click(Sender: TObject);
begin
  if WasTranslated then
  begin
    DoRestore;
    StatusBar1.Panels[PanelTS].Text := 'TS:';
    SetTextState;
  end;
  NoUndo;
end;

procedure TForm1.IsReadOnly1Click(Sender: TObject);
begin
  ReadOnlyState := not ReadOnlyState;
end;

procedure TForm1.StatusBar1DblClick(Sender: TObject);
begin
  if (StatusBarX>=StatusPanelLeft[PanelRO]) and (StatusBarX<=StatusPanelRight[PanelRO]) then
    IsReadOnly1Click( StatusBar1 );
end;

procedure TForm1.StatusBar1Resize(Sender: TObject);
Var
  i: integer;
begin
// Recalculate coordinates of panels
  for i := 0 to PanelConf do
  begin
    if i=0 then
      StatusPanelLeft[0] := 1
    else
      StatusPanelLeft[i] := StatusPanelRight[i-1]+2;
    StatusPanelRight[i] := StatusPanelLeft[i] + StatusBar1.Panels[i].Width;
  end;
end;

procedure TForm1.Dictionary1Click(Sender: TObject);
begin
  ShellExecute(Handle,'Open',PChar(DictionaryProgram),nil,PChar(GetFilePath(DictionaryProgram)),SW_SHOWNORMAL)
end;

procedure TForm1.UWWSplitterMoved(Sender: TObject);
begin
  with UWWFrame1 do
  if UWW.Visible then
    UWWHeight := UWW.Height;
end;

procedure TForm1.UWWButtonClick(Sender: TObject);
begin
  HideUWW;
end;

procedure TForm1.FindUnknownWord1Click(Sender: TObject);
begin
  with UWWFrame1.UWW do
  begin
    Cursor := crHourGlass;
    FindString( 0 );
    if StringFound then
    begin
      RichEdit1.SetFocus;
      FindMore1.Enabled := True;
    end;
    Cursor := crDefault;
  end;
end;

procedure TForm1.UWWMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  LineN: integer;
begin
  with UWWFrame1.UWW do
  begin
    LineN := Perform( EM_EXLINEFROMCHAR, 0, SelStart );
    StringToFind := Lines.Strings[LineN];
    FindUnknownWord1.Caption := 'Найти слово '+StringToFind;
  end;
end;

procedure TForm1.UWWFrame1UWWButtonClick(Sender: TObject);
begin
  HideUWW;
end;

procedure TForm1.UWWFrame1UWWMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  LineN: integer;
begin
  with UWWFrame1.UWW do
  begin
    LineN := Perform( EM_EXLINEFROMCHAR, 0, SelStart );
    StringToFind := Lines.Strings[LineN];
    FindUnknownWord1.Caption := M('pFindWord')+' '+StringToFind;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TForm1.Configuration1Click(Sender: TObject);
begin
  ConfigForm.Left := Left + ( Width - ConfigForm.Width ) div 2;
  ConfigForm.Top := Top + ( Height - ConfigForm.Height ) div 2;
  if (ConfigForm.ShowModal = mrOK) then
  begin
    if ShowUnknown then
      ShowUnkWords
    else
      HideUWW;
    if LangChanged then
    begin
      GetMsgs( LangFileName );
      UpdateMsgs;
    end;
    Dictionary1.Enabled := FileExists( DictionaryProgram );
    if DictChanged then
      Warning( M('mReload') );
    StatusBar1.Panels[PanelConf].Text := ConfigurationName;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//  if not Initialized then
    Initialize;
//  if not Initialized then
//    Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//  Initialized := False;
end;

procedure TForm1.StatusBar1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  StatusBarX := X;
{
  StatusBarY := Y;
  for i := 0 to PanelConf do
    if (StatusBarX>=StatusPanelLeft[i]) and (StatusBarX<=StatusPanelRight[i]) then
    begin
      case i of
        PanelRO: StatusBar1.Hint := M('hPanelRO');
        PanelDS: StatusBar1.Hint := M('hPanelDS');
        PanelTS: StatusBar1.Hint := M('hPanelTS');
        PanelPos: StatusBar1.Hint := M('hPanelPos');
        PanelProgress: StatusBar1.Hint := M('hPanelProgress');
        PanelConf: StatusBar1.Hint := M('hPanelConf');
      end;
      Break;
    end;
}
end;

procedure TForm1.HideUWW1Click(Sender: TObject);
begin
  HideUWW;
end;

end.

