{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Auth.LoginFormUnit.pas
* Description: Форма аутентификации по логину и паролю
*
* Created: 31.03.2024 21:35:39
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Security.Auth.LoginFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils, Security.Auth.AuthProviderUnit,
  System.NetEncoding, System.UITypes, Vcl.Buttons;

type
  /// <summary>TLoginFormParameters
  /// Параметры проведения аутентификации
  /// </summary>
  TLoginFormParameters = class(TNamePasswordCredentials)
  strict private
    FAuthProvider: INamePasswordAuthProvider;
    FOnConnectionSettings: TNotifyEvent;
    FSavePassword: Boolean;
  public
    /// <summary>TLoginFormParameters.AuthProvider
    /// Провайдер аутентификации
    /// </summary>
    /// type:INamePasswordAuthProvider
    property AuthProvider: INamePasswordAuthProvider read FAuthProvider write
        FAuthProvider;
    /// <summary>TLoginFormParameters.SavePassword
    /// Флаг сохранения пароля в настройках пользователя
    /// </summary>
    /// type:Boolean
    property SavePassword: Boolean read FSavePassword write FSavePassword;
    /// <summary>TLoginFormParameters.OnConnectionSettings
    /// Обработчик события вызываемый при нажатии на кнопку настроек соединения
    /// </summary>
    /// type:TNotifyEvent
    property OnConnectionSettings: TNotifyEvent read FOnConnectionSettings write
        FOnConnectionSettings;
  end;


  /// <summary>TLoginForm
  /// Форма аутентификации по логину и паролю
  /// </summary>
  TLoginForm = class(TForm)
    bvlBottom: TBevel;
    btnLogin: TButton;
    btnCancel: TButton;
    lblLogin: TLabel;
    edtLogin: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    chkSavePassword: TCheckBox;
    btnOptions: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
  strict private
    FParams: TLoginFormParameters;
    procedure Init(ALoginFormParameters: TLoginFormParameters);
    procedure LoadControls;
    procedure SaveControls;
  public
    /// <summary>TLoginForm.Login
    /// Попытка аутентификации
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="AAuthProvider"> (INamePasswordAuthProvider) Провайдер
    /// аутентификации по логину и паролю</param>
    /// <param name="ALoginCredentials"> (TNamePasswordLoginData) Исходный логин и
    /// пароль</param>
    class function Login(ALoginFormParameters: TLoginFormParameters): Boolean;
  end;

implementation

{$R *.dfm}

resourcestring
  SLoginError = 'Ошибка входа. Неверное логическое имя или пароль';

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' "' + Application.Title + '"';
end;

procedure TLoginForm.btnCancelClick(Sender: TObject);
begin
  Close();
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
begin
  SaveControls();
  if not FParams.AuthProvider.Login(FParams) then
  begin
    MessageDlg(SLoginError,
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    ModalResult := mrNone;
  end;
end;

procedure TLoginForm.btnOptionsClick(Sender: TObject);
begin
  if Assigned(FParams.OnConnectionSettings) then
    FParams.OnConnectionSettings(FParams);
end;

procedure TLoginForm.Init(ALoginFormParameters: TLoginFormParameters);
begin
  FParams := ALoginFormParameters;
  LoadControls;
end;

procedure TLoginForm.LoadControls;
begin
  with FParams do
  begin
    edtLogin.Text := LoginName;
    edtPassword.Text := Password;
    chkSavePassword.Checked := SavePassword;
  end;
end;

class function TLoginForm.Login(ALoginFormParameters: TLoginFormParameters):
    Boolean;
begin
  var vForm := TLoginForm.Create(nil);
  try
    vForm.Init(ALoginFormParameters);
    Result := IsPositiveResult(vForm.ShowModal);
  finally
    vForm.Free;
  end;
end;

procedure TLoginForm.SaveControls;
begin
  with FParams do
  begin
    LoginName := edtLogin.Text;
    Password := edtPassword.Text;
    SavePassword := chkSavePassword.Checked;
  end;
end;

end.

