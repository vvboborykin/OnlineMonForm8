{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.ConnectionOptionsStorageUnit.pas
* Description: Интерфейс хранилица настроек подключечния к БД
*
* Created: 03.04.2024 11:56:31
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.ConnectionOptionsStorageUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>IConnectionOptionsStorage
  /// Интерфейс хранилица настроек подключечния к БД
  /// </summary>
  IConnectionOptionsStorage = interface
    ['{607F381C-F822-432A-B4F8-ADD8ABE998C1}']
    /// <summary>IConnectionOptionsStorage.Load
    /// Считать настройки
    /// </summary>
    /// <param name="AOptions"> (TSqlDatabaseConnectionData) </param>
    procedure Load(AOptions: TSqlDatabaseConnectionData); stdcall;
    /// <summary>IConnectionOptionsStorage.Save
    /// Сохранить настройки
    /// </summary>
    /// <param name="AOptions"> (TSqlDatabaseConnectionData) </param>
    procedure Save(AOptions: TSqlDatabaseConnectionData); stdcall;
  end;

var
  ConnectionOptionsStorage: IConnectionOptionsStorage;

implementation

end.
