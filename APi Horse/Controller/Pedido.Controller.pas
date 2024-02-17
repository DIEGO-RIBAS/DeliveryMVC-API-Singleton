unit Pedido.Controller;

interface
  uses System.SysUtils, System.JSON,System.Classes,
       Horse, Horse.jhonson;


  procedure Registry;
  procedure ListarPedidos(Req: THorseRequest; Res:THorseResponse; Next : TProc );
  procedure InserirPedidos(Req: THorseRequest; Res:THorseResponse; Next : TProc );

implementation

  uses uPedido.Entity, Model.Pedidos;

procedure ListarPedidos(Req: THorseRequest; Res:THorseResponse; Next : TProc );
var
  Pedidos : TPedidosModel;
begin
  Pedidos := TPedidosModel.Create;
  try
    Res.Send(Pedidos.ListaPedidos).Status(200);
  finally
    FreeAndNil(Pedidos);
  end;
end;

procedure InserirPedidos(Req: THorseRequest; Res:THorseResponse; Next : TProc );
var
  PedidoModel : TPedidosModel;
  jPedido     : TJSONObject;
  jArray      : TJSONArray;
  PedidoClass : TPedidos;
  i           : Integer;
begin
  jPedido := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as TJSONObject;

  jArray  := jPedido.GetValue<TJSONArray>('Itens') as TJSONArray;

  PedidoClass := TPedidos.Create;
  try

    with PedidoClass do
    begin
      IDCliente   := StrToInt(jPedido.GetValue('idcliente').Value);
      DTpedido    := DateTimeToStr(Now);
      Endreeco    := jPedido.GetValue('endereco').Value;
      Fone        := jPedido.GetValue('fone').Value;
      Status      := jPedido.GetValue('status').Value;
      TaxaEntrega := jPedido.GetValue<double>('vlr_taxa_entrega');

      for I := 0 to Pred(jArray.Count) do
        begin
          jPedido := jArray.Items[i] as TJSONObject;

          Item.IdProduto := jPedido.GetValue<integer>('idproduto');
          Item.Qtde      := jPedido.GetValue<Double>('qtde');
          Item.Preco     := jPedido.GetValue<Double>('preco');
          Item.Obs       := jPedido.GetValue<string>('obs');

          Itens.Add(Item);
        end;

      PedidoModel := TPedidosModel.Create;
      try
        Res.Send(PedidoModel.GravarPedido(PedidoClass)).Status(201);
      finally
        FreeAndNil(PedidoModel);
      end;
    end;

  finally
    FreeAndNil(jPedido);
 //   FreeAndNil(jArray);
 //   FreeAndNil(PedidoClass);
  end;
end;

procedure Registry;
begin
  THorse.Get('Pedidos',ListarPedidos);
  THorse.Post('Pedidos',InserirPedidos);

end;

end.

