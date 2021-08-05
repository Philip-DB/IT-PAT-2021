program NGOProgram_p;

uses
  Vcl.Forms,
  NGOProgram_u in 'NGOProgram_u.pas' {frmMainProgram},
  Vcl.Themes,
  Vcl.Styles,
  dmHospital_u in 'dmHospital_u.pas' {dmHospital: TDataModule},
  clsMedicine_u in 'clsMedicine_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Auric');
  Application.CreateForm(TfrmMainProgram, frmMainProgram);
  Application.CreateForm(TdmHospital, dmHospital);
  Application.Run;
end.
