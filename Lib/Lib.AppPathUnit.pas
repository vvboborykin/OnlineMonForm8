{*******************************************************
* Project: OnlineMonForm8
* Unit: Lib.AppPathUnit.pas
* Description: ������ ��������� ����� � ���� ������ � �������� �������
*
* Created: 04.04.2024 9:49:05
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Lib.AppPathUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  TAppDirType = (adtApplication, adtCurrent, adtUser, adtPublic);

  /// <summary>IAppPath
  /// ������ ��������� ����� � ���� ������ � �������� �������
  /// </summary>
  IAppPath = interface
  ['{2CA757CE-FD6C-4462-902E-C25EC4D9F740}']
    /// <summary>IAppPath.ApplicationDir
    /// �������� ������� (����������� � ������������) ������������ ����������
    /// </summary>
    /// <returns> string
    /// </returns>
    /// <param name="ASubdir"> (string) ���������� � �������� ����������</param>
    function ApplicationDir(ASubdir: string = ''): string; stdcall;
    /// <summary>IAppPath.GetDir
    /// �������� ������� (����������� � ������������) �������� ������� ����������
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="AType"> (TAppDirType) ��� ��������</param>
    function GetDir(AType: TAppDirType; ASubDir: string = ''): String; stdcall;
    function UserDir(ASubdir: string = ''): string; stdcall;
  end;

implementation

end.
