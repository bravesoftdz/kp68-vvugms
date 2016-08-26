unit decodefunct;

interface

uses SysUtils,ComCtrls;

function createDate(str:string):boolean;
function createTN(str:string):boolean;
function createTD(str:string):boolean;
function createClPrN(str:string):boolean;
function createClPrD(str:string):boolean;
function createWdWsN(str:string):boolean;
function createWdWsD(str:string):boolean;

implementation

uses main;

function createDate(str:string):boolean; //Срок
var error:string;
begin
  result:=true;
  if(StrToIntDef(str,0)=0) then
  begin
    result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' не раскодирован. Неправильный формат КП-68. Неправильный срок прогноза. ';
    Form1.writelog(error);
  end
  else Form1.li.SubItems.Add(str);
end;

function createTN(str:string):boolean;//Значение температуры ночью
var error:string;
begin
  result:=true;
  if (length(str)<3)or(StrToIntDef(str,0)=0) then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения ночной температуры. ';
    Form1.writelog(error);
  end
  else if str[2]='0' then Form1.li.SubItems.Add(IntToStr(StrToIntDef(str[3]+str[4],0)))
  else Form1.li.SubItems.Add(IntToStr(StrToIntDef(str[3]+str[4],0)*(-1)));
end;

function createTD(str:string):boolean;//Значение температуры днём
var error:string;
begin
  result:=true;
  if (length(str)<3)or(StrToIntDef(str,0)=0) then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения дневной температуры. ';
    Form1.writelog(error);
  end
  else if str[2]='0' then Form1.li.SubItems.Add(IntToStr(StrToIntDef(str[3]+str[4],0)))
  else Form1.li.SubItems.Add(IntToStr(StrToIntDef(str[3]+str[4],0)*(-1)));
end;

function createClPrN(str:string):boolean; //Облачность и осадки ночью
var error:string;
    j:integer;
begin
  result:=true;
  //Облачность ночью
  if (strToIntDef(str[2],-1)=-1) or (length(str)<2) then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения облачности ночью. ';
    Form1.writelog(error);
    exit;
  end
  else Form1.li.SubItems.Add(intToStr(masobl[strToIntDef(str[2],-1)]));
  Form1.li.SubItems.Add(masobltext[masobl[strToIntDef(str[2],-1)]]);

  //Осадки ночью
  if (strToIntdef(str[4]+str[5],-1)=-1)or(length(str)<5) then
  begin
      Result:=false;
      error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения осадков ночью. ';
      Form1.writelog(error);
      exit;
  end
  else
  begin
  for j:=0 to length(maspr)-1 do
    if (strToIntdef(str[4]+str[5],-1)=maspr[j]) then
    begin
      Form1.li.SubItems.Add(intToStr(newmaspr[j]));
      Form1.li.SubItems.Add(masprtext[j]);
      break;
    end;
    if j=length(maspr)-1 then
    begin
      Result:=false;
      error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения осадков ночью. ';
      Form1.writelog(error);
      exit;
    end;
  end;
end;

function createClPrD(str:string):boolean; //Облачность и осадки днём
var error:string;
    j:integer;
begin
  result:=true;
  //Облачность днём
  if (strToIntDef(str[2],-1)=-1) or (length(str)<2) then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения облачности днём. ';
    Form1.writelog(error);
    exit;
  end
  else Form1.li.SubItems.Add(intToStr(masobl[strToIntDef(str[2],-1)]));
  Form1.li.SubItems.Add(masobltext[masobl[strToIntDef(str[2],-1)]]);

  //Осадки днём
  if (strToIntdef(str[4]+str[5],-1)=-1)or(length(str)<5) then
  begin
      Result:=false;
      error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения осадков днём. ';
      Form1.writelog(error);
      exit;
  end
  else
  begin
  for j:=0 to length(maspr)-1 do
    if (strToIntdef(str[4]+str[5],-1)=maspr[j]) then
    begin
      Form1.li.SubItems.Add(intToStr(newmaspr[j]));
      Form1.li.SubItems.Add(masprtext[j]);
      break;
    end;
    if j=length(maspr)-1 then
    begin
      Result:=false;
      error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения осадков днём. ';
      Form1.writelog(error);
      exit;
    end;
  end;
end;

function createWdWsN(str:string):boolean;//Ветер ночью
var error:string;
    j,ws:integer;
begin
  result:=true;
  if (strToIntdef(str[2]+str[3],-1)=-1)or(length(str)<7)then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения направления ветра ночью. ';
    Form1.writelog(error);
    exit;
  end
  else
    for j:=0 to length(maswd)-1 do
    begin
        if strToIntdef(str[2]+str[3],-1)=maswd[j] then
        begin
          Form1.li.SubItems.Add(intToStr(newmaswd[j]));
          break;
        end;
        if j=length(maspr)-1 then
        begin
          Result:=false;
          error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения направления ветра ночью. ';
          Form1.writelog(error);
          exit;
        end;
    end;

  if (strToIntdef(str[4]+str[5],-1)=-1) then
  begin
    Result:=false;
    error:='Прогноз для станции '+ Form1.li.SubItems.Strings[0]+' на '+ Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения скорости ветра ночью. ';
    Form1.writelog(error);
    exit;
  end
  else
  begin
    ws:=strToIntdef(str[4]+str[5],-1);
    if (ws=8) then
      Form1.li.SubItems.Add('0-5')
    else if (ws=9) then
      Form1.li.SubItems.Add('Штиль')
    else
      if (ws-2>0) then
        Form1.li.SubItems.Add(intTostr(ws-2)+'-'+intTostr(ws+3))
      else Form1.li.SubItems.Add('0-5');
  end;
end;

function createWdWsD(str:string):boolean;//Ветер днём
var error:string;
    j,ws:integer;
begin
  result:=true;
  if (strToIntdef(str[2]+str[3],-1)=-1)or(length(str)<7)then
  begin
    Result:=false;
    error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения направления ветра днём. ';
    Form1.writelog(error);
    exit;
  end
  else
    for j:=0 to length(maswd)-1 do
    begin
        if strToIntdef(str[2]+str[3],-1)=maswd[j] then
        begin
          Form1.li.SubItems.Add(intToStr(newmaswd[j]));
          break;
        end;
        if j=length(maswd)-1 then
        begin
          Result:=false;
          error:='Прогноз для станции '+Form1.li.SubItems.Strings[0]+' на '+Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения направления ветра днём. ';
          Form1.writelog(error);
          exit;
        end;
    end;

  if (strToIntdef(str[4]+str[5],-1)=-1) then
  begin
    Result:=false;
    error:='Прогноз для станции '+ Form1.li.SubItems.Strings[0]+' на '+ Form1.li.SubItems.Strings[1]+' часа не раскодирован. Неправильный формат КП-68. Неверный формат кода для значения скорости ветра днём. ';
    Form1.writelog(error);
    exit;
  end
  else
  begin
    ws:=strToIntdef(str[4]+str[5],-1);
    if (ws=8) then
      Form1.li.SubItems.Add('0-5')
    else if (ws=9) then
      Form1.li.SubItems.Add('Штиль')
    else
      if (ws-2>0) then
        Form1.li.SubItems.Add(intTostr(ws-2)+'-'+intTostr(ws+3))
      else Form1.li.SubItems.Add('0-5');
  end;
end;



end.
