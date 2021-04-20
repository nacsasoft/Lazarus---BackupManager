unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, global, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnMentes : TButton;
    btnBeallitasok : TButton;
    btnKilepes : TButton;
    spbVisszatoltes : TSpeedButton;
    procedure btnBeallitasokClick(Sender : TObject);
    procedure btnKilepesClick(Sender : TObject);
    procedure btnMentesClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure spbVisszatoltesClick(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1 : TForm1;

implementation

uses gepadatmentes,beallitasok,gepadatvissza;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender : TObject);
var
    inifile: TINIFile;

begin

  spbVisszatoltes.Caption := 'Gépadatok' + LineEnding + 'visszatöltése';

  sSettings_ini_utvonal := ExtractFilePath(Application.ExeName) + 'settings.ini';

  //sorvezérlő ip-cím és gép azonosító beolvasása a settings.ini fájlból:
  inifile             := TINIFile.Create(sSettings_ini_utvonal);
  sSorvezIP           := inifile.ReadString('beallitasok','ip_cim','');
  sGepAzonosito       := inifile.ReadString('beallitasok','GepAzonosito','');
  sTavoliMeghajtoNev  := inifile.ReadString('beallitasok','TavoliMeghajtoNev','');
  sSzoftver_verzio    := inifile.ReadString('beallitasok','Szoftver_verzio','');
  bSzoftver_tesztmod  := inifile.ReadBool('beallitasok','Szoftver_tesztmod',false);

  inifile.Free;

end;

procedure TForm1.spbVisszatoltesClick(Sender : TObject);
begin
  //Gépadatok visszatöltése :
  Form1.Hide;
  frmGepeadatokVissza.Show;
end;

procedure TForm1.btnKilepesClick(Sender : TObject);
begin
  Form1.Close;
end;

procedure TForm1.btnBeallitasokClick(Sender : TObject);
begin
  Form1.Hide;
  frmBeallitasok.Show;
end;

procedure TForm1.btnMentesClick(Sender : TObject);
begin
     Form1.Hide;
  frmGepadatmentes.Show;
end;

end.

