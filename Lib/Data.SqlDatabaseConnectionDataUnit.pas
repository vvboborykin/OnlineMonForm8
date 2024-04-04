{*******************************************************
* Project: OnlineMonForm8
* Unit: Data.SqlDatabaseConnectionDataUnit.pas
* Description: �������� ����������� ��� ����������� � SQL ���� ������
*
* Created: 03.04.2024 14:26:49
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Data.SqlDatabaseConnectionDataUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>TSqlDatabaseConnectionData
  /// �������� ����������� ��� ����������� � SQL ���� ������
  /// </summary>
  TSqlDatabaseConnectionData = class
  strict private
    FDatabase: String;
    FPassword: String;
    FServer: String;
    FUserName: String;
  public
    /// <summary>TSqlDatabaseConnectionData.Database
    /// ��� ���� ������ � ������� ���������� �����������
    /// </summary>
    /// type:String
    property Database: String read FDatabase write FDatabase;
    /// <summary>TSqlDatabaseConnectionData.Password
    /// ������ ������������ ������� ��
    /// </summary>
    /// type:String
    property Password: String read FPassword write FPassword;
    /// <summary>TSqlDatabaseConnectionData.Server
    /// �������� ��� ��� IP ����� ������ ��
    /// </summary>
    /// type:String
    property Server: String read FServer write FServer;
    /// <summary>TSqlDatabaseConnectionData.UserName
    /// ��� ������������ ������� ��
    /// </summary>
    /// type:String
    property UserName: String read FUserName write FUserName;
  end;

implementation

end.
