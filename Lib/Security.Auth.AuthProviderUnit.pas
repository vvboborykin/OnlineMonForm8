{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Auth.AuthProviderUnit.pas
* Description: ��������� ��������������
*
* Created: 30.03.2024 8:26:53
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Security.Auth.AuthProviderUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>IAuthProvider
  /// ��������� ��������������
  /// </summary>
  IAuthProvider<TLoginCredentials> = interface
  ['{04ECAAEA-8E60-4AF3-885E-DF701A977152}']
    /// <summary>IAuthProvider<TLoginData>.CurrentUserId
    /// ������������� �������� ������������
    /// </summary>
    /// <returns> Variant
    /// </returns>
    function CurrentUserId: Variant; stdcall;
    /// <summary>IAuthProvider<TLoginData>.IsLoggedIn
    /// ��������� ���������������� �� ������� ������������
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function IsLoggedIn: Boolean; stdcall;
    /// <summary>IAuthProvider<TLoginData>.Login
    /// �������� �������������� �������� ������������
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="ALoginCredentials"> (TLoginData) ������ ��� ��������������</param>
    function Login(ALoginCredentials: TLoginCredentials): Boolean; stdcall;
    /// <summary>IAuthProvider<TLoginData>.Logout
    /// �������� �������������� �������� ������������
    /// </summary>
    procedure Logout; stdcall;
  end;

  /// <summary>TNamePasswordCredentials
  /// ������ �������������� ������������ �� ����� � ������
  /// </summary>
  TNamePasswordCredentials = class
    /// <summary>TNamePasswordCredentials.LoginName
    /// ���������� ��� ������������
    /// </summary>
    /// type:String
    LoginName: String;
    /// <summary>TNamePasswordCredentials.Password
    /// ������ ������������
    /// </summary>
    /// type:String
    Password: String;
  end;

  /// <summary>INamePasswordAuthProvider
  /// ��������� �������������� � �������������� ����� � ������ ������������
  /// </summary>
  INamePasswordAuthProvider = interface(IAuthProvider<TNamePasswordCredentials>)
  ['{B0FC25ED-6792-4918-B295-156696192E94}']
  end;

implementation

end.
