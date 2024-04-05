{*******************************************************
* Project: OnlineMonForm8
* Unit: ReportBuilderModuleUnit.pas
* Description: Модуль формирования отчета формы 8
*
* Created: 30.03.2024 8:49:12
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit ReportBuilderModuleUnit;

interface

uses
  System.SysUtils, System.Classes, DateUtils, FireDAC.Stan.Intf, System.StrUtils,
  Task.ProgressControllerUnit, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  System.Variants, System.IOUtils, Winapi.ActiveX, MemDS, DBAccess, Uni,
  UniProvider, MySQLUniProvider, MsOffice.Excel.ExcelServiceUnit,
  Data.UniDataModuleUnit,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>TReportBuildParams
  /// Параметры формирования отчета формы 8
  /// </summary>
  TReportBuildParams = class
  strict private
    FEndDateField: Integer;
    FProgress: IProgressController;
    FReportDate: TDateTime;
    FUseInogorAccounts: Boolean;
  public
    property EndDateField: Integer read FEndDateField write FEndDateField;
    property Progress: IProgressController read FProgress write FProgress;
    property ReportDate: TDateTime read FReportDate write FReportDate;
    property UseInogorAccounts: Boolean read FUseInogorAccounts write
        FUseInogorAccounts;
  end;

  /// <summary>TData
  /// Сервис формирования отчета формы 8
  /// </summary>
  TReportBuilderModule = class(TUniDataModule)
    dsAccount: TDataSource;
    dsAty: TDataSource;
    dsContract: TDataSource;
    dsEty: TDataSource;
    MySQLUniProvider: TMySQLUniProvider;
    qryAccount: TUniQuery;
    qryAccountcontract_id: TIntegerField;
    qryAccountid: TIntegerField;
    qryAccountnumber: TWideStringField;
    qryAccountsettleDate: TDateField;
    qryAccountsum: TFloatField;
    qryAty: TUniQuery;
    qryAtyactionTypeCode: TWideStringField;
    qryAtyactionTypeName: TWideStringField;
    qryAtyeventTypeCode: TWideStringField;
    qryAtyeventTypeName: TWideStringField;
    qryAtyevent_id: TIntegerField;
    qryAtyexecDate: TDateTimeField;
    qryAtykol: TLargeintField;
    qryAtymaster_id: TIntegerField;
    qryAtyserviceCode: TWideStringField;
    qryAtysettleDate: TDateField;
    qryAtysumma: TFloatField;
    qryContract: TUniQuery;
    qryContractendDate: TDateField;
    qryContractid: TIntegerField;
    qryContractnumber: TWideStringField;
    qryEty: TUniQuery;
    qryEtyeventTypeCode: TWideStringField;
    qryEtyeventTypeName: TWideStringField;
    qryEtyexecDate: TDateTimeField;
    qryEtykol: TLargeintField;
    qryEtymaster_id: TIntegerField;
    qryEtysettleDate: TDateField;
    qryEtysumma: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryAccountBeforeOpen(DataSet: TDataSet);
    procedure qryAtyBeforeOpen(DataSet: TDataSet);
    procedure qryContractBeforeOpen(DataSet: TDataSet);
    procedure qryEtyBeforeOpen(DataSet: TDataSet);
  strict private
    FConnectionOptions: TSqlDatabaseConnectionData;
    FExcelService: TExcelService;
    FParams: TReportBuildParams;
    procedure AddDayData(vActionWhere, vEventWhere: string; vRowIndex: Integer);
    procedure AddPeriodData(vActionWhere, vEventWhere: string; vRowIndex:
      Integer; ABegDate, AEndDate: TDateTime; AKolColumn, ASummaColumn: Integer);
    procedure AddPeriodSectionData(ASectionQuery: TUniQuery; vRowIndex: Integer;
      ABegDate, AEndDate: TDateTime; AKolColumn, ASummaColumn: Integer;
      AWhereFilter: string);
    procedure AddYearData(vActionWhere, vEventWhere: string; vRowIndex: Integer);
    procedure AppendAccountToReportData;
    procedure ClearOptionsCells;
    function DayKolColumn: Integer;
    function DaySummaColumn: Integer;
    procedure FillHeader;
    function FirstExcelRow: Integer;
    function FirstOptionsRow: Integer;
    function GetCellValue(ARowIndex, AColumnIndex: Integer): OleVariant;
    function GetEndDateFieldName: string;
    function GetExcelTemplateFileName: string;
    function ActionWhereColumn: Integer;
    function LastExcelRow: Integer;
    procedure LogFinish;
    procedure LogStart;
    procedure OpenDatabaseConnection;
    procedure OpenExcelReportWorkbook;
    procedure OpenQueries;
    procedure PopulateDayFact;
    function Progress: IProgressController;
    function ReportDate: TDateTime;
    function RowNameColumn: Integer;
    procedure SetCellValue(ARowIndex, AColumnIndex: Integer; const Value:
      OleVariant);
    procedure SetupConnectionFromParams;
    procedure ShowProgress(Value: Double);
    procedure ShowText(AText: string; AParams: array of const);
    function UseInogorAccounts: Boolean;
    function EventWhereColumn: Integer;
    function YearKolColumn: Integer;
    function YearSummaColumn: Integer;
    property CellValue[ARowIndex, AColumnIndex: Integer]: OleVariant read
      GetCellValue write SetCellValue;
  public
    /// <summary>TData.ExecuteReport
    /// Сформировать отчет
    /// </summary>
    /// <param name="AExecuteParams"> (TReportBuildParams) Параметры формирования
    /// отчета</param>
    procedure ExecuteReport(AExecuteParams: TReportBuildParams;
      AConnectionOptions: TSqlDatabaseConnectionData);
  end;

implementation

uses
  IniOptionsUnit, Log.LoggerUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

resourcestring
  SRowNameColumnMarker = 'Строки';
  SFirstDataRowMarker = 'Посещение';
  SConnectionEstablished = 'Установлено соединение с БД %s %s';
  SConnectingToDatabase = 'Подключаемся к БД';
  SOpeningTemplate = 'Открываем шаблон %s';
  SLoadingExcel = 'Загружаем EXCEL';
  SFillingData = 'Заполняем сведения';

procedure TReportBuilderModule.AddDayData(vActionWhere, vEventWhere: string;
  vRowIndex: Integer);
begin
  AddPeriodData(vActionWhere, vEventWhere, vRowIndex, ReportDate.StartOfTheDay,
    ReportDate.EndOfTheDay, DayKolColumn, DaySummaColumn);
end;

procedure TReportBuilderModule.AddPeriodData(vActionWhere, vEventWhere: string;
  vRowIndex: Integer; ABegDate, AEndDate: TDateTime; AKolColumn, ASummaColumn:
  Integer);
begin
  if vActionWhere.Trim() <> '' then
    AddPeriodSectionData(qryAty, vRowIndex, ABegDate, AEndDate, AKolColumn,
      ASummaColumn, vActionWhere);

  if vEventWhere.Trim() <> '' then
    AddPeriodSectionData(qryEty, vRowIndex, ABegDate, AEndDate, AKolColumn,
      ASummaColumn, vEventWhere);
end;

procedure TReportBuilderModule.AddPeriodSectionData(ASectionQuery: TUniQuery;
  vRowIndex: Integer; ABegDate, AEndDate: TDateTime; AKolColumn, ASummaColumn:
  Integer; AWhereFilter: string);
begin
  ASectionQuery.Close;

  ASectionQuery.MacroByName('WhereFilter').Value := ' AND ' + AWhereFilter;
  ASectionQuery.ParamByName('BegDate').Value := ABegDate;
  ASectionQuery.ParamByName('EndDate').Value := AEndDate;

  ASectionQuery.Open;

  ASectionQuery.First;
  while not ASectionQuery.Eof do
  begin
    var vRowName := VarToStr(CellValue[vRowIndex, RowNameColumn]);
    var vKol: Integer := ASectionQuery['kol'];
    var vSumma: Double := ASectionQuery['summa'];
//     ShowText('Строка %s кол %d сумма %.2f', [vRowName, vKol, vSumma]);
    var vOldKol: Integer := CellValue[vRowIndex, AKolColumn];
    var vOldSumma: Double := CellValue[vRowIndex, ASummaColumn];
    CellValue[vRowIndex, AKolColumn] := vOldKol + vKol;
    CellValue[vRowIndex, ASummaColumn] := vOldSumma + vSumma;
    ASectionQuery.Next;
  end;
end;

procedure TReportBuilderModule.AddYearData(vActionWhere, vEventWhere: string;
  vRowIndex: Integer);
begin
  AddPeriodData(vActionWhere, vEventWhere, vRowIndex, MinDateTime, ReportDate.EndOfTheDay,
    YearKolColumn, YearSummaColumn);
end;

procedure TReportBuilderModule.AppendAccountToReportData;
begin
  ShowText('Счет №%s от %s', [qryAccountnumber.AsString, qryAccountsettleDate.AsString]);
  for var vRowIndex := FirstExcelRow to LastExcelRow do
  begin
    if Progress.CancellationPending then
      Break;

    var vActionWhere := VarToStr(CellValue[vRowIndex, ActionWhereColumn]);
    var vEventWhere := VarToStr(CellValue[vRowIndex, EventWhereColumn]);

    if (vActionWhere = '') and (vEventWhere = '') then
      Continue;

    AddDayData(vActionWhere, vEventWhere, vRowIndex);
    AddYearData(vActionWhere, vEventWhere, vRowIndex);
  end;
end;

procedure TReportBuilderModule.ClearOptionsCells;
begin
  for var vRowIndex := FirstOptionsRow to LastExcelRow do
  begin
    CellValue[vRowIndex, ActionWhereColumn] := '';
    CellValue[vRowIndex, EventWhereColumn] := '';
  end;
end;

procedure TReportBuilderModule.DataModuleCreate(Sender: TObject);
begin
  FExcelService := TExcelService.Create;
end;

procedure TReportBuilderModule.DataModuleDestroy(Sender: TObject);
begin
  FExcelService.Free;
end;

function TReportBuilderModule.DayKolColumn: Integer;
begin
  Result := FExcelService.FindTextColumn('факт на день');
end;

function TReportBuilderModule.DaySummaColumn: Integer;
begin
  Result := DayKolColumn + 1;
end;

procedure TReportBuilderModule.ExecuteReport(AExecuteParams: TReportBuildParams;
  AConnectionOptions: TSqlDatabaseConnectionData);
begin
  FParams := AExecuteParams;
  FConnectionOptions := AConnectionOptions;
  LogStart();

  ShowText('Начато формирование отчета за %s', [DateToStr(ReportDate)]);
  OpenExcelReportWorkbook();
  FillHeader();
  OpenDatabaseConnection();
  OpenQueries();
  PopulateDayFact();
  ClearOptionsCells();
  ShowText('Формирование отчета закончено', []);
  FExcelService.Show();

  LogFinish();
  // CloseExcel;
end;

procedure TReportBuilderModule.FillHeader;
begin
  CellValue[4, 1] := 'Отчетный период: ' + DateToStr(ReportDate);
end;

function TReportBuilderModule.FirstExcelRow: Integer;
begin
  Result := FExcelService.FindTextRow(SFirstDataRowMarker);
end;

function TReportBuilderModule.FirstOptionsRow: Integer;
begin
  Result := FExcelService.FindTextRow('ActionWhere');
end;

function TReportBuilderModule.GetCellValue(ARowIndex, AColumnIndex: Integer):
  OleVariant;
begin
  Result := FExcelService.CellValue[ARowIndex, AColumnIndex];
end;

function TReportBuilderModule.GetEndDateFieldName: string;
begin
  Result := 'e.execDate';
  if FParams.EndDateField = 1 then
    Result := 'e.modifyDateTime'
  else if FParams.EndDateField = 2 then
    Result := 'acc.settleDate';
end;

function TReportBuilderModule.GetExcelTemplateFileName: string;
begin
  Result := TPath.Combine(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    'Template'), 'Ежедневный мониторинг выполнения объемов и ' +
    'стоимости мед. помощи в рамках Тер. Прог. ОМС за 2024 год.xls');
end;

function TReportBuilderModule.ActionWhereColumn: Integer;
begin
  Result := FExcelService.FindTextColumn('ActionWhere');
end;

function TReportBuilderModule.LastExcelRow: Integer;
begin
  Result := FExcelService.LastRowIndex;
end;

procedure TReportBuilderModule.LogFinish;
begin
  Logger.AddInfo('Завершено формирование отчета за %s', [DateToStr(FParams.ReportDate)])
end;

procedure TReportBuilderModule.LogStart;
begin
  Logger.AddInfo('Запущено формирование отчета за %s', [DateToStr(FParams.ReportDate)])
end;

procedure TReportBuilderModule.OpenDatabaseConnection;
begin
  ShowText(SConnectingToDatabase, []);
  OpenDatabase(FConnectionOptions);
  ShowText(SConnectionEstablished, [conMain.Server, conMain.Database]);
end;

procedure TReportBuilderModule.OpenExcelReportWorkbook;
begin
  ShowText(SLoadingExcel, []);
  var vTemplateFileName := GetExcelTemplateFileName();
  ShowText(SOpeningTemplate, [vTemplateFileName]);

  FExcelService.AddWorkbook(vTemplateFileName);
end;

procedure TReportBuilderModule.OpenQueries;
begin
  qryContract.Open();
  qryAccount.Open;
  qryEty.Open;
  qryAty.Open;
end;

procedure TReportBuilderModule.PopulateDayFact;
begin
  if Progress.CancellationPending then
    Exit;

  ShowText(SFillingData, []);

  qryContract.First;
  while not qryContract.Eof do
  begin
    if Progress.CancellationPending then
      Break;
    qryAccount.First;
    while not qryAccount.Eof do
    begin
      if Progress.CancellationPending then
        Break;

      ShowProgress(100 * qryAccount.RecNo / qryAccount.RecordCount);
      AppendAccountToReportData();

      qryAccount.Next;
    end;
    qryContract.Next;
  end;
end;

function TReportBuilderModule.Progress: IProgressController;
begin
  Result := FParams.Progress;
end;

procedure TReportBuilderModule.qryAccountBeforeOpen(DataSet: TDataSet);
begin
  qryAccount.ParamByName('ReportDate').Value := ReportDate;
end;

procedure TReportBuilderModule.qryAtyBeforeOpen(DataSet: TDataSet);
begin
  qryAty.ParamByName('AccountId').Value := qryAccountid.AsVariant;
  qryAty.MacroByName('EndDateField').Value := GetEndDateFieldName();
end;

procedure TReportBuilderModule.qryContractBeforeOpen(DataSet: TDataSet);
begin
  qryContract.ParamByName('ReportDate').Value := ReportDate;
  qryContract.ParamByName('UseInogorAccounts').Value := 0;
  if UseInogorAccounts then
    qryContract.ParamByName('UseInogorAccounts').Value := 1;
end;

procedure TReportBuilderModule.qryEtyBeforeOpen(DataSet: TDataSet);
begin
  qryEty.ParamByName('AccountId').Value := qryAccountid.AsVariant;
  qryEty.MacroByName('EndDateField').Value := GetEndDateFieldName();
end;

function TReportBuilderModule.ReportDate: TDateTime;
begin
  Result := FParams.ReportDate;
end;

function TReportBuilderModule.RowNameColumn: Integer;
begin
  Result := FExcelService.FindTextColumn(SRowNameColumnMarker);
end;

procedure TReportBuilderModule.SetCellValue(ARowIndex, AColumnIndex: Integer;
  const Value: OleVariant);
begin
  FExcelService.CellValue[ARowIndex, AColumnIndex] := Value;
end;

procedure TReportBuilderModule.SetupConnectionFromParams;
begin
  with conMain do
  begin
    Server := FConnectionOptions.Server;
    Database := FConnectionOptions.Database;
    Username := FConnectionOptions.UserName;
    Password := FConnectionOptions.Password;
  end;
end;

procedure TReportBuilderModule.ShowProgress(Value: Double);
begin
  Progress.ShowPercent(Value);
end;

procedure TReportBuilderModule.ShowText(AText: string; AParams: array of const);
begin
  if Progress <> nil then
    Progress.ShowText(AText, AParams);
end;

function TReportBuilderModule.UseInogorAccounts: Boolean;
begin
  Result := FParams.UseInogorAccounts;
end;

function TReportBuilderModule.EventWhereColumn: Integer;
begin
  Result := FExcelService.FindTextColumn('EventWhere');
end;

function TReportBuilderModule.YearKolColumn: Integer;
begin
  Result := FExcelService.FindTextColumn('факт на год');
end;

function TReportBuilderModule.YearSummaColumn: Integer;
begin
  Result := YearKolColumn + 1;
end;

end.

