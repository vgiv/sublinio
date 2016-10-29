unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Jpeg, ExtCtrls, StdCtrls;

type
  TAboutForm = class(TForm)
    OKButton: TButton;
    AuthorText: TStaticText;
    UrlText: TStaticText;
    EmailText: TStaticText;
    Label1: TLabel;
    VersionText: TStaticText;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Bevel1: TBevel;
    procedure OKButtonClick(Sender: TObject);
    procedure UrlTextClick(Sender: TObject);
    procedure EmailTextClick(Sender: TObject);
    procedure OKButtonKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses slKernel, Main, FMXUtils, mCommon;

{$R *.DFM}

procedure TAboutForm.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TAboutForm.EmailTextClick(Sender: TObject);
begin
  ExecuteFile('mailto:'+EmailText.Caption,'','',SW_NORMAL);
end;

procedure TAboutForm.UrlTextClick(Sender: TObject);
begin
  ExecuteFile(UrlText.Caption,'','',SW_MAXIMIZE);
end;

procedure TAboutForm.OKButtonKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    ModalResult := mrOK;
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  VersionText.Caption := 'v.'+ProgramVer;
  VersionText.Left := (ClientWidth-VersionText.Width) div 2;
  AuthorText.Caption := Format( M('cAuthor'),  [ProgramYear] );
  AuthorText.Left := (ClientWidth-AuthorText.Width) div 2;
  Caption := M('cAbout');
  OKButton.Caption := M('mOK');
end;

end.
