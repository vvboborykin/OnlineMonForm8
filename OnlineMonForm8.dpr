program OnlineMonForm8;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  ReportBuilderModuleUnit in 'ReportBuilderModuleUnit.pas' {ReportBuilderModule: TDataModule},
  IniOptionsUnit in 'IniOptionsUnit.pas',
  MsOffice.Excel.ExcelServiceUnit in 'Lib\MsOffice.Excel.ExcelServiceUnit.pas',
  Task.ProgressControllerUnit in 'Lib\Task.ProgressControllerUnit.pas',
  Task.ProgressFormUnit in 'Lib\Task.ProgressFormUnit.pas' {ProgressForm},
  Security.Auth.LoginFormUnit in 'Lib\Security.Auth.LoginFormUnit.pas' {LoginForm},
  Security.Auth.AuthProviderUnit in 'Lib\Security.Auth.AuthProviderUnit.pas',
  Vista.LoginDataModuleUnit in 'Lib\Vista.LoginDataModuleUnit.pas' {LoginDataModule: TDataModule},
  Ini.IniFileNamesUnit in 'Lib\Ini.IniFileNamesUnit.pas',
  Data.SqlDatabaseConnectionDataUnit in 'Lib\Data.SqlDatabaseConnectionDataUnit.pas',
  LoginServiceUnit in 'LoginServiceUnit.pas',
  Data.UniConnectionHelperUnit in 'Lib\Data.UniConnectionHelperUnit.pas',
  Data.FieldNameAttributeUnit in 'Lib\Data.FieldNameAttributeUnit.pas',
  Data.UniDataModuleUnit in 'Lib\Data.UniDataModuleUnit.pas' {UniDataModule: TDataModule},
  UserIniOptionsUnit in 'UserIniOptionsUnit.pas',
  Log.LoggerUnit in 'Lib\Log.LoggerUnit.pas',
  Log.BaseLoggerUnit in 'Lib\Log.BaseLoggerUnit.pas',
  Log.TextFileLoggerUnit in 'Lib\Log.TextFileLoggerUnit.pas',
  Data.UniConnectionOptionsFormUnit in 'Lib\Data.UniConnectionOptionsFormUnit.pas' {UniConnectionOptionsForm},
  Data.ConnectionOptionsStorageUnit in 'Lib\Data.ConnectionOptionsStorageUnit.pas',
  IniConnectionOptionsStorageUnit in 'IniConnectionOptionsStorageUnit.pas',
  Security.Auth.UserCredentialStorageUnit in 'Lib\Security.Auth.UserCredentialStorageUnit.pas',
  UserIniCredentialStorageUnit in 'UserIniCredentialStorageUnit.pas',
  Security.Crypto.Base64StringCodecUnit in 'Lib\Security.Crypto.Base64StringCodecUnit.pas',
  Security.Crypto.StringCodecUnit in 'Lib\Security.Crypto.StringCodecUnit.pas',
  Security.Crypto.StringCodecOwnerUnit in 'Lib\Security.Crypto.StringCodecOwnerUnit.pas',
  Log.ErrorLoggerUnit in 'Lib\Log.ErrorLoggerUnit.pas' {ErrorLogger: TDataModule},
  GlobalDataUnit in 'GlobalDataUnit.pas' {GlobalData: TDataModule},
  DbConnSetupServiceUnit in 'DbConnSetupServiceUnit.pas',
  Di.ContainerUnit in 'Lib\Di.ContainerUnit.pas',
  Lib.AppPathUnit in 'Lib\Lib.AppPathUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Онлайн мониторинг форма 8';
  if LoginService.Login then
    Application.CreateForm(TErrorLogger, ErrorLogger);
  Application.CreateForm(TGlobalData, GlobalData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
