{*******************************************************
* Project: OnlineMonForm8
* Unit: Lib.AppPathUnit.pas
* Description: Сервис получения путей и имен файлов в файловой системе
*
* Created: 04.04.2024 9:49:05
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Lib.AppPathUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  TAppDirType = (adtApplication, adtCurrent, adtUser, adtPublic);

  /// <summary>IAppPath
  /// Сервис получения путей и имен файлов в файловой системе
  /// </summary>
  IAppPath = interface
  ['{2CA757CE-FD6C-4462-902E-C25EC4D9F740}']
    /// <summary>IAppPath.ApplicationDir
    /// Получить каталог (опционально с подкаталогом) расположения приложения
    /// </summary>
    /// <returns> string
    /// </returns>
    /// <param name="ASubdir"> (string) Подкаталог в каталоге приложения</param>
    function ApplicationDir(ASubdir: string = ''): string; stdcall;
    /// <summary>IAppPath.GetDir
    /// Получить каталог (опционально с подкаталогом) файловой системы приложения
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="AType"> (TAppDirType) Тип каталога</param>
    function GetDir(AType: TAppDirType; ASubDir: string = ''): String; stdcall;
    function UserDir(ASubdir: string = ''): string; stdcall;
  end;

implementation

end.
