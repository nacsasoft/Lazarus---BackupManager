program BackupManager;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, laz_synapse, Unit1, gepadatmentes, beallitasok, gepadatvissza
  { you can add units after this };

{$R *.res}

begin
  Application.Title := 'SrcMaBackup manager';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmGepadatmentes, frmGepadatmentes);
  Application.CreateForm(TfrmBeallitasok, frmBeallitasok);
  Application.CreateForm(TfrmGepeadatokVissza, frmGepeadatokVissza);
  Application.Run;
end.

