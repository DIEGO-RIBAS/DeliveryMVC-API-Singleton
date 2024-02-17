unit uConexaoSingleton;

interface
  Uses
  System.SysUtils,


  FireDAC.DApt,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,
  Data.DB,
  FireDAC.Comp.Client,

  uConexxao.Entity ;

  type
    TInstanciaConexao = class(TConexaoSQLite)
      private
        Fcon : TFDConnection;

        {SQLite}
        FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;

      public
        class Function ObterInstancia : TInstanciaConexao;
        property Conexao : TFDConnection read FCon;

        constructor Create;
    end;

implementation

  var
    InstanciaDB : TInstanciaConexao;

constructor TInstanciaConexao.Create;
var
  Conexao : TConexaoSQLite;
begin
  inherited;

  Conexao := TConexaoSQLite.Create;
  FDPhysSQLiteDriverLink1 := TFDPhysSQLiteDriverLink.Create(nil);

  FCon := TFDConnection.Create(Nil);

  { Conexão SQLite }
  try
    with Conexao do
    begin
      FCon.Params.DriverID := DriverID;
      FCon.Params.UserName := UserName;
      Fcon.Params.Password := Password;
      Fcon.Params.Database := DataBase;
    end;
  finally
    FreeAndNil(Conexao);
  end;

  try
    Fcon.Connected := True;
  except on E : Exception do
     begin
       raise Exception.Create('Erro na conexão :'+E.Message);
     end;
  end;
end;

class function TInstanciaConexao.ObterInstancia: TInstanciaConexao;
begin
  if InstanciaDB = nil then
    InstanciaDB := TInstanciaConexao.Create;

  Result := InstanciaDB;
end;

end.
