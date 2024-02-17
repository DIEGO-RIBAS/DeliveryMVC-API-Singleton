program Food;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain.View in 'uMain.View.pas' {frmMain},
  Cardapio.Controller in 'Controller\Cardapio.Controller.pas',
  Pedido.Controller in 'Controller\Pedido.Controller.pas',
  Configuracoes.Controller in 'Controller\Configuracoes.Controller.pas',
  uConexaoSingleton in 'Model\uConexaoSingleton.pas',
  uConexxao.Entity in 'Entity\uConexxao.Entity.pas',
  Model.Configuracoes in 'Model\Model.Configuracoes.pas',
  Model.Pedidos in 'Model\Model.Pedidos.pas',
  Model.Cardapio in 'Model\Model.Cardapio.pas',
  uPedido.Entity in 'Entity\uPedido.Entity.pas',
  Produto.Controller in 'Controller\Produto.Controller.pas',
  uModel.Produto in 'Model\uModel.Produto.pas',
  uProduto.Entity in 'Entity\uProduto.Entity.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
