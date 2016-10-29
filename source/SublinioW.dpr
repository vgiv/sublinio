program SublinioW;

{%ToDo 'SublinioW.todo'}

uses
  Forms,
  Main in 'Main.pas' {Form1},
  slKernel in 'slKernel.pas',
  Find in 'Find.pas' {FindForm},
  About in 'About.pas' {AboutForm},
  GotoLine in 'GotoLine.pas' {GotoLineForm},
  UWW in 'UWW.pas' {UWWFrame: TFrame},
  mCommon in 'mCommon.pas',
  mConfig in 'mConfig.pas' {ConfigForm},
  MyMB in 'MyMB.pas' {MyMsgBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMyMsgBox, MyMsgBox);
  Application.CreateForm(TFindForm, FindForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TGotoLineForm, GotoLineForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
