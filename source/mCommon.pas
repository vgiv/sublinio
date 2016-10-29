unit mCommon;

{$I defs.inc}

interface

Uses
  Comctrls, Classes;

Const
  ProgramName = 'SublinioW';
  ProgramYear = '2003';
  ProgramVer = '2.01';
  ProgramNameVer = ProgramName + ' (v. ' + ProgramVer + ')';
//  EmailString = 'ivanovv@gao.spb.ru';
//  UrlString = 'http://vgiv.narod.ru/sublinio.html';
  AuthorName = 'Vladimir Ivanov';
{------}
  MaxWordsQ = 6000; { макс. количество слов в словаре }
  MaxAffixQ = 100; { макс. количество аффиксов }
  OrigWordLen = 16; { макс. длина переводимого слова }
  TransWordLen = 32; { макс. длина переведенного слова }
  AffixLen = 16; { макс. длина аффикса }
  AffixCommentLen = 50; { макс. длина комментария к аффиксу }
  MaxSubstQ  = 20; { макс. количество подстановок }
  MaxSubstLen = 8; { макс. длина подстановки }
  MaxUnkWordsQ = 1000; { макс. количество неизвестных слов }
  DebugName = 'debug.log'; { отладочный лог }
{-----}
  ProgressStep = 1;
  MaxFileNames = 9;
(*  clFound: TColor = $00008080; { color for found text }*)
  MarkStr: string = '';
//  SaveMsgFileName = 'new.lng'; { файл сообщений }
  MaxMsgsQ = 300;
  LangFileName: string = 'russian.lng'; { файл сообщений }
  DictionaryProgram: string = '';
  InFileName: string = '';
  DictName: string = 'cxefa.dic';
  PrefixesName: string = 'prefikso.dic';
  SuffixesName: string = 'sufikso.dic';
  AddDictName: string = '';
  Separators: string = 'aeo';
  Substitutions: string = '^/x&u~/ux&w/ux';
  ConfigurationName: string = '';
  NoAlign: boolean = False;
  NoComplex: boolean = False;
  ProgramIniFile: string = 'subliniow.ini';
  UnknownWordsLog: string = 'nekonata.log';
  LogUnknownWords: boolean = False;
  Debug: boolean = False;
  AddEmptyLine: boolean = True;
  IntellectualSubst: boolean = True;
  NoBreakLines: boolean = False;
  ToTAF9: boolean = False;
  FileNames: integer = 0;
  FileNamesFirstItemN: integer = 0;
{---}
  KnownWords: longint = 0;
  UnknownWords: longint = 0;
  DiffUnknownWords: longint = 0;
  AllWords: longint = 0;
{---}
  ShowUnknownWords: boolean = True;
  RestorePosition: boolean = True;
  Confirmations: boolean = True;
  OpenReadOnly: boolean = True;
  ShowUnknown: boolean = True;

Type
  TMsg = record
    Name, Txt: PChar;
    Translated: boolean;
  end;
  TMsgs = array[1..MaxMsgsQ] of TMsg;
  TConfiguration = record
    ProgramIniFile: string;
  end;

function OpenFile( Var f: text; fn: string ): integer;
function CreateFile( Var f: text; fn: string ): integer;
function SizeOfFile( fn: string): longint;
Procedure OpenFileOrHalt( Var f: text; fn: string );
procedure Error( s: string );
procedure Warning( s: string );
procedure GetMsgs( fn: string );
Function M( s: string ): PChar;
Procedure AddMsg( s1, s2: string );
procedure CheckMsgs;
function AllMsgTranslated: integer;
procedure WriteMsgs( fn: string );
procedure WinFromDos( Var s: string );
Procedure InitProgress;
Procedure ShowProgress( i, n: longint );
Procedure DoneProgress;
procedure ShowTwoLines( s1, s2: string );
function GetTextSize: integer;
function EndOfText: boolean;
procedure GetNextLine( Var s: string );
function GetFilePath( const Value: string ): string;
function GetFileName( const Value: string ): string;
function ShortFileName( s: string ): string;
function MyMessageBox(const Text, Caption: PChar; Flags: Longint): Integer;

Var
  Msgs: TMsgs;
  MsgsQ: integer;
  MsgFileExists: boolean;
  DictWordsQ, PrefixesQ, SuffixesQ, AffixesQ: integer;
  OldProgressFrac, ProgressFrac: integer;
  MFStatusbar: TStatusbar;
  MFRichedit: TRichEdit;
  FileLines: TStrings;
  CurrLineN: integer;
  WorkingDir: string;
  ToTranslateAffixes: boolean;
  WereErrors: boolean;

implementation

uses
  Windows, Forms, SysUtils, Graphics, Dblogdlg, MyMB;
//  Messages, Graphics, Controls, Dialogs,
//  Menus, StdCtrls, Clipbrd, slKernel, ExtCtrls, ToolWin, Buttons;

function OpenFile( Var f: text; fn: string ): integer;
begin
  if FileExists( fn ) then
  begin
    Reset( f, fn );
    Result := 0;
  end else
    Result := -1;
end;

function CreateFile( Var f: text; fn: string ): integer;
begin
  Rewrite( f, fn );
  Result := 0;
end;

function SizeOfFile( fn: string): longint;
Var
  f: text;
begin
  Assign( f, fn );
  Result := FileSize( f );
end;

Procedure OpenFileOrHalt( Var f: text; fn: string );
begin
{$IFNDEF E3}
  if OpenFile( f, fn ) <> 0 then
{$ENDIF}
    Error( M('mOpn')+' "'+fn+'"' );
end; { OpenFileOrHalt }

procedure Error( s: string );
begin
  if not WereErrors then
  begin
    {Application.}MyMessageBox( PChar(s), M('mErr'), MB_OK or MB_ICONERROR );
    WereErrors := True;
    Application.Terminate;
  end;
//  Application.Terminate; // does not work imediatly !?
//  Application.MainForm.Close;  // ?!
end;

Procedure Warning( s: string );
begin
  {Application.}MyMessageBox( PChar(s), M('mWrn'), MB_OK or MB_ICONWARNING );
end; { Warning }

Function M( s: string ): PChar;
Var
  i: integer;
begin
  for i := 1 to MsgsQ do
  begin
    if StrPas(Msgs[i].Name) = UpperCase(s) then
    begin
      M := Msgs[i].Txt;
      Exit;
    end;
  end;
  M := '???';
end;

Function FindMsg( s: string ): integer;
Var
  i: integer;
begin
  for i := 1 to MsgsQ do
  begin
    if StrPas(Msgs[i].Name) = UpperCase(s) then
    begin
      FindMsg := i;
      Exit;
    end;
  end;
  FindMsg := 0;
end;

Procedure AddMsg( s1, s2: string );
begin
  if MsgsQ >= MaxMsgsQ then
    Warning( 'Too many messages' );;
  Inc( MsgsQ );
  with Msgs[MsgsQ] do
  begin
    GetMem( Name, Length(s1)+1 );
    GetMem( Txt, Length(s2)+1 );
    StrPCopy( Name, UpperCase(s1) );
    StrPCopy( Txt, s2 );
    Translated := True;
  end;
end;

Procedure ReplaceMsg( s1, s2: string );
Var
  i: integer;
begin
  i := FindMsg(s1);
  if i<>0 then
  with Msgs[i] do
  begin
    FreeMem( Txt, Length(Txt^)+1 );
    GetMem( Txt, Length(s2)+1 );
    StrPCopy( Txt, s2 );
    Translated := True;
  end else
    Msgs[i].Translated := False;
end;

Procedure SetAllMsgNotTranslated;
Var
  i: integer;
begin
  for i := 1 to MsgsQ do
    Msgs[i].Translated := False;
end;

Function AllMsgTranslated: integer;
Var
  i: integer;
begin
  for i := 1 to MsgsQ do
    if not Msgs[i].Translated then
    begin
      Result := i;
      Exit;
    end;
  Result := 0;
end;

Procedure ReadMsgs( fn: string );
Var
  f: text;
  p: integer;
  s: string;
begin
  if not FileExists( fn ) then
  begin
    Warning( Format( M('mNolang'), [fn]) );
    MsgFileExists := False;
    Exit;
  end;
  MsgFileExists := True;
  OpenFile( f, fn );
  while not Eof(f) do
  begin
    ReadLn( f, s );
    p := Pos( '=', s );
    if p<>0 then
      ReplaceMsg( Copy( s, 1, p-1 ), Copy(s, p+1, Length(s)-p ) );
  end;
  Close( f );
end;

procedure GetMsgs( fn: string );
begin
  SetAllMsgNotTranslated;
  ReadMsgs( fn );
end;

procedure CheckMsgs;
{$IFNDEF NoMsg}
Var
  i: integer;
begin
  i := AllMsgTranslated;
  if i<>0 then
    Warning( Format(M('mNotTrMsg'), [Msgs[i].Name]) );
end;
{$ELSE}
begin
end;
{$ENDIF}

Procedure WriteMsgs( fn: string );
Var
  i: integer;
  f: text;
  c: string[1];
begin
  CreateFile( f, fn );
  for i := 1 to MsgsQ do
    with Msgs[i] do
    begin
      if Translated or (Txt[1]='*') then
        c := ''
      else
        c := '*';
      WriteLn( f,  Name, '=', c, Txt );
    end;
  Close( f );
end;

procedure WinFromDos( Var s: string );
Var
  i: integer;
  p: byte;
begin
  for i := 1 to Length(s) do
  begin
    p := Ord(s[i]);
    if (p>=$80) and (p<=$AF) then
      p := p + $40
    else if (p>=$E0) and (p<=$EF) then
      p := p + $10
    else if (p=$F0) then
      p := $A8
    else if (p=$F1) then
      p := $B8;
    s[i] := Char(p);
  end
end;

Procedure InitProgress;
begin
  OldProgressFrac := -1;
end; { InitProgress }

Procedure ShowProgress( i, n: longint );
begin
  with MFStatusBar do
  begin
    ProgressFrac := i*100 div n;
    if ProgressFrac-OldProgressFrac>=ProgressStep then
    begin
      Repaint;
      OldProgressFrac := ProgressFrac;
    end;
  end;
end; { ShowProgress }

Procedure DoneProgress;
begin
  ProgressFrac := 0;
  MFStatusBar.Repaint;
end; { DoneProgress }

procedure ShowTwoLines( s1, s2: string );
begin
  with MFRichEdit do
  begin
    SelAttributes.Color := clBlack;
    Lines.Add( s1 );
    SelAttributes.Color := clRed;
    Lines.Add( s2 );
  end;
end;

function GetTextSize: integer;
begin
  Result := Length(FileLines.Text);
end;

function EndOfText: boolean;
begin
  Result := CurrLineN >= FileLines.Count;
end;

procedure GetNextLine( Var s: string );
begin
  s := FileLines[CurrLineN];
end;

Function GetFilePath( const Value: string ): string;
Var
  p: integer;
begin
  for p := Length(Value) downto 1 do
    if Value[p]='\' then
      Break;
  Result := Copy( Value, 1, p-1 );
//  if Result = '' then
//    Result := WorkingDir;
end;

Function GetFileName( const Value: string ): string;
Var
  p: integer;
begin
  for p := Length(Value) downto 1 do
    if Value[p]='\' then
      Break;
  Result := Copy( Value, p+1, Length(Value)-p );
end;

function ShortFileName( s: string ): string;
Var
  sp: string;
begin
  sp := GetFilePath( s );
  if UpperCase( sp ) <> UpperCase( WorkingDir ) then
    Result := s
  else
    Result := GetFileName( s );
end;

function MyMessageBox(const Text, Caption: PChar; Flags: Longint): Integer;

Const
  MB_ICONS = MB_ICONERROR or MB_ICONQUESTION  or MB_ICONINFORMATION;

Var
  s: string;
  NewWidth, NewHeight, IconHeight: integer;
  q, q2, n: integer;
  IName: string;

procedure DivideStr( Var s: string );
Var
  i, k1, k2: integer;
  b: boolean;
begin
   if Length(s)<=80 then
     Exit;
   k1 := 1;
   k2 := 80;
   repeat
     b := False;
     for i := k2 downto 1 do
       if (s[i]=' ') or (s[i]=#13) then
       begin
         b := True;
         if s[i]=' ' then
           s[i] := #13;
         k1 := i+1;
         Break;
       end;
     if not b then
     begin
       s := Copy(s,1,k2) + #13 + Copy(s,k2+1,Length(s)-k2);
       k1 := k2+2;
     end;
     k2 := k1 + 79;
   until k2>Length(s);
end;

function LinesQ( s: string ): integer;
Var
  i: integer;
begin
  Result := 1;
  for i := 1 to Length(s) do
    if s[i]=#13 then
      Result := Result + 1;
end;

function IsFlag( f: integer ): boolean;
begin
  Result := (Flags and f ) = f;
end;

begin
  s := Text;
  DivideStr( s );
  MyMsgBox.Caption := Caption;
  MyMsgBox.l.Caption := s;
  MyMsgBox.Flags := Flags;
  if IsFlag(MB_OKCANCEL) then
    n := 2
  else
    n := 1;
  case Flags and MB_ICONS of
    MB_ICONERROR: IName := 'IconError';
    MB_ICONQUESTION: IName := 'IconQuestion';
    MB_ICONWARNING: IName := 'IconWarning';
    MB_ICONINFORMATION: IName := 'IconInformation';
  else
    IName := '';
  end;
  with MyMsgBox do
  begin
    q := Abs(l.Font.Height);
    q2 := q div 2;
    Icon.Top := q2;
    Icon.Left := q2;
    if IName<>'' then
    begin
      IconHeight := Icon.Height;
      l.Left := q + Icon.Width;
      l.Top := Icon.Height div 2;
    end else begin
      IconHeight := 0;
      l.Left := q;
      l.Top := q2;
    end;
    Width := q+n*(b1.Width+q);
    NewWidth := l.Left+l.Width+q;
    if NewWidth>Width then
      ClientWidth := NewWidth;
    ClientHeight := l.Top + LinesQ(s)*q + q + b1.Height + q2;
    NewHeight := Icon.Top + IconHeight + q + b1.Height + q2;
    if NewHeight>ClientHeight then
      ClientHeight := NewHeight;
    b1.Left := (Width - n*b1.Width - q) div 2;
    b2.Left := b1.Left + b1.Width + q;
    b1.Top := ClientHeight - b1.Height-q2;
    b2.Top := ClientHeight - b2.Height-q2;
    b1.Caption := M('mOK');
    b2.Caption := M('mCancel');
    if n=1 then
      b2.Hide
    else begin
      b2.Show;
      if IsFlag(MB_DEFBUTTON2) then
        DefButton := 2
      else
        DefButton := 1;
    end;
    if IName<>'' then
      Icon.Picture.Bitmap.LoadFromResourceName( HInstance, IName )
    else
      Icon.Picture.Bitmap := nil;
  end;
  Result := MyMsgBox.ShowModal;
end;

end.
