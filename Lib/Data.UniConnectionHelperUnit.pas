{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.UniConnectionHelperUnit.pas
* Description: Класс-расширение функций TUniConnection
*
* Created: 01.04.2024 20:57:42
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.UniConnectionHelperUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Uni, System.Rtti,
  System.Generics.Collections;

type
  /// <summary>TUniConnectionHelper
  /// Класс-расширение функций TUniConnection
  /// </summary>
  TUniConnectionHelper = class helper for TUniConnection
  public
    procedure AssignObjectScalarPropertiesFromQuery(AObject: TObject; AQuery:
      TUniQuery);
    /// <summary>TUniConnectionHelper.SqlSelect
    /// Выбрать данные запроса SELECT
    /// </summary>
    /// <returns> TUniQuery
    /// </returns>
    /// <param name="ASqlText"> (String) Текст запроса</param>
    /// <param name="AParams"> (array of Variant) Значения параметров запроса</param>
    function SqlSelect(ASqlText: string; AParams: array of Variant): TUniQuery;
    /// <summary>TUniConnectionHelper.SqlGetObject<,>
    /// Запросить объект заполненный данными из записи запроса
    /// </summary>
    /// Объект типа T, если запрос вернул хотя бы одну запись, иначе nil
    /// <returns> T
    /// </returns>
    /// <param name="ASqlText"> (string) SQL SELECT запрос</param>
    /// <param name="AParams"> (array of Variant) Значения параметров запроса</param>
    function SqlGetObject<T: class, constructor>(ASqlText: string; AParams: array
        of Variant): T;
    /// <summary>TUniConnectionHelper.SqlQueryObjects<,>
    /// Получить список объектов, заполненных данными записей (по одному объекту на
    /// запись)
    /// </summary>
    /// <returns> TList<T>
    /// </returns>
    /// <param name="ASqlText"> (string) Текст SELECT запроса</param>
    /// <param name="AParams"> (array of Variant) Значения параметров запроса</param>
    function SqlQueryObjects<T: class, constructor>(ASqlText: string; AParams:
        array of Variant): TList<T>;
    /// <summary>TUniConnectionHelper.SqlCalc
    /// Получить скалярный результат выполнения запроса SELECT - первое поле первой строки
    /// </summary>
    /// <returns> TUniQuery
    /// </returns>
    /// <param name="ASqlText"> (String) Текст запроса</param>
    /// <param name="AParams"> (array of Variant) Значения параметров запроса</param>
    function SqlCalc(ASqlText: string; AParams: array of Variant): Variant;
    /// <summary>TUniConnectionHelper.TrySqlCalc
    /// Попытаться получить скалярный результат  выполнения запроса
    /// </summary>
    /// <returns> Boolean
    /// True в случае если значение получено
    /// </returns>
    /// <param name="ASqlText"> (String) Текст запроса</param>
    /// <param name="AParams"> (array of Variant) Значения параметров запроса</param>
    /// <param name="AResult"> (Variant) Скалярное значение - результат запроса</param>
    function TrySqlCalc(ASqlText: string; AParams: array of Variant; var AResult:
      Variant): Boolean; overload;
    /// <summary>TUniConnectionHelper.SqlExec
    /// Выполнить команду SQL (INSERT UPDATE DELETE)
    /// </summary>
    /// <returns> Integer
    /// </returns>
    /// <param name="ASqlText"> (String) Текст команды</param>
    /// <param name="AParams"> (array of Variant) Значения параметров команды</param>
    function SqlExec(ASqlText: string; AParams: array of Variant): Integer;
  end;

implementation

uses
  Data.FieldNameAttributeUnit;

procedure TUniConnectionHelper.AssignObjectScalarPropertiesFromQuery(AObject:
  TObject; AQuery: TUniQuery);
var
  vFieldName: string;
begin
  if (AQuery.RecordCount > 0) and (AObject <> nil) then
  begin
    var context := TRttiContext.Create;
    var objType := context.FindType(AObject.ClassType.QualifiedClassName) as
      TRttiInstanceType;
    if objType <> nil then
    begin
      for var propInfo in objType.GetProperties do
      begin
        if propInfo.PropertyType.Name <> 'Variant' then
          Continue;

        vFieldName := propInfo.Name;
        var attr := propInfo.GetAttribute<TFieldNameAttribute>();
        if attr <> nil then
          vFieldName := attr.DataFieldName;

        var field := AQuery.FindField(vFieldName);
        if field <> nil then
          propInfo.SetValue(AObject, TValue.FromVariant(field.Value));
      end;
    end;
  end;
end;

function TUniConnectionHelper.SqlCalc(ASqlText: string; AParams: array of
  Variant): Variant;
begin
  Result := Null;
  var vQuery := SqlSelect(ASqlText, AParams);
  try
    if vQuery.RecordCount > 0 then
      Result := vQuery.Fields[0].Value;
  finally
    vQuery.Free;
  end;
end;

function TUniConnectionHelper.SqlExec(ASqlText: string; AParams: array of
  Variant): Integer;
var
  I: Integer;
begin
  var vSql := TUniSQL.Create(nil);
  try
    vSql.SQL.Text := ASqlText;
    for I := 0 to vSql.Params.Count - 1 do
      vSql.Params[I].Value := AParams[I];
    vSql.Execute;
    Result := vSql.RowsAffected;
  finally
    vSql.Free;
  end;
end;

function TUniConnectionHelper.SqlGetObject<T>(ASqlText: string; AParams: array
    of Variant): T;
begin
  Result := nil;
  var vQuery := SqlSelect(ASqlText, AParams);
  try
    if vQuery.RecordCount > 0 then
    begin
      Result := T.Create;
      AssignObjectScalarPropertiesFromQuery(Result, vQuery);
    end;
  finally
    vQuery.Free;
  end;
end;

function TUniConnectionHelper.SqlQueryObjects<T>(ASqlText: string; AParams:
    array of Variant): TList<T>;
begin
  Result := TList<T>.Create;
  var vQuery := SqlSelect(ASqlText, AParams);
  try
    if vQuery.RecordCount > 0 then
    begin
      vQuery.First;
      while not vQuery.Eof do
      begin
        var vResult := T.Create;
        AssignObjectScalarPropertiesFromQuery(vResult, vQuery);
        Result.Add(vResult);
      end;
    end;
  finally
    vQuery.Free;
  end;
end;

function TUniConnectionHelper.SqlSelect(ASqlText: string; AParams: array of
  Variant): TUniQuery;
var
  I: Integer;
begin
  Result := TUniQuery.Create(nil);
  Result.Connection := Self;
  Result.SQL.Text := ASqlText;
  for I := 0 to Result.Params.Count - 1 do
    Result.Params[I].Value := AParams[I];
  Result.Open;
end;

function TUniConnectionHelper.TrySqlCalc(ASqlText: string; AParams: array of
  Variant; var AResult: Variant): Boolean;
begin
  var vResult := SqlCalc(ASqlText, AParams);
  Result := vResult <> Null;
  if Result then
    AResult := vResult;
end;

end.

