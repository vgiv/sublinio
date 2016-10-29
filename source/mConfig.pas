unit mConfig;

{$I defs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Tabnotbk, mCommon, ExtCtrls;

type
  TConfigForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    pcConfig: TPageControl;
    tsTranslation: TTabSheet;
    tsInterface: TTabSheet;
    bRestore: TButton;
    cbAlign: TCheckBox;
    lLangFile: TLabel;
    eLangFile: TEdit;
    bLangFile: TButton;
    FilesDialog: TOpenDialog;
    cbComplex: TCheckBox;
    cbLogUW: TCheckBox;
    cbDebug: TCheckBox;
    cbBL: TCheckBox;
    cbIntSub: TCheckBox;
    cbTAF9: TCheckBox;
    tsFiles: TTabSheet;
    cbConfirm: TCheckBox;
    cbRestorePosition: TCheckBox;
    cbOpenRO: TCheckBox;
    lExtDic: TLabel;
    eExtDic: TEdit;
    bExtDic: TButton;
    lConfFile: TLabel;
    eConfFile: TEdit;
    lMainDic: TLabel;
    eMainDic: TEdit;
    bMainDic: TButton;
    lPrefDic: TLabel;
    ePrefDic: TEdit;
    bPrefDic: TButton;
    lSuffDic: TLabel;
    eSuffDic: TEdit;
    bSuffDic: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    eConfName: TEdit;
    lConfName: TLabel;
    eMarkStr: TEdit;
    lMarkStr: TLabel;
    cbShowUnknown: TCheckBox;
    eUW: TEdit;
    bUW: TButton;
    lUW: TLabel;
    lSubst: TLabel;
    eSubst: TEdit;
    procedure FormShow(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bRestoreClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bLangFileClick(Sender: TObject);
    procedure bExtDicClick(Sender: TObject);
    procedure bMainDicClick(Sender: TObject);
    procedure bPrefDicClick(Sender: TObject);
    procedure bSuffDicClick(Sender: TObject);
    procedure cbLogUWClick(Sender: TObject);
    procedure bUWClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    procedure CToForm;
    procedure CFromForm;
  public
    { Public declarations }
  end;

Var
  ConfigForm: TConfigForm;
  LangChanged: boolean;
  DictChanged: boolean;

implementation

{$R *.DFM}

procedure TConfigForm.CToForm;
begin
  eConfFile.Text := ShortFileName(ProgramIniFile);
  eConfName.Text := ConfigurationName;
  eMainDic.Text := ShortFileName(DictName);
  ePrefDic.Text := ShortFileName(PrefixesName);
  eSuffDic.Text := ShortFileName(SuffixesName);
  eLangFile.Text := ShortFileName(LangFileName);
  eExtDic.Text := ShortFileName(DictionaryProgram);
  eUW.Text := ShortFileName(UnknownWordsLog);
  cbAlign.Checked := not NoAlign;
  cbComplex.Checked := not NoComplex;
  cbLogUW.Checked := LogUnknownWords;
  cbShowUnknown.Enabled := cbLogUW.Checked;
  cbDebug.Checked := Debug;
  cbBL.Checked := not NoBreakLines;
  cbIntSub.Checked := IntellectualSubst;
  eMarkStr.Text := MarkStr;
  cbTAF9.Checked := ToTAF9;
  cbConfirm.Checked := Confirmations;
  cbRestorePosition.Checked := RestorePosition;
  cbOpenRO.Checked := OpenReadOnly;
  cbShowUnknown.Checked := ShowUnknown;
  eSubst.Text := Substitutions;
end;

procedure TConfigForm.CFromForm;
begin
  ConfigurationName := eConfName.Text;
  DictName := ShortFileName(eMainDic.Text);
  PrefixesName := ShortFileName(ePrefDic.Text);
  SuffixesName := ShortFileName(eSuffDic.Text);
  LangFileName := ShortFileName(eLangFile.Text);
  DictionaryProgram := ShortFileName(eExtDic.Text);
  UnknownWordsLog := ShortFileName(eUW.Text);
  NoAlign := not cbAlign.Checked;
  NoComplex := not cbComplex.Checked;
  LogUnknownWords := cbLogUW.Checked;
  Debug := cbDebug.Checked;
  NoBreakLines := not cbBL.Checked;
  IntellectualSubst := cbIntSub.Checked;
  MarkStr := eMarkStr.Text;
  ToTAF9 := cbTAF9.Checked;
  Confirmations := cbConfirm.Checked;
  RestorePosition := cbRestorePosition.Checked;
  OpenReadOnly := cbOpenRO.Checked;
  ShowUnknown := cbShowUnknown.Checked;
  Substitutions := LowerCase(eSubst.Text);
end;

procedure TConfigForm.FormShow(Sender: TObject);
begin
  Caption := M('cConfig');
  CToForm;
  bCancel.SetFocus;
  cbAlign.Caption := M('cAlign');
  cbComplex.Caption := M('cComplex');
  cbLogUW.Caption := M('cUnknown');
  cbDebug.Caption := M('cDebug');
  lMarkStr.Caption := M('cMarkStr') + ':';
  eMarkStr.Left := lMarkStr.Left + lMarkStr.Width + 3;
  cbBL.Caption := M('cBreakLines')+':';
  cbIntSub.Caption := M('cIntellectualSubst');
  cbRestorePosition.Caption := M('cRestorePosition');
  cbTAF9.Caption := M('cTranslateAffixes');
  cbConfirm.Caption := M('cConfirmations');
  cbOpenRO.Caption := M('cOpenReadOnly');
  cbShowUnknown.Caption := M('cShowUnknown');
  lLangFile.Caption := M('cLangFile')+':';
  lExtDic.Caption := M('cDictionaryFile')+':';
  lConfFile.Caption := M('cConfFile')+':';
  lConfName.Caption := M('cConfName')+':';
  bOK.Caption := M('cOK');
  bCancel.Caption := M('cCancel');
  bRestore.Caption := M('cRestore');
  tsTranslation.Caption := M('cTranslation');
  tsInterface.Caption := M('cInterface');
  tsFiles.Caption := M('cFiles');
  lMainDic.Caption := M('cMainDic')+':';
  lPrefDic.Caption := M('cPrefDic')+':';
  lSuffDic.Caption := M('cSuffDic')+':';
  lSubst.Caption := M('cSubst')+':';
  eSubst.Left := lSubst.Left + lSubst.Width + 3;
  eSubst.Width := tsTranslation.Width - lSubst.Width - 6;
  lUW.Caption := M('cUW')+':';
end;

procedure TConfigForm.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConfigForm.bRestoreClick(Sender: TObject);
begin
  CToForm;
end;

procedure TConfigForm.bOKClick(Sender: TObject);
begin
  LangChanged := UpperCase(LangFileName) <> UpperCase( ShortFileName(eLangFile.Text) );
  DictChanged :=
  ( UpperCase(DictName) <> UpperCase( ShortFileName(eMainDic.Text) ) )
  or
  ( UpperCase(PrefixesName) <> UpperCase( ShortFileName(ePrefDic.Text) ) )
  or
  ( UpperCase(SuffixesName) <> UpperCase( ShortFileName(eSuffDic.Text) ) );
  CFromForm;
  ModalResult := mrOK;
end;

procedure TConfigForm.bLangFileClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( eLangFile.Text );
    Filter := '*.lng|*.lng';
    if Execute then
      eLangFile.Text := ShortFileName(FileName);
  end;
end;

procedure TConfigForm.bExtDicClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( DictionaryProgram );
    Filter := '*.exe|*.exe';
    if Execute then
      eExtDic.Text := FileName;
    SetCurrentDir( WorkingDir );
  end;
end;

procedure TConfigForm.bMainDicClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( DictName );
    Filter := '*.dic|*.dic';
    if Execute then
      eMainDic.Text := ShortFileName(FileName);
    SetCurrentDir( WorkingDir );
  end;
end;

procedure TConfigForm.bPrefDicClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( PrefixesName );
    Filter := '*.dic|*.dic';
    if Execute then
      ePrefDic.Text := ShortFileName(FileName);
    SetCurrentDir( WorkingDir );
  end;
end;

procedure TConfigForm.bSuffDicClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( SuffixesName );
    Filter := '*.dic|*.dic';
    if Execute then
      eSuffDic.Text := ShortFileName(FileName);
    SetCurrentDir( WorkingDir );
  end;
end;

procedure TConfigForm.cbLogUWClick(Sender: TObject);
begin
  cbShowUnknown.Enabled := cbLogUW.Checked;
end;

procedure TConfigForm.bUWClick(Sender: TObject);
begin
  with FilesDialog do
  begin
    InitialDir := GetFilePath( UnknownWordsLog );
    Filter := '*.log|*.log';
    if Execute then
      eUW.Text := ShortFileName(FileName);
    SetCurrentDir( WorkingDir );
  end;
end;

procedure TConfigForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if Msg.CharCode=VK_F1 then
  begin
    Handled := True;
    Application.HelpJump('Config');
  end;
end;

end.
