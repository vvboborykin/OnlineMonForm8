{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.SqlDatabaseConnectionDataUnit.pas
* Description: Сведения необходимые для подключения к SQL базе данных
*
* Created: 03.04.2024 14:26:49
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.SqlDatabaseConnectionDataUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>TSqlDatabaseConnectionData
  /// Сведения необходимые для подключения к SQL базе данных
  /// </summary>
  TSqlDatabaseConnectionData = class
  strict private
    FDatabase: String;
    FPassword: String;
    FServer: String;
    FUserName: String;
  public
    /// <summary>TSqlDatabaseConnectionData.Database
    /// Имя базы данных к которой проводится подключение
    /// </summary>
    /// type:String
    property Database: String read FDatabase write FDatabase;
    /// <summary>TSqlDatabaseConnectionData.Password
    /// Пароль пользователя сервера БД
    /// </summary>
    /// type:String
    property Password: String read FPassword write FPassword;
    /// <summary>TSqlDatabaseConnectionData.Server
    /// Доменное имя или IP адрес срвера БД
    /// </summary>
    /// type:String
    property Server: String read FServer write FServer;
    /// <summary>TSqlDatabaseConnectionData.UserName
    /// Имя пользователя сервера БД
    /// </summary>
    /// type:String
    property UserName: String read FUserName write FUserName;
  end;

implementation

end.
