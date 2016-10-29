unit GotoLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGotoLineForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    lGotoLine: TLabel;
    eGoto: TEdit;
    procedure bCancelClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GotoLineForm: TGotoLineForm;
  LineNtogo: integer;

implementation

uses
  mCommon;

{$R *.DFM}

procedure TGotoLineForm.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TGotoLineForm.bOKClick(Sender: TObject);
Var
  code: integer;
begin
  if eGoto.Text='' then
  begin
    ModalResult := mrCancel;
    Exit;
  end;
  Val( eGoto.Text, LineNtogo, code );
  if (code=0) and (LineNtogo>=1) then
    ModalResult := mrOK;
end;

procedure TGotoLineForm.FormShow(Sender: TObject);
begin
  Caption := M('cGotoLine');
  lGotoLine.Caption := M('cLineN')+':';
  bOK.Caption := M('cOK');
  bCancel.Caption := M('cCancel');
  eGoto.SetFocus;
  eGoto.SelectAll;
end;

end.
