{*******************************************************
* Project: OnlineMonForm8
* Unit: ProgressControllerUnit.pas
* Description: ���������� �������� ���������� ������
*
* Created: 29.03.2024 19:51:59
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Task.ProgressControllerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Threading;

type
  /// <summary>IProgressController
  /// ���������� �������� ���������� ������
  /// </summary>
  IProgressController = interface
    ['{7FD37013-D1C1-4771-869B-F0A1C2AAB2D5}']
    /// <summary>IProgressController.Cancel
    /// ������ ���������� ���������� ������
    /// </summary>
    procedure Cancel; stdcall;
    /// <summary>IProgressController.CancellationPending
    /// ���������� ��������� �� ���������� ���������� ������
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function CancellationPending: Boolean; stdcall;
    /// <summary>IProgressController.ShowPercent
    /// ���������� ������� ���������� ������
    /// </summary>
    /// <param name="APercent"> (Double) ������� ���������� ������</param>
    procedure ShowPercent(APercent: Double); stdcall;
    /// <summary>IProgressController.ShowText
    /// ���������� ��������� ��������� �� ������
    /// </summary>
    /// <param name="AText"> (String) ������ ������</param>
    /// <param name="AParams"> (array of const) ��������� ���������� �������</param>
    procedure ShowText(AText: string; AParams: array of const); stdcall;
    /// <summary>IProgressController.ReportTaskCompleted ����� ���������� � ���������� ������
    /// </summary>
    procedure ReportTaskCompleted; stdcall;
  end;

implementation


end.

