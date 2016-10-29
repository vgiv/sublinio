unit MyMB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TMyMsgBox = class(TForm)
    b1: TButton;
    b2: TButton;
    l: TLabel;
    Icon: TImage;
    procedure b1Click(Sender: TObject);
    procedure b2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Flags: longint;
    DefButton: integer;
  end;

var
  MyMsgBox: TMyMsgBox;

implementation

{$R *.DFM}

procedure TMyMsgBox.b1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TMyMsgBox.b2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMyMsgBox.FormShow(Sender: TObject);
begin
  if DefButton=2 then
  begin
    b2.SetFocus;
    b2.Cancel := True;
  end else begin
    b1.SetFocus;
    b1.Cancel := True;
  end;
end;

end.
