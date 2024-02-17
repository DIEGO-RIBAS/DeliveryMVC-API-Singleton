unit uModel.Produto;

interface

    uses
      System.SysUtils,
      {FireDac}
      FireDAC.Comp.Client,FireDAC.DApt,FireDAC.Stan.Def,FireDAC.Phys.MySQL,FireDAC.Phys.MySQLDef,
        FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,
      Data.DB,


       FireDAC.VCLUI.Wait,
       FireDAC.Stan.Async,

      {MyClass}
      uEntity.CadastroProduto,
      uDao.ConexaoSingleton;

    type

      TModelProduto = class
        private
          FQuery : TFDQuery;
        public
          function Gravar(Produto: TEntityProduto; newProd:Boolean): Boolean;
          function GetLista(tpLista : integer): TEntityListaProdutos;
          function AtualizaProdutosAposEnvio(Lista : TEntityListaProdutos):Boolean;

          constructor Create;
          destructor Destroy;
      end;

implementation

{ TProduto }

function TModelProduto.AtualizaProdutosAposEnvio(Lista: TEntityListaProdutos): Boolean;
var
  i : Integer;
begin
  for I := 0 to Pred(Lista.ListaProdutos.Count) do
   begin
     FQuery.Close;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Update produto set api='+ Lista.ListaProdutos[i].API.ToString +', atualizado = 1 where id =  '+ Lista.ListaProdutos[i].ID.ToString );
     FQuery.ExecSQL;
   end;

   Result := True;
end;

constructor TModelProduto.Create;
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TConexaoSingleton.GetInstance.Conexao;
end;

destructor TModelProduto.Destroy;
begin
  FreeAndNil(FQuery);
end;

function TModelProduto.GetLista(tpLista: integer): TEntityListaProdutos;
var
  Lista : TEntityListaProdutos;
begin
  try
    with FQuery do
    begin
      SQL.Clear;
      SQL.Add('Select Id, nome, Descricao, Preco, Foto, idCategoria, API, atualizado from produto where id > 0 ');
      case tpLista of
        0 : SQL.Add('and produto.UpDate = 0 '); { Atualizado na APi = False }
        1 : SQL.Add('and produto.UpDate = 1 '); { Atualizado na APi = True  }
      end;

    //  sql.SaveToFile('C:\Sql.txt');

      try
        Open;
      except On E: Exception do
        begin
          raise Exception.Create('Erro ao listar produtos :'+ e.Message);
        end;
      end;

      Lista := TEntityListaProdutos.Create;
      try
        while not Eof do
        begin
          with Lista do
          begin
            Produto.ID          := FieldByName('id').AsInteger;
            Produto.Nome        := FieldByName('nome').AsString;
            Produto.Descricao   := FieldByName('descricao').AsString;
            Produto.Preco       := FieldByName('preco').AsFloat;
            Produto.Foto        := FieldByName('foto').AsString;
            Produto.IdCategoria := FieldByName('idcategoria').AsInteger;
            Produto.API         := FieldByName('API').AsInteger;
            Produto.Update      := FieldByName('atualizado').AsInteger;
          end;

          Lista.AddProduto(Lista.Produto);

          Next;
        end;

        Result := Lista;
      finally
      end;
    end;
  finally
    FreeAndNil(FQuery);
  end;
end;

function TModelProduto.Gravar(Produto: TEntityProduto; newProd:Boolean): Boolean;
begin
    try
      with FQuery do
      begin
        SQL.Clear;

        if newProd then
        begin
          SQL.Add('Insert into produto(nome,descricao,preco,foto,idcategoria, API, atualizado)');
          SQL.Add('values');
          SQL.Add('( "'+Produto.Nome+'","'+Produto.Descricao+'", '+StringReplace(FloatToStr(Produto.Preco),',','.',[rfReplaceAll])+', "'+Produto.Foto+'",'+IntToStr(Produto.IdCategoria)+' , "0",0)');
        end
          else
          begin
            SQL.Add('UpDate Produto set  nome="'+Produto.Nome+'",descricao="'+Produto.Descricao+'",');
            SQL.Add('preco='+StringReplace(FloatToStr(Produto.Preco),',','.',[rfReplaceAll])+',');
            SQL.Add(' foto="'+Produto.Foto+'", idcategoria='+IntToStr(Produto.IdCategoria)+',atualizado=0 WHERE id = '+ Produto.ID.ToString);
         end;

        ExecSQL;
      end;
    except On E: Exception do
      begin
        raise Exception.Create('Error ao gravar produto. ERRO: '+E.Message);
      end;
    end;

    Result := True;
end;

end.
