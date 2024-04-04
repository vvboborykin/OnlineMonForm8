{*******************************************************
* Project: OnlineMonForm8
* Unit: ProgressControllerUnit.pas
* Description: Контроллер фонового выполнения задачи
*
* Created: 29.03.2024 19:51:59
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Task.ProgressControllerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Threading;

type
  /// <summary>IProgressController
  /// Контроллер фонового выполнения задачи
  /// </summary>
  IProgressController = interface
    ['{7FD37013-D1C1-4771-869B-F0A1C2AAB2D5}']
    /// <summary>IProgressController.Cancel
    /// Запрос прерывания выполнения задачи
    /// </summary>
    procedure Cancel; stdcall;
    /// <summary>IProgressController.CancellationPending
    /// Определить запрошено ли прерывание выполнения задачи
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function CancellationPending: Boolean; stdcall;
    /// <summary>IProgressController.ShowPercent
    /// Отобразить процент выполнения задачи
    /// </summary>
    /// <param name="APercent"> (Double) Процент выполнения задачи</param>
    procedure ShowPercent(APercent: Double); stdcall;
    /// <summary>IProgressController.ShowText
    /// Отобразить текстовое сооющение от задачи
    /// </summary>
    /// <param name="AText"> (String) Шаблон текста</param>
    /// <param name="AParams"> (array of const) Параметры заполнения шаблона</param>
    procedure ShowText(AText: string; AParams: array of const); stdcall;
    /// <summary>IProgressController.ReportTaskCompleted Метод оповещения о завершении задачи
    /// </summary>
    procedure ReportTaskCompleted; stdcall;
  end;

implementation


end.

