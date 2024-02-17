unit Produto.Controller;

interface
  uses System.SysUtils, System.JSON,System.Classes,
       Horse, Horse.jhonson,
       uModel.Produto, uProduto.Entity;


  procedure Registry;
  procedure InserirProduto(Req: THorseRequest; Res:THorseResponse; Next : TProc );

implementation

procedure InserirProduto(Req: THorseRequest; Res:THorseResponse; Next : TProc );
var
  ProdutoModel  : TProdutosModel;
  jProdutos     : TJSONObject;
  jArray        : TJSONArray;
  ListaProdutos : TListaProdutos;
  i             : Integer;
begin
  jProdutos     := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as TJSONObject;
  jArray        := jProdutos.GetValue<TJSONArray>('Produtos') as TJSONArray;
  ListaProdutos := TListaProdutos.Create;

  try
    with ListaProdutos do
    begin

      for I := 0 to Pred(jArray.Count) do
        begin
          jProdutos := jArray.Items[i] as TJSONObject;

          ProdutO.Id          := jProdutos.GetValue<integer>('id');
          ProdutO.Nome        := jProdutos.GetValue<string>('nome');
          ProdutO.Descricao   := jProdutos.GetValue<string>('descricao');
          ProdutO.Preco       := jProdutos.GetValue<double>('preco');
          ProdutO.Foto        := '';//jProdutos.GetValue<string>('foto');
          ProdutO.idCategoria := jProdutos.GetValue<string>('idcategoria');
          ProdutO.idAPI       := jProdutos.GetValue<integer>('idapi');
          AdicionarItem(ListaProdutos.ProdutO);
        end;

    end;
  finally
    FreeAndNil(jProdutos);
  end;

  i := ListaProdutos.ProdutoS.Count;

  ProdutoModel := TProdutosModel.Create;
  try
    Res.Send(ProdutoModel.GravarProduto(ListaProdutos)).Status(201);
  finally
    FreeAndNil(ProdutoModel);
  end;

end;

procedure Registry;
begin
  THorse.Post('Produtos',InserirProduto);
end;

end.
