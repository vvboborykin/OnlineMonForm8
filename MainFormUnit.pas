{*******************************************************
* Project: OnlineMonForm8
* Unit: MainFormUnit.pas
* Description: Главная форма приложения
*
* Created: 31.03.2024 11:06:51
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.StdCtrls, System.Threading,
  System.DateUtils, Task.ProgressFormUnit, Task.ProgressControllerUnit,
  Vcl.ExtCtrls, ReportBuilderModuleUnit, Data.SqlDatabaseConnectionDataUnit;

type
  TMainForm = class(TForm)
    dtpDate: TDateTimePicker;
    lblDate: TLabel;
    btnStart: TButton;
    aclMain: TActionList;
    actStart: TAction;
    chkUseInogor: TCheckBox;
    rgEndField: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  strict private
    function BuildConnParams: TSqlDatabaseConnectionData;
    function CreateAndInitReportBuildParameters: TReportBuildParams;
    function GetIniFileName: string;
    procedure LoadOptionsFromIni;
    procedure SaveOptionsToIni;
    procedure StartTask;
  public
  end;

var
  MainForm: TMainForm;

implementation

uses
  Data.ConnectionOptionsStorageUnit, IniOptionsUnit, Ini.IniFileNamesUnit;


{$R *.dfm}

resourcestring
  STaskCaption =
    'Формирование ежедневного отчета по выполнению плановых показателей';

procedure TMainForm.FormCreate(Sender: TObject);
begin
  dtpDate.DateTime := DateOf(Now);
  LoadOptionsFromIni();
end;

procedure TMainForm.actStartExecute(Sender: TObject);
begin
  StartTask();
end;

function TMainForm.BuildConnParams: TSqlDatabaseConnectionData;
begin
  Result := TSqlDatabaseConnectionData.Create;
  ConnectionOptionsStorage.Load(Result);
end;

function TMainForm.CreateAndInitReportBuildParameters: TReportBuildParams;
begin
  Result := TReportBuildParams.Create;
  Result.ReportDate := dtpDate.Date;
  Result.UseInogorAccounts := chkUseInogor.Checked;
  Result.EndDateField := rgEndField.ItemIndex;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptionsToIni();
end;

function TMainForm.GetIniFileName: string;
begin
  Result := IniFileNames.ApplicationIniFileName();
end;

procedure TMainForm.LoadOptionsFromIni;
begin
  IniOptions.LoadFromFile(GetIniFileName());
  chkUseInogor.Checked := IniOptions.OptionsSection.UseInogor;
  rgEndField.ItemIndex := IniOptions.OptionsSection.DateEndField;
end;

procedure TMainForm.SaveOptionsToIni;
begin
  IniOptions.OptionsSection.UseInogor := chkUseInogor.Checked;
  IniOptions.OptionsSection.DateEndField := rgEndField.ItemIndex;
  IniOptions.SaveToFile(GetIniFileName());
end;

procedure TMainForm.StartTask;
begin
  TProgressForm.RunTaskModal(
    procedure(AProgress: IProgressController)
    begin
      var vReportBuilder := TReportBuilderModule.Create(nil);

      var vReportBuildParams := CreateAndInitReportBuildParameters();
      vReportBuildParams.Progress := AProgress;

      var vConnParams := BuildConnParams();
      try
        vReportBuilder.ExecuteReport(vReportBuildParams, vConnParams);
      finally
        vReportBuilder.Free;
        vReportBuildParams.Free;
        vConnParams.Free;
      end;
    end, STaskCaption);
end;

end.

