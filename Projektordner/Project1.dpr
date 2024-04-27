program Project1;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UField in 'UField.pas',
  UFigur in 'UFigur.pas',
  USpringer in 'USpringer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
