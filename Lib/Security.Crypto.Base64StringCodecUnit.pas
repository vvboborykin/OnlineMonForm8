{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Crypto.Base64StringCodecUnit.pas
* Description: Кодек использующий Base64
*
* Created: 03.04.2024 13:45:43
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Security.Crypto.Base64StringCodecUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.NetEncoding,
  Security.Crypto.StringCodecUnit;

type
  /// <summary>TBase64StringCodec
  /// Объект-Кодек использующий Base64
  /// </summary>
  TBase64StringCodec = class(TInterfacedObject, IStringCodec)
  strict private
  strict protected
    /// <summary>TBase64StringCodec.Decrypt
    /// Закодировать строку в BASE64
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) Исходная строка</param>
    function Decrypt(APassword: string): String; stdcall;
    /// <summary>TBase64StringCodec.Encrypt
    /// Раскодировать строку из BASE64
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) Строка закодированная ранее в BASE64</param>
    function Encrypt(APassword: string): String; stdcall;
  end;

implementation

function TBase64StringCodec.Decrypt(APassword: string): String;
begin
  Result := TNetEncoding.Base64String.Decode(APassword);
end;

function TBase64StringCodec.Encrypt(APassword: string): String;
begin
  Result := TNetEncoding.Base64String.Encode(APassword);
end;

end.
