program FoodDeskTop;

uses
  Vcl.Forms,
  uView.Main in 'View\uView.Main.pas' {frmMain},
  uDao.ConexaoSingleton in 'Dao\uDao.ConexaoSingleton.pas',
  uEntity.ConexaoDB in 'Entity\uEntity.ConexaoDB.pas',
  uView.Produtos in 'View\uView.Produtos.pas' {frmCadastroProduto},
  uEntity.CadastroProduto in 'Entity\uEntity.CadastroProduto.pas',
  uController.CadastroProdutos in 'Controller\uController.CadastroProdutos.pas',
  uDAO.API in 'Dao\uDAO.API.pas',
  uModel.Produto in 'Model\uModel.Produto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
