{*******************************************************
* Project: OnlineMonForm8
* Unit: UserIniCredentialStorageUnit.pas
* Description: Хранилище данных аутентификации пользователя в ini файле
*
* Created: 03.04.2024 13:36:59
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit UserIniCredentialStorageUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Security.Auth.UserCredentialStorageUnit,
  Security.Auth.AuthProviderUnit, Security.Crypto.StringCodecOwnerUnit;

type
  /// <summary>TUserIniCredentialStorage
  /// Хранилище данных аутентификации пользователя в ini файле
  /// </summary>
  TUserIniCredentialStorage = class(TStringCodecOwner,
      INamePasswordCredentialsStorage)
  strict private
    procedure Load(ACredentials: TNamePasswordCredentials; var ASavePassword: Boolean);
        stdcall;
    procedure Save(ACredentials: TNamePasswordCredentials; ASavePassword: Boolean);
        stdcall;
  end;

implementation

uses
  UserIniOptionsUnit, Ini.IniFileNamesUnit, Security.Crypto.Base64StringCodecUnit;

{ TUserIniCredentialStorage }

procedure TUserIniCredentialStorage.Load(ACredentials: TNamePasswordCredentials;
  var ASavePassword: Boolean);
begin
  UserIniOptions.LoadFromFile(IniFileNames.UserIniFileName);
  with UserIniOptions.LoginOptionsSection do
  begin
    ACredentials.LoginName := LoginName;
    ASavePassword := SavePassword;
    if ASavePassword then
      ACredentials.Password := Decrypt(Password)
    else
      ACredentials.Password := '';
  end;
end;

procedure TUserIniCredentialStorage.Save(ACredentials: TNamePasswordCredentials;
  ASavePassword: Boolean);
begin
  with UserIniOptions.LoginOptionsSection do
  begin
    LoginName := ACredentials.LoginName;
    SavePassword := ASavePassword;
    if SavePassword then
      Password := Encrypt(ACredentials.Password)
    else
      Password := '';
  end;

  UserIniOptions.SaveToFile(IniFileNames.UserIniFileName);
end;

initialization
  NamePasswordCredentialsStorage := TUserIniCredentialStorage.Create(TBase64StringCodec.Create);
end.
