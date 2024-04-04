unit DbConnSetupServiceUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  TDbConnSetupService = class
  strict private
    function TryConnectGlobalData: Boolean;
  public
    function ConnectGlobalData: Boolean;
  end;
implementation

uses
  GlobalDataUnit, Data.UniConnectionOptionsFormUnit, Data.SqlDatabaseConnectionDataUnit;

function TDbConnSetupService.ConnectGlobalData: Boolean;
begin
  var tryCount := 0;
  while not TryConnectGlobalData() and (tryCount < 3) do
  begin

  end;
  Result := GlobalData.conMain.Connected;
end;

function TDbConnSetupService.TryConnectGlobalData: Boolean;
begin
  var vConnParrams := TSqlDatabaseConnectionData.Create;
  Result := False;
  // TODO -cMM: TDbConnSetupService.TryConnectGlobalData default body inserted
end;

end.
