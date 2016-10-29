unit Find;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFindForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    lFind: TLabel;
    FindText: TComboBox;
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FindForm: TFindForm;
  StringToFind: string;

implementation

uses
  mCommon;

const
  MaxListQ = 9;

{$R *.DFM}

procedure TFindForm.bOKClick(Sender: TObject);
begin
  with FindText do
  begin
    StringToFind := Text;
    if Items.IndexOf(Text)<0 then
    begin
      if  Items.Count=MaxListQ then
        Items.Delete( MaxListQ-1 );
      Items.Insert(0,Text);
    end;
  end;
  ModalResult := mrOK;
end;

procedure TFindForm.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFindForm.FormShow(Sender: TObject);
begin
  Caption := M('cFind');
  lFind.Caption := M('cFindString') + ':';
  bOK.Caption := M('cOK');
  bCancel.Caption := M('cCancel');
end;

end.
