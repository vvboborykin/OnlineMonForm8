{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Crypto.StringCodecOwnerUnit.pas
* Description: Объект использующий строковый кодек
*
* Created: 03.04.2024 13:56:48
* Copyright (C) 2024 Боборыкин В.В. (bpost@yandex.ru)
*******************************************************}
unit Security.Crypto.StringCodecOwnerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Security.Crypto.StringCodecUnit;

type
  /// <summary>TStringCodecOwner
  /// Объект использующий строковый кодек
  /// </summary>
  TStringCodecOwner = class(TInterfacedObject)
  strict private
  strict protected
    FCodec: IStringCodec;
    function Decrypt(APassword: string): String; virtual;
    function Encrypt(APassword: string): String; virtual;
  public
    /// <summary>TStringCodecOwner.Create
    /// </summary>
    /// <param name="ACodec"> (IStringCodec) Строковый кодек используемый для
    /// кодирования - декодирования строк</param>
    constructor Create(ACodec: IStringCodec);
  end;

implementation

constructor TStringCodecOwner.Create(ACodec: IStringCodec);
begin
  inherited Create;
  FCodec := ACodec;
end;

function TStringCodecOwner.Decrypt(APassword: string): String;
begin
  Result := FCodec.Decrypt(APassword);
end;

function TStringCodecOwner.Encrypt(APassword: string): String;
begin
  Result := FCodec.Encrypt(APassword);
end;

end.
