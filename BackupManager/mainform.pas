unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, global, Windows, shellapi;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBeallitasok : TButton;
    Button4 : TButton;
    cmbMentes_Gepek : TComboBox;
    cmbAdatVissza_Gepek : TComboBox;
    GroupBox1 : TGroupBox;
    GroupBox2 : TGroupBox;
    Label1 : TLabel;
    Label2 : TLabel;
    sbtnAdatmentes : TSpeedButton;
    sbtnAdatVisszatoltes : TSpeedButton;
    procedure btnBeallitasokClick(Sender : TObject);
    procedure Button4Click(Sender : TObject);
    procedure cmbMentes_GepekChange(Sender : TObject);
    procedure FormActivate(Sender : TObject);
    procedure sbtnAdatmentesClick(Sender : TObject);
    procedure sbtnAdatVisszatoltesClick(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain : TfrmMain;


implementation

uses beallitasok;
{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.Button4Click(Sender : TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.cmbMentes_GepekChange(Sender : TObject);
begin
	sbtnAdatmentes.Caption := 'Gépadatok mentése' + #13#10 + 'a(z) '+ cmbMentes_Gepek.Text +' -gépről!';
end;

procedure TfrmMain.btnBeallitasokClick(Sender : TObject);
begin
  frmMain.Hide;
  frmBeallitasok.Show;
end;

procedure TfrmMain.FormActivate(Sender : TObject);
var
  iGepekSzama,i : integer;
	inifile: TextFile;

begin
  cmbMentes_Gepek.Clear;
  cmbAdatVissza_Gepek.Clear;
  cmbMentes_Gepek.Items.Add('Összes gép!');
  cmbAdatVissza_Gepek.Items.Add('Válassz gépet!');
	cmbMentes_Gepek.ItemIndex := 0;
	cmbAdatVissza_Gepek.ItemIndex := 0;
  sbtnAdatmentes.Caption := 'Gépadatok mentése' + #13#10 + 'az összes gépről!';
  sbtnAdatVisszatoltes.Caption := 'Gépadatok visszaállítása';	// + #13#10 + 'az összes gépre!';

  sSettings_ini_utvonal := ExtractFilePath(Application.ExeName) + 'settings.ini';

  AssignFile (inifile, sSettings_ini_utvonal);
 	Reset (inifile);
  ReadLn(inifile,iGepekSzama);
  SetLength(rMachineDatas,iGepekSzama);
  for i := 0 to iGepekSzama - 1 do
  begin
    ReadLn(inifile,rMachineDatas[i].sType);
		ReadLn(inifile,rMachineDatas[i].sGepNev);
    ReadLn(inifile,rMachineDatas[i].sSN);
    ReadLn(inifile,rMachineDatas[i].sIP);
    cmbMentes_Gepek.Items.AddObject(rMachineDatas[i].sGepNev,TObject(i+1));
		cmbAdatVissza_Gepek.Items.AddObject(rMachineDatas[i].sGepNev,TObject(i+1));
  end;

  CloseFile(inifile);

end;

procedure TfrmMain.sbtnAdatmentesClick(Sender : TObject);
var
  iGep,iGepdb,i : integer;
  inifile: TextFile;
  sSettingsUtv,sGepadatUtv,sGepName,sType,sSN,sIP,sTavoliUtv,sDate : string;
  dwRet: DWORD;

begin
	sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25'

  //Adatmentés az összes vagy csak a kiválasztott gépről:
  sSettingsUtv := ExtractFilePath(Application.ExeName) + 'settings.ini';
  sGepadatUtv := ExtractFilePath(Application.ExeName);
  iGep := integer(cmbMentes_Gepek.Items.Objects[cmbMentes_Gepek.ItemIndex]);
	if iGep = 0 then
    begin
      //A gépadatok lementése az összes gépről a sorvezre :
      AssignFile (inifile, sSettingsUtv);
 		  Reset (inifile);
      ReadLn(inifile,iGepdb);
 		  Repeat
  		  ReadLn(inifile,sType);
  		  ReadLn(inifile,sGepName);
        ReadLn(inifile,sSN);
        ReadLn(inifile,sIP);
        sTavoliUtv := '\\' + sIP + '\srdaten';
			  dwRet := MakeDriveMapping(sTavoliUtv);
        if dwRet = 0 then
      	  begin
            if not DirectoryExists(sGepadatUtv + sSN) then
          	  CreateDir(sGepadatUtv + sSN);
            if not DirectoryExists(sGepadatUtv + sSN + '\' + sDate) then
          	  CreateDir(sGepadatUtv + sSN + '\' + sDate);
					  Copy_Dir(Meghajto + '\srcma', sGepadatUtv + sSN + '\' + sDate);
            //ShowMessage(sGepadatUtv + sSN + '\' + sDate);
      	  end
        else
      	  begin
					  ShowMessage('Csatlakozási hiba! '+#10#10+'A(z) '
          	  +sGepName+' beültetőgép adatait nem sikerült lementeni!'+#10+#10
              +'Hiba száma : '+IntToStr(dwRet));
            Kapcsolat_vege();
            CloseFile(inifile);
            exit;
      	  end;

        Kapcsolat_vege();
 		  Until Eof(inifile);
 		  CloseFile(inifile);
      ShowMessage('Gépadatok mentése a sorvezérlőre megtörtént!');
      exit;
    end
  else
  	begin
      //Kiválasztott gép adatainak mentése:
      //ShowMessage(IntToStr(iGep));
      //exit;
      i := 1;
			AssignFile (inifile, sSettingsUtv);
 		  Reset (inifile);
      ReadLn(inifile,iGepdb);
      Repeat
  		  ReadLn(inifile,sType);
  		  ReadLn(inifile,sGepName);
        ReadLn(inifile,sSN);
        ReadLn(inifile,sIP);
        //erről a gépről kell lementeni az adatokat:
				if (iGep = i) then break;
        inc(i);
      Until Eof(inifile);
 		  CloseFile(inifile);
      //ShowMessage(sGepName);
      sTavoliUtv := '\\' + sIP + '\srdaten';
			dwRet := MakeDriveMapping(sTavoliUtv);
      if dwRet = 0 then
      	begin
          if not DirectoryExists(sGepadatUtv + sSN) then
          	CreateDir(sGepadatUtv + sSN);
          if not DirectoryExists(sGepadatUtv + sSN + '\' + sDate) then
          	CreateDir(sGepadatUtv + sSN + '\' + sDate);
					Copy_Dir(Meghajto + '\srcma', sGepadatUtv + sSN + '\' + sDate);
          //ShowMessage(sGepadatUtv + sSN + '\' + sDate);
      	end
      else
      	begin
					ShowMessage('Csatlakozási hiba! '+#10#10+'A(z) '
          	+sGepName+' beültetőgép adatait nem sikerült lementeni!'+#10+#10
            +'Hiba száma : '+IntToStr(dwRet));
          Kapcsolat_vege();
          exit;
      	end;
        Kapcsolat_vege();
  	end;
end;

procedure TfrmMain.sbtnAdatVisszatoltesClick(Sender : TObject);
var
  iGep,iGepdb : integer;
  inifile: TextFile;
  sSettingsUtv,sGepadatUtv,sGepName,sType,sSN,sIP,sTavoliUtv,sDate : string;
  dwRet: DWORD;

begin
  //Gépadatvisszatöltés a kiválasztott gépre :
  sSettingsUtv := ExtractFilePath(Application.ExeName) + 'settings.ini';
  sGepadatUtv := ExtractFilePath(Application.ExeName);
  //Kiválasztott gép :
  iGep := integer(cmbAdatVissza_Gepek.Items.Objects[cmbAdatVissza_Gepek.ItemIndex]);

end;

end.

