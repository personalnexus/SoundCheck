program SoundCheck;

uses
  Forms,
  MainF in 'MainF.pas' {MainForm},
  Sound in '..\shDelphiUtils\Media\Sound.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
