{*******************************************************
* Project: OnlineMonForm8
* Unit: Log.LoggerUnit.pas
* Description: ��������� ������ ������� ��������� ������ ���������
*
* Created: 02.04.2024 11:10:22
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Log.LoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>
  /// ��� ������ ���������
  /// </summary>
  TLogLevel = (lolDebug, lolInfo, lolWarning, lolError);

type
  /// <summary>ILogger
  /// ��������� ������ ������� ��������� ������ ���������
  /// </summary>
  ILogger = interface
    ['{1C184D2E-2CFF-4120-B034-FA17A4DE41BE}']
    /// <summary>ILogger.Add
    /// �������� ������ � ��������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    /// <param name="ALevel"> (TLogLevel) </param>
    procedure Add(AText: string; AParams: array of const; ALevel: TLogLevel =
        lolInfo); stdcall;
    /// <summary>ILogger.AddDebug
    /// �������� ���������� ������ � ��������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddDebug(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddInfo
    /// �������� �������������� ������ � ��������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddInfo(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddWarning
    /// �������� ������-�������������� � ��������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddWarning(AText: string; AParams: array of const); stdcall;
    /// <summary>ILogger.AddError
    /// �������� ������ �� ������ � ��������
    /// </summary>
    /// <param name="AText"> (string) </param>
    /// <param name="AParams"> (array of const) </param>
    procedure AddError(AText: string; AParams: array of const); stdcall;
  end;

var
  Logger: ILogger;

resourcestring
  SError = '������';
  SWarning = '��������������';
  SInfo = '����������';
  SDebug = '�������';

const
  LogLevelNames: array [Low(TLogLevel) .. High(TLogLevel)] of string
    = (SDebug, SInfo, SWarning, SError);

implementation
end.
