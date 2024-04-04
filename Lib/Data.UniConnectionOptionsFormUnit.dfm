object UniConnectionOptionsForm: TUniConnectionOptionsForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1082' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 297
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    491
    297)
  TextHeight = 21
  object bvlBottom: TBevel
    Left = 24
    Top = 211
    Width = 419
    Height = 12
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
    ExplicitTop = 356
    ExplicitWidth = 564
  end
  object lblServer: TLabel
    Left = 35
    Top = 32
    Width = 79
    Height = 21
    Caption = #1057#1077#1088#1074#1077#1088' '#1041#1044':'
  end
  object lblDatabase: TLabel
    Left = 56
    Top = 72
    Width = 58
    Height = 21
    Caption = #1048#1084#1103' '#1041#1044':'
  end
  object lblLogin: TLabel
    Left = 11
    Top = 114
    Width = 102
    Height = 21
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
  end
  object lblPassword: TLabel
    Left = 58
    Top = 156
    Width = 56
    Height = 21
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object btnSave: TButton
    Left = 178
    Top = 237
    Width = 123
    Height = 34
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 320
    Top = 237
    Width = 123
    Height = 34
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
  object edtServer: TEdit
    Left = 120
    Top = 29
    Width = 323
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    TextHint = #1042#1074#1077#1076#1080#1090#1077' '#1089#1077#1090#1077#1074#1086#1077' '#1080#1084#1103' '#1080#1083#1080' IP '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1041#1044
  end
  object edtDatabase: TEdit
    Left = 120
    Top = 69
    Width = 323
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    TextHint = #1048#1084#1103' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  end
  object edtUserName: TEdit
    Left = 119
    Top = 111
    Width = 324
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    TextHint = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  end
  object edtPassword: TEdit
    Left = 120
    Top = 153
    Width = 323
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 3
    TextHint = #1055#1072#1088#1086#1083#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  end
end
