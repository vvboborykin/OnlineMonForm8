{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Auth.AuthProviderUnit.pas
* Description: Провайдер аутентификации
*
* Created: 30.03.2024 8:26:53
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Security.Auth.AuthProviderUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>IAuthProvider
  /// Провайдер аутентификации
  /// </summary>
  IAuthProvider<TLoginCredentials> = interface
  ['{04ECAAEA-8E60-4AF3-885E-DF701A977152}']
    /// <summary>IAuthProvider<TLoginData>.CurrentUserId
    /// Идентификатор текущего пользвоателя
    /// </summary>
    /// <returns> Variant
    /// </returns>
    function CurrentUserId: Variant; stdcall;
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
    function Login(ALoginCredentials: TLoginCredentials): Boolean; stdcall;
    /// <summary>IAuthProvider<TLoginData>.Logout
    /// Отменить аутентификацию текущего пользователя
    /// </summary>
    procedure Logout; stdcall;
  end;

  /// <summary>TNamePasswordCredentials
  /// Данные аутентификации пользователя по имени и паролю
  /// </summary>
  TNamePasswordCredentials = class
    /// <summary>TNamePasswordCredentials.LoginName
    /// Логическое имя пользователя
    /// </summary>
    /// type:String
    LoginName: String;
    /// <summary>TNamePasswordCredentials.Password
    /// Пароль пользователя
    /// </summary>
    /// type:String
    Password: String;
  end;

  /// <summary>INamePasswordAuthProvider
  /// Провайдер аутентификации с использованием имени и пароля пользователя
  /// </summary>
  INamePasswordAuthProvider = interface(IAuthProvider<TNamePasswordCredentials>)
  ['{B0FC25ED-6792-4918-B295-156696192E94}']
  end;

implementation

end.
