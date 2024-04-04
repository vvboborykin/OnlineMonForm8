unit IniOptionsUnit;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  iniConnectionSection = 'Connection';
  iniOptionsSection = 'Options';

  {Section: Connection}
  iniConnectionServer = 'Server';
  iniConnectionDatabase = 'Database';
  iniConnectionUserName = 'UserName';
  iniConnectionPassword = 'Password';

  {Section: Options}
  iniOptionsDateEndField = 'DateEndField';
  iniOptionsUseInogor = 'UseInogor';

type
  TConnectionSection = class
  private
    FServer: string;
    FDatabase: string;
    FUserName: string;
    FPassword: string;
  public
    property Server: string read FServer write FServer;
    property Database: string read FDatabase write FDatabase;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

  TOptionsSection = class
  private
    FDateEndField: Integer;
    FUseInogor: Boolean;
  public
    property DateEndField: Integer read FDateEndField write FDateEndField;
    property UseInogor: Boolean read FUseInogor write FUseInogor;
  end;

  TIniOptions = class(TObject)
  private
    {Section: Connection}
    FConnectionSection: TConnectionSection;
    {Section: Options}
    FOptionsSection: TOptionsSection;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure LoadSettings(Ini: TMemIniFile);
    procedure SaveSettings(Ini: TMemIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: Connection}
    property ConnectionSection: TConnectionSection read FConnectionSection;
    {Section: Options}
    property OptionsSection: TOptionsSection read FOptionsSection;
  end;

var
  IniOptions: TIniOptions = nil;

implementation

procedure TIniOptions.LoadSettings(Ini: TMemIniFile);
begin
  if Ini <> nil then
  begin
    {Section: Connection}
    FConnectionSection.Server := Ini.ReadString(iniConnectionSection, iniConnectionServer, 'MySqlServer');
    FConnectionSection.Database := Ini.ReadString(iniConnectionSection, iniConnectionDatabase, 's11');
    FConnectionSection.UserName := Ini.ReadString(iniConnectionSection, iniConnectionUserName, '');
    FConnectionSection.Password := Ini.ReadString(iniConnectionSection, iniConnectionPassword, '');

    {Section: Options}
    FOptionsSection.DateEndField := Ini.ReadInteger(iniOptionsSection, iniOptionsDateEndField, 0);
    FOptionsSection.UseInogor := Ini.ReadBool(iniOptionsSection, iniOptionsUseInogor, True);
  end;
end;

procedure TIniOptions.SaveSettings(Ini: TMemIniFile);
begin
  if Ini <> nil then
  begin
    {Section: Connection}
    Ini.WriteString(iniConnectionSection, iniConnectionServer, FConnectionSection.Server);
    Ini.WriteString(iniConnectionSection, iniConnectionDatabase, FConnectionSection.Database);
    Ini.WriteString(iniConnectionSection, iniConnectionUserName, FConnectionSection.UserName);
    Ini.WriteString(iniConnectionSection, iniConnectionPassword, FConnectionSection.Password);

    {Section: Options}
    Ini.WriteInteger(iniOptionsSection, iniOptionsDateEndField, FOptionsSection.DateEndField);
    Ini.WriteBool(iniOptionsSection, iniOptionsUseInogor, FOptionsSection.UseInogor);
  end;
end;

procedure TIniOptions.LoadFromFile(const FileName: string);
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

procedure TIniOptions.SaveToFile(const FileName: string);
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

constructor TIniOptions.Create;
begin
  inherited;
  FConnectionSection := TConnectionSection.Create;
  FOptionsSection := TOptionsSection.Create;
end;

destructor TIniOptions.Destroy;
begin
  FConnectionSection.Free;
  FOptionsSection.Free;
  inherited;
end;

initialization
  IniOptions := TIniOptions.Create;

finalization
  IniOptions.Free;

end.

