{*******************************************************
* Project: OnlineMonForm8
* Unit: Log.ErrorLoggerUnit.pas
* Description: ������ ���������������� ������
*
* Created: 03.04.2024 14:58:15
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Log.ErrorLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, Vcl.AppEvnts;

type
  /// <summary>TErrorLogger
  /// ������ ���������������� ������
  /// </summary>
  TErrorLogger = class(TDataModule)
    apeMain: TApplicationEvents;
    procedure apeMainException(Sender: TObject; E: Exception);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ErrorLogger: TErrorLogger;

implementation

uses
  Log.LoggerUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TErrorLogger.apeMainException(Sender: TObject; E: Exception);
begin
  Logger.AddError(E.Message, []);
  raise E;
end;

end.
