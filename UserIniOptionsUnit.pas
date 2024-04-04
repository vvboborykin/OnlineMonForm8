unit UserIniOptionsUnit;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  csIniLoginOptionsSection = 'LoginOptions';

  {Section: LoginOptions}
  csIniLoginOptionsLoginName = 'LoginName';
  csIniLoginOptionsPassword = 'Password';
  csIniLoginOptionsSavePassword = 'SavePassword';

type
  TLoginOptionsSection = class
  private
    FLoginName: string;
    FPassword: string;
    FSavePassword: Boolean;
  public
    property LoginName: string read FLoginName write FLoginName;
    property Password: string read FPassword write FPassword;
    property SavePassword: Boolean read FSavePassword write FSavePassword;
  end;

  TUserIniOptions = class(TObject)
  private
    {Section: LoginOptions}
    FLoginOptionsSection: TLoginOptionsSection;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure LoadSettings(Ini: TMemIniFile);
    procedure SaveSettings(Ini: TMemIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: LoginOptions}
    property LoginOptionsSection: TLoginOptionsSection read FLoginOptionsSection;
  end;

var
  UserIniOptions: TUserIniOptions = nil;

implementation

procedure TUserIniOptions.LoadSettings(Ini: TMemIniFile);
begin
  if Ini <> nil then
  begin
    {Section: LoginOptions}
    FLoginOptionsSection.LoginName := Ini.ReadString(csIniLoginOptionsSection, csIniLoginOptionsLoginName, 'user6');
    FLoginOptionsSection.Password := Ini.ReadString(csIniLoginOptionsSection, csIniLoginOptionsPassword, '');
    FLoginOptionsSection.SavePassword := Ini.ReadBool(csIniLoginOptionsSection, csIniLoginOptionsSavePassword, True);
  end;
end;

procedure TUserIniOptions.SaveSettings(Ini: TMemIniFile);
begin
  if Ini <> nil then
  begin
    {Section: LoginOptions}
    Ini.WriteString(csIniLoginOptionsSection, csIniLoginOptionsLoginName, FLoginOptionsSection.LoginName);
    Ini.WriteString(csIniLoginOptionsSection, csIniLoginOptionsPassword, FLoginOptionsSection.Password);
    Ini.WriteBool(csIniLoginOptionsSection, csIniLoginOptionsSavePassword, FLoginOptionsSection.SavePassword);
  end;
end;

procedure TUserIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(FileName);
  try
    LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TUserIniOptions.SaveToFile(const FileName: string);
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(FileName);
  try
    SaveSettings(Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

constructor TUserIniOptions.Create;
begin
  inherited;
  FLoginOptionsSection := TLoginOptionsSection.Create;
end;

destructor TUserIniOptions.Destroy;
begin
  FLoginOptionsSection.Free;
  inherited;
end;

initialization
  UserIniOptions := TUserIniOptions.Create;

finalization
  UserIniOptions.Free;

end.

