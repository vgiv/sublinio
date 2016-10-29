unit UWW;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TUWWFrame = class(TFrame)
    UWW: TRichEdit;
    UWWBevel: TBevel;
    UWWButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Main;

{$R *.DFM}

end.
