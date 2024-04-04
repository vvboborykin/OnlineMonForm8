{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Auth.UserCredentialStorageUnit.pas
* Description: ��������� ������ �������������� ������������
*
* Created: 03.04.2024 13:33:35
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Security.Auth.UserCredentialStorageUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Security.Auth.AuthProviderUnit;

type
  /// <summary>IUserCredentialStorage
  /// ��������� ������ �������������� ������������
  /// </summary>
  IUserCredentialStorage<TLoginCredentials> = interface
    ['{2AA2A0E9-6266-444A-BE25-7270459A9E72}']
    procedure Load(ACredentials: TLoginCredentials; var ASavePassword: Boolean);
        stdcall;
    procedure Save(ACredentials: TLoginCredentials; ASavePassword: Boolean);
        stdcall;
  end;

  /// <summary>INamePasswordCredentialsStorage
  /// ��������� ����� � ������ ������������
  /// </summary>
  INamePasswordCredentialsStorage = interface(IUserCredentialStorage<TNamePasswordCredentials>)
    ['{E1987CE2-5424-41FA-B32F-DFA7C1791AA2}']
  end;

var
  NamePasswordCredentialsStorage: INamePasswordCredentialsStorage;

implementation

end.

