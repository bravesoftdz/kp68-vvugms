unit classTFrc;

interface

uses Classes;

const masobl: array [0..8] of integer =(0,0,1,1,2,2,3,3,4);
const masobltext:array[0..4] of string=('����','�����������','������� � ������������','�������','��������');
const maspr:array[0..36] of integer=(0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,
                                     21,22,23,24,25,26,50,51,52,53,54,55,56,57,58,59,
                                     60,61,62);
const masprtext:array[0..36] of string=('��� �������','��� �������','��� �������','��������� �����','��������� �����',
                                        '��������� �����','�����','�����','�����','�����','����� �� ������','����� �� ������',
                                        '������� �����','������� �����','������� �����','������� ����� �� ������','������� ����� �� ������',
                                        '������� �����','������� ����� �� ������','������� ����� �� ������','����� �� ������','����� �� ������',
                                        '����� �� ������','����� �� ������','��� �������','��� �������','��� �������','��������� ����',
                                        '����','����','����','������� ����','������� ����','������� ����','������� ����','������� ����','������� ����');
const newmaspr:array[0..36] of integer=(0,0,0,1,1,1,2,2,2,2,3,3,4,4,4,5,5,4,5,5,3,3,3,3,0,0,0,6,7,7,7,8,8,8,8,8,8);

const maswd:array[0..9] of integer=(5,9,14,18,23,27,32,36,99,0);
const newmaswd:array[0..9] of integer=(2,3,4,5,6,7,8,1,9,0);
const masweather:array[0..27] of integer=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,30,31,40,41,42,50,51,52,53,54,55,56,57);
const masweathertext:array[0..27] of string=('�����','�����','����','������','������� ����','������� ����','������','���������� �� �������',
                                         '��������','��������� ������� ����� �� �������� � ��������','�����','������� �����',
                                         '������� ����','���������','������������ �������� ���������','�����','������',
                                         '�����','����','������� ������ �� �������','����������','�����������','����������',
                                         '������ ����������','�����������','������ �����������','�������� ������','���������� ������');


implementation

type TFrcRecord=record
  index:integer;
  advance_time:TDateTime;
  mintN:integer;
  maxtN:integer;
  mintD:integer;
  maxtD:integer;
  clN:integer;
  clD:integer;
  prN:integer;
  prD:integer;
  wdN:integer;
  wdD:integer;
  wsN1:integer;
  wsN2:integer;
  wsD1:integer;
  wsD2:integer;
  textN:string;
  textD:string;
  cltextN:string;
  cltextD:string;
  prtextN:string;
  prtextD:string;
end;

type TFrcClass=class
  frcRecord: TFrcRecord;

end;

end.
