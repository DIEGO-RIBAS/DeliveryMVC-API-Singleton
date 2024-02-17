unit uController.CadastroProdutos;

interface
    uses
      System.Diagnostics, Vcl.Forms,Winapi.Windows,System.SysUtils, system.JSON,
      { MyClasses }
      uEntity.CadastroProduto,
      uModel.Produto,
      uDAO.API;

  type

    TControllerProduto = class
      private
        FNewRegs: Boolean;
        FProduto: TEntityProduto;
        function ValidaCampo : Boolean;
      public
        property Produto : TEntityProduto read FProduto  write FProduto ;
        property NewRegs : Boolean read FNewRegs write FNewRegs;

        constructor Create;
        destructor Destroy;

        function GravaProduto : Boolean;
        function GetLista(tpBusca:Integer): TEntityListaProdutos;
        function EnviaProdutosAPI(ListaProdutos : TEntityListaProdutos): TEntityListaProdutos;
        function AtualizaProdutosAposEnvio(Lista : TEntityListaProdutos): Boolean;
    end;
implementation

{ TcadastroProduto }

function TControllerProduto.AtualizaProdutosAposEnvio(Lista: TEntityListaProdutos): Boolean;
var
  ProdutosModel : TModelProduto;
begin
  ProdutosModel := TModelProduto.Create;
  try
    Result := ProdutosModel.AtualizaProdutosAposEnvio(Lista);
  finally
    FreeAndNil(ProdutosModel);
  end;
end;

constructor TControllerProduto.Create;
begin
  FProduto:= TEntityProduto.Create;
end;

destructor TControllerProduto.Destroy;
begin
  FreeAndNil(FProduto);
end;

function TControllerProduto.EnviaProdutosAPI(ListaProdutos: TEntityListaProdutos): TEntityListaProdutos;
var
  API     : TApi;
  jObject : TJsonObject;
  jArray  : TJSONArray;
  i       : Integer;
  ListaR  : TEntityListaProdutos;
begin
  API    := TApi.create;
  ListaR := TEntityListaProdutos.Create;
  try

    jObject := API.EnviarProdutos(ListaProdutos);
    jArray  := jObject.GetValue<TJSONArray>('NovosProdutos') as TJSONArray;

    for I := 0 to Pred(jArray.Count) do
      begin
        jObject := jArray.Items[i] as TJSONObject;
        ListaR.Produto.ID  := jObject.GetValue<Integer>('idLocal');
        ListaR.Produto.API := jObject.GetValue<Integer>('idAPI');
        ListaR.AddProduto(ListaR.Produto);
      end;

    Result := ListaR;

  finally
    FreeAndNil(API);
    FreeAndNil(jObject);
  end;
end;

function TControllerProduto.GetLista(tpBusca: Integer): TEntityListaProdutos;
var
  ModelProduto : TModelProduto;
begin
  ModelProduto := TModelProduto.Create;
  try
    Result := ModelProduto.GetLista(tpBusca);
  finally
    FreeAndNil(ModelProduto);
  end;
end;

function TControllerProduto.GravaProduto: Boolean;
var
  ProdutoModel : TModelProduto;
begin
  Result := False;

  if ValidaCampo then
  begin

    ProdutoModel := TModelProduto.Create;
    try
      try
        if ProdutoModel.Gravar(FProduto, FNewRegs)then
          Application.MessageBox('Produto armazenado com sucesso !','Informação !',MB_ICONINFORMATION);

      except On E : Exception do
        begin
          raise Exception.Create('Erro ao gravar ítem. Erro :'+E.Message);
        end;

      end;
    finally
      FreeAndNil(ProdutoModel);
      Result := True;
    end;

  end;
end;

function TControllerProduto.ValidaCampo: Boolean;
begin
  Result := false;

  if FProduto.Nome = '' then
  begin
     Application.MessageBox('O campo nome deve ser preenchido !','Atenção !',MB_ICONMASK);
     Exit;;
  end;

  if FProduto.Descricao = '' then
  begin
     Application.MessageBox('O campo DESCRIÇÃO deve ser preenchido !','Atenção !',MB_ICONMASK);
     Exit;
  end;

  if FProduto.Preco <= 0 then
  begin
     Application.MessageBox('O campo Preço deve ser preenchido !','Atenção !',MB_ICONMASK);
     Exit;
  end;

  if FProduto.IdCategoria <= 0 then
  begin
     Application.MessageBox('O campo Categoria deve ser preenchido !','Atenção !',MB_ICONMASK);
     Exit;
  end;

  Result := True;
end;

end.
