{---------------------------------------------------------------}
{ Ядро программы квазиподстрочного перевода                          }
{---------------------------------------------------------------}

{$I defs.inc}

Unit slKernel;

interface

  procedure InitTranslate;
  procedure BeginTranslate;
  procedure Translate;
  procedure EndTranslate;
  function Alpha( c: char ): boolean;
  function TranslateWord( OrigWord: string ): string;

implementation

Uses
  mSearch, SysUtils, Math, mCommon;

Const
  BufStr1: string = '';
  BufStr2: string = '';
  BufLen: integer = 0;

  WasBadOrder: boolean = False;

  ClosedOrNot: byte = $00;
  NotClosed: byte = $01;
  Closed: byte = $02;

  PrefixType = $01;
  SuffixType = $02;
  AnyWord = $ff;

Type
  POrigWord = ^TOrigWord;
  TOrigWord = string[OrigWordLen];
  TTransWord = string[TransWordLen];
  PWord = ^TWord;
  TWord = record
    Orig: TOrigWord;
    Trans: TTransWord;
    ClosingMode: byte;
  end;

  TDict = object
    WordsQ: word;
    Words: array[1..MaxWordsQ] of PWord;
    Procedure Init;
    Function FindPlace( W: string; WType: byte ): word;
    Procedure AddWord( Wrd: TWord );
    Procedure AddSortWord( Wrd: TWord );
    Procedure CheckWordsOrder;
    Function FindWord( w: string; WordType: byte ): string;
    Function FindComplexWord( w: string; WordType: byte ): string;
    Function FindSimpleOrComplexWord( w: string; WordType: byte ): string;
    Function ParseWordRun( w: string;
      Var Prefix, Suffix: string;
      Var PrefixComment, SuffixComment: string;
      PrefixOrd, SuffixOrd: integer;
      FirstRun: boolean ): string;
    Function ParseWord( w: string;
      Var Prefix, Suffix: string;
      PrefixOrd, SuffixOrd: integer ): string;
    Procedure GetDictFromFile( FileName: string; Unsorted: boolean );
    Procedure GetDict;
  end;

  TAffix = record
    S: string[AffixLen];
    Comment: string[AffixCommentLen];
    ClosingMode: byte;
    AType: byte;
    Ord: integer;
  end;
  TAffixes = array[1..MaxAffixQ] of TAffix;

  PDictSearcher = ^TDictSearcher;
  TDictSearcher = object(TSearcher)
    Function GetQ: longint; virtual;
    Function Compare( i: longint; Var P ): integer; virtual;
  end;

  PUnkWords = ^TUnkWords;
  TUnkWords = object
    Q: integer;
    W: array[1..MaxUnkWordsQ] of POrigWord;
    Constructor Init;
    Procedure PutWord( s: string );
    Procedure OutWords;
  end;

  PUnkSearcher = ^TUnkSearcher;
  TUnkSearcher = object(TSearcher)
    Function GetQ: longint; virtual;
    Function Compare( i: longint; Var P ): integer; virtual;
  end;

Var
  f1, fu, fdebug: text;
  Dict: TDict;
  WLen: word;
  Affixes: TAffixes;
  SubstQ: integer;
  Subst: array[1..MaxSubstQ] of record
    Str1, Str2: string[MaxSubstLen]
  end;
  DictSearcher: PDictSearcher;
  UnkSearcher: PUnkSearcher;
  UnkWords: PUnkWords;
  DebugIndent: string[1];
  WasFinalSuffixes: boolean;

Function StrEnd( s: string; l: integer ): string;
{ Extract last l bytes from the string }
begin
  StrEnd := Copy( s, Length(s)-l+1, l )
end; { StrEnd }

Procedure DelEnd( Var s: string; l: integer );
{ Delete last l bytes from the string }
begin
  Delete( s, Length(s)-l+1, l )
end; { StrEnd }

Function Alpha( c: char ): boolean;
{ Is c symbol of latin alphabet }
begin
  Alpha :=
    ( c in ['A'..'Z'] )
    or
    ( c in ['a'..'z'] )
    or
    ( c = '^' )
    or
    ( c = '~' )
    or
    ( c = '''' )
    ;
end; { Alpha }

Function CyrAlpha( c: char ): boolean;
{ Is c symbol of cyrilic alphabet }
begin
  CyrAlpha :=
    ( c in ['А'..'п'] )
    or
    ( c in ['р'..'я'] )
    or
    ( Pos( c, ',-_.' ) <> 0 );
{
    ( c = ',' )
    or
    ( c = '-' )
    or
    ( c = '_' )
    or
    ( c = '.' )
    ;
}
end; { CyrAlpha }

Function CyrWord( w: string ): boolean;
Var
  i: word;
begin
  for i := 1 to Length(w) do
    if not CyrAlpha( w[i] ) then
    begin
      CyrWord := False;
      Exit;
    end;
  CyrWord := True;
end; { CyrWord }

Function NoAlphaStr( s: string ): boolean;
Var
  i: integer;
begin
  for i := 1 to Length(s) do
    if Alpha( s[i] ) then
    begin
      NoAlphaStr := False;
      Exit;
    end;
  NoAlphaStr := True;
end; { NoAlphaStr }

Function Numeric( s: string ): boolean;
Var
  i: integer;
begin
  for i := 1 to Length(s) do
    if not (s[i] in ['0'..'9']) then
    begin
      Numeric := False;
      Exit;
    end;
  Numeric := True;
end; { Numeric }

Function IsWinTab( fn: string ): boolean;
Var
  f: text;
  s: string;
  R: boolean;
begin
  OpenFileOrHalt( f, fn );
  ReadLn( f, s );
  R := (Length(s)>=2) and (Copy(s,1,2)='#!');
{$IFNDEF W1}
  if not R then
{$ENDIF}  
    Warning( M('mGost') + ' "' + fn + '". ' + M('mFromGost') );
  IsWinTab := R;
  Close( f );
end;

procedure Encode( Var s: string; FromWin: boolean );
begin
  if not FromWin then
    WinFromDos( s );
end;

Function PosFirst( s1, s2: string ): byte;
Var
  i, p, pp: byte;
begin
  p := 0;
  for i := 1 to Length(s1) do
  begin
    pp := Pos( s1[i], s2 );
    if (pp<>0) and ( (p=0) or (pp<p) ) then
      p := pp;
  end;
  PosFirst := p;
end; { PosFirst }

Procedure NextWord( Var s, PreWord, w: string );
begin
  PreWord := '';
  w := '';
  while (s<>'') and not Alpha(s[1]) do
  begin
    PreWord := PreWord + s[1];
    Delete( s, 1, 1 );
  end;
  while (s<>'') and Alpha(s[1]) do
  begin
    w := w + s[1];
    Delete( s, 1, 1 );
  end;
end; { NextWord }

Function ToRight( s: string; l: integer ): string;
Var
  i: integer;
begin
  if l<Length(s) then
  begin
    s := '*';
    for i := 1 to l do
      s := s + '*';
  end else
    for i := Length(s)+1 to l do
      s := s + ' ';
  ToRight := s;
end; { ToRight }

Procedure ReplaceAll( Var s: string; s1, s2: string; Wise: boolean );
Var
  p, q: integer;
begin
  q := 1;
  repeat
    p := Pos( s1, Copy( s, q, Length(s)-q+1 ) ) + q - 1;
    if 
      (p <> q-1) 
      and 
      not ( Wise and ( p+Length(s2)-1<=Length(s) ) and ( Copy(s,p,Length(s2))=s2 ) )
    then
    begin
      Delete( s, p, Length(s1) );
      Insert( s2, s, p );
      q := p + Length(s2);
    end else
      Break;
  until False;
end; { ReplaceAll }

Procedure MakeSubst( Var s: string );
Var
  i: integer;
  olds: string;
begin
  olds := s;
  for i := 1 to SubstQ do
    ReplaceAll( s, Subst[i].Str1, Subst[i].Str2, IntellectualSubst );
  if Debug and (olds<>s) then
    WriteLn( fdebug, olds, ' -> ', s );
end; { MakeSubst }

Procedure PushBuf;
begin
  ShowTwoLines( BufStr1, BufStr2 );
  BufStr1 := '';
  BufStr2 := '';
  BufLen := 0;
end; { PushBuf }

Procedure PutBuf( s1, s2: string );
begin
  if not NoBreakLines and (BufLen + Length(s1) >= 80) and not NoAlign then
    PushBuf;
  BufStr1 := BufStr1 + s1;
  BufStr2 := BufStr2 + s2;
  BufLen := BufLen + Length(s1);
end; { PutBuf }

Function CompareWords( w1, w2: TWord ): integer;
begin
  if w1.Orig < w2.Orig then
    CompareWords := -1
  else if w1.Orig > w2.Orig then
    CompareWords := 1
  else if ( (w1.ClosingMode and w2.ClosingMode) = 0 ) then
  begin
    if (w1.ClosingMode < w2.ClosingMode) then
      CompareWords := -1
    else if w1.ClosingMode > w2.ClosingMode then
      CompareWords := 1
    else
      CompareWords := 0;
  end else
    CompareWords := 0;
end; { CompareWords }

Function DeleteAffix( w: string; i: word; Var w2, Affix, AffixComment: string;
  Var AffixOrd: integer; OldPrefixOrd, OldSuffixOrd: integer;
  Var AffixType: byte; IsFinalSuffix: boolean ): boolean;
Var
  Deleted: boolean;
begin
  w2 := w;
  Affix := '';
  AffixComment := '';
  Deleted := False;
  AffixType := Affixes[i].AType;
  if AffixType = SuffixType then
  begin
    if
      ( Copy( w2, Length(w2)-Length(Affixes[i].S)+1, Length(Affixes[i].S) ) = Affixes[i].S )
      and
      ( Affixes[i].Ord >= OldSuffixOrd )
      and ( 
        ( Affixes[i].ClosingMode = ClosedOrNot )
        or
        ( (Affixes[i].ClosingMode = Closed) and  IsFinalSuffix )
        or
        ( (Affixes[i].ClosingMode = NotClosed) and not IsFinalSuffix )
      )
    then
    begin
      Delete( w2, Length(w2)-Length(Affixes[i].S)+1, Length(Affixes[i].S) );
      Deleted := True
    end
  end else begin
    if
      ( Copy( w2, 1, Length(Affixes[i].S) ) = Affixes[i].S )
      and
      ( Affixes[i].Ord >= OldPrefixOrd )
    then
    begin
      Delete( w2, 1, Length(Affixes[i].S) );
      Deleted := True;
    end;
  end;
  if Deleted then
  begin
    Affix := Affixes[i].S;
    if Affixes[i].Comment <>'' then
      AffixComment := Affixes[i].Comment
    else
      AffixComment := Affix;
    AffixOrd := Affixes[i].Ord;
  end;
  DeleteAffix := Deleted;
end; { DeleteAffix }

Procedure TDict.Init;
Var
  i: word;
begin
  for i := 1 to MaxWordsQ do
    Words[i] := nil;
end; { TDict.Init }

Function TDict.FindPlace( W: string; WType: byte ): word;
Var
  Wrd: TWord;
begin
  Wrd.Orig := W;
  Wrd.ClosingMode := WType;
  FindPlace := DictSearcher^.FindPlace( Wrd );
end; { TDict.FindPlace }

Procedure TDict.AddSortWord( Wrd: TWord );
Var
  i, j: integer;
  NewWordP: PWord;
begin
{  if WordsQ >= MaxWordsQ then
    Error( M('mLng') );}
  i := FindPlace( Wrd.Orig, Wrd.ClosingMode );
  AddWord( Wrd );
  NewWordP := Words[WordsQ];
  for j := WordsQ downto i+2 do
    Words[j] := Words[j-1];
  if (i>0) and (WordsQ<>1) then
    Words[i+1] := NewWordP
  else
    Words[1] := NewWordP;
end; { TDict.AddSortWord }

Procedure TDict.AddWord( Wrd: TWord );
begin
{$IFNDEF E1}
  if WordsQ >= MaxWordsQ then
{$ENDIF}
    Error( M('mLng') );
  Inc( WordsQ );
  New( Words[WordsQ] );
  Words[WordsQ]^ := Wrd;
end; { TDict.AddWord }

Procedure TDict.CheckWordsOrder;
begin
{$IFNDEF W2}
  if (WordsQ>1) and (CompareWords( Words[WordsQ-1]^, Words[WordsQ]^ ) > 0) then
    if not WasBadOrder then
{$ELSE}
  if not WasBadOrder and ( WordsQ>1 ) then
{$ENDIF}
    begin
      Warning( Format( M('mAlp'), [DictName,Words[WordsQ-1]^.Orig]) );
      WasBadOrder := True;
    end;
end; { TDict.CheckWordsOrder }

Function TDict.FindWord( w: string; WordType: byte ): string;
Var
  i: word;
  Wrd: TWord;
begin
  Wrd.Orig := w;
  Wrd.ClosingMode := WordType;
  i := FindPlace( w, WordType );
  if (i>0) and (CompareWords( Words[i]^, Wrd ) = 0) then
    FindWord :=  Words[i]^.Trans
  else
    FindWord := '';
end;

Function TDict.FindComplexWord( w: string; WordType: byte ): string;
Var
  p: byte;
  i, i0: integer;
  ww, fw: string;
begin
  i0 := FindPlace( w[1], AnyWord );
  if i0=0 then
    Inc(i0)
  else if (i0>1) and (Words[i0]^.Orig[1]=w[1]) then
    Dec(i0);
  for i := i0 to Dict.WordsQ do
  begin
    if Words[i]^.Orig[1] > w[1] then
      Break;
    p := Pos( Words[i]^.Orig, w );
    if p=1 then
    begin
      ww := w;
      Delete( ww, 1, Length(Words[i]^.Orig) );
      fw := FindWord( ww, WordType );
      if (fw = '') and (ww<>'') and ( Pos(ww[1],Separators) <> 0 ) then
      begin
        Delete( ww, 1, 1 );
        fw := FindWord( ww, WordType );
      end;
      if fw<>'' then
      begin
        FindComplexWord := Words[i]^.Trans + '~' + fw;
        Break;
      end;
    end;
  end;
end; { TDict.FindComplexWord }

Function TDict.FindSimpleOrComplexWord( w: string; WordType: byte ): string;
Var
  fw: string;
begin
  fw := FindWord( w, WordType );
  if (fw='') and not NoComplex then
    fw := FindComplexWord( w, WordType );
  FindSimpleOrComplexWord := fw;
end; { TDict.FindSimpleOrComplexWord }

Function TDict.ParseWordRun( w: string;
  Var Prefix, Suffix: string;
  Var PrefixComment, SuffixComment: string;
  PrefixOrd, SuffixOrd: integer;
  FirstRun: boolean ): string;
Var
  i: integer;
  fw, w2, Affix2, Prefix2, Suffix2, Affix2Comment: string;
  Affix2Ord, Prefix2Ord, Suffix2Ord: integer;
  AffixType: byte;
  WordType: byte;
  fr: string[1];
  Prefix2Comment, Suffix2Comment: string;
begin

  if FirstRun then
    fr := ''
  else
    fr := '~';

  if Debug then
  begin
    WriteLn( fdebug, DebugIndent, fr + Prefix + w + Suffix );
    DebugIndent := ' ';
  end;

  if (Prefix='') and (Suffix='') then
    WordType := Closed
  else
    WordType := NotClosed;

  if FirstRun then
    fw := FindWord( w, WordType )
  else
    fw := FindSimpleOrComplexWord( w, WordType );

  if (fw<>'') and Debug then
    WriteLn( fdebug, DebugIndent, Prefix + '[' + fw + ']' + Suffix );

  if fw='' then
  begin
    for i := 1 to AffixesQ do
    begin
      if
        DeleteAffix( w, i, w2, Affix2, Affix2Comment, Affix2Ord, PrefixOrd, SuffixOrd, AffixType, Suffix='' )
        and (w2<>'')
      then
      begin
        if AffixType = SuffixType then
        begin
          Prefix2 := '';
          Prefix2Comment := '';
          Suffix2 := Affix2;
          Suffix2Comment := Affix2Comment;
          Prefix2Ord := PrefixOrd;
          Suffix2Ord := Affix2Ord;
        end else
        begin
          Suffix2 := '';
          Suffix2Comment := '';
          Prefix2 := Affix2;
          Prefix2Comment := Affix2Comment;
          Prefix2Ord := Affix2Ord;
          Suffix2Ord := SuffixOrd;
        end;
        if FirstRun then
          fw := FindWord( w2, NotClosed )
        else
          fw := FindSimpleOrComplexWord( w2, NotClosed );
        if fw<>'' then
        begin
          if Prefix2<>'' then
          begin
            Prefix := Prefix + Prefix2 + '-';
            PrefixComment := PrefixComment + Prefix2Comment + '-';
          end;
          if Suffix2<>'' then
          begin
            Suffix := '-' + Suffix2 + Suffix;
            SuffixComment := '-' + Suffix2Comment + SuffixComment;
          end;
          if Debug then
          begin
            WriteLn( fdebug, DebugIndent, fr + Prefix + w2 + Suffix );
            WriteLn( fdebug, DebugIndent, Prefix + '[' + fw + ']' + Suffix );
          end;
          Break;
        end else begin
          if Prefix2<>'' then
          begin
            Prefix2 := Prefix + Prefix2 + '-';
            Prefix2Comment := PrefixComment + Prefix2Comment + '-';
          end else begin
            Prefix2 := Prefix;
            Prefix2Comment := PrefixComment;
          end;
          if Suffix2<>'' then
          begin
            Suffix2 := '-' + Suffix2 + Suffix;
            Suffix2Comment := '-' + Suffix2Comment + SuffixComment;
          end else
          begin
            Suffix2 := Suffix;
            Suffix2Comment := SuffixComment;
          end;
          fw := ParseWordRun( w2, Prefix2, Suffix2,
            Prefix2Comment, Suffix2Comment, Prefix2Ord, Suffix2Ord, FirstRun );
          if fw<>'' then
          begin
            Prefix := Prefix2;
            PrefixComment := Prefix2Comment;
            Suffix := Suffix2;
            SuffixComment := Suffix2Comment;
            Break;
          end;
        end;
      end;
    end;
  end;
  ParseWordRun := fw;
end;

Function TDict.ParseWord( w: string;
  Var Prefix, Suffix: string;
  PrefixOrd, SuffixOrd: integer ): string;
Var
  fw, PrefixComment, SuffixComment: string;
begin
  Prefix := '';
  Suffix := '';
  PrefixComment := '';
  SuffixComment := '';
  DebugIndent := '';
  fw := ParseWordRun( w, Prefix, Suffix, PrefixComment, SuffixComment,
    PrefixOrd, SuffixOrd, True );
  if fw='' then
    fw := ParseWordRun( w, Prefix, Suffix, PrefixComment, SuffixComment,
      PrefixOrd, SuffixOrd, False );
  if ToTranslateAffixes then
  begin
    if PrefixComment<>'' then
      Prefix := '/' + Copy( PrefixComment, 1, Length(PrefixComment)-1) + '/' + '-';
    if SuffixComment<>'' then
      Suffix := '-' + '/' + Copy( SuffixComment, 2, Length(SuffixComment)-1) + '/';
  end;
  ParseWord := fw;
end;

function TranslateWord( OrigWord: string ): string;
Var
  TransWord, Prefix, Suffix: string;
begin
  OrigWord := LowerCase(OrigWord);
  MakeSubst( OrigWord );
  TransWord := Dict.ParseWord( LowerCase(OrigWord), Prefix, Suffix, 0, 0 );
  if TransWord<>'' then
    TranslateWord := Prefix+'[' + TransWord + ']'+Suffix;
end;

Procedure TDict.GetDictFromFile( FileName: string; Unsorted: boolean );
Var
  s, ss, OrigWord, TransWord: string;
  p: integer;
  WordType: byte;
  c: char;
  Wrd: TWord;
  FromWin: boolean;
begin

  FromWin := IsWinTab( FileName );
  OpenFileOrHalt( f1, FileName );

  while not SeekEof(f1) do
  begin
    ReadLn( f1, s );
    Encode( s, FromWin );
    if (s<>'') and (s[1]='#') then
      Continue;
    p := PosFirst( ' '#9, s );
    ss := Copy( s, 1, p-1 );
{$IFNDEF W3}
    if p<>0 then
      if Length(ss) > OrigWordLen then
{$ELSE}
    if WordsQ=1 then
{$ENDIF}
        Warning( Format(M('mTol'), [ss,OrigWordLen]) );
    OrigWord := ss;
    if Pos(  OrigWord[Length(OrigWord)], '.:') <> 0 then
    begin
      c := OrigWord[Length(OrigWord)];
      Delete( OrigWord, Length(OrigWord), 1 );
      case c of
        '.': WordType := Closed;
        ':': WordType := Closed or NotClosed;
      else
        WordType := NotClosed;
      end;
    end else
      WordType := NotClosed;
    Delete( s, 1, p );
    while (s<>'') and ( Pos(s[1],' '#09) <> 0 ) do
      Delete( s, 1, 1 );
    { Отделить комментарий }
    p := Pos( '#', s );
    if p<>0 then
      Delete( s, p, Length(s)-p+1 );
    while (s<>'') and ( Pos( s[Length(s)], ' '#9 )<>0 ) do
      Delete( s, Length(s), 1 );
{$IFNDEF W4}
    if Length(s) > TransWordLen then
{$ELSE}
    if WordsQ=1 then
{$ENDIF}
      Warning( Format( M('mTola'), [ss,TransWordLen] ) );
    TransWord := s;
    with Wrd do
    begin
      Orig := OrigWord;
      Trans := TransWord;
      ClosingMode := WordType;
    end;
    if Unsorted then
      Dict.AddSortWord( Wrd )
    else begin
      Dict.AddWord( Wrd );
      CheckWordsOrder;
    end;
  end;

  Close( f1 );

end; { TDict.GetDictName }

Procedure TDict.GetDict;
begin

  GetDictFromFile( DictName, False );
{
  i := FindPlace( 'ok', 1 );
  if i > 1 then
  WriteLn( Words[i-1]^.Orig, ' ', Words[i-1]^.ClosingMode );
  if i > 0 then
  WriteLn( Words[i]^.Orig, ' ', Words[i]^.ClosingMode );
  WriteLn( Words[i+1]^.Orig, ' ', Words[i+1]^.ClosingMode );
  Halt;
}
  if (AddDictName<>'') and FileExists( AddDictName ) then
    GetDictFromFile( AddDictName, True );

end; { TDict.GetDict }

Function Key( c: char; v: boolean ): string;
Function PM( v: boolean ): char;
begin
  if v then
    PM := '+'
  else
    PM := '-'
end;
begin
  Key := '/'+c+PM(v);
end;


Procedure Translate;
Var
  s, OrigWord, OrigWordSubst, TransWord, PreWord, Prefix, Suffix: string;
  fSize, cfSize: longint;
begin

  KnownWords := 0;
  UnknownWords := 0;
  DiffUnknownWords := 0;
  AllWords := 0;

  fSize := GetTextSize;
  cfSize := 0;
  InitProgress;

  while not EndOfText do
  with Dict do
  begin
    GetNextLine( s );
    Inc( cfSize, Length(s) + 2 );
    ShowProgress( cfSize, fSize );
    repeat
      NextWord( s, PreWord, OrigWord );
      PutBuf( PreWord, PreWord );
      if OrigWord<>'' then
      begin
        OrigWordSubst := LowerCase(OrigWord);
        MakeSubst( OrigWordSubst );
        TransWord := ParseWord( LowerCase(OrigWordSubst), Prefix, Suffix, 0, 0 );
        if TransWord<>'' then
        begin
          TransWord := Prefix+'[' + TransWord + ']'+Suffix;
          Inc( KnownWords );
        end else begin
          TransWord := OrigWord + MarkStr;
          Inc( UnknownWords );
          UnkWords^.PutWord( LowerCase(OrigWordSubst) );
        end;
        Inc( AllWords );
        if not NoAlign then
        begin
          WLen := Max( Length(OrigWord), Length(TransWord) );
          OrigWord := ToRight( OrigWord, WLen );
          TransWord := ToRight( TransWord, WLen );
        end;
        PutBuf( OrigWord, TransWord );
      end
    until s='';
    PushBuf;
    Inc( CurrLineN );
  end;

  DoneProgress;

end; { Translate }

Procedure GetAffixesFromFile( FileName: string; AffixType: byte;
  Var TheseAffixesQ: integer );
Var
  f: text;
  s, cs: string;
  code: integer;
  p, pp: byte;
  FromWin: boolean;
begin
  FromWin := IsWinTab( FileName );
  OpenFileOrHalt( f, FileName );
  TheseAffixesQ := 0;
  while not SeekEof( f ) do
  begin
{$IFNDEF E2}
    if AffixesQ > MaxAffixQ then
{$ENDIF}    
      Error( M('mAff') );
    ReadLn( f, s );
    Encode( s, FromWin );
    { Отделить комментарий }
    p := Pos( '#', s );
    if p<>0 then
    begin
      pp := p+1;
      while ( pp<Length(s) ) and (s[pp]=' ') do
        Inc(pp);
      if s[pp]<> ' ' then
        cs := Copy( s, pp, Length(s)-pp+1 )
      else
        cs := '';
      Delete( s, p, Length(s)-p+1 );
    end;
    while (s<>'') and ( Pos( s[Length(s)], ' '#9 )<>0 ) do
      Delete( s, Length(s), 1 );
    if s='' then
      Continue;
    {}
    Inc( AffixesQ );
    Inc( TheseAffixesQ );
    if Numeric(s[1]) then
    begin
      Val( Copy( s, 1, 1 ), Affixes[AffixesQ].Ord, code );
      Delete( s, 1, 1 );
    end else
      Affixes[AffixesQ].Ord := 0;
    p := Pos( s[Length(s)], '.:' );
    if p<>0 then
    begin
      case p of
         1: Affixes[AffixesQ].ClosingMode := Closed;
         2: Affixes[AffixesQ].ClosingMode := ClosedOrNot;
      end;
      Delete( s, Length(s), 1 );
      if AffixType = SuffixType then
        WasFinalSuffixes := True;
    end else
      Affixes[AffixesQ].ClosingMode := NotClosed;
    Affixes[AffixesQ].S := s;
    Affixes[AffixesQ].Comment := cs;
    Affixes[AffixesQ].AType := AffixType;
  end;

  Close( f );
end; { GetAffixesFromFile }

Procedure CheckOlderVersions;
Var
  i: integer;
begin
{$IFNDEF W5}
  if not WasFinalSuffixes then
{$ENDIF}  
  begin
    Warning ( M('mOlder11') );
    for i := 1 to AffixesQ do
      Affixes[i].ClosingMode := ClosedOrNot;
  end;
end;

Procedure GetAffixes;
begin
  AffixesQ := 0;
  WasFinalSuffixes := False;
  GetAffixesFromFile( SuffixesName, SuffixType, SuffixesQ );
  GetAffixesFromFile( PrefixesName, PrefixType, PrefixesQ );
  CheckOlderVersions;
end; { GetAffixes }

Procedure ParseSubstitutions;
Var
  s, ss, ss1: string;
  p: byte;
begin
  s := Substitutions;
  SubstQ := 0;
  while s <> '' do
  begin
    p := Pos( '&', s );
    if p=0 then
      p := Length(s) + 1;
    ss := Copy( s, 1, p-1 );
    Delete( s, 1, p );
    p := Pos( '/', ss );
    if p=0 then
      p := Length(ss) + 1;
    ss1 := Copy( ss, 1, p-1 );
    Delete( ss, 1, p );
    Inc( SubstQ );
    Subst[SubstQ].Str1 := ss1;
    Subst[SubstQ].Str2 := ss;
    if SubstQ >= MaxSubstQ then
      Break;
  end;
end; { ParseSubstitutions }

Constructor TUnkWords.Init;
begin
  Q :=  0;
end; { InitUnkWords }

Procedure TUnkWords.PutWord( s: string );
Var
  i, j: integer;
  NewW: POrigWord;
begin
  i := UnkSearcher^.FindPlace( s );
  if (Q<>0) and (i<>0) and (W[i]^ = s) then
    Exit;
  if Q >= MaxUnkWordsQ then
  begin
    W[Q]^ := Copy( M('mListCut'), 1, OrigWordLen );
    Exit;
  end;
  Inc( Q );
  New( NewW );
  NewW^ := s;
  for j := Q downto i+2 do
    W[j] := W[j-1];
  if (i>0) and (Q<>1) then
    W[i+1] := NewW
  else
    W[1] := NewW;
  DiffUnknownWords := Q;
end; { TUnkWords.PutWord }

Procedure TUnkWords.OutWords;
Var
  i: integer;
begin
  CreateFile( fu, UnknownWordsLog );
  for i := 1 to Q do
    WriteLn( fu, W[i]^ );
  Close( fu );
end; { TUnkWords.OutWords }

Function TDictSearcher.GetQ: longint;
begin
  GetQ := Dict.WordsQ;
end;

Function TDictSearcher.Compare( i: longint; Var P ): integer;
Var
  W: ^TWord;
begin
  W := @P;
  Compare := CompareWords( Dict.Words[i]^, W^ );
end;

Function TUnkSearcher.GetQ: longint;
begin
  GetQ := UnkWords^.Q;
end;

Function TUnkSearcher.Compare( i: longint; Var P ): integer;
Var
  s: ^string;
begin
  s := @P;
  if UnkWords^.W[i]^ > s^ then
    Compare := 1
  else if UnkWords^.W[i]^ < s^ then
    Compare := -1
  else
    Compare := 0;
end;

Procedure InitSearchers;
begin
  New( DictSearcher, Init(0) );
  New( UnkSearcher, Init(0) );
end; { InitSearchers }

procedure BeginTranslate;
begin
  New( UnkWords, Init );
  if Debug then
    CreateFile( fdebug, DebugName );
end;

procedure InitTranslate;
begin
  ParseSubstitutions;
  InitSearchers;
  Dict.GetDict;
  GetAffixes;
  DictWordsQ := Dict.WordsQ;
end;

procedure EndTranslate;
begin
  if Debug then
    Close( fdebug );
  if LogUnknownWords then
    UnkWords^.OutWords;
end;

Begin

End.


