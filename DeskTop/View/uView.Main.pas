unit uView.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmMain = class(TForm)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

   uses
     uView.Produtos;

{$R *.dfm}

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TfrmCadastroProduto, frmCadastroProduto);
    frmCadastroProduto.ShowModal;
  finally
    FreeAndNil(frmCadastroProduto);
  end;
end;

end.
