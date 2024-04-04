object ProgressForm: TProgressForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  Caption = #1060#1086#1085#1086#1074#1072#1103' '#1079#1072#1076#1072#1095#1072
  ClientHeight = 376
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 10
  Padding.Top = 10
  Padding.Right = 10
  Padding.Bottom = 10
  Position = poScreenCenter
  TextHeight = 15
  object pbTask: TProgressBar
    AlignWithMargins = True
    Left = 10
    Top = 67
    Width = 608
    Height = 17
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 604
  end
  object btnCancel: TButton
    AlignWithMargins = True
    Left = 13
    Top = 13
    Width = 602
    Height = 44
    Margins.Bottom = 10
    Align = alTop
    Cancel = True
    Caption = #1055#1088#1077#1088#1074#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1079#1072#1076#1072#1095#1080
    TabOrder = 1
    OnClick = btnCancelClick
    ExplicitWidth = 598
  end
  object mmoLog: TMemo
    Left = 10
    Top = 94
    Width = 608
    Height = 272
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
    ExplicitWidth = 604
    ExplicitHeight = 271
  end
end
