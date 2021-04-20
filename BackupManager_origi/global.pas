unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Windows, shellapi, FileUtil, Dialogs;

//globális típusok


const
//globális állandók
  Felhasznalo = 'europe\tab_siemens'; // 'station';
  Jelszo = 'Flextronics1';
  ORIGI_SIRIOCONFIG   = 'c:\Sirio\Work\AutoConfiguration.SirioConfiguration';
  ORIGI_SIRIOVERSION  = 'c:\Sirio\Versionsinfo.xml';

var
//globális változók

  sSettings_ini_utvonal : string;		//settings.ini fájl helye
  sSorvezIP             : string;		//Sorvezérlő IP címe
  sGepAzonosito		    : string;		//Lehet gépnév vagy sorozatszám...
  sTavoliMeghajtoNev	: string;		//Távoli meghajtó betüjele....
  bSzoftver_tesztmod    : boolean;      //Ha a szoftver teszt üzemmódban fut akkor = true

  {
   Szoftver verzió
   FONTOS:
          4XX, 5XX :
                  "C:\SRDaten\SrcMa"
          6XX :
                  "C:\SRDaten\SrcMa"
                  "C:\SRDaten\Config"
                  "C:\SRDaten\DeviceLibraries"
          7XX :
                  "C:\Sirio\Work\Individual"
                  "C:\Sirio\Versionsinfo.xml" --> "_SirioVersion.xml"  néven
                  "C:\Sirio\Work\AutoConfiguration.SirioConfiguration" --> "_SirioConfig.xml"  néven

  }
  sSzoftver_verzio      : string;
  sGepadatok            : string;       //Gépadatok mappa


//Globális eljárás és függvénydeklarációk
procedure Kapcsolat_vege(Meghajto : String);
function MakeDriveMapping(Meghajto, DirectoryPath: String): DWORD;
function Copy_Dir(Mit,Hova: String): Boolean;
procedure GetSubDirectories(const directory : string; list : TStrings) ;
Function CopyFiles(FromPath,ToPath,FileMask: String): Boolean;



implementation

//Távoli meghajtó felcsatolása....
function MakeDriveMapping(Meghajto, DirectoryPath: String): DWORD;

var
  Res: NetResource;
  dwFlags: DWORD;
  //Jelszo, FelhNev: PChar;

begin
	FillChar(Res, SizeOf(Res), #0);
  with Res do
  begin
    	dwDisplayType := RESOURCEDISPLAYTYPE_GENERIC;
    	dwScope := RESOURCE_GLOBALNET;
      dwType := RESOURCETYPE_DISK;
      //dwUsage := RESOURCEUSAGE_CONNECTABLE;
      //lpComment := nil;
    	lpLocalName := PChar(Meghajto);
    	lpRemoteName := PChar(DirectoryPath);
  		lpProvider := nil;
  end;
	//ShowMessage(DirectoryPath+#10+Jelszo+#10+Felhasznalo);
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
       //fAnyOperationsAborted := false;
		   wFunc := FO_COPY;
		   //fFlags := FOF_SILENT or FOF_SIMPLEPROGRESS or FOF_NOERRORUI;
       fFlags := FOF_NOCONFIRMATION Or FOF_NOCONFIRMMKDIR;
		   pFrom := PChar(Mit + #0);
		   pTo := PChar(Hova + #0);
	end;
	Result:=(0=ShFileOperation(Fos));
end;


//fils the "list" TStrings with the subdirectories of the "directory" directory
 procedure GetSubDirectories(const directory : string; list : TStrings) ;
 var
   sr : TSearchRec;
 begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then
       Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
         list.Add(sr.Name) ;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
 end;


procedure Kapcsolat_vege(Meghajto : String);
begin
  WNetCancelConnection2(PChar(Meghajto),CONNECT_UPDATE_PROFILE,true);
end;


{
  Fajlok masolasa adott helyrol (FromPath) megadott helyre (ToPath)
  Ha az osszes fajlt masolni kell akkor a FileMask = *.*
}
Function CopyFiles(FromPath,ToPath,FileMask: String): Boolean;
{
var
   SearchRec      :TSearchRec;
   FromFn, ToFn   :string;
begin
    if FindFirst(FromPath + '\*.*', (faAnyFile AND NOT(faDirectory)), SearchRec) = 0 then
    begin
      repeat
        FromFn := FromPath + '\' + SearchRec.name;
        ToFn := ToPath + '\' + SearchRec.name;
        CopyFile(Pchar(FromFn), Pchar(ToFn), false);
      until FindNext(SearchRec) <> 0;
    end;
end;
}
var
   CopyFilesSearchRec: TSearchRec;
   FindFirstReturn: Integer;
   LastFile: String;
Begin
     Result := False;
     FindFirstReturn :=
     FindFirst(FromPath+'\'+FileMask, faAnyFile, CopyFilesSearchRec);
     LastFile := CopyFilesSearchRec.Name;
     If Not (CopyFilesSearchRec.Name = '') And Not (FindFirstReturn = -18) Then
     Begin
          Result := True;
          CopyFile(PChar(FromPath+'\'+CopyFilesSearchRec.Name),
            PChar(ToPath+'\'+CopyFilesSearchRec.Name), false);
          While True Do
          Begin
            If (FindNext(CopyFilesSearchRec)<0) or (LastFile = CopyFilesSearchRec.Name) Then
            Begin
              Break;
            End
            Else
            Begin
              CopyFile(PChar(FromPath+'\'+CopyFilesSearchRec.Name),
                  PChar(ToPath+'\'+CopyFilesSearchRec.Name), false);
              LastFile := CopyFilesSearchRec.Name;
            End;
          End;
     End;
End;

end.

