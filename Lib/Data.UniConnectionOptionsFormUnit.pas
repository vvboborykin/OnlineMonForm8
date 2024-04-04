{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.UniConnectionOptionsFormUnit.pas
* Description: Форма редактора настроек подключения к БД
*
* Created: 03.04.2024 12:00:24
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Data.UniConnectionOptionsFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.ConnectionOptionsStorageUnit,
  Data.SqlDatabaseConnectionDataUnit;

type
  /// <summary>TUniConnectionOptionsForm
  /// Форма редактора настроек подключения к БД
  /// </summary>
  TUniConnectionOptionsForm = class(TForm)
    bvlBottom: TBevel;
    btnSave: TButton;
    btnCancel: TButton;
    lblServer: TLabel;
    edtServer: TEdit;
    lblDatabase: TLabel;
    edtDatabase: TEdit;
    lblLogin: TLabel;
    lblPassword: TLabel;
    edtUserName: TEdit;
    edtPassword: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  strict private
    FConnOptions: TSqlDatabaseConnectionData;
    FStorage: IConnectionOptionsStorage;
    procedure LoadControlsFromStorage;
  private
  public
    /// <summary>TUniConnectionOptionsForm.Init
    /// Инициализация формы
    /// </summary>
    /// <param name="AStorage"> (IConnectionOptionsStorage) </param>
    procedure Init(AStorage: IConnectionOptionsStorage);
  end;


implementation

{$R *.dfm}

procedure TUniConnectionOptionsForm.btnSaveClick(Sender: TObject);
begin
  with FConnOptions do
  begin
    Server := edtServer.Text;
    Database := edtDatabase.Text;
    UserName := edtUserName.Text;
    Password := edtPassword.Text;
  end;
  FStorage.Save(FConnOptions);
end;

procedure TUniConnectionOptionsForm.FormDestroy(Sender: TObject);
begin
  FConnOptions.Free;
end;

procedure TUniConnectionOptionsForm.FormCreate(Sender: TObject);
begin
  FConnOptions := TSqlDatabaseConnectionData.Create;
end;

procedure TUniConnectionOptionsForm.Init(AStorage: IConnectionOptionsStorage);
begin
  FStorage := AStorage;
  LoadControlsFromStorage();
end;

procedure TUniConnectionOptionsForm.LoadControlsFromStorage;
begin
  FStorage.Load(FConnOptions);
  with FConnOptions do
  begin
    edtServer.Text := Server;
    edtDatabase.Text := Database;
    edtUserName.Text := UserName;
    edtPassword.Text := Password;
  end;
end;

end.

