{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.FieldNameAttributeUnit.pas
* Description: Атрибут имени поля БД для Variant свойств объектов
*
* Created: 03.04.2024 14:29:21
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.FieldNameAttributeUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>TFieldNameAttribute
  /// Атрибут имени поля для Variant свойств объектов
  /// </summary>
  TFieldNameAttribute = class(TCustomAttribute)
  private
    FDataFieldName: String;
    procedure SetDataFieldName(const Value: String);
  public
    constructor Create(const AFieldName: String);
    /// <summary>TFieldNameAttribute.DataFieldName
    /// Имя поля БД хранящего данные ствойства
    /// </summary>
    /// type:String
    property DataFieldName: String read FDataFieldName write SetDataFieldName;
  end;

implementation

constructor TFieldNameAttribute.Create(const AFieldName: String);
begin
  inherited Create;
  FDataFieldName := AFieldName;
end;

procedure TFieldNameAttribute.SetDataFieldName(const Value: String);
begin
  FDataFieldName := Value;
end;

end.
