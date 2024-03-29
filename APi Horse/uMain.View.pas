unit uMain.View;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

   uses Horse,
        horse.jhonson,
        horse.Cors,
        Cardapio.Controller,
        Pedido.Controller,
        Configuracoes.Controller,
        Produto.Controller;

{$R *.fmx}

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  THorse.StopListen;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  THorse.Use(Jhonson());
  THorse.Use(cors);

  { Cardapio - registra as Rotas para Cardapio }
  Cardapio.Controller.Registry;

  { Pedidos - Registra as Rotas para Pedidos }
  Pedido.Controller.Registry;

  { Configuracoes - registra as Rotas para Conbfigura��es }
  Configuracoes.Controller.Registry;

  {Produtos - Grava e lista produtos}
  Produto.Controller.Registry;


  THorse.Listen(9000);
end;

end.
