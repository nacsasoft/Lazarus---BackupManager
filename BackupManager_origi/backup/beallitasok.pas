unit beallitasok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, global, IniFiles;

type

  { TfrmBeallitasok }

  TfrmBeallitasok = class(TForm)
    btnKilepes : TButton;
    btnMentes : TButton;
    chkTest: TCheckBox;
    cmbMeghajto : TComboBox;
    cmbPlatform: TComboBox;
    cmbMentettGepadatok: TComboBox;
    edtPassword : TEdit;
    edtIP : TEdit;
    edtGepAzonosito : TEdit;
    GroupBox1: TGroupBox;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Shape1: TShape;
    procedure btnKilepesClick(Sender : TObject);
    procedure btnMentesClick(Sender : TObject);
    procedure cmbMentettGepadatokChange(Sender: TObject);
    procedure edtGepAzonositoClick(Sender: TObject);
    procedure edtGepAzonositoEnter(Sender: TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmBeallitasok : TfrmBeallitasok;

implementation

uses Unit1;

{ TfrmBeallitasok }

procedure TfrmBeallitasok.btnKilepesClick(Sender : TObject);
begin
  frmBeallitasok.Hide;
  Form1.Show;
end;

procedure TfrmBeallitasok.btnMentesClick(Sender : TObject);
var
	inifile: TINIFile;
    sPassword : string;
    arrSzoftver_verziok : array [0..3] of string = ('4XX', '5XX', '6XX', '7XX');
begin

  //Adatok ellenörzése és lementése ill. a globális változók frissítése...
  //Jelszó ellenörzés:
  sPassword := edtPassword.Text;
  if (sPassword <> 'kincso') then
  begin
    ShowMessage('Rossz jelszó!');
    exit;
  end;

  if (Trim(edtGepAzonosito.Text) = '') then
  begin
    ShowMessage('Gép azonosító mező kitöltése kötelező!'+#10+'pl.: HS50_1, vagy lehet sorozatszám is!');
    exit;
  end;

  //adatok oksa....
  sSorvezIP := edtIP.Text;
  sGepAzonosito := edtGepAzonosito.Text;
  sTavoliMeghajtoNev := cmbMeghajto.Text;
  sSzoftver_verzio := arrSzoftver_verziok[cmbPlatform.ItemIndex];
  bSzoftver_tesztmod := chkTest.Checked;

  //mentés az ini-fájlba...
  inifile := TINIFile.Create(sSettings_ini_utvonal);
  inifile.WriteString('beallitasok','ip_cim',sSorvezIP);
  inifile.WriteString('beallitasok','GepAzonosito',sGepAzonosito);
  inifile.WriteString('beallitasok','TavoliMeghajtoNev',sTavoliMeghajtoNev);
  inifile.WriteString('beallitasok','Szoftver_verzio',sSzoftver_verzio);
  inifile.WriteBool('beallitasok','Szoftver_tesztmod',bSzoftver_tesztmod);
  inifile.Free;

  ShowMessage('Beállítások frissítése megtörtént!');
	frmBeallitasok.Hide;
  Form1.Show;
end;

procedure TfrmBeallitasok.cmbMentettGepadatokChange(Sender: TObject);
begin
  edtGepAzonosito.Text := cmbMentettGepadatok.Text;
end;

procedure TfrmBeallitasok.edtGepAzonositoClick(Sender: TObject);
begin
  //edtGepAzonosito.Text := '';
end;

procedure TfrmBeallitasok.edtGepAzonositoEnter(Sender: TObject);
begin
  //edtGepAzonosito.Text := '';
end;

procedure TfrmBeallitasok.FormClose(Sender : TObject;
  var CloseAction : TCloseAction);
begin
	frmBeallitasok.Hide;
  Form1.Show;
end;

procedure TfrmBeallitasok.FormShow(Sender : TObject);
var
  sTavoliUtv,sMentesNeve : string;
  dwRet: DWORD;
  iSWItemIndex: integer;

begin
  edtIP.Text := sSorvezIP;
  edtGepAzonosito.Text := sGepAzonosito;
  cmbMeghajto.Text := sTavoliMeghajtoNev;

  edtPassword.Text := '';
  cmbMentettGepadatok.Clear;

  case sSzoftver_verzio of
       '4XX': iSWItemIndex := 0;
       '5XX': iSWItemIndex := 1;
       '6XX': iSWItemIndex := 2;
       '7XX': iSWItemIndex := 3;
  end;
  cmbPlatform.ItemIndex := iSWItemIndex;
  chkTest.Checked := bSzoftver_tesztmod;

  //Mentett gepadatokhoz tartozo lista :
  sTavoliUtv := '\\' + sSorvezIP + '\siemens\Gepadatok';
  sMentesNeve := sTavoliMeghajtoNev;

  dwRet := MakeDriveMapping(sTavoliMeghajtoNev,sTavoliUtv);
  if (dwRet <> 0) then
  begin
    ShowMessage('Hálózati hiba! ' + #10#10 + 'Az irodában lévő GHOST_PC -t be kell kapcsolni vagy ujraindítani!!');
    Kapcsolat_vege(sTavoliMeghajtoNev);
    exit;
  end;

  GetSubDirectories(sMentesNeve,cmbMentettGepadatok.Items);
  cmbMentettGepadatok.ItemIndex := 0;
  Kapcsolat_vege(sTavoliMeghajtoNev);


end;

{$R *.lfm}

end.

