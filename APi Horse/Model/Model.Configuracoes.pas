unit Model.Configuracoes;

interface

   uses
    System.JSON,System.SysUtils,
    FireDAC.Comp.Client, FireDAC.DApt,
    DataSet.Serialize,
    {Singleton}
    uConexaoSingleton;

  type

    TConfig = class
      private
        FQuery : TFDQuery;
      public
         function getConfig : TJSONObject;

         constructor Create();
         destructor Destroy;
    end;

implementation

{ TConfig }

constructor TConfig.Create;
begin
  FQuery := TFDQuery.Create(nil);
end;

destructor TConfig.Destroy;
begin
  FreeAndNil(FQuery);
end;

function TConfig.getConfig: TJSONObject;
begin
  FQuery.Connection := TInstanciaConexao.ObterInstancia.Conexao;

  try
    with FQuery do
    begin
      SQL.Add('Select Vlr_Entrega from Config limit 1');
      Open();
    end;

  finally
    Result := FQuery.ToJSONObject();
  end;
end;

end.
