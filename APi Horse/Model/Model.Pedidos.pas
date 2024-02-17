unit Model.Pedidos;

interface

   uses
      System.SysUtils,System.JSON,  System.Classes,


      Winapi.Windows, Winapi.Messages,  System.Variants,  Vcl.Graphics,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  FireDAC.DApt,FireDAC.Stan.Option,FireDAC.Comp.Client,
  FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf,  Data.DB, FireDAC.Comp.DataSet,
   FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,

      uConexaoSingleton,uPedido.Entity,
      DataSet.Serialize;

   type

     TPedidosModel = class
       private
         FQuery : TFDQuery;
         FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
       public
         function ListaPedidos : TJSONArray;
         function GravarPedido(Pedido : TPedidos) : TJSONObject;

         constructor Create;
         destructor Destroy;
     end;

implementation


{ TPedidos }

constructor TPedidosModel.Create;
begin
  FDPhysSQLiteDriverLink := TFDPhysSQLiteDriverLink.Create(nil);

  FQuery := TFDQuery.Create(nil);

  with Fquery.FormatOptions do
   begin
    OwnMapRules := True;
    with MapRules.Add do
    begin
      SourceDataType := dtInt32;
      TargetDataType := dtInt64;
    end;
  end;
  FQuery.Connection := TInstanciaConexao.ObterInstancia.Conexao;
end;

destructor TPedidosModel.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FDPhysSQLiteDriverLink);
end;

function TPedidosModel.GravarPedido(Pedido : TPedidos): TJSONObject;
var
  idPedidoAPI : string;
  jResult     : TJSONObject;
  i           : Integer;
begin
  Result := TJSONObject.Create;

  { Grava o Pedido no banco - Query j� criado e assossiada ao conection}
  with FQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into Pedido(idCliente, dtPedido, endereco, fone, vlr_taxa_entrega , status)');
    SQL.Add('values');
    SQL.Add('('+Pedido.IDCliente.ToString+',dateTime(''Now''),"'+Pedido.Endreeco+'", "'+Pedido.Fone+'", '+Pedido.TaxaEntrega.ToString+', "'+Pedido.Status+'");  ');
    SQL.Add('SELECT LAST_INSERT_ROWID() AS CodPedido;');

    try
      ExecSQL;
    except On E : Exception do
      begin
        Result.AddPair('Gravou','False');
        Result.AddPair('Mensagem','Erro ao gravar PEDIDO - erro: : '+ E.Message);

        raise;
      end;
    end;

    open;
    idPedidoAPI := FieldByName('CodPedido').AsString;
  end;

  for I := 0 to Pred(Pedido.Itens.Count) do
    begin
      with FQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert into pedido_itens(idpedido,qtde,preco,idproduto,observacoes)');
        SQL.Add('values');
        SQL.Add('('+idPedidoAPI+', '+ StringReplace(Pedido.Itens[i].Qtde.ToString,',','.',[rfReplaceAll]) +',  '+StringReplace(Pedido.Itens[i].Preco.ToString,',','.',[rfReplaceAll])+', '+Pedido.Itens[i].IdProduto.ToString+', "'+Pedido.Itens[i].Obs+'" )');

        SQL.SaveToFile('C:\Teste.txt');

        try
          ExecSQL;
        except On E : Exception do
          begin
            Result.AddPair('Gravou','False');
            Result.AddPair('mensagem ','Erro ao gravar ITEM - erro: : '+ E.Message);

            raise;
          end;
        end;
      end;
    end;

  Result.AddPair('Gravou','True');
  Result.AddPair('idPedido',idPedidoAPI);
  Result.AddPair('Mensagem','Gravou tudo certo - Parab�ns meu irm�o.');
end;

function TPedidosModel.ListaPedidos: TJSONArray;
var
  jPedido : TJSONObject;
  i       : Integer;
begin
  try
    FQuery.SQL.Add('select P.ID as idPedido, strFTime(''%d/%M/%Y %H:%M'',P.dtPedido) as dtPedido, ');
    FQuery.SQL.Add('Sum((I.Qtde * I.Preco)-P.Vlr_Taxa_Entrega)as vTotal');
    FQuery.SQL.Add('from pedido P inner join Pedido_Itens I ');
    FQuery.SQL.Add('on I.idPedido = P.id ');
    FQuery.SQL.Add('group by P.id');
    FQuery.SQL.Add('order by P.id');
    FQuery.Open();

    jPedido := TJSONObject.Create;

    Result := FQuery.ToJSONArray();

    for I := 0 to Result.Count - 1 do
    begin
      jPedido := Result.Items[i] as TJSONObject;

      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('Select item.id, item.idPedido, item.Qtde, item.Preco,item.Observacoes,');
      FQuery.SQL.Add('Prod.id as CodProd, Prod.Nome, Prod.Foto');
      FQuery.SQL.Add('from pedido_itens Item ');
      FQuery.SQL.Add('inner join Produto Prod');
      FQuery.SQL.Add('on Prod.id = item.IdProduto');
      FQuery.SQL.Add('where Item.idPedido = '+ jPedido.GetValue<string>('idpedido'));
      FQuery.Open();

      jPedido.AddPair('Itens',FQuery.ToJSONArray());
    end;

  finally
    FreeAndNil(FQuery);
  end;
end;

end.
