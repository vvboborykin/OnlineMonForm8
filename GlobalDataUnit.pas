unit GlobalDataUnit;

interface

uses
  System.SysUtils, System.Classes, Vista.LoginDataModuleUnit, UniProvider,
  MySQLUniProvider, Data.DB, DBAccess, Uni;

type
  TGlobalData = class(TLoginDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalData: TGlobalData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
