program backupmanager;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mainform, global, beallitasok
  { you can add units after this };

{$R *.res}

begin
  Application.Title := 'BackupManager';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmBeallitasok, frmBeallitasok);
  Application.Run;
end.

