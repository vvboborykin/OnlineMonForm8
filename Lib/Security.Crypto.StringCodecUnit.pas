{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Crypto.StringCodecUnit.pas
* Description: Кодек строковых данных
*
* Created: 03.04.2024 13:49:11
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Security.Crypto.StringCodecUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>IStringCodec
  /// Кодек строковых данных
  /// </summary>
  IStringCodec = interface
    ['{B8A66153-9583-4B60-97C0-F7F49A23AF0D}']
    /// <summary>TBase64StringCodec.Decrypt
    /// Закодировать строку
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) Исходная строка</param>
    function Decrypt(APassword: string): String; stdcall;
    /// <summary>TBase64StringCodec.Encrypt
    /// Раскодировать строку
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) Строка закодированная ранее</param>
    function Encrypt(APassword: string): String; stdcall;
  end;

implementation

end.
