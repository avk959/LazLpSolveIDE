unit dlgAbout;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, LCLIntf;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label16: TLabel;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label12: TLabel;
    Label6: TLabel;
    procedure URLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

procedure TAboutForm.URLClick(Sender: TObject);
begin
  OpenUrl(PChar(TLabel(Sender).Caption));
end;

end.
