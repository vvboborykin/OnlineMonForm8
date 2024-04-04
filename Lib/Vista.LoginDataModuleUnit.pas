{*******************************************************
* Project: OnlineMonForm8
* Unit: Vista.LoginDataUnit.pas
* Description: Модуль аутентификации ВистаМед
*
* Created: 31.03.2024 20:58:18
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Vista.LoginDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, UniProvider, MySQLUniProvider, Data.DB,
  DBAccess, Uni, Security.Auth.AuthProviderUnit, System.Variants,  Data.UniDataModuleUnit,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>TLoginData
  /// Модуль аутентификации ВистаМед
  /// </summary>
  TLoginDataModule = class(TUniDataModule, INamePasswordAuthProvider)
    MySQLUniProvider: TMySQLUniProvider;
    procedure DataModuleCreate(Sender: TObject);
  strict private
   FCurrentUserId: Variant;
  public
    /// <summary>IAuthProvider<TLoginData>.IsLoggedIn
    /// Проверить аутентифицирован ли текущий пользователь
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function IsLoggedIn: Boolean; stdcall;
    /// <summary>IAuthProvider<TLoginData>.Login
    /// Провести аутентификацию текущего пользователя
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="ALoginCredentials"> (TLoginData) Данные для аутентификации</param>
    function Login(ALoginCredentials: TNamePasswordCredentials): Boolean; virtual;
        stdcall;
    /// <summary>IAuthProvider<TLoginData>.Logout
    /// Отменить аутентификацию текущего пользователя
    /// </summary>
    procedure Logout; stdcall;
    /// <summary>IAuthProvider<TLoginData>.CurrentUserId
    /// Идентификатор текущего пользвоателя
    /// </summary>
    /// <returns> Variant
    /// </returns>
    function CurrentUserId: Variant; stdcall;
  end;


implementation

uses
  Data.UniConnectionHelperUnit, Log.LoggerUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TLoginDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FCurrentUserId := Null;
end;

{ TLoginData }

function TLoginDataModule.CurrentUserId: Variant;
begin
  Result := FCurrentUserId;
end;

function TLoginDataModule.IsLoggedIn: Boolean;
begin
  Result := not (VarIsNull(FCurrentUserId) or VarIsEmpty(FCurrentUserId));
end;

function TLoginDataModule.Login(ALoginCredentials: TNamePasswordCredentials):
    Boolean;
begin
  Logger.AddInfo('Попытка входа в программу', []);

  FCurrentUserId := conMain.SqlCalc('SELECT id FROM Person ' +
    'WHERE login = :Login AND password = MD5(:Password) ' +
    'AND deleted = 0 AND retireDate IS NULL LIMIT 1',
      [ALoginCredentials.LoginName, ALoginCredentials.Password]);

  Result := IsLoggedIn;

  if Result then
    Logger.AddInfo('Пользователь "%s" вошел в программу',
      [ALoginCredentials.LoginName])
  else
    Logger.AddWarning('Ошибка аутентификации пользователя "%s"',
      [ALoginCredentials.LoginName]);
end;

procedure TLoginDataModule.Logout;
begin
  FCurrentUserId := Null;
end;

end.
