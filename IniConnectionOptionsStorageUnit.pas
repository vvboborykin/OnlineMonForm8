{*******************************************************
* Project: OnlineMonForm8
* Unit: IniConnectionOptionsStorageUnit.pas
* Description: Реализация хранилища настроек подключения к БД
*
* Created: 03.04.2024 12:41:46
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit IniConnectionOptionsStorageUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Data.ConnectionOptionsStorageUnit, Data.SqlDatabaseConnectionDataUnit,
  Security.Crypto.StringCodecUnit, Security.Crypto.StringCodecOwnerUnit;

type
  /// <summary>TIniConnectionOptionsStorage
  /// Реализация хранилища настроек подключения к БД
  /// </summary>
  TIniConnectionOptionsStorage = class(TStringCodecOwner,
    IConnectionOptionsStorage)
  strict private
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

implementation

uses
  IniOptionsUnit, Security.Crypto.Base64StringCodecUnit, Ini.IniFileNamesUnit;

procedure TIniConnectionOptionsStorage.Load(AOptions: TSqlDatabaseConnectionData);
begin
  IniOptions.LoadFromFile(IniFileNames.ApplicationIniFileName);
  with IniOptions.ConnectionSection do
  begin
    AOptions.Server := Server;
    AOptions.Database := Database;
    AOptions.UserName := UserName;
//    AOptions.Password := Decrypt(Password);
    AOptions.Password := Password;
  end;
end;

procedure TIniConnectionOptionsStorage.Save(AOptions: TSqlDatabaseConnectionData);
begin
  with IniOptions.ConnectionSection do
  begin
    Server := AOptions.Server;
    Database := AOptions.Database;
    UserName := AOptions.UserName;
//    Password := Encrypt(AOptions.Password);
    Password := AOptions.Password;
  end;
  IniOptions.SaveToFile(IniFileNames.ApplicationIniFileName);
end;

initialization
  ConnectionOptionsStorage := TIniConnectionOptionsStorage.Create(TBase64StringCodec.Create);

end.

