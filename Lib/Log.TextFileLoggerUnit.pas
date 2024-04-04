{*******************************************************
* Project: OnlineMonForm8
* Unit: Log.TextFileLoggerUnit.pas
* Description: Реалиазция службы протокола на основе текстового файла
*
* Created: 02.04.2024 11:41:37
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Log.TextFileLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Log.BaseLoggerUnit,
  Log.LoggerUnit, System.IOUtils;

type
  /// <summary>TTextFileLogger
  /// Реалиазция службы протокола на основе текстового файла
  /// </summary>
  TTextFileLogger = class(TBaseLogger, ILogger)
  strict private
    FFileName: string;
    procedure SetDefaultLogFileName;
  strict protected
    procedure InternalAdd(vText: string; ALevel: TLogLevel); override;
  public
    constructor Create(AMinLevel: TLogLevel; AFileName: string = '');
  end;

implementation

constructor TTextFileLogger.Create(AMinLevel: TLogLevel; AFileName: string =
    '');
begin
  inherited Create(AMinLevel);
  FFileName := AFileName;
  if FFileName = '' then
    SetDefaultLogFileName();
end;

procedure TTextFileLogger.InternalAdd(vText: string; ALevel: TLogLevel);
begin
  var vLogText := DateTimeToStr(Now) + #9 + LogLevelNames[ALevel] + #9 + vText;
  TFile.AppendAllText(FFileName, vLogText + #13, TEncoding.UTF8);
end;

procedure TTextFileLogger.SetDefaultLogFileName;
begin
  var vDirName := TPath.Combine(TPath.GetHomePath,
    TPath.GetFileNameWithoutExtension(ParamStr(0)));

  if not TDirectory.Exists(vDirName) then
    TDirectory.CreateDirectory(vDirName);

  FFileName := TPath.Combine(vDirName, TPath.GetFileName(ParamStr(0)) + '.log');
end;

initialization
  Logger := TTextFileLogger.Create(lolWarning);
end.
