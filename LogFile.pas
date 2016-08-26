unit logfile;
interface
Uses Windows, SysUtils, Classes, Graphics, Controls,
     StdCtrls, ComCtrls, {ExtDlgs,} ExtCtrls, Registry;

const
    LFLT_INFO=1;
    LFLT_STATUS=2;
    LFLT_ERROR=4;
    LFLT_TRACE=8;
    LFLT_ALL=$FFFF;

type
   TLogType=(ltUnknown,ltInfo,ltStatus,ltError,ltTraceGot,ltTraceSent,ltAttach,ltSuccess);

   TLogFile=Class
    LogList:TListView;
    LogName,LogPath:string;
    tf:System.Text;
    LogOpened:boolean;
    LogLimit:integer;
    Filter:Word;
    lPrefix:string;
    constructor Create(List:TListView; LPath:string);
    destructor destroy; override;
    procedure AddLog(mtype:TLogType; Message:string);
    procedure LoadLog;
    procedure Clearlog;
    procedure CloseLog;
    function SaveLog(fname:string):boolean;
    function ReopenLog:boolean;
    function GetNewLogFileName:string;
    function GetPrevLogFileName:string;
    procedure LimitLog;
   public
    procedure ChangeDirectory(NewDir:string);
    procedure SaveToStrings(ss:TStrings);
    property NewLogName:string read GetNewLogFileName;
    property CurLogName:string read LogName;
    property PrevLogName:string read GetPrevLogFileName;
   end;

implementation
Uses ImgList;

Constructor TLogFile.Create;
Begin
LogOpened:=FALSE;
LogList:=List; LogLimit:=200;
LogPath:=LPath;
LogName:=NewLogName; Filter:=LFLT_ALL; lPrefix:='l';
LogList.SmallImages.ResourceLoad(rtBitmap,'LOGIMAGES2',RGB(255,0,255));
End;

Destructor TLogFile.Destroy;
Begin
 if LogOpened then CloseFile(TF);
End;

Procedure TLogFile.ChangeDirectory;
Begin
 LogPath:=NewDir;
End;

Function TLogFile.GetPrevLogFileName;
var wYear,wMonth,wDay:word; i:integer;
Begin
 DecodeDate(Now-1,wYear,wMonth,wDay);
 if wYear>=2000 then Dec(wYear,2000) else Dec(wYear,1900);
 Result:=Format('%2d%2d%2d.log',[lPrefix,wYear,wMonth,wDay]);
 for i:=1 to length(Result) do if Result[i]=' ' then Result[i]:='0';
 Result:=LogPath+Result;
End;

Function TLogFile.GetNewLogFileName;
var wYear,wMonth,wDay:word; i:integer;
Begin
 DecodeDate(Now,wYear,wMonth,wDay);
 if wYear>=2000 then Dec(wYear,2000) else Dec(wYear,1900);
 Result:=Format('%2d%2d%2d.log',[wYear,wMonth,wDay]);
 for i:=1 to length(Result) do if Result[i]=' ' then Result[i]:='0';
 Result:=LogPath+Result;
End;

procedure TLogFile.AddLog;
var li:TListItem; imi:integer; dt,fname:string;
Begin
 imi:=2; 
 case mtype of
   ltError: if (Filter and LFLT_ERROR)<>0 then imi:=0 else exit;
   ltSuccess: imi:=9;
   ltTraceSent: if (Filter and LFLT_TRACE)<>0 then imi:=7 else exit;
   ltTraceGot: if (Filter and LFLT_TRACE)<>0 then imi:=8 else exit;
   ltInfo: if (Filter and LFLT_INFO)<>0 then imi:=1 else exit;
   ltStatus: if (Filter and LFLT_STATUS)<>0 then imi:=3 else exit;
   ltAttach: imi:=4;
 end;
 li:=LogList.Items.Add;
 li.ImageIndex:=imi;
 dt:=DateToStr(now)+' '+TimeToStr(now);li.SubItems.Add(dt);
 li.SubItems.Add(message);
 LogList.Scroll(0,LogList.Items.Count*13);
 LogList.Refresh;
 if not LogOpened then
 begin
  FName:=GetNewLogFileName;
  System.Assign(tf,FName);
  try
   System.Append(tf);
  except
   System.Rewrite(tf);
  end; 
  LogOpened:=TRUE;
 end;
 Writeln(tf,imi,'; '+dt+'; '+Message);
End;

procedure TLogFile.LimitLog;
Begin
if LogList.Items.Count<LogLimit+100 then exit;
LogList.Items.BeginUpdate;
while LogList.Items.Count>LogLimit do LogList.Items.Delete(0);
LogList.Items.EndUpdate;
End;

procedure TLogFile.LoadLog;
var rtf:System.Text; s,dt:string;
var li:TListItem; imi,p:integer;
Begin
 AssignFile(rtf,GetNewLogFileName);
 try
  Reset(rtf);
 except
  exit;
 end;
 while not eof(rtf) do
 begin
  li:=LogList.Items.Add;
  Readln(rtf,s);
  p:=Pos(';',s); imi:=StrToInt(Copy(s,1,p-1)); delete(s,1,p+1); li.imageindex:=imi;
  p:=Pos(';',s); dt:=Copy(s,1,p-1); delete(s,1,p+1);
  li.Subitems.Add(s); li.SubItems.Add(dt);
 end;
 CloseFile(rtf);
 LogList.Scroll(0,LogList.Items.Count*16);
End;

Procedure TLogFile.CloseLog;
Begin
if LogOpened then CloseFile(tf);
LogOpened:=FALSE;
End;

Procedure TLogFile.ClearLog;
Begin
LogList.Items.BeginUpdate;
LogList.Items.Clear;
LogList.Items.EndUpdate;
CloseLog;
AssignFile(tf,GetNewLogFileName);
try
 Rewrite(tf);
except
 LogOpened:=FALSE;
 Exit;
end;
LogOpened:=TRUE;
End;

Function TLogFile.ReopenLog;
var LName:string;
Begin
 if LogOpened then CloseFile(TF);
 LName:=GetNewLogFileName;
 if LName<>LogName then Result:=TRUE else Result:=FALSE;
 LogName:=LName;
 AssignFile(tf,LogName);
 try
  Append(tf);
 except
  Rewrite(tf);
 end;
 LogOpened:=TRUE;
End;

Function TLogFile.SaveLog;
var t:system.text; c,i:integer;
Begin
 Result:=FALSE;
 AssignFile(t,fname);
 try
  Rewrite(t);
 except
  exit;
 end;
 c:=LogList.Items.Count;
 if c>0 then for i:=0 to c-1 do
  Writeln(t,LogList.Items[i].ImageIndex,'; ',LogList.Items[i].SubItems[1],'; ',
           LogList.Items[i].SubItems[0]);
  CloseFile(t);
  Result:=TRUE;
End;

Procedure TLogFile.SaveToStrings;
var i:integer;
Begin
 if LogList.Items.Count>0 then
 for i:=0 to LogList.Items.Count-1 do
  ss.Add(LogList.Items[i].SubItems[1]+' - '+
           LogList.Items[i].SubItems[0]);
End;


end.
