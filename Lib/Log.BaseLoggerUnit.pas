{*******************************************************
* Project: OnlineMonForm8
* Unit: Log.BaseLoggerUnit.pas
* Description: Базовая абстрактная реализация службы ведения протокола работы программы
*
* Created: 03.04.2024 14:32:37
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.BaseLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Log.LoggerUnit,
  System.SyncObjs, System.StrUtils;

type
  /// <summary>TBaseLogger
  /// Базовая абстрактная реализация службы ведения протокола работы программы
  /// </summary>
  TBaseLogger = class abstract(TInterfacedObject, ILogger)
  strict private
    FLock: TCriticalSection;
    FMinLevel: TLogLevel;
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
    /// <summary>ILogger.AddError
    /// Добавить запись об ошибке в протокол
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddError(AText: string; AParams: array of const); stdcall;
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
    procedure SetMinLevelFromCommandLine;
  strict protected
    procedure InternalAdd(vText: string; ALevel: TLogLevel); virtual; abstract;
  public
    constructor Create(AMinLevel: TLogLevel);
    destructor Destroy; override;
  end;

implementation

resourcestring
  SError = 'Error';
  SWarning = 'Warning';
  SInfo = 'Info';
  SDebug = 'Debug';

constructor TBaseLogger.Create(AMinLevel: TLogLevel);
begin
  inherited Create;
  FMinLevel := AMinLevel;
  SetMinLevelFromCommandLine();
  FLock := TCriticalSection.Create();
end;

destructor TBaseLogger.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure TBaseLogger.Add(AText: string; AParams: array of const; ALevel:
  TLogLevel = lolInfo);
begin
  if ALevel >= FMinLevel then
  begin
    var vText := Format(AText, AParams);
    FLock.Enter;
    try
      InternalAdd(vText, ALevel);
    finally
      FLock.Leave;
    end;
  end;
end;

procedure TBaseLogger.AddDebug(AText: string; AParams: array of const);
begin
  Add(AText, AParams, lolDebug)
end;

procedure TBaseLogger.AddError(AText: string; AParams: array of const);
begin
  Add(AText, AParams, lolError)
end;

procedure TBaseLogger.AddInfo(AText: string; AParams: array of const);
begin
  Add(AText, AParams, lolInfo)
end;

procedure TBaseLogger.AddWarning(AText: string; AParams: array of const);
begin
  Add(AText, AParams, lolWarning)
end;

procedure TBaseLogger.SetMinLevelFromCommandLine;
var
  vLogLevel: string;
const
  CCmdLogLevelNames: array of string = [SDebug, SInfo, SWarning, SError];
begin
  if FindCmdLineSwitch('LogLevel', vLogLevel, True) then
  begin
    var vIndex := AnsiIndexText(vLogLevel, CCmdLogLevelNames);
    if vIndex >= 0 then
      FMinLevel := TLogLevel(vIndex);
  end;
end;

end.

