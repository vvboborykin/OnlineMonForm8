{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.UniDataModuleUnit.pas
* Description: Модуль данных UniDac
*
* Created: 02.04.2024 9:14:16
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.UniDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>TUniDataModule
  /// Модуль данных UniDac
  /// </summary>
  TUniDataModule = class(TDataModule)
    conMain: TUniConnection;
  strict private
  public
    /// <summary>IAuthProvider<TLoginData>.OpenDatabase
    /// Подключиться к БД
    /// </summary>
    /// <param name="AConnectionData"> (TDatabaseConnectionData) </param>
    procedure OpenDatabase(AConnectionData: TSqlDatabaseConnectionData);
  end;

implementation

uses
  Log.LoggerUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TUniDataModule.OpenDatabase(AConnectionData:
  TSqlDatabaseConnectionData);
begin
  with AConnectionData do
  begin
    Logger.AddDebug('Параметры подключения: %s, %s, %s', [Server, Database,
      UserName]);
    conMain.Server := Server;
    conMain.Database := Database;
    conMain.Username := UserName;
    conMain.Password := Password;
  end;

  Logger.AddDebug('Попытка подключения к БД', []);
  conMain.Open();
  Logger.AddDebug('Подключено успешно', []);
end;

end.

