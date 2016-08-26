unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActiveX, DateUtils, ImgList,logfile,
  ExtCtrls,IniFiles, IdPOP3,IdMessage,IdBaseComponent, IdCoderHeader,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient;


type
TMyIdMessage = class(TIdMessage)
  protected
  procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
  constructor Create(AOwner:TComponent);
end;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    buttonAutoStart: TButton;
    GroupBox1: TGroupBox;
    ButtonLoadTxtFile: TButton;
    GroupBox5: TGroupBox;
    Memo1: TMemo;
    Encode: TButton;
    GroupBox6: TGroupBox;
    ListView5: TListView;
    WriteWeb: TButton;
    GroupBox7: TGroupBox;
    ImageList1: TImageList;
    ListView6: TListView;
    Label1: TLabel;
    Memo2: TMemo;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    buttonAutoStop: TButton;
    GroupBox3: TGroupBox;
    ListView2: TListView;
    Timer1: TTimer;
    IdPOP31: TIdPOP3;
    Timer2: TTimer;
    Label3: TLabel;
    Label2: TLabel;
    Timer3: TTimer;
    procedure ButtonLoadTxtFileClick(Sender: TObject);
    procedure EncodeClick(Sender: TObject);
    procedure WriteWebClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure buttonAutoStartClick(Sender: TObject);
    procedure buttonAutoStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    function GetFileNameFromBrowse(hOwner: LongInt; var sFile: string; sInitDir, sDefExt, sFilter, sTitle: string): Boolean;
    procedure ParsingData(Memo:TMemo;ListView:TListView);
    function RasborKP68(var strPrognoz:string;ListView:TListView;Date:TDateTime):boolean;
    function loadKP68():boolean;
  public
    statusFrcList,statusAutoFrcList,statusFrc: TLogFile;
    li:TListItem;
    procedure writelog(var error:string);
    procedure ThreadsDone(Sender: TObject);
    { Public declarations }
  end;


var
  Form1: TForm1;
  bTabSheet1Show:boolean=false;
  bTabSheet2Show:boolean=false;
  strPathApp:string;

implementation

uses setup;

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
inherited;
  Self.OnInitializeISO:= OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet := 'koi8-r';
  VHeaderEncoding := '8';
end;

function SHGetFileNameFromBrowse(hOwner: LongInt; sFile: LPWSTR; nMaxFile:
  LongInt;
  sInitDir: LPWSTR; sDefExt, sFilter, sTitle: LPWSTR): Boolean; stdcall; external 'Shell32.dll' index 63;

function TForm1.GetFileNameFromBrowse(hOwner: LongInt; var sFile: string;
  sInitDir, sDefExt, sFilter, sTitle: string): Boolean;
var
  sFileW, sInitDirW, sDefExtW, sFilterW, sTitleW: PWideChar;
  sInitDirL, sDefExtL, sFilterL, sTitleL: Integer;
begin
  sFileW := CoTaskMemAlloc(255 * sizeof(WideChar));
  StringToWideChar(SFile, SFileW, 255);
  SInitDirL := Length(sInitDir) + 1;
  sInitDirW := CoTaskMemAlloc(SInitDirL * sizeof(WideChar));
  StringToWideChar(SInitDir, SInitDirW, sInitDirL);
  SDefExtL := Length(sDefExt) + 1;
  sDefExtW := CoTaskMemAlloc(SDefExtL * sizeof(WideChar));
  StringToWideChar(SDefExt, SDefExtW, sDefExtL);
  SFilterL := Length(sFilter) + 1;
  sFilterW := CoTaskMemAlloc(SFilterL * sizeof(WideChar));
  StringToWideChar(SFilter, SFilterW, sFilterL);
  STitleL := Length(sTitle) + 1;
  sTitleW := CoTaskMemAlloc(STitleL * sizeof(WideChar));
  StringToWideChar(STitle, STitleW, sTitleL);
  Result := SHGetFileNameFromBrowse(hOwner, sFileW, Integer(sFileW), sInitDirW,
    sDefExtW, sFilterW, sTitleW);
  SFile := sFileW;
  CoTaskMemFree(sFileW);
  CoTaskMemFree(sInitDirW);
  CoTaskMemFree(sDefExtW);
  CoTaskMemFree(sFilterW);
  CoTaskMemFree(sTitleW);
end;

{$R *.dfm}

procedure TForm1.ButtonLoadTxtFileClick(Sender: TObject);
var temp:string;
    s1:TStringList;
    i:integer;
begin
  if GetFileNameFromBrowse(handle, temp, 'c:Install', '*.txt','Текстовые файлы'#0'*.txt'#0'Все файлы'#0'*.*'#0#0      , 'Название') then
  begin
    Memo1.Lines.Clear;
    s1:=TstringList.Create;
    try
      s1.LoadFromFile(temp);
    except
      on E:Exception do begin showmessage('Не возможно открыть файл '+temp);
      exit;
      end;
    end;

    temp:='';

    for i:=0 to s1.Count-1 do
    begin
      temp:=temp+s1.Strings[i];
      if ((pos('=',temp)<>length(temp)) and (i>1)) then continue
      else
        Delete(temp, pos('=',temp), length(temp));
      Memo1.Lines.Add(temp);
      temp:='';
    end;

    Encode.Enabled:=true;
    s1.Free;
  end;
end;

procedure TForm1.EncodeClick(Sender: TObject);
var error: string;
begin
  ListView5.Clear;
  ListView6.Clear;
  if (Memo1.Lines.Count>2) then ParsingData(Memo1,ListView5)
  else
  begin
    error:='Неправильный формат КП-68. Отсутствует дата составления прогноза. Файл не раскодирован';
    writelog(error);
    exit;
  end;

  //if (zaprosrequest.Count>0) and (bTabSheet2Show=true) then  WriteWeb.Enabled:=true;
  
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var IniFile:TIniFile;
    i:integer;
    strtimeUpdate:string;
    s1:TStrings;
    TimeNow,TimeUpdate:TDateTime;
    HourNow,MinNow,SecNow,MSecNow,HourUp,minUp:Word;
begin
  IniFile := TIniFile.Create(strPathApp+'meteocfg.ini');
  with IniFile do strtimeUpdate:=ReadString('frc3','timeUpdate','');
  IniFile.Free;

  DecodeTime(Now,HourNow,MinNow,SecNow,MSecNow);
  TimeNow:=encodeTime(HourNow,MinNow,0,0);

  s1:=TStringList.Create;
  s1.CommaText:=strtimeUpdate;
  if (s1.Count=0) then s1.Add('14:30');
  for i:=0 to s1.Count-1 do
  begin
    HourUp:=strToIntDef(Copy(s1.Strings[i],1,Pos(':',s1.Strings[i])-1),0);
    MinUp:=strToIntDef(Copy(s1.Strings[i],Pos(':',s1.Strings[i])+1,Length(s1.Strings[i])),0);
    TimeUpdate:=encodeTime(HourUp,MinUp,0,0);
    if (TimeUpdate=TimeNow) then
    begin
      Timer1.Interval:=60000;
      label2.Caption:='Обновление прогноза...';
      Timer3.Enabled:=false;
      Memo2.Lines.Clear;
      ListView1.Clear;
      ListView2.Clear;
      if (loadKP68()=true) then
      begin
        ParsingData(Memo2,ListView1);
        //if (zaprosrequest.Count>0) and (bTabSheet1Show=true) then  initpotokAuto;
      end;
      break;
    end;
    if (TimeUpdate<>TimeNow) then begin Timer3.Enabled:=true; Timer1.Interval:=1000; end;
  end;
  s1.Free;
end;

function TForm1.loadKP68():boolean;
var IniFile:TIniFile;
    host,port,username,password,error:string;
    count:integer;
    MessageBase:TMyIdMessage;
    s1:Tstrings;
    i:integer;
begin
  Result:=true;
  IniFile := TIniFile.Create(strPathApp+'meteocfg.ini');
  with IniFile do
  begin
    host:=ReadString('frc3','host','');
    port:=ReadString('frc3','port','');
    username:=ReadString('frc3','username','');
    password:=ReadString('frc3','password','');
  end;
  IniFile.Free;
  IdPOP31:=TIdPOP3.Create(nil);
  IdPOP31.Host:=host;
  IdPOP31.Port:=strTointDef(port,110);
  IdPOP31.Username:=username;
  IdPOP31.Password:=password;
  try
    IdPOP31.Connect;
  except
    IdPOP31.Free;
    error:='Не удалось установить соединение с '+host+ '. Попробуйте записать данные на сайт в ручном режиме';
    writelog(error);
    Result:=false;
    exit;
  end;
  if (IdPOP31.Connected=true) then
  begin
    count:=IdPOP31.CheckMessages;
    if count>0 then
    begin
      MessageBase:=TMyIdMessage.Create(nil);
      MessageBase.ContentType:='text/plain';
      try
        if IdPOP31.Retrieve(count, MessageBase) then
        begin
          s1:=Tstringlist.Create;
          s1.AddStrings(MessageBase.Body);
          s1.SaveToFile(strPathApp+'frckp68.txt');
          MessageBase.Free;
          for i:=0 to s1.Count-1 do
            if length(s1.Strings[i])>5 then Memo2.Lines.Add(s1.Strings[i]);
          //Memo2.Lines.SaveToFile(strPathApp+'frckp68.txt');
          s1.Free;
        end;
      except
        IdPOP31.Free;
        error:='Не удалось прочитать данные с прогнозом в коде КП-68 с сервера '+host+'. Попробуйте обновить прогноз на сайте вручную.';
        writelog(error);
        Result:=false;
        exit;
      end;
    end
    else
    begin
      error:='Отсутствуют данные с прогнозом в коде КП-68';
      writelog(error);
      Result:=false;
    end;
    IdPOP31.Disconnect;
  end;
  IdPOP31.Free;
end;


procedure TForm1.ParsingData(Memo:TMemo;ListView:TListView);
var i:integer;
    temp, error, strDate:string;
    s1: TStringList;
    Day, Month, Year: Word;
begin

  s1:=TstringList.Create;
  s1.CommaText:=Memo.Lines[1];

  temp:=s1.Strings[1];

  if (length(temp)<>6) or (strToInt64Def(temp,0)=0) then // Проверка даты
  begin
    error:='Неправильный формат КП-68. Неверный формат даты прогноза. Файл не раскодирован'; writelog(error);
    exit;
  end;

  //zaprosrequest.Clear;

  strDate:=s1.Strings[1];
  try
    Day:=strToIntdef(strDate[1]+strDate[2],24);
    Month:=strToIntdef(strDate[3]+strDate[4],11);
    Year:=2000+strToIntdef((strDate[5]+strDate[6]),2005);
  except
    error:='Неправильный формат КП-68. Неверный формат даты прогноза. Файл не раскодирован'; writelog(error);
    exit;
  end;

  //DateFRC:=encodeDate(Year, Month, Day);

  for i:=2 to Memo.Lines.Count-1 do
  begin
    temp:=Memo.Lines.Strings[i];
    //RasborKP68(temp,ListView,DateFRC);
  end;
  
  s1.Free;
end;

function TForm1.RasborKP68(var strPrognoz:string;ListView:TListView;Date:TDateTime):boolean;
var i,j,k,weather,groupNumber:integer;
    s1:TStringList;
    error, temp, strD, strN:string;

begin
  Result:=true;

  li:=ListView.Items.Add;

  s1:=TStringList.Create;
  s1.CommaText:=strPrognoz;

  temp:=s1.Strings[0];

  //Индекс
  
  if (StrToIntDef(temp,0)<>5) or (StrToIntDef(temp,0)=0) then
  begin
    Result:=false;
    error:='Неправильный формат КП-68. Неправильный индекс станции';
    writelog(error);
    s1.Free;
    exit;
  end
  else
  begin
    li.ImageIndex:=9;
    li.SubItems.Add(temp);
    s1.Delete(0);
  end;

  {for i:=0 to 8 do
    if i=StrToIntDef(s1.Strings[i][1],-1) then break;
    if (i=8) then
    begin
    end;
  end; }

  { case groupNumber of
    0: if createDate(temp)=false then begin s1.Free; exit; end;//Срок
    1: if createTN(temp)=false then begin s1.Free; exit; end;//Значение температуры ночью
    2: if createTD(temp)=false then begin s1.Free; exit; end;//Значение температуры днём
    3: if createClPrN(temp)=false then begin s1.Free; exit; end;//Облачность и осадки ночью
    4: if createClPrD(temp)=false then begin s1.Free; exit; end;//Облачность и осадки днём
    5: if createWdWsN(temp)=false then begin s1.Free; exit; end;//Ветер ночью
    6: if createWdWsD(temp)=false then begin s1.Free; exit; end;//Ветер днём
   end;
   i:=i+1;
  end; 

  //Другие явления
  for j:=8 to s1.Count-1 do
  begin
    temp:=s1.Strings[j];
    weather:=strToIntdef(temp[2]+temp[3],-1);
    if weather<>-1 then
      for k:=0 to length(masweather)-1 do
        if weather=masweather[k] then
          if (temp[1]='7') then
            strN:=strN+' '+masweathertext[k]+' '
          else strD:=strD+' '+masweathertext[k]+' ';
  end;
  li.SubItems.Add(strN);
  li.SubItems.Add(strD);
  statusFrc.AddLog(ltStatus,'Прогноз для станции '+li.SubItems.Strings[0]+' на '+li.SubItems.Strings[1]+' часа успешно раскодирован');
  ListView.Items.BeginUpdate;
  ListView.Items.EndUpdate;

  zaprosrequest.Add('?index='+li.SubItems.Strings[0]+'&date='+FormatDateTime('mm/d/yyyy',date)+
              '&tn='+li.SubItems.Strings[2]+'&td='+li.SubItems.Strings[3]+
              '&cln='+li.SubItems.Strings[4]+'&cltextn='+li.SubItems.Strings[5]+
              '&prn='+li.SubItems.Strings[6]+'&prtextn='+li.SubItems.Strings[7]+
              '&cld='+li.SubItems.Strings[8]+'&cltextd='+li.SubItems.Strings[9]+
              '&prd='+li.SubItems.Strings[10]+'&prtextd='+li.SubItems.Strings[11]+
              '&wdn='+li.SubItems.Strings[12]+'&wsn='+li.SubItems.Strings[13]+
              '&wdd='+li.SubItems.Strings[14]+'&wsd='+li.SubItems.Strings[15]+
              '&textn='+li.SubItems.Strings[16]+'&textd='+li.SubItems.Strings[17]);
  s1.Free; }
end;

procedure TForm1.WriteWebClick(Sender: TObject);
begin
  WriteWeb.Enabled:=false;
  //initPotokManual;
end;

procedure TForm1.ThreadsDone(Sender: TObject);
begin
  WriteWeb.Enabled:=true;
end;

procedure TForm1.buttonAutoStartClick(Sender: TObject);
begin
  Timer1.Enabled:=true;
  Timer1.Interval:=1;
  buttonAutoStart.Enabled:=false;
  buttonAutoStop.Enabled:=true;
  Timer3.Enabled:=true;
end;

procedure TForm1.buttonAutoStopClick(Sender: TObject);
begin
  Timer1.Enabled:=false;
  buttonAutoStop.Enabled:=false;
  buttonAutoStart.Enabled:=true;
  label2.Caption:='Сервис остановлен. Для запуска нажмите кнопку "Запустить"';
  Timer3.Enabled:=false;
end;

procedure TForm1.writelog(var error:string);
begin
  statusFrc.AddLog(ltError,error);
end;

procedure TForm1.FormCreate(Sender: TObject);
var buf: array[0..1024] of char;
    k:integer;
begin
  GetModuleFilename(hInstance, @buf, SizeOf(buf));
  k:=LastDelimiter('\',buf);
  k:=k+1;
  strPathApp:=buf;
  Delete(strPathApp,k,Length(buf)-k+1);
  ListView1.SmallImages:=ImageList1;
  ListView2.SmallImages:=ImageList1;
  statusAutoFrcList:=TLogFile.Create(ListView2,'frcAuto');
  ListView6.SmallImages:=ImageList1;
  ListView5.SmallImages:=ImageList1;
  statusFrcList:=TLogFile.Create(ListView6,'frc');
  //zaprosrequest:=TStringList.Create;//стринглист с реквестом
  //InitializeCriticalSection(CS);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  statusAutoFrcList.Free;
  statusFrcList.Free;
  //zaprosrequest.Free;
  //DeleteCriticalSection(CS);
end;

procedure TForm1.TabSheet2Show(Sender: TObject);
begin
  bTabSheet1Show:=false;
  bTabSheet2Show:=true;
  statusFrc:=statusFrcList;
end;

procedure TForm1.TabSheet1Show(Sender: TObject);
begin
  bTabSheet2Show:=false;
  bTabSheet1Show:=true;
  statusFrc:=statusAutoFrcList;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var NowTime:TDateTime;
begin
  NowTime:=Now;
  label3.Caption:=FormatDateTime('dd.mm.yyyy hh:mm:ss',NowTime); //текущее время
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var IniFile:TIniFile;
    i:integer;
    strtimeUpdate:string;
    s1:TStrings;
    Present:TDateTime;
    HourUp,minUp:Word;
    masTimeUpdate:array of TDateTime;
begin
  IniFile := TIniFile.Create(strPathApp+'meteocfg.ini');
  with IniFile do strtimeUpdate:=ReadString('frc3','timeUpdate','');
  IniFile.Free;

  Present:=Now;
  s1:=TStringList.Create;
  s1.CommaText:=strtimeUpdate;
  setLength(masTimeUpdate,s1.Count);
  if (s1.Count=0) then s1.Add('14:30');
  for i:=0 to s1.Count-1 do
  begin
    HourUp:=strToIntDef(Copy(s1.Strings[i],1,Pos(':',s1.Strings[i])-1),0);
    MinUp:=strToIntDef(Copy(s1.Strings[i],Pos(':',s1.Strings[i])+1,Length(s1.Strings[i])),0);
    masTimeUpdate[i]:=encodeDateTime(strToIntDef(FormatDateTime('yyyy',Present),2006),strToIntDef(FormatDateTime('mm',Present),2006),strToIntDef(FormatDateTime('dd',Present),2006),HourUp,MinUp,0,0);
  end;
  for i:=0 to length(masTimeUpdate)-1 do
  begin
    if Present<=masTimeUpdate[i] then
    begin
      label2.Caption:='Следующая сессия обновления прогноза '+FormatDateTime('dd.mm.yyyy '+s1.Strings[i],Present);
      break;
    end;
    if (i=length(masTimeUpdate)-1) then
    begin
      Present:=incDay(Present);
      label2.Caption:='Следующая сессия обновления прогноза '+FormatDateTime('dd.mm.yyyy '+s1.Strings[0],Present);
    end;
  end;
  masTimeUpdate:=nil;
  s1.Free;
end;

end.

