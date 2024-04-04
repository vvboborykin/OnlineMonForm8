{*******************************************************
* Project: OnlineMonForm8
* Unit: Di.ContainerUnit.pas
* Description: ������� ��������� ������������
*
* Created: 04.04.2024 8:04:32
* Copyright (C) 2024 ��������� �.�. (bpost@yandex.ru)
*******************************************************}
unit Di.ContainerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Generics.Collections,
  System.Rtti;

type
  /// <summary>TContainer
  /// ������� ��������� ������������
  /// </summary>
  TContainer = class
  strict private
    FSingletons: TDictionary<string, IInterface>;
    FRegistry: TDictionary<string, TInterfacedClass>;
    function GetInterfaceGuid<T: IInterface>: TGUID;
    function GetKey(IID: TGUID; AName: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>TContainer.GetSingleton<>
    /// �������� ������������������ ����� ���������-��������
    /// </summary>
    /// <returns> T
    /// </returns>
    /// <param name="AName"> (string) </param>
    function GetSingleton<T: IInterface>(AName: string = ''): T;
      /// <summary>TContainer.RegisterImplementor<T: ����������� ���������, U: ����� ����������� ���>
    /// ���������������� ���������� ����������
    /// </summary>
    ///  ������� ��������� ������������
    /// <returns> TContainer
    /// </returns>
    /// <param name="AName"> (string) ��� ����������</param>
    function RegisterImplementor<T: IInterface; U: TInterfacedObject>(AName:
      string = ''): TContainer; overload;
    /// <summary>TContainer.RegisterImplementor<T: ����������� ���������>
    /// ���������������� ���������� ����������
    /// </summary>
    ///  ������� ��������� ������������
    /// <returns> TContainer
    /// </returns>
    /// <param name="AName"> (string) ��� ����������</param>
    function RegisterImplementor<T: IInterface>(AImplementorClass:
      TInterfacedClass; AName: string = ''): TContainer; overload;
    /// <summary>TContainer.RegisterImplementor
    /// ���������������� ���������� ����������
    /// </summary>
    /// <returns> TContainer
    /// </returns>
    /// <param name="IID"> (TGUID) GUIG ������������ ����������</param>
    /// <param name="AImplementorClass"> (TInterfacedClass) �����, �����������
    /// ���������</param>
    /// <param name="AName"> (string) ��� ����������</param>
    function RegisterImplementor(IID: TGUID; AImplementorClass: TInterfacedClass;
      AName: string = ''): TContainer; overload;
    /// <summary>TContainer.RegisterSingleton<T: IInterface>
    /// ���������������� ��������� ����������
    /// </summary>
    /// <returns> TContainer
    /// </returns>
    /// <param name="ASingleton"> (TObject) ������ - ��������</param>
    /// <param name="AName"> (string) ��� ����������</param>
    function RegisterSingleton<T: IInterface>(ASingleton: T; AName: string = ''):
        TContainer; overload;
    function RegisterSingleton<T: IInterface>(ASingletonClass: TInterfacedClass;
        AName: string = ''): TContainer; overload;
    /// <summary>TContainer.Resolve<T: ������������� ���������>
    /// </summary>
    /// ��������� �������, ����������� ���������
    /// <returns> T
    /// </returns>
    /// <param name="AName"> (string) ��� ����������</param>
    function Resolve<T: IInterface>(AName: string = ''): T;
  end;

/// <summary>procedure GlobalContainer
/// ���������� ��������� ����������
/// </summary>
/// <returns> TContainer
/// </returns>
function GlobalContainer: TContainer;

implementation

var
  FGlobalContainer: TContainer;

function GlobalContainer: TContainer;
begin
  Result := FGlobalContainer;
end;

constructor TContainer.Create;
begin
  inherited Create;
  FRegistry := TDictionary<string, TInterfacedClass>.Create();
  FSingletons := TDictionary<string, IInterface>.Create();
end;

destructor TContainer.Destroy;
begin
  FSingletons.Free;
  FRegistry.Free;
  inherited Destroy;
end;

function TContainer.GetInterfaceGuid<T>: TGUID;
begin
  var vContext := TRttiContext.Create;
  try
    Result := TRTTIInterfaceType(vContext.GetType(TypeInfo(T))).GUID;
  finally
    vContext.Free;
  end;
end;

function TContainer.GetKey(IID: TGUID; AName: string): string;
begin
  Result := IID.ToString() + '_' + AName;
end;

function TContainer.GetSingleton<T>(AName: string = ''): T;
var
  vIID: TGUID;
begin
  vIID := GetInterfaceGuid<T>();
  var vKey := GetKey(vIID, AName);
  var vSingleton := FSingletons[vKey];
  Supports(vSingleton, vIID, Result);
end;

function TContainer.RegisterImplementor(IID: TGUID; AImplementorClass:
  TInterfacedClass; AName: string = ''): TContainer;
begin
  var vKey := GetKey(IID, AName);
  FRegistry.AddOrSetValue(vKey, AImplementorClass);
  Result := Self;
end;

function TContainer.RegisterImplementor<T, U>(AName: string = ''): TContainer;
begin
  Result := RegisterImplementor<T>(TInterfacedClass(TypeInfo(U)), AName);
end;

function TContainer.RegisterImplementor<T>(AImplementorClass: TInterfacedClass;
  AName: string = ''): TContainer;
begin
  var vIID: TGUID := GetInterfaceGuid<T>();
  Result := RegisterImplementor(vIID, TInterfacedClass(TypeInfo(T)), AName);
end;

function TContainer.RegisterSingleton<T>(ASingletonClass: TInterfacedClass;
    AName: string = ''): TContainer;
var
  vSingleton: T;
begin
  Supports(ASingletonClass.Create, GetInterfaceGuid<T>(), vSingleton);
  Result := RegisterSingleton<T>(vSingleton, AName);
end;

function TContainer.RegisterSingleton<T>(ASingleton: T; AName: string = ''):
    TContainer;
begin
  var vKey := GetKey(GetInterfaceGuid<T>(), AName);
  FSingletons.AddOrSetValue(vKey, ASingleton);
  Result := Self;
end;

function TContainer.Resolve<T>(AName: string = ''): T;
var
  vIID: TGUID;
begin
  vIID := GetInterfaceGuid<T>();
  var vKey := GetKey(vIID, AName);
  Supports(FRegistry[vKey].Create, vIID, Result);
end;

initialization
  FGlobalContainer := TContainer.Create;
finalization
  FreeAndNil(FGlobalContainer);
end.

