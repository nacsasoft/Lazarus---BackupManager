unit gepadatvissza;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, zipper, LazFileUtils;

type

  { TfrmGepeadatokVissza }

  TfrmGepeadatokVissza = class(TForm)
    btnKilepes : TButton;
    GroupBox1 : TGroupBox;
    lstGepadatok : TListBox;
    spbGepadatVissza : TSpeedButton;
    procedure btnKilepesClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure spbGepadatVisszaClick(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmGepeadatokVissza : TfrmGepeadatokVissza;

implementation

uses Unit1,global;

{ TfrmGepeadatokVissza }

procedure TfrmGepeadatokVissza.FormShow(Sender : TObject);
var
  sTavoliUtv,sMentesNeve : string;
  dwRet: DWORD;
begin
  //gomb felirat beállítása....
  spbGepadatVissza.Caption := 'Gépadatok' + LineEnding + 'visszatöltése';
  lstGepadatok.Clear;

  //Tesztmódban fut a szoftver?
  if bSzoftver_tesztmod then
     begin
          ShowMessage('A szoftver tesztmódban van!' + #10 +
                         'A tömörített gépadatokat el kell helyezni a ' + #10 +
                         '"D:\TesztGepadatokVissza\-Géptípus-\-MentesDatuma-\" helyre a következő formátumban:' + #10 +
                         'pl.: "D:\TesztGepadatokVissza\I-D4_560286\2018.08.23\2018.08.23.zip"' + #10 + #10 +
                         'Fontos hogy a beállításokban lévő géppel azonos legyen a mappanév!!' + #10 +
                         'Jelen esetben: "I-D4_560286"');
          sTavoliUtv := 'D:\TesztGepadatokVissza\' + sGepAzonosito;
          GetSubDirectories(sTavoliUtv,lstGepadatok.Items);
     end
  else
      begin
        //Géphez tartozó gépadatok összegyüjtése:
        sTavoliUtv := '\\' + sSorvezIP + '\siemens';

        dwRet := MakeDriveMapping(sTavoliMeghajtoNev,sTavoliUtv);
        if (dwRet <> 0) then
        begin
          ShowMessage('Hálózati hiba! ' + #10#10 + 'Az irodában lévő GHOST_PC -t be kell kapcsolni vagy újraindítani!!');
          Kapcsolat_vege(sTavoliMeghajtoNev);
          exit;
        end;

        sMentesNeve := sTavoliMeghajtoNev+'\Gepadatok\' + sGepAzonosito;
        GetSubDirectories(sMentesNeve,lstGepadatok.Items);
        Kapcsolat_vege(sTavoliMeghajtoNev);
      end;



end;

procedure TfrmGepeadatokVissza.spbGepadatVisszaClick(Sender : TObject);
const
  AKTUELLMA         = 'c:\srdaten\srcma\AKTUELL.MA';
  AKTUELLBAK 	    = 'c:\srdaten\srcma\AKTUELL.BAK';
  AKTUELLMA_TEMP    = 'c:\_Gepadatok_\AKTUELL.MA';
  AKTUELLBAK_TEMP   = 'c:\_Gepadatok_\AKTUELL.BAK';
var
  sGepadat,sTavoliUtv,sTomoritettMappa,sTomoritetlenMappa : string;
  dwRet: DWORD;
  bResult: boolean;
  UnZipper: TUnZipper;
  sZipfile: string;


begin
  //Kiválasztott gépadat visszatötlése:
	sGepadat := lstGepadatok.GetSelectedText;
  if (trim(sGepadat) = '') then
  begin
    ShowMessage('Válassz ki egy gépadatot!');
    lstGepadatok.SetFocus;
    exit;
  end;
  if MessageDlg ('Gépadat visszatöltése...', 'Biztos hogy visszaállítod a következő gépadatot ?' + #10 + #10 +
  							sGepadat + #10 + #10 + 'A jelenlegi gépadatokról másolat készül a C:\_Gepadatok_ -könyvtárba!',
                mtConfirmation, [mbYes, mbNo],0) = mrNo then exit;

  //_Gepadatok_ mappa törlése:
  bResult := DeleteDirectory('C:\_Gepadatok_',True);

  //Szoftver teszt üzemmód esetén törölni kell a D:\GepadatokvisszaTeszt -mappát is!!
  bResult := DeleteDirectory('D:\GepadatokvisszaTeszt',True);

  //bizt. ment. készítése :
  CreateDir('C:\_Gepadatok_');

  //Szoftver tesztmód mappa:
  CreateDir('D:\GepadatokvisszaTeszt');

  sTomoritettMappa := ExtractFilePath(Application.ExeName) + 'TomoritettAdatok\';     //szerverről ide kerülnek a zippelt gépadatok
  sTomoritetlenMappa := ExtractFilePath(Application.ExeName) + 'TomoritetlenAdatok\'; //és ide lesznek kibontva!!
  DeleteDirectory(sTomoritettMappa, false);
  DeleteDirectory(sTomoritetlenMappa, false);
  CreateDir(sTomoritettMappa);
  CreateDir(sTomoritetlenMappa);

  //Station szoftver verziók szerint kell biztonsági mentést is csinálni:
  if bSzoftver_tesztmod = false then
  begin
    case sSzoftver_verzio of
         '4XX','5XX':
           begin
             //Csak a "C:\SRDaten\SrcMa" -t kell menteni:
             CopyFiles('c:\srdaten\srcma','C:\_Gepadatok_','*.*');
           end;
         '6XX':
           begin
             {  "C:\SRDaten\SrcMa"
                "C:\SRDaten\Config"
                "C:\SRDaten\DeviceLibraries" }
             //Létre kell hozni az SrcMa,Config,DeviceLibraries mappákat:
             CreateDir('C:\_Gepadatok_\SrcMa');
             CreateDir('C:\_Gepadatok_\Config');
             CreateDir('C:\_Gepadatok_\DeviceLibraries');
             //eredeti adatok mentése:
             CopyFiles('c:\srdaten\srcma','C:\_Gepadatok_\SrcMa','*.*');
             CopyFiles('c:\srdaten\Config','C:\_Gepadatok_\Config','*.*');
             CopyFiles('c:\srdaten\DeviceLibraries','C:\_Gepadatok_\DeviceLibraries','*.*');
           end;
         '7XX':
           begin
             {  "C:\Sirio\Work\Individual"
                "C:\Sirio\Versionsinfo.xml" --> "_SirioVersion.xml"  néven
                "C:\Sirio\Work\AutoConfiguration.SirioConfiguration" --> "_SirioConfig.xml"  néven}
             //eredeti adatok mentése:
             CopyFiles('C:\Sirio\Work\Individual','C:\_Gepadatok_' ,'*.*');
             CopyFile(ORIGI_SIRIOCONFIG,'C:\_Gepadatok_' + '\_SirioConfig.xml');
             CopyFile(ORIGI_SIRIOVERSION,'C:\_Gepadatok_' + '\_SirioVersion.xml');
           end;
    end;   //Case end
    //Szerver felcsatolása:
    sTavoliUtv := '\\' + sSorvezIP + '\siemens';
    dwRet := MakeDriveMapping(sTavoliMeghajtoNev,sTavoliUtv);
    if (dwRet <> 0) then
    begin
      ShowMessage('Hálózati hiba! '+ #10+#10 + 'Az irodában lévő GHOST_PC -t be kell kapcsolni vagy újraindítani!!');
      Kapcsolat_vege(sTavoliMeghajtoNev);
      exit;
    end;
    //tömörített adatok visszamásolása a szerverről:
    sTavoliUtv := sTavoliMeghajtoNev + '\Gepadatok\' + sGepAzonosito + '\' + sGepadat;
    CopyFiles(sTavoliUtv, sTomoritettMappa,'*.*');
  end
  else
  begin
    //tesztmód aktív, tömörített tesztadatok másolása a D:\TesztGepadatokVissza\ mappából
    //az alkalmazás "mellett" lévő TomoritettAdatok mappába
    CopyFiles('D:\TesztGepadatokVissza\' + sGepAzonosito + '\' + sGepadat, sTomoritettMappa,'*.*');
  end;

  //Tömörített gépadatok kibontása:
  sZipfile := sTomoritettMappa + sGepadat + '.zip';

  UnZipper := TUnZipper.Create;
  UnZipper.Filename := sZipfile;
  UnZipper.OutputPath := sTomoritetlenMappa + '\';
  UnZipper.Examine;
  try
     UnZipper.UnZipAllFiles;
  finally
         UnZipper.Free;
  end;

  //Station szoftver verziók szerint kell visszatölteni a gépadatokat:
  case sSzoftver_verzio of
       '4XX','5XX':
         begin
           //Csak a "C:\SRDaten\SrcMa" -t kell:
           if bSzoftver_tesztmod then
              begin
                   CopyFiles(sTomoritetlenMappa + '\' + sGepadat, 'D:\GepadatokvisszaTeszt','*.*');
              end
           else
               begin
                    CopyFiles(sTomoritetlenMappa + '\' + sGepadat, 'c:\srdaten\srcma','*.*');
                    //pipettakonfig visszaírása :
                    CopyFile(AKTUELLBAK_TEMP,AKTUELLBAK);
                    CopyFile(AKTUELLMA_TEMP,AKTUELLMA);
               end;
         end;
       '6XX':
         begin
           {  "C:\SRDaten\SrcMa"
              "C:\SRDaten\Config"
              "C:\SRDaten\DeviceLibraries" }
           if bSzoftver_tesztmod then
              begin
                   CreateDir('D:\GepadatokvisszaTeszt\srcma');
                   CreateDir('D:\GepadatokvisszaTeszt\Config');
                   CreateDir('D:\GepadatokvisszaTeszt\DeviceLibraries');
                   CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\srcma', 'D:\GepadatokvisszaTeszt\srcma', '*.*');
                   CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\Config', 'D:\GepadatokvisszaTeszt\Config', '*.*');
                   CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\DeviceLibraries', 'D:\GepadatokvisszaTeszt\DeviceLibraries', '*.*');
              end
           else
               begin
                    //SrcMa,Config,DeviceLibraries mappákat:
                    CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\srcma', 'c:\srdaten\srcma', '*.*');
                    CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\Config', 'c:\srdaten\Config', '*.*');
                    CopyFiles(sTomoritetlenMappa + '\' + sGepadat + '\DeviceLibraries', 'c:\srdaten\DeviceLibraries', '*.*');
               end;
         end;
       '7XX':
         begin
           {  "C:\Sirio\Work\Individual"
              "C:\Sirio\Versionsinfo.xml" --> "_SirioVersion.xml"  néven
              "C:\Sirio\Work\AutoConfiguration.SirioConfiguration" --> "_SirioConfig.xml"  néven}
           if bSzoftver_tesztmod then
              begin
                   CreateDir('D:\GepadatokvisszaTeszt\Sirio');
                   CreateDir('D:\GepadatokvisszaTeszt\Sirio\Work');
                   CreateDir('D:\GepadatokvisszaTeszt\Sirio\Work\Individual');
                   CopyFiles(sTomoritetlenMappa + '\' + sGepadat,'D:\GepadatokvisszaTeszt\Sirio\Work\Individual','*.*');
                   CopyFile(sTomoritetlenMappa + '\' + sGepadat + '\_SirioVersion.xml','D:\GepadatokvisszaTeszt\Sirio\Versionsinfo.xml');
                   CopyFile(sTomoritetlenMappa + '\' + sGepadat + '\_SirioConfig.xml','D:\GepadatokvisszaTeszt\Sirio\Work\AutoConfiguration.SirioConfiguration');
              end
           else
               begin
                    CopyFiles(sTomoritetlenMappa + '\' + sGepadat,'c:\Sirio\Work\Individual','*.*');
                    CopyFile(sTomoritetlenMappa + '\' + sGepadat + '\_SirioVersion.xml','c:\Sirio\Versionsinfo.xml');
                    CopyFile(sTomoritetlenMappa + '\' + sGepadat + '\_SirioConfig.xml','c:\Sirio\Work\AutoConfiguration.SirioConfiguration');
               end;
         end;
  end;   //Case end

  if bSzoftver_tesztmod then
     ShowMessage('A szoftver teszt üzemmódban van!' + #10 + 'A gépadatok jelenleg a D:\GepadatokvisszaTeszt\ mappába lettek visszamásolva!' + #10 +
                    'a D:\TesztGepadatokVissza\ -mappából!!')
  else
    begin
         Kapcsolat_vege(sTavoliMeghajtoNev);
         ShowMessage('Az eredeti gépadatok felül lettek írva!' + #10 + 'A beültetőgépet újra kell indítani!!');
    end;


  frmGepeadatokVissza.Hide;
  Form1.Show;
end;

procedure TfrmGepeadatokVissza.btnKilepesClick(Sender : TObject);
begin
  frmGepeadatokVissza.Hide;
	Form1.Show;
end;

{$R *.lfm}

end.

