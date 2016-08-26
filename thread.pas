unit thread;

interface

uses Classes,ComCtrls,logfile,Windows,WinInet,Dialogs,SysUtils;

procedure initPotokAuto;
procedure initPotokManual;

type
   TFRCThread = class(TThread)
   private
    t_host:string;
    t_Logfile:^TLogFile;
    t_ms:TStringStream;
    t_request:Tstrings;
    OwnerWnd:HWND;
   protected
    procedure Execute; override;
    procedure writedb(const host,str:string);
    Function GetURL(URL:string):boolean;
   public
end;

var CS:TRTLCriticalSection;

implementation

uses main;

procedure initPotokAuto;
var potok:TFRCThread;
begin
  potok:=TFRCThread.Create(true);
  potok.t_host:='http://www.meteo.nnov.ru/prognoz/writefrc.php';
  potok.t_Logfile:=@Form1.statusAutoFrcList;
  potok.t_request:=Form1.zaprosrequest;
  potok.Priority :=tpNormal;
  potok.OwnerWnd:=Form1.handle;
  potok.Resume;
end;

procedure initPotokManual;
var potok:TFRCThread;
begin
  potok:=TFRCThread.Create(true);
  potok.t_host:='http://www.meteo.nnov.ru/prognoz/writefrc.php';
  potok.t_Logfile:=@Form1.statusFrcList;
  potok.t_request:=Form1.zaprosrequest;
  potok.Priority :=tpNormal;
  potok.OwnerWnd:=Form1.handle;
  potok.Resume;
end;

procedure TFRCThread.Execute;
var i:integer;
begin
  OnTerminate:=Form1.ThreadsDone;
  EnterCriticalSection(CS);
  for i:=0 to t_request.Count-1 do
  begin
    writedb(t_host,t_request.Strings[i]);
    sleep(5);
  end;
  LeaveCriticalSection(CS);
end;

procedure TFRCThread.writedb(const host,str:string);
var URL:string;
    s1:Tstrings;
    newstr,station,hour:string;
begin
  newstr:=StringReplace(str,'&',',',[rfReplaceAll]);
  s1:=TstringList.Create;
  s1.CommaText:=newstr;
  try
    station:=s1.Strings[0];
    Delete(station,1,pos('=',station));
    hour:=s1.Strings[1];
    Delete(hour,1,pos('=',hour));
  except
    station:='undefined';
    hour:='undefined';
  end;
  s1.Free;
  
  url:=host+str;
  t_ms:=TStringStream.Create('');
  try
    GetURL(url);
    t_logFile.LimitLog;
    if (t_ms.DataString='ok') then
      t_logFile.AddLog(ltSuccess,'Прогноз для станции '+station+' на '+hour+' записан на сайт ВВ УГМС')
    else
      if length(t_ms.DataString)=0 then
        t_logFile.AddLog(ltError,'Прогноз для станции '+station+' на '+hour+' не записан на сайт ВВ УГМС. Отсутствует соединение с сервером')
      else
        t_logFile.AddLog(ltError,'Прогноз для станции '+station+' на '+hour+' не записан на сайт ВВ УГМС. '+t_ms.DataString);
  except
    t_logFile.AddLog(ltError,'Прогноз для станции '+station+' на '+hour+' не записан на сайт ВВ УГМС. Сбой в передачи данных на сервер');
  end;
  t_ms.Free;
end;

Function TFRCThread.GetURL(URL:string):boolean;
var hSession,hConnection:Pointer; buf:PChar; i,Len:DWORD;
const buflen:DWORD=16384; nRetr=3;
Begin
 hSession:=nil;  Result:=False;
 for i:=1 to nRetr do
 begin
  hSession:=InternetOpen('Internet MDB Client',INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  if hSession<>nil then break else sleep(1000);
 end;
 if hSession=nil then exit;
 for i:=1 to nRetr do
 begin
  hConnection:=InternetOpenURL(hSession,PChar(URL+#0),Pchar('Accept: */*'),11,INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_PRAGMA_NOCACHE,0);
  if hConnection<>nil then break else sleep(1000);
 end;
 if hConnection=nil then
 begin
  InternetCloseHandle(hSession);
  exit;
 end;
 GetMem(buf,buflen);
 try
  repeat
   if InternetReadFile(hConnection,Pointer(buf),buflen,Len) then
   begin
    if len=0 then begin Result:=true;  break end
    else begin t_ms.WriteBuffer(buf^,len); Result:=false; end;
   end
   else begin break; result:=false; end;
  until false;
 except
  Result:=false;
 end;
 FreeMem(buf,buflen);
 InternetCloseHandle(hConnection);
 InternetCloseHandle(hSession);
End;

end.
