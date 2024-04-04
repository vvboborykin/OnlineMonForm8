{*******************************************************
* Project: OnlineMonForm8
* Unit: MsOffice.Excel.ExcelServiceUnit.pas
* Description: Сервис упрощенного доступа к EXCEL средствами OLE
*
* Created: 30.03.2024 10:27:00
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit MsOffice.Excel.ExcelServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils;

type
  XlFindLookIn = (xlComments = -4144, xlCommentsThreaded = -4184, xlFormulas = -
    4123, xlValues = -4163);


  /// <summary>TExcelService
  /// Сервис упрощенного доступа к EXCEL средствами OLE
  /// </summary>
  TExcelService = class
  strict private
    FRowColCache: TStringList;
    FExcelApplication: OleVariant;
    FWorkbook: OleVariant;
    FWorksheet: OleVariant;
    procedure CreateExcelApp;
    function GetCells(ARow: Integer; ACol: Integer): OleVariant;
    function GetCellValue(ARow: Integer; ACol: Integer): Variant;
    procedure SetCellValue(ARow: Integer; ACol: Integer; const Value: Variant);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Quit;
    procedure AddWorkbook(ATemplateName: string = '');
    function Find(AFindWhat: OleVariant; out AFoundRow, AFoundCol: Integer):
      Boolean;
    function FindTextRowOrColumn(AText: string; AFindRow: Boolean): Integer;
    function FindTextRow(AText: string): Integer;
    function FindTextColumn(AText: string): Integer;
    procedure Hide;
    function LastRowIndex: Integer;
    function FirstRowIndex: Integer;
    function FirstColumnIndex: Integer;
    function LastColumnIndex: Integer;
    procedure OpenWorkbook(AFileName: string; AReadOnly: Boolean = False);
    procedure SelectWorkbook(AIndexOrName: OleVariant);
    procedure SelectWorksheet(AIndexOrName: OleVariant);
    procedure SaveWorkbook(AFileName: string = '');
    procedure Show;
    property Cells[ARow: Integer; ACol: Integer]: OleVariant read GetCells;
    property CellValue[ARow: Integer; ACol: Integer]: Variant read GetCellValue
      write SetCellValue;
  end;

implementation

uses
  ActiveX, System.Win.ComObj;

constructor TExcelService.Create;
begin
  inherited Create;
  CoInitialize(nil);
  CreateExcelApp;
  FRowColCache := TStringList.Create();
end;

destructor TExcelService.Destroy;
begin
  FRowColCache.Free;
  CoUninitialize();
  inherited;
end;

procedure TExcelService.AddWorkbook(ATemplateName: string = '');
begin
  var vTemplate: Variant := EmptyParam;

  if ATemplateName <> '' then
    vTemplate := ATemplateName;

  FWorkbook := FExcelApplication.Workbooks.Add(vTemplate);
  SelectWorksheet(1);
end;

procedure TExcelService.CreateExcelApp;
begin
  FExcelApplication := CreateOleObject('Excel.Application');
end;

function TExcelService.Find(AFindWhat: OleVariant; out AFoundRow, AFoundCol:
  Integer): Boolean;
begin
  var vRange: OleVariant := FWorksheet.Cells.Find(AFindWhat);
  Result := not VarIsNull(vRange) and not VarIsEmpty(vRange);
  if Result then
  begin
    AFoundRow := vRange.Row;
    AFoundCol := vRange.Column;
  end
  else
  begin
    AFoundRow := -1;
    AFoundCol := -1;
  end;
end;

function TExcelService.FindTextRow(AText: string): Integer;
begin
  Result := FindTextRowOrColumn(AText, True);
end;

function TExcelService.FindTextColumn(AText: string): Integer;
begin
  Result := FindTextRowOrColumn(AText, False);
end;

function TExcelService.FindTextRowOrColumn(AText: string; AFindRow: Boolean):
    Integer;
var
  vCol: Integer;
  vIndex: Integer;
  vKey: string;
  vRow: Integer;
begin
  vKey := AText + IfThen(AFindRow, '_RowIndex', '_ColumnIndex');
  vIndex := FRowColCache.IndexOf(vKey);
  if vIndex < 0 then
  begin
    if Find(AText, vRow, vCol) then
    begin
    begin
      if AFindRow then
        Result := vRow
      else
        Result := vCol;
    end;
    end
    else
      Result := 0;
    FRowColCache.AddObject(vKey, TObject(Result));
  end
  else
    Result := Integer(FRowColCache.Objects[vIndex]);
end;

function TExcelService.FirstRowIndex: Integer;
begin
  Result := FWorksheet.UsedRange.Row;
end;

function TExcelService.FirstColumnIndex: Integer;
begin
  Result := FWorksheet.UsedRange.Column;
end;

function TExcelService.GetCells(ARow: Integer; ACol: Integer): OleVariant;
begin
  Result := FWorksheet.Cells[ARow, ACol];
end;

function TExcelService.GetCellValue(ARow: Integer; ACol: Integer): Variant;
begin
  Result := FWorksheet.Cells[ARow, ACol].Value;
end;

procedure TExcelService.Hide;
begin
  FExcelApplication.Visible := False;
end;

function TExcelService.LastRowIndex: Integer;
begin
  Result := FirstRowIndex + FWorksheet.UsedRange.Rows.Count;
end;

function TExcelService.LastColumnIndex: Integer;
begin
  Result := FirstColumnIndex + FWorksheet.UsedRange.Columns.Count;
end;

procedure TExcelService.OpenWorkbook(AFileName: string; AReadOnly: Boolean =
  False);
begin
  FWorkbook := FExcelApplication.Workbooks.Open(AFileName, ReadOnly := AReadOnly);
  SelectWorksheet(1);
end;

procedure TExcelService.Quit;
begin
  FExcelApplication.Quit();
end;

procedure TExcelService.SaveWorkbook(AFileName: string = '');
begin
  if AFileName = '' then
    FWorkbook.Save()
  else
    FWorkbook.SaveAs(AFileName)
end;

procedure TExcelService.SelectWorkbook(AIndexOrName: OleVariant);
begin
  FWorkbook := FExcelApplication.Workbooks[AIndexOrName];
end;

procedure TExcelService.SelectWorksheet(AIndexOrName: OleVariant);
begin
  FWorksheet := FWorkbook.Worksheets[AIndexOrName];
end;

procedure TExcelService.SetCellValue(ARow: Integer; ACol: Integer; const Value:
  Variant);
begin
  FWorksheet.Cells[ARow, ACol].Value := Value;
end;

procedure TExcelService.Show;
begin
  FExcelApplication.Visible := True;
end;

end.

