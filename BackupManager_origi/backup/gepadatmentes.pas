unit gepadatmentes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, zipper, LazFileUtils;

type

  { TfrmGepadatmentes }

  TfrmGepadatmentes = class(TForm)
    btnMentes : TButton;
    btnKilepes : TButton;
    edtMentesNeve : TEdit;
    Label1 : TLabel;
    procedure btnKilepesClick(Sender : TObject);
    procedure btnMentesClick(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmGepadatmentes : TfrmGepadatmentes;

implementation

uses Unit1,global;

{$R *.lfm}

{ TfrmGepadatmentes }

procedure TfrmGepadatmentes.btnKilepesClick(Sender : TObject);
begin
  frmGepadatmentes.Hide;
	Form1.Show;
end;

procedure TfrmGepadatmentes.btnMentesClick(Sender : TObject);

var
  sTavoliUtv,sMentesNeve,sTomoritetlenMappa, sTomoritettMappa, sMentesMappa : string;
  dwRet: DWORD;
  bResult: boolean;

  AZipper: TZipper;
  TheFileList:TStringList;
  relativefn: string;
  i : integer;


begin
  //Gépadatok mentése:

  sMentesNeve := edtMentesNeve.Text;
  sMentesMappa := ExtractFilePath(Application.ExeName) + 'TomoritetlenAdatok\' + sGepAzonosito + '\' + sMentesNeve;
  sTomoritetlenMappa := ExtractFilePath(Application.ExeName) + 'TomoritetlenAdatok\';
  sTomoritettMappa := ExtractFilePath(Application.ExeName) + 'TomoritettAdatok\';

  //gépadatok összegyüjtése és tömörítés:
  DeleteDirectory(sTomoritetlenMappa,True);
  if not DirectoryExists(sTomoritetlenMappa) then CreateDir(sTomoritetlenMappa);

  //Ide kerül a tömöritett gépadat:
  DeleteDirectory(sTomoritettMappa,True);
  if not DirectoryExists(sTomoritettMappa) then CreateDir(sTomoritettMappa);

  //Gépadatok másolása a tömörítéshez:
  case sSzoftver_verzio of
   '4XX','5XX':
     begin
       //Csak a "C:\SRDaten\SrcMa" -t kell menteni:
       CopyFiles('c:\srdaten\srcma',sTomoritetlenMappa,'*.*');
     end;
   '6XX':
     begin
       {  "C:\SRDaten\SrcMa"
          "C:\SRDaten\Config"
          "C:\SRDaten\DeviceLibraries" }
       //Létre kell hozni az SrcMa,Config,DeviceLibraries mappákat:
       if not DirectoryExists(sTomoritetlenMappa + '\SrcMa') then CreateDir(sTomoritetlenMappa + '\SrcMa');
       if not DirectoryExists(sTomoritetlenMappa + '\Config') then CreateDir(sTomoritetlenMappa + '\Config');
       if not DirectoryExists(sTomoritetlenMappa + '\DeviceLibraries') then CreateDir(sTomoritetlenMappa + '\DeviceLibraries');
       CopyFiles('c:\srdaten\srcma',sTomoritetlenMappa + '\SrcMa','*.*');
       CopyFiles('c:\srdaten\Config',sTomoritetlenMappa + '\Config','*.*');
       CopyFiles('c:\srdaten\DeviceLibraries',sTomoritetlenMappa + '\DeviceLibraries','*.*');
     end;
   '7XX':
     begin
       {  "C:\Sirio\Work\Individual"
          "C:\Sirio\Versionsinfo.xml" --> "_SirioVersion.xml"  néven
          "C:\Sirio\Work\AutoConfiguration.SirioConfiguration" --> "_SirioConfig.xml"  néven}
       CopyFiles('C:\Sirio\Work\Individual',sTomoritetlenMappa ,'*.*');
       CopyFile(ORIGI_SIRIOCONFIG,sTomoritetlenMappa + '\_SirioConfig.xml');
       CopyFile(ORIGI_SIRIOVERSION,sTomoritetlenMappa + '\_SirioVersion.xml');
     end;
   end;   //Case end

   //Tömörítés:
   AZipper := TZipper.Create;
   AZipper.Filename := sTomoritettMappa + sMentesNeve + '.zip';
   TheFileList := TStringList.Create;

    try
      FindAllFiles(TheFileList, sTomoritetlenMappa);

      //ProgressBar1.Max := TheFileList.Count;
      //ProgressBar1.Position := 0;
      //ProgressBar1.Refresh;

      for i:=0 to TheFileList.Count-1 do
      begin
          relativefn := CreateRelativePath(TheFileList[i], sTomoritetlenMappa);
          AZipper.Entries.AddFileEntry(TheFileList[i], relativefn);
      end;
      //AZipper.OnProgress := @UnZipperProgress;
      AZipper.ZipAllFiles;

    finally
      TheFileList.Free;
      AZipper.Free;
      ShowMessage('Gépadatok tömörítése befejeződött!');
      //ProgressBar1.Position := 0;
      //ProgressBar1.Refresh;
    end;

    //Tömörített gépadatok mentése (tesztmódtól függően!!):
    //ha tesztmódban van a sw akkor csak a D:\TesztmodeAdamentes mappába kell menteni!!
    if bSzoftver_tesztmod then
      begin
         bResult := DeleteDirectory('D:\TesztmodeAdamentes',True);
         if bResult then begin
            bResult := RemoveDir('D:\TesztmodeAdamentes');
            end;
         if not DirectoryExists('D:\TesztmodeAdamentes\') then CreateDir('D:\TesztmodeAdamentes\');
         CreateDir('D:\TesztmodeAdamentes\' + sMentesNeve);
         CopyFiles(sTomoritettMappa,'D:\TesztmodeAdamentes\' + sMentesNeve,'*.*');
         ShowMessage('Gépadatok mentése megtörtént!' + #10 + 'A szoftver tesztmódban fut így a mentés a :'
                                + #10 + 'D:\TesztmodeAdamentes\' + sMentesNeve + ' - mappába történt!!');
         frmGepadatmentes.Hide;
         Form1.Show;
         exit;
      end;

    sTavoliUtv := '\\' + sSorvezIP + '\siemens';

    dwRet := MakeDriveMapping(sTavoliMeghajtoNev,sTavoliUtv);
    if dwRet = 0 then
      begin
        sMentesMappa := sTavoliMeghajtoNev + '\Gepadatok\' + sGepAzonosito + '\' + sMentesNeve;
        if not DirectoryExists(sTavoliMeghajtoNev + '\Gepadatok\' + sGepAzonosito) then
          CreateDir(sTavoliMeghajtoNev + '\Gepadatok\' + sGepAzonosito);
        if not DirectoryExists(sMentesMappa) then CreateDir(sMentesMappa);
        CopyFiles(sTomoritettMappa,sMentesMappa,'*.*');
      end
    else
    begin
         ShowMessage('Csatlakozási hiba! ' + #10#10 + 'A(z) '
        + sGepAzonosito + ' beültetőgép adatait nem sikerült lementeni!' + #10+#10
        + 'Az irodában lévő GHOST_PC -t be kell kapcsolni vagy ujraindítani!!');
      Kapcsolat_vege(sTavoliMeghajtoNev);
      exit;
    end;

    //Felcsatolt mappa leválasztása:
    Kapcsolat_vege(sTavoliMeghajtoNev);

    ShowMessage('Gépadatok mentése megtörtént!');
    frmGepadatmentes.Hide;
    Form1.Show;

    exit;

end;

procedure TfrmGepadatmentes.FormClose(Sender : TObject;
  var CloseAction : TCloseAction);
begin
	frmGepadatmentes.Hide;
	Form1.Show;
end;

procedure TfrmGepadatmentes.FormShow(Sender : TObject);
begin
  edtMentesNeve.Text := FormatDateTime('YYYY.MM.DD',Now);
end;

end.

