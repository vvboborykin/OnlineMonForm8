{*******************************************************
* Project: OnlineMonForm8
* Unit: LoginServiceUnit.pas
* Description: Сервис аутентификации приложения
*
* Created: 01.04.2024 20:19:56
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit LoginServiceUnit;

interface

uses
  System.SysUtils, System.Classes, Data.SqlDatabaseConnectionDataUnit,
  System.Variants, Security.Auth.AuthProviderUnit, Security.Auth.LoginFormUnit;

type
  /// <summary>TLoginService
  /// Сервис аутентификации приложения
  /// </summary>
  TLoginService = class
  strict private
    procedure DoConnectionSettings(Sender: TObject);
    function LoadConnectionData: TSqlDatabaseConnectionData;
    function LoadLoginFormParams: TLoginFormParameters;
    procedure SaveLoginCredentials(AParams: TLoginFormParameters);
    function SetupConnection: Boolean;
  public
    /// <summary>TLoginService.Login
    /// Провести аутентификацию пользователя в СМСО
    /// </summary>
    /// <returns> Boolean
    /// True при успешной аутентификации, иначе False
    /// </returns>
    function Login: Boolean;
  end;

  /// <summary>procedure LoginService
  /// Получить глобальный экземпляр сервиса аутентификации
  /// </summary>
  /// <returns> TLoginService
  /// </returns>
function LoginService: TLoginService;

implementation

uses
  Vista.LoginDataModuleUnit, Security.Auth.UserCredentialStorageUnit,
  Data.ConnectionOptionsStorageUnit, Data.UniConnectionOptionsFormUnit;

var
  FLoginService: TLoginService;

function LoginService: TLoginService;
begin
  Result := FLoginService;
end;

procedure TLoginService.DoConnectionSettings(Sender: TObject);
begin
  SetupConnection;
end;

function TLoginService.LoadConnectionData: TSqlDatabaseConnectionData;
begin
  Result := TSqlDatabaseConnectionData.Create;
  ConnectionOptionsStorage.Load(Result);
end;

function TLoginService.LoadLoginFormParams: TLoginFormParameters;
var
  vSavePassword: Boolean;
begin
  Result := TLoginFormParameters.Create();
  NamePasswordCredentialsStorage.Load(Result, vSavePassword);
  Result.SavePassword := vSavePassword;
end;

function TLoginService.Login: Boolean;
begin
  var vLoginModule := TLoginDataModule.Create(nil);
  var vDbError := False;
  repeat
    var vConn: TSqlDatabaseConnectionData := LoadConnectionData;
    try
      vLoginModule.OpenDatabase(vConn);
    except on E: Exception do
      begin
        vDbError := True;
      end;
    end;

    if vDbError then
    begin
      vConn.Free;
      DoConnectionSettings(Self);
    end;
  until not vDbError;

  var vLoginFormParams := LoadLoginFormParams();
  vLoginFormParams.AuthProvider := vLoginModule;
  vLoginFormParams.OnConnectionSettings := Self.DoConnectionSettings;
  try
    Result := TLoginForm.Login(vLoginFormParams);
    if Result then
      SaveLoginCredentials(vLoginFormParams);
  finally
    vLoginModule.Free;
    vLoginFormParams.Free;
  end;
end;

procedure TLoginService.SaveLoginCredentials(AParams: TLoginFormParameters);
begin
  NamePasswordCredentialsStorage.Save(AParams, AParams.SavePassword);
end;

function TLoginService.SetupConnection: Boolean;
begin
  var vForm := TUniConnectionOptionsForm.Create(nil);
  try
    vForm.Init(ConnectionOptionsStorage);
    vForm.ShowModal;
  finally
    vForm.Free;
  end;
  Result := False; // TODO:
end;

initialization
  FLoginService := TLoginService.Create;

finalization
  FLoginService.Free;

end.

