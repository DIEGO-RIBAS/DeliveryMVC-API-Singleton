unit Model.Cardapio;

interface

   uses
      System.SysUtils,System.JSON,
      FireDAC.Comp.Client, FireDAC.DApt,
      uConexaoSingleton,
      DataSet.Serialize;

type

     TCardaprio = class
       private
         FQuery : TFDQuery;
       public
         function Listacardapio : TJSONArray;
         constructor Create;
         destructor Destroy;
     end;


implementation

{ TCardaprio }

constructor TCardaprio.Create;
begin
  FQuery := TFDQuery.Create(nil);
end;

destructor TCardaprio.Destroy;
begin
  FreeAndNil(FQuery);
end;

function TCardaprio.Listacardapio: TJSONArray;
begin
  FQuery.Connection := TInstanciaConexao.ObterInstancia.Conexao;
  try
     FQuery.SQL.Add('select P.ID, P.Descricao, P.Preco,');
     FQuery.SQL.Add('C.categoria as descrcategoria');
     FQuery.SQL.Add('from');
     FQuery.SQL.Add('Produto P');
     FQuery.SQL.Add('left join produto_categoria C on C.id = P.id_categoria');
     FQuery.SQL.Add('Order By C.Categoria, P.Descricao');
     FQuery.Open();
  finally
     Result := FQuery.ToJSONArray();
  end;
end;

end.
