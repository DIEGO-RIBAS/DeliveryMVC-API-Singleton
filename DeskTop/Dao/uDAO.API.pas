unit uDAO.API;

interface

    uses
     System.SysUtils,  IpPeerClient, system.Classes,
     REST.Client, REST.Types,
     system.JSON,
     uEntity.CadastroProduto;

    type

    TApi = class
      private
        RestClient   : TRESTClient;
        RestResponse :  TRESTResponse;
        RestRequest  :  TRESTRequest;
      public
        function EnviarProdutos(ListaProdutos : TEntityListaProdutos):TJSONObject;
        constructor create;
        destructor destroy;
    end;

implementation

{ TApi }

constructor TApi.create;
begin
  RestClient  := TRESTClient.Create(nil);
  RestResponse :=  TRESTResponse.Create(nil);
  RestRequest  :=  TRESTRequest.Create(nil);

  RestRequest.Timeout    := 50000;
  RestClient.ContentType := 'application/json';

  RestRequest.Response   := RestResponse;
  RestRequest.Client     := RestClient;

  RESTResponse.contentType := 'application/json';
  RESTRequest.Client.Params.Clear;
  RESTClient.BaseURL := 'localhost:9000/'; // Homologacao -> //https://hml-integracao.concilia360.com.br/api/v2

end;

destructor TApi.destroy;
begin
  FreeAndNil(RestClient);
  FreeAndNil(RestResponse);
  FreeAndNil(RestRequest);
end;

function TApi.EnviarProdutos(ListaProdutos: TEntityListaProdutos): TJSONObject;
const
  AUTHORIZATION = 'Authorization';
var
  jObject : TJSONObject;
  jArray  : TJsonArray;
  i       : Integer;

  str : TStringList;
begin
  jObject := TJSONObject.Create;
  jArray  := TJsonArray.Create;
  try
    for I := 0 to Pred(ListaProdutos.ListaProdutos.Count) do
      begin
        jObject := TJsonObject.Create;
        jObject.AddPair('id',   ListaProdutos.ListaProdutos[i].ID.ToString);
        jObject.AddPair('nome', ListaProdutos.ListaProdutos[i].nome);
        jObject.AddPair('descricao', ListaProdutos.ListaProdutos[i].Descricao);
        jObject.AddPair('preco', StringReplace(ListaProdutos.ListaProdutos[i].Preco.ToString,',','.',[rfReplaceAll]));
        jObject.AddPair('foto', ListaProdutos.ListaProdutos[i].Foto);
        jObject.AddPair('idcategoria', ListaProdutos.ListaProdutos[i].IdCategoria.ToString);
        jObject.AddPair('idapi', ListaProdutos.ListaProdutos[i].API.ToString);

        jArray.Add(jObject);
      end;

      jObject := TJSONObject.Create;
      jObject.AddPair('Produtos',jArray);

{      str := TStringList.Create;
      try
        str.Add(jObject.ToString);
        str.SaveToFile('C:\tjson.txt');
      finally
        FreeAndNil(str);
      end;}

      RESTRequest.Resource := 'Produtos';
      RESTRequest.Method   := rmPOST;
//    RESTRequest.Params.AddHeader(AUTHORIZATION,'Bearer ' + vToken[0]);
//    RESTRequest.Params.ParameterByName(AUTHORIZATION).Options := [poDoNotEncode];
      RESTRequest.AddBody(jObject.ToJSON+' ',ctAPPLICATION_JSON);
      RESTRequest.Execute;

      Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(RestResponse.Content),0) as TJSONObject;

{      str := TStringList.Create;
      try
        str.Add(RestResponse.Content);
        str.SaveToFile('C:\aateste.txt');
      finally
        FreeAndNil(str);
      end;}

  finally
    FreeAndNil(jObject);
  end;

end;

end.
