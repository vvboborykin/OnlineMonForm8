{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.FieldNameAttributeUnit.pas
* Description: ������� ����� ���� �� ��� Variant ������� ��������
*
* Created: 03.04.2024 14:29:21
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Data.FieldNameAttributeUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>TFieldNameAttribute
  /// ������� ����� ���� ��� Variant ������� ��������
  /// </summary>
  TFieldNameAttribute = class(TCustomAttribute)
  private
    FDataFieldName: String;
    procedure SetDataFieldName(const Value: String);
  public
    constructor Create(const AFieldName: String);
    /// <summary>TFieldNameAttribute.DataFieldName
    /// ��� ���� �� ��������� ������ ���������
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
