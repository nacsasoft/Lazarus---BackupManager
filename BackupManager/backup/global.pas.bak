unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Windows, shellapi, FileUtil, Dialogs;

//globális típusok

	//gép fontosabb adatai :
  type mDatas = record
        sType				: string;		//Gép típusa pl.:S23,F4 stb.
        sGepNev			: string;		//Gép elnevezése - egyszerű azonosítása a sorban pl.: S23_1 -első S23-as gép
        sSN					: string;		//Gép sorozat száma
        sIP					:	string;		//Gép IP-címe
  end;

const
//globális állandók
  Meghajto = 'X:';
  Felhasznalo = 'station';
  Jelszo = 'Flextronics1';

var
//globális változók
  rMachineDatas : array of mDatas;	//Gépadatokat (típus,gépszám stb.) tartalmazó record
	sSettings_ini_utvonal : string;		//settings.ini fájl helye


//Globális eljárás és függvénydeklarációk
procedure Kapcsolat_vege();
function MakeDriveMapping(DirectoryPath: String): DWORD;
function Copy_Dir(Mit,Hova: String): Boolean;




implementation
//Globális függvények megvalósításai

//Távoli meghajtó felcsatolása....
function MakeDriveMapping(DirectoryPath: String): DWORD;

var
  Res: NetResource;
  dwFlags: DWORD;
  //Jelszo, FelhNev: PChar;

begin
	FillChar(Res, SizeOf(Res), #0);
  with Res do
  begin
      dwType := RESOURCETYPE_DISK;
    	lpLocalName := PChar(Meghajto);
    	lpRemoteName := PChar(DirectoryPath);
  		lpProvider := nil;
  end;
	//ShowMessage(DirectoryPath);
  dwFlags := CONNECT_UPDATE_PROFILE;
  Result := WNetAddConnection2(Res, PChar(Jelszo), PChar(Felhasznalo), dwFlags);

end;

//Mappa másolása a benne lévő tartalommal együtt...
function Copy_Dir(Mit,Hova: String): Boolean;
var
	Fos: TSHFileOpStruct;
begin
	ZeroMemory(@Fos, SizeOf(Fos));
	with Fos do
	begin
		wFunc := FO_COPY;
		fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
		pFrom := PChar(Mit + #0);
		pTo := PChar(Hova + #0);
	end;
	Result:=(0=ShFileOperation(Fos));
end;






//Globális eljárások megvalósításai

procedure Kapcsolat_vege();
begin
  WNetCancelConnection2(PChar(Meghajto),CONNECT_UPDATE_PROFILE,true);
end;

end.

