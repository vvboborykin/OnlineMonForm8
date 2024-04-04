{*******************************************************
* Project: OnlineMonForm8
* Unit: Ini.IniFileNamesUnit.pas
* Description: Генератор имен INI файлов
*
* Created: 31.03.2024 20:54:46
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Ini.IniFileNamesUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.IOUtils,
  Winapi.Windows;

type
  /// <summary>TIniFileNames
  /// Генератор имен INI файлов
  /// </summary>
  TIniFileNames = class
  strict private
    function ExpandEnvStrings(const AString: string): string;
  private
    function ExpandCmdSwitch(vFileName: string): string;
  public
    /// <summary>TIniFileNames.ApplicationIniFileName
    /// Имя ini файла приложения
    /// </summary>
    /// <returns> string
    /// </returns>
    function ApplicationIniFileName: string;
    /// <summary>TIniFileNames.UserIniFileName
    /// Имя ini файла пользователя
    /// </summary>
    /// <returns> string
    /// </returns>
    function UserIniFileName: string;
  end;

function IniFileNames: TIniFileNames;

implementation

var
  FIniFileNames: TIniFileNames;

function IniFileNames: TIniFileNames;
begin
  Result := FIniFileNames;
end;

function TIniFileNames.ApplicationIniFileName: string;
var
  vFileName: string;
begin
  Result := ParamStr(0) + '.ini';
  if FindCmdLineSwitch('IniFileName', vFileName, True) then
    Result := ExpandCmdSwitch(vFileName);
end;

function TIniFileNames.ExpandCmdSwitch(vFileName: string): string;
begin
  Result := ExpandEnvStrings(vFileName);
  if Result.StartsWith('"') and Result.EndsWith('"') then
    Result := AnsiDequotedStr(Result, '"');
end;

function TIniFileNames.ExpandEnvStrings(const AString: string): string;
var
  bufsize: Integer;
begin
  bufsize := ExpandEnvironmentStrings(PChar(AString), nil, 0);
  SetLength(result, bufsize);
  ExpandEnvironmentStrings(PChar(AString), PChar(result), bufsize);
  result := TrimRight(result);
end;

function TIniFileNames.UserIniFileName: string;
var
  vFileName: string;
begin
  Result := TPath.Combine(TPath.GetHomePath,
    TPath.GetFileNameWithoutExtension(ParamStr(0)));

  if not TDirectory.Exists(Result) then
    TDirectory.CreateDirectory(Result);

  Result := TPath.Combine(Result, TPath.GetFileName(ParamStr(0)) + '.User.ini');

  if FindCmdLineSwitch('UserIniFileName', vFileName, True) then
    Result := ExpandCmdSwitch(vFileName);
end;

initialization
  FIniFileNames := TIniFileNames.Create;
finalization
  IniFileNames.Free;
end.

