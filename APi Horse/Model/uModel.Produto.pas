unit uModel.Produto;

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


      uConexaoSingleton,uProduto.Entity,
      DataSet.Serialize;

    type

     TProdutosModel = class
       private
         FQuery : TFDQuery;
         FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
       public
         function ListaPedidos : TJSONArray;
         function GravarProduto(Lista : TListaProdutos) : TJSONObject;

         constructor Create;
         destructor Destroy;
     end;



implementation

{ TProdutosModel }

constructor TProdutosModel.Create;
begin
  FDPhysSQLiteDriverLink := TFDPhysSQLiteDriverLink.Create(nil);

  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TInstanciaConexao.ObterInstancia.Conexao;

end;

destructor TProdutosModel.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FDPhysSQLiteDriverLink);
end;

function TProdutosModel.GravarProduto(Lista: TListaProdutos): TJSONObject;
var
  IdProdAPI     : string;
  jObject : TJSONObject;
  jArrayOK,jArrayError : TJSONArray;
  i             : Integer;

  str : TStringList;
begin
  jObject     := TJSONObject.Create;
  jArrayOK    := TJSONArray.Create;
  jArrayError := TJSONArray.Create;

  try
    with FQuery do
    begin
      for I := 0 to Pred(Lista.ProdutoS.Count) do
        begin
          Close;
          SQL.Clear;

          if Lista.ProdutoS[i].idAPI > 0 then
          begin
            SQL.Add('Update Produto set nome="'+Lista.ProdutoS[i].Nome+'", descricao="'+Lista.ProdutoS[i].Descricao+'",preco='+StringReplace(Lista.ProdutoS[i].Preco.ToString,',','.',[rfReplaceAll])+', foto="'+Lista.ProdutoS[i].Foto+'", id_Categoria='+Lista.ProdutoS[i].idCategoria+'  ');
            SQL.Add('where id = '+Lista.ProdutoS[i].idAPI.ToString+'  ');

            try
              ExecSQL;

              jObject    := TJSONObject.Create;
              jObject.AddPair('idLocal',Lista.ProdutoS[i].Id.ToString);
              jObject.AddPair('idAPI',Lista.ProdutoS[i].idAPI.ToString);
              jArrayOK.Add(jObject);

            except On E : Exception do
              begin
                jObject := TJSONObject.Create;
                jObject.AddPair('Produto',Lista.ProdutoS[i].Id.ToString);
                jObject.AddPair('Mensagem','Erro ao gravar PRODUTO:'+Lista.ProdutoS[i].Nome+' - erro: : '+ E.Message);
                jArrayError.Add(jObject);
              end;
            end;
          end
            else
            begin
              SQL.Add('Insert into produto(nome,descricao,preco,foto,id_categoria)');
              SQL.Add('values');
              SQL.Add('("'+Lista.ProdutoS[i].Nome+'","'+Lista.ProdutoS[i].Descricao+'",'+StringReplace(Lista.ProdutoS[i].Preco.ToString,',','.',[rfReplaceAll])+', "'+Lista.ProdutoS[i].Foto+'", '+Lista.ProdutoS[i].idCategoria+');  ');
              SQL.Add('SELECT LAST_INSERT_ROWID() AS CodPProdutoAPI;');
              try
                Open;
                IdProdAPI := FieldByName('CodPProdutoAPI').AsString;

                jObject    := TJSONObject.Create;
                jObject.AddPair('idLocal',Lista.ProdutoS[i].Id.ToString);
                jObject.AddPair('idAPI',IdProdAPI);
                jArrayOK.Add(jObject);

              except On E : Exception do
                begin
                  jObject := TJSONObject.Create;
                  jObject.AddPair('Produto',Lista.ProdutoS[i].Id.ToString);
                  jObject.AddPair('Mensagem','Erro ao gravar PRODUTO:'+Lista.ProdutoS[i].Nome+' - erro: : '+ E.Message);
                  jArrayError.Add(jObject);
                end;
              end;
            end;
        end;

      Close;
    end;
  finally

    jObject := TJSONObject.Create;

    if jArrayOK.Count > 0 then    jObject.AddPair(TJSONPair.Create('NovosProdutos', jArrayOK ));
    if jArrayError.Count > 0 then jObject.AddPair(TJSONPair.Create('ProdutosComErro', jArrayError ));

    str := TStringList.Create;
    try
      str.Add(jObject.ToString);
      str.SaveToFile('C:\jsonJson.txt');
    finally
      FreeAndNil(str);
    end;


    Result := jObject;

  end;
end;

function TProdutosModel.ListaPedidos: TJSONArray;
begin

end;

end.
