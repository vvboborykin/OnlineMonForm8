{*******************************************************
* Project: OnlineMonForm8
* Unit: Security.Crypto.StringCodecUnit.pas
* Description: ����� ��������� ������
*
* Created: 03.04.2024 13:49:11
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Security.Crypto.StringCodecUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  /// <summary>IStringCodec
  /// ����� ��������� ������
  /// </summary>
  IStringCodec = interface
    ['{B8A66153-9583-4B60-97C0-F7F49A23AF0D}']
    /// <summary>TBase64StringCodec.Decrypt
    /// ������������ ������
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) �������� ������</param>
    function Decrypt(APassword: string): String; stdcall;
    /// <summary>TBase64StringCodec.Encrypt
    /// ������������� ������
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="APassword"> (string) ������ �������������� �����</param>
    function Encrypt(APassword: string): String; stdcall;
  end;

implementation

end.
