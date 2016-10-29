{ Sorting functions }
Unit
  mSearch;

{-$DEFINE Debug}

Interface

Type
  PSearcher = ^TSearcher;
  TSearcher = object
    Q: longint;
    Constructor Init( QInit: longint );
    Function GetQ: longint; virtual;
    Function Compare( i: longint; Var P ): integer; virtual;
    Function FindPlace( Var P ): longint;
  end;

Implementation

Constructor TSearcher.Init;
begin
  Q := QInit;
end;

Function TSearcher.GetQ: longint;
begin
  GetQ := Q;
end;

Function TSearcher.Compare( i: longint; Var P ): integer;
begin
  Compare := 0;
end;

Function TSearcher.FindPlace( Var P ): longint;
{ Binary search in ordered array }
Var
  i, i1, i2: longint;
  c: integer;
begin
  Q := GetQ;
  if Q=0 then
  begin
    FindPlace := 1;
    Exit;
  end;
  i1 := 1;
  i2 := Q;
  repeat
    i := i1 + (i2-i1) div 2;
{$IFDEF Debug}
    WriteLn( i1, ' ', i, ' ', i2 );
{$ENDIF}
    if (i1=i) or (i2=i) then
    begin
      if Compare( i2, P ) <= 0 then
        i := i2
      else if Compare( i1, P ) > 0 then
        i := i1-1;
      Break;
    end;
    c := Compare( i, P );
    if c = 0 then
      Break
    else if c > 0 then
      i2 := i
    else
      i1 := i;
  until False;
  FindPlace := i;
end; { TDict.FindPlace }

Begin

End.
