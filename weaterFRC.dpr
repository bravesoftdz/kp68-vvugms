program weaterFRC;

uses
  Forms,
  main in 'main.pas' {Form1},
  classTFrc in 'classTFrc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
