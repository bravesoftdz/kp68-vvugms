object OKBottomDlg: TOKBottomDlg
  Left = 374
  Top = 177
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 261
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 1
    Top = 1
    Width = 312
    Height = 217
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 12
    Top = 28
    Width = 89
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077'  ip-'#1072#1076#1088#1077#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 12
    Top = 70
    Width = 109
    Height = 14
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1086#1088#1090#1072
  end
  object OKBtn: TButton
    Left = 79
    Top = 231
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Top = 231
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 128
    Top = 25
    Width = 177
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 128
    Top = 68
    Width = 65
    Height = 21
    TabOrder = 3
  end
end
