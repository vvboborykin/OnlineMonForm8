{*******************************************************
* Project: OnlineMonForm8
* Unit: Log.LoggerUnit.pas
* Description: Интерфейс службы ведения протокола работы программы
*
* Created: 02.04.2024 11:10:22
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.LoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>
  /// Тип записи протокола
  /// </summary>
  TLogLevel = (lolDebug, lolInfo, lolWarning, lolError);

type
  /// <summary>ILogger
  /// Интерфейс службы ведения протокола работы программы
  /// </summary>
  ILogger = interface
    ['{1C184D2E-2CFF-4120-B034-FA17A4DE41BE}']
    /// <summary>ILogger.Add
    /// Добавить запись в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    /// <param name="ALevel"> (TLogLevel) </param>
    procedure Add(AText: string; AParams: array of const; ALevel: TLogLevel =
        lolInfo); stdcall;
    /// <summary>ILogger.AddDebug
    /// Добавить отладочную запись в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddDebug(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddInfo
    /// Добавить информационную запись в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddInfo(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddWarning
    /// Добавить запись-предупреждение в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddWarning(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddError
    /// Добавить запись об ошибке в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddError(AText: string; AParams: array of const); stdcall;
  end;

var
  Logger: ILogger;

resourcestring
  SError = 'ОШИБКА';
  SWarning = 'Предупреждение';
  SInfo = 'Информация';
  SDebug = 'Отладка';

const
  LogLevelNames: array [Low(TLogLevel) .. High(TLogLevel)] of string
    = (SDebug, SInfo, SWarning, SError);

implementation
end.
