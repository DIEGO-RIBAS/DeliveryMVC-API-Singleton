unit uProduto.Entity;

interface

   uses
     System.Generics.Collections, System.SysUtils;

   type

     TProduto = class
       private
         FID          : Integer;
         FPreco       : Double;
         FDescricao   : string;
         FFoto        : string;
         FNome        : string;
         FidCategoria : string;
         FidAPI: Integer;

       public
         property Id          : Integer read FID write FID;
         property Nome        : string  read FNome  write FNome ;
         property Descricao   : string  read FDescricao write FDescricao;
         property Preco       : Double  read FPreco write FPreco;
         property Foto        : string  read FFoto write FFoto;
         property idCategoria : string  read FidCategoria write FidCategoria;
         property idAPI       : Integer read FidAPI       write FidAPI;

     end;

     TListaProdutos = class
       private
          FProdutO: TProduto;
          FProdutoS: TObjectList<TProduto>;

       public
          property ProdutoS : TObjectList<TProduto> read FProdutoS write FProdutoS;
          property ProdutO  : TProduto              read FProdutO  write FProdutO;

          constructor Create;
          destructor Destroy; override;
          procedure AdicionarItem(Produto : TProduto);
     end;

implementation

{ TListaProdutos }

procedure TListaProdutos.AdicionarItem(Produto: TProduto);
var
  I: Integer;
begin

  FProdutoS.Add(TProduto.Create);
  I := FProdutoS.Count -1;
  FProdutoS[I].FID          := Produto.FID;
  FProdutoS[I].FPreco       := Produto.FPreco;
  FProdutoS[I].FDescricao   := Produto.Descricao;
  FProdutoS[I].FFoto        := Produto.Foto;
  FProdutoS[I].FidCategoria := Produto.idCategoria;
  FProdutoS[I].FidAPI       := Produto.idAPI;

end;

constructor TListaProdutos.Create;
begin
  FProdutoS := TObjectList<TProduto>.Create;
  FProdutO  := TProduto.Create;
end;

destructor TListaProdutos.Destroy;
begin
  FreeAndNil(FProdutoS);
  FreeAndNil(FProdutO);

  inherited;
end;

end.
