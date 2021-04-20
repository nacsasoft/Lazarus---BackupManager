unit beallitasok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MaskEdit, global;

type

  { TfrmBeallitasok }

  TfrmBeallitasok = class(TForm)
    btnMentes : TButton;
    btnKilepes : TButton;
    chkGepAktiv1 : TCheckBox;
    chkGepAktiv2 : TCheckBox;
    chkGepAktiv3 : TCheckBox;
    chkGepAktiv4 : TCheckBox;
    chkGepAktiv5 : TCheckBox;
    cmbGeptipus1 : TComboBox;
    cmbGeptipus2 : TComboBox;
    cmbGeptipus3 : TComboBox;
    cmbGeptipus4 : TComboBox;
    cmbGeptipus5 : TComboBox;
    edtGepnev2 : TEdit;
    edtGepnev3 : TEdit;
    edtGepnev4 : TEdit;
    edtGepnev5 : TEdit;
    edtIPCim1 : TEdit;
    edtIPCim2 : TEdit;
    edtIPCim3 : TEdit;
    edtIPCim4 : TEdit;
    edtIPCim5 : TEdit;
    edtSorozatszam2 : TEdit;
    edtSorozatszam3 : TEdit;
    edtSorozatszam4 : TEdit;
    edtSorozatszam5 : TEdit;
    edtGepnev1 : TEdit;
    edtSsz : TEdit;
    edtSorozatszam1 : TEdit;
    edtSsz1 : TEdit;
    edtSsz2 : TEdit;
    edtSsz3 : TEdit;
    edtSsz4 : TEdit;
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    procedure btnKilepesClick(Sender : TObject);
    procedure btnMentesClick(Sender : TObject);
    procedure chkGepAktiv1Change(Sender : TObject);
    procedure chkGepAktiv2Change(Sender : TObject);
    procedure chkGepAktiv3Change(Sender : TObject);
    procedure chkGepAktiv4Change(Sender : TObject);
    procedure chkGepAktiv5Change(Sender : TObject);
    procedure cmbGeptipus1Change(Sender : TObject);
    procedure cmbGeptipus2Change(Sender : TObject);
    procedure cmbGeptipus3Change(Sender : TObject);
    procedure cmbGeptipus4Change(Sender : TObject);
    procedure cmbGeptipus5Change(Sender : TObject);
    procedure edtGepnev1Change(Sender : TObject);
    procedure edtGepnev2Change(Sender : TObject);
    procedure edtGepnev3Change(Sender : TObject);
    procedure edtGepnev4Change(Sender : TObject);
    procedure edtGepnev5Change(Sender : TObject);
    procedure edtIPCim1Change(Sender : TObject);
    procedure edtIPCim2Change(Sender : TObject);
    procedure edtIPCim3Change(Sender : TObject);
    procedure edtIPCim4Change(Sender : TObject);
    procedure edtIPCim5Change(Sender : TObject);
    procedure edtSorozatszam1Change(Sender : TObject);
    procedure edtSorozatszam2Change(Sender : TObject);
    procedure edtSorozatszam3Change(Sender : TObject);
    procedure edtSorozatszam4Change(Sender : TObject);
    procedure edtSorozatszam5Change(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    bAdatValtozasok : Boolean;	//Ha vmelyik adat magváltozott akkor a kilépést meg kell erősíteni.

  public
    { public declarations }
  end;

var
  frmBeallitasok : TfrmBeallitasok;

implementation

uses mainform;

{ TfrmBeallitasok }

procedure TfrmBeallitasok.btnMentesClick(Sender : TObject);
//Gépelérésekkel kapcsolatos változások elmentése...
var
  iGepekSzama,i : integer;
	inifile: TextFile;
  errrrr : Boolean;

begin
  //adatok összegyüjtése :
  iGepekSzama := -1;
  errrrr := False;
  SetLength(rMachineDatas,0);
  SetLength(rMachineDatas,5);
  if chkGepAktiv1.Checked then
  begin
  	if (Trim(edtSorozatszam1.Text) = '') or (Trim(edtIPCim1.Text) = '') then errrrr := True;
		Inc(iGepekSzama);
		rMachineDatas[iGepekSzama].sType := cmbGeptipus1.Text;
		rMachineDatas[iGepekSzama].sGepNev := edtGepnev1.Text;
    rMachineDatas[iGepekSzama].sSN := edtSorozatszam1.Text;
		rMachineDatas[iGepekSzama].sIP := edtIPCim1.Text;
  end;
  if chkGepAktiv2.Checked then
  begin
    if (Trim(edtSorozatszam2.Text) = '') or (Trim(edtIPCim2.Text) = '') then errrrr := True;
		Inc(iGepekSzama);
		rMachineDatas[iGepekSzama].sType := cmbGeptipus2.Text;
    rMachineDatas[iGepekSzama].sGepNev := edtGepnev2.Text;
    rMachineDatas[iGepekSzama].sSN := edtSorozatszam2.Text;
		rMachineDatas[iGepekSzama].sIP := edtIPCim2.Text;
  end;
  if chkGepAktiv3.Checked then
  begin
    if (Trim(edtSorozatszam3.Text) = '') or (Trim(edtIPCim3.Text) = '') then errrrr := True;
		Inc(iGepekSzama);
		rMachineDatas[iGepekSzama].sType := cmbGeptipus3.Text;
    rMachineDatas[iGepekSzama].sGepNev := edtGepnev3.Text;
    rMachineDatas[iGepekSzama].sSN := edtSorozatszam3.Text;
		rMachineDatas[iGepekSzama].sIP := edtIPCim3.Text;
  end;
  if chkGepAktiv4.Checked then
  begin
    if (Trim(edtSorozatszam4.Text) = '') or (Trim(edtIPCim4.Text) = '') then errrrr := True;
		Inc(iGepekSzama);
		rMachineDatas[iGepekSzama].sType := cmbGeptipus4.Text;
    rMachineDatas[iGepekSzama].sGepNev := edtGepnev4.Text;
    rMachineDatas[iGepekSzama].sSN := edtSorozatszam4.Text;
		rMachineDatas[iGepekSzama].sIP := edtIPCim4.Text;
  end;
  if chkGepAktiv5.Checked then
  begin
    if (Trim(edtSorozatszam5.Text) = '') or (Trim(edtIPCim5.Text) = '') then errrrr := True;
		Inc(iGepekSzama);
		rMachineDatas[iGepekSzama].sType := cmbGeptipus5.Text;
    rMachineDatas[iGepekSzama].sGepNev := edtGepnev5.Text;
    rMachineDatas[iGepekSzama].sSN := edtSorozatszam5.Text;
		rMachineDatas[iGepekSzama].sIP := edtIPCim5.Text;
  end;

  //mezők ki vannak töltve a bepipált gépeknél?
  if errrrr then
  Begin
    //gááz van...
    ShowMessage('Az aktív gépeknél az adatok kitöltése kötelező!');
    exit;
  end;

  if MessageDlg ('Adatok módosítása...', 'Biztos hogy felülírjam a régi beállításokat?', mtConfirmation,
                  [mbYes, mbNo],0) = mrNo then exit;

  sSettings_ini_utvonal := ExtractFilePath(Application.ExeName) + 'settings.ini';

  AssignFile (inifile, sSettings_ini_utvonal);
 	Rewrite (inifile);
	WriteLn(inifile,IntToStr(iGepekSzama + 1));
  for i := 0 to iGepekSzama do
  begin
    WriteLn(inifile,rMachineDatas[i].sType);
		WriteLn(inifile,rMachineDatas[i].sGepNev);
    WriteLn(inifile,rMachineDatas[i].sSN);
    WriteLn(inifile,rMachineDatas[i].sIP);
  end;
  CloseFile(inifile);
  ShowMessage('Adatok frissítése megtörtént!');
  frmBeallitasok.Close;
  bAdatValtozasok := False;
end;

procedure TfrmBeallitasok.chkGepAktiv1Change(Sender : TObject);
begin
  cmbGeptipus1.Enabled := chkGepAktiv1.Checked;
  edtGepnev1.Enabled := chkGepAktiv1.Checked;
  edtSorozatszam1.Enabled := chkGepAktiv1.Checked;
  edtIPCim1.Enabled := chkGepAktiv1.Checked;
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.chkGepAktiv2Change(Sender : TObject);
begin
  cmbGeptipus2.Enabled := chkGepAktiv2.Checked;
  edtGepnev2.Enabled := chkGepAktiv2.Checked;
  edtSorozatszam2.Enabled := chkGepAktiv2.Checked;
  edtIPCim2.Enabled := chkGepAktiv2.Checked;
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.chkGepAktiv3Change(Sender : TObject);
begin
  cmbGeptipus3.Enabled := chkGepAktiv3.Checked;
  edtGepnev3.Enabled := chkGepAktiv3.Checked;
  edtSorozatszam3.Enabled := chkGepAktiv3.Checked;
  edtIPCim3.Enabled := chkGepAktiv3.Checked;
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.chkGepAktiv4Change(Sender : TObject);
begin
  cmbGeptipus4.Enabled := chkGepAktiv4.Checked;
  edtGepnev4.Enabled := chkGepAktiv4.Checked;
  edtSorozatszam4.Enabled := chkGepAktiv4.Checked;
  edtIPCim4.Enabled := chkGepAktiv4.Checked;
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.chkGepAktiv5Change(Sender : TObject);
begin
  cmbGeptipus5.Enabled := chkGepAktiv5.Checked;
  edtGepnev5.Enabled := chkGepAktiv5.Checked;
  edtSorozatszam5.Enabled := chkGepAktiv5.Checked;
  edtIPCim5.Enabled := chkGepAktiv5.Checked;
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.cmbGeptipus1Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.cmbGeptipus2Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.cmbGeptipus3Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.cmbGeptipus4Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.cmbGeptipus5Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtGepnev1Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtGepnev2Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtGepnev3Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtGepnev4Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtGepnev5Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtIPCim1Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtIPCim2Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtIPCim3Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtIPCim4Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtIPCim5Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtSorozatszam1Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtSorozatszam2Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtSorozatszam3Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtSorozatszam4Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.edtSorozatszam5Change(Sender : TObject);
begin
  bAdatValtozasok := true;
end;

procedure TfrmBeallitasok.FormCloseQuery(Sender : TObject;
  var CanClose : boolean);
begin
	//Figyelmeztetés ha történt adat módosítás :
  if (bAdatValtozasok) then
  begin
    if MessageDlg ('Adatok módosítása...', 'A beállítási adatok módosultak és nem lettek elmentve!'
    							+ #10 + 'Biztos hogy bezárjam az ablakot?', mtConfirmation,[mbYes, mbNo],0) = mrNo then
    begin
      CanClose := false;
      exit;
    end;
  end;
  CanClose := true;
	frmBeallitasok.Hide;
  frmMain.Show;
end;

procedure TfrmBeallitasok.FormShow(Sender : TObject);
var
  i,j,iGepekSzama : integer;
  MyControl : TControl;
  chk : TCheckBox;
  sName : string;

begin
  cmbGeptipus1.ItemIndex := 0;
  cmbGeptipus2.ItemIndex := 0;
  cmbGeptipus3.ItemIndex := 0;
  cmbGeptipus4.ItemIndex := 0;
  cmbGeptipus5.ItemIndex := 0;
  edtSorozatszam1.Text := '';
  edtSorozatszam2.Text := '';
  edtSorozatszam3.Text := '';
  edtSorozatszam4.Text := '';
  edtSorozatszam5.Text := '';
  edtIPCim1.Text := '';
  edtIPCim2.Text := '';
  edtIPCim3.Text := '';
  edtIPCim4.Text := '';
  edtIPCim5.Text := '';
  edtGepnev1.Text := '';
  edtGepnev2.Text := '';
  edtGepnev3.Text := '';
  edtGepnev4.Text := '';
  edtGepnev5.Text := '';
  chkGepAktiv1.Checked := false;
  chkGepAktiv2.Checked := false;
  chkGepAktiv3.Checked := false;
  chkGepAktiv4.Checked := false;
  chkGepAktiv5.Checked := false;

  //Gépadatok betöltése:
  iGepekSzama := Length(rMachineDatas);
  for i := 0 to iGepekSzama - 1 do
  begin
    for j := 0 to GroupBox1.ControlCount - 1 do
    begin
      if (GroupBox1.Controls[j] is TEdit) then
      begin
				MyControl := GroupBox1.Controls[j];
				if (MyControl.Name = 'edtGepnev'+IntToStr(i+1)) then MyControl.Caption := rMachineDatas[i].sGepNev;
				if (MyControl.Name = 'edtSorozatszam'+IntToStr(i+1)) then MyControl.Caption := rMachineDatas[i].sSN;
        if (MyControl.Name = 'edtIPCim'+IntToStr(i+1)) then MyControl.Caption := rMachineDatas[i].sIP;
      end;
      if (GroupBox1.Controls[j] is TComboBox) then
      begin
				MyControl := GroupBox1.Controls[j];
        if (MyControl.Name = 'cmbGeptipus'+IntToStr(i+1)) then
        begin
          (MyControl as TComboBox).Text := rMachineDatas[i].sType;
          //ShowMessage(rMachineDatas[i].sType);
        end;
      end;
      if (GroupBox1.Controls[j] is TCheckBox) then
      begin
				MyControl := GroupBox1.Controls[j];
        if (MyControl.Name = 'chkGepAktiv'+IntToStr(i+1)) then
				begin
        	(MyControl as TCheckBox).Checked := true;
					//ShowMessage('ok');
        end;
      end;
    end;
  end;

  bAdatValtozasok := false;

end;

procedure TfrmBeallitasok.btnKilepesClick(Sender : TObject);
begin
  //Figyelmeztetés ha történt adat módosítás :
  if (bAdatValtozasok) then
  begin
    if MessageDlg ('Adatok módosítása...', 'A beállítási adatok módosultak és nem lettek elmentve!'
    							+ #10 + 'Biztos hogy bezárjam az ablakot?', mtConfirmation,[mbYes, mbNo],0) = mrNo then exit;
  end;
  frmBeallitasok.Hide;
  frmMain.Show;
end;

{$R *.lfm}

end.

