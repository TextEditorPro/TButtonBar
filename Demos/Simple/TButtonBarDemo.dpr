program TButtonBarDemo;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
