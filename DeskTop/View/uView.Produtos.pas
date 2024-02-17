unit uView.Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  numedit,

  uController.CadastroProdutos,uEntity.CadastroProduto,

   Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, dxGDIPlusClasses, System.ImageList, Vcl.ImgList, Vcl.Menus;

type

  TCheckProduto = class
    private
      FTpMarcacao: Integer;
      FClientDataSet: TClientDataSet;

    public
      property TpMarcacao : Integer read FTpMarcacao write FTpMarcacao;
      property ClientDataSet : TClientDataSet read FClientDataSet write FClientDataSet;
      procedure ExecutaSelecao;

      constructor Create;
      destructor Destroy;
  end;


  TfrmCadastroProduto = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TbsdadosProduto: TTabSheet;
    TbsConsultaProduto: TTabSheet;
    GroupBox1: TGroupBox;
    edtNome: TEdit;
    Label1: TLabel;
    edtCodigo: TEdit;
    Label2: TLabel;
    edtDescricao: TEdit;
    Label3: TLabel;
    edtPreco: TNumberEdit;
    Label4: TLabel;
    edtFoto: TEdit;
    Label5: TLabel;
    Panel2: TPanel;
    ImgFoto: TImage;
    Label6: TLabel;
    edtCategoria: TNumberEdit;
    edtDescrCategoria: TEdit;
    Label7: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    GroupBox3: TGroupBox;
    Panel4: TPanel;
    RadioGroup1: TRadioGroup;
    btnExibir: TBitBtn;
    DBGridProduto: TDBGrid;
    CdsProduto: TClientDataSet;
    CdsProdutoid: TIntegerField;
    CdsProdutonome: TStringField;
    CdsProdutodescricao: TStringField;
    CdsProdutopreco: TFloatField;
    CdsProdutoidcategoria: TIntegerField;
    CdsProdutofoto: TStringField;
    CdsProdutoAPI: TIntegerField;
    DataSource1: TDataSource;
    btnEnviarAPI: TBitBtn;
    CdsProdutoChecado: TIntegerField;
    CdsProdutoIndex: TIntegerField;
    GroupBox2: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Label8: TLabel;
    Label9: TLabel;
    ImageList1: TImageList;
    btnMarcarTodos: TSpeedButton;
    btnDesmarcarTodos: TSpeedButton;
    btnInverterSelecao: TSpeedButton;
    btnEnviadoAPI: TSpeedButton;
    btnNaoEnviadoAPI: TSpeedButton;
    CdsProdutoUpDate: TIntegerField;
    Label10: TLabel;
    OpenDialog: TOpenDialog;
    PopupImagem: TPopupMenu;
    Carregarimagem1: TMenuItem;
    Removerimagem1: TMenuItem;
    BitBtn3: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnExibirClick(Sender: TObject);
    procedure DBGridProdutoDblClick(Sender: TObject);
    procedure DBGridProdutoCellClick(Column: TColumn);
    procedure DBGridProdutoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnEnviarAPIClick(Sender: TObject);
    procedure DBGridProdutoTitleClick(Column: TColumn);
    procedure btnMarcarTodosClick(Sender: TObject);
    procedure btnDesmarcarTodosClick(Sender: TObject);

    procedure btnInverterSelecaoClick(Sender: TObject);
    procedure btnEnviadoAPIClick(Sender: TObject);
    procedure btnNaoEnviadoAPIClick(Sender: TObject);
    procedure TbsConsultaProdutoShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Carregarimagem1Click(Sender: TObject);
    procedure Removerimagem1Click(Sender: TObject);
    procedure edtFotoChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    FNewRegs : Boolean;
    procedure ClearFields;

  public
    { Public declarations }
  end;

var
  frmCadastroProduto: TfrmCadastroProduto;

implementation


{$R *.dfm}

procedure TfrmCadastroProduto.BitBtn1Click(Sender: TObject);
begin
  ClearFields;
end;

procedure TfrmCadastroProduto.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastroProduto.BitBtn3Click(Sender: TObject);
var
  Produtos : TControllerProduto;
begin
  Produtos := TControllerProduto.Create;
  try

    with Produtos do
    begin
      if not FNewRegs then
        Produto.ID := StrToInt(edtCodigo.Text); { Verdadeiro ir� inserir, caso contr�rio ir� atualizar }

      Produto.Nome        := edtNome.Text;
      Produto.Descricao   := edtDescricao.Text;
      Produto.Preco       := edtPreco.Value;
       Produto.Foto       := edtFoto.Text;
      Produto.IdCategoria := StrToInt(edtCategoria.Text);
      Produto.Update      := 0; { caso false ir� sinalizar para fazer o envio para API a atualiza��o ou novo produto }
    end;

    { Insert ou Update }
    Produtos.NewRegs := FNewRegs;

    if Produtos.GravaProduto then
    begin
      ClearFields;
    end;
  finally
    FreeAndNil(Produtos);
  end;
end;

procedure TfrmCadastroProduto.btnExibirClick(Sender: TObject);
var
  ControllerProduto : TControllerProduto;
  Lista   : TEntityListaProdutos;
  i       : Integer;
begin
  ControllerProduto := TControllerProduto.Create;

  CdsProduto.close;
  CdsProduto.CreateDataSet;
  CdsProduto.Open;

  try
    Lista := ControllerProduto.GetLista(RadioGroup1.ItemIndex);
    for I := 0 to Pred(Lista.ListaProdutos.Count) do
    begin
      CdsProduto.Append;
      CdsProdutoid.Value          := Lista.ListaProdutos[i].ID;
      CdsProdutonome.Value        := Lista.ListaProdutos[i].Nome;
      CdsProdutodescricao.Value   := Lista.ListaProdutos[i].Descricao;
      CdsProdutopreco.Value       := Lista.ListaProdutos[i].Preco;
      CdsProdutoidcategoria.Value := Lista.ListaProdutos[i].IdCategoria;
      CdsProdutofoto.Value        := Lista.ListaProdutos[i].Foto;
      CdsProdutoAPI.Value         := StrToInt(Lista.ListaProdutos[i].API.ToString);
      CdsProdutoChecado.Value     := 0;
      CdsProdutoUpDate.Value      := Lista.ListaProdutos[i].Update;
      CdsProduto.Post;
    end;
  finally
    FreeAndNil(Lista);
    FreeAndNil(ControllerProduto);
  end;
end;

procedure TfrmCadastroProduto.btnEnviarAPIClick(Sender: TObject);
var
  Lista : TEntityListaProdutos;
  ControllerProduto : TControllerProduto;
  i : Integer;
begin
  if not CdsProduto.IsEmpty then
  begin
    ControllerProduto := TControllerProduto.Create;

    Lista := TEntityListaProdutos.Create;
    try
      CdsProduto.DisableControls;
      CdsProduto.First;
      while not CdsProduto.Eof do
      begin
        if( CdsProdutoChecado.Value > 0 )then
        begin
          with Lista do
          begin
            Produto.ID          := CdsProdutoid.Value;
            Produto.Nome        := CdsProdutonome.Value;
            Produto.Descricao   := CdsProdutodescricao.Value;
            Produto.Preco       := CdsProdutopreco.Value;
            Produto.IdCategoria := CdsProdutoidcategoria.Value;
            Produto.Foto        := CdsProdutofoto.Value;
            Produto.API         := CdsProdutoAPI.Value;
            Produto.Update      := CdsProdutoUpDate.Value;
            AddProduto(Lista.Produto);
          end;

        end;
        CdsProduto.Next;
      end;
      CdsProduto.EnableControls;

      if Lista.ListaProdutos.Count > 0 then
      begin
        Lista := ControllerProduto.EnviaProdutosAPI(Lista);

        { Atualiza Banco local }
        if ControllerProduto.AtualizaProdutosAposEnvio(Lista) then
        begin
          Application.MessageBox('Envio realizado com sucesso !','Aten��o !',MB_ICONINFORMATION);
          btnExibir.Click;
        end;

      end
        else Application.MessageBox('N�o h� produtos selecionados !','Aten��o !',MB_ICONINFORMATION);
    finally
      FreeAndNil(Lista);
      FreeAndNil(ControllerProduto);
    end;
  end;
end;

procedure TfrmCadastroProduto.Carregarimagem1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtFoto.Text := OpenDialog.FileName;
end;

procedure TfrmCadastroProduto.ClearFields;
begin
  edtNome.Text      := '';
  edtCodigo.Text    := '';
  edtDescricao.Text := '';
  edtPreco.Value    := 0;
  edtFoto.Text      := '';
  edtCategoria.Value:= 0;
  edtDescrCategoria.Text := '';
  ImgFoto.Picture := nil;

  FNewRegs := True;
end;

procedure TfrmCadastroProduto.DBGridProdutoCellClick(Column: TColumn);
var
  fValue : Integer;
begin
  if Column.FieldName = 'Index' then
  begin
    if CdsProdutoChecado.Value = 0 then fValue := 1
    else                                fValue := 0;

    CdsProduto.Edit;
    CdsProdutoChecado.Value := fValue;
    CdsProduto.Post;
  end;
end;

procedure TfrmCadastroProduto.DBGridProdutoDblClick(Sender: TObject);
begin
  if not CdsProduto.IsEmpty then
  begin
    edtCodigo.Text     := CdsProdutoid.AsString;
    edtNome.Text       := CdsProdutonome.AsString;
    edtDescricao.Text  := CdsProdutodescricao.AsString;
    edtPreco.Value     := CdsProdutopreco.AsFloat;
    edtFoto.Text       := CdsProdutofoto.AsString;
    edtCategoria.Text  := CdsProdutoidcategoria.AsString;

    FNewRegs := false;

    PageControl1.ActivePageIndex := 0;
  end;
end;

procedure TfrmCadastroProduto.DBGridProdutoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Check1 : Integer;
  R1     : TRect;
begin
  { CheckBox }
  if Column.FieldName = 'Index' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    Check1 := 0;

    if CdsProdutoChecado.Value = 1 then Check1 := DFCS_CHECKED
    else                                Check1 := 0;

    R1 := Rect;
    InflateRect(R1,-2,-2);
    DrawFrameControl(DBGridProduto.Canvas.Handle,R1,DFC_BUTTON, DFCS_BUTTONCHECK or Check1);
  end;

  { Imagem }
  if Column.FieldName = 'img' then
  begin
     TDBGrid(Sender).Canvas.FillRect(Rect);
     if CdsProdutoUpDate.Value > 0  then
       ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1)
     else
       ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
  end;

end;


procedure TfrmCadastroProduto.DBGridProdutoTitleClick(Column: TColumn);
var
  B : TBookmark;
begin
 if Column.FieldName = 'Index' then
  begin
    B := CdsProduto.GetBookmark;

    CdsProduto.First;
    while not CdsProduto.Eof do
      begin
        CdsProduto.Edit;
        if CdsProdutoChecado.Value = 0 then CdsProdutoChecado.Value := 1
        else                                CdsProdutoChecado.Value := 0;
        CdsProduto.Post;

        CdsProduto.Next;
      end;

    CdsProduto.GotoBookmark(B);
  end;
end;

procedure TfrmCadastroProduto.edtFotoChange(Sender: TObject);
begin
  try
    ImgFoto.Picture.LoadFromFile(edtFoto.Text);
  except

  end;
end;

procedure TfrmCadastroProduto.FormCreate(Sender: TObject);
begin
    CdsProduto.CreateDataSet;
//    Image1.Popup;
end;

procedure TfrmCadastroProduto.FormShow(Sender: TObject);
begin
  FNewRegs := True;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmCadastroProduto.Removerimagem1Click(Sender: TObject);
begin
  ImgFoto.Picture := nil;
  edtFoto.Text    := '';
end;

procedure TfrmCadastroProduto.TbsConsultaProdutoShow(Sender: TObject);
var
  B : TBookmark;
begin
  if CdsProduto.RecordCount > 0 then
  begin
    B := CdsProduto.GetBookmark;
    btnExibir.Click;
    CdsProduto.GotoBookmark(b);
  end;

end;

procedure TfrmCadastroProduto.btnMarcarTodosClick(Sender: TObject);
var
 CheckProduto : TCheckProduto;
begin
  CheckProduto := TCheckProduto.Create;
  try
    CheckProduto.FTpMarcacao   := 0;
    CheckProduto.ClientDataSet := CdsProduto;
    CheckProduto.ExecutaSelecao;
  finally
    FreeAndNil(CheckProduto);
  end;
end;

procedure TfrmCadastroProduto.btnDesmarcarTodosClick(Sender: TObject);
var
 CheckProduto : TCheckProduto;
begin
  { Pra evitar recodifica��o - criei uma classe para controlar a marca��o/selec��o dos produtos }

  CheckProduto := TCheckProduto.Create;
  try
    CheckProduto.FTpMarcacao   := 1;
    CheckProduto.ClientDataSet := CdsProduto;
    CheckProduto.ExecutaSelecao;
  finally
    FreeAndNil(CheckProduto);
  end;
end;

procedure TfrmCadastroProduto.btnEnviadoAPIClick(Sender: TObject);
var
 CheckProduto : TCheckProduto;
begin
  { Pra evitar recodifica��o - criei uma classe para controlar a marca��o/selec��o dos produtos }

  CheckProduto := TCheckProduto.Create;
  try
    CheckProduto.FTpMarcacao   := 3;
    CheckProduto.ClientDataSet := CdsProduto;
    CheckProduto.ExecutaSelecao;
  finally
    FreeAndNil(CheckProduto);
  end;

end;

procedure TfrmCadastroProduto.btnNaoEnviadoAPIClick(Sender: TObject);
var
 CheckProduto : TCheckProduto;
begin
  { Pra evitar recodifica��o - criei uma classe para controlar a marca��o/selec��o dos produtos }

  CheckProduto := TCheckProduto.Create;
  try
    CheckProduto.TpMarcacao   := 4;
    CheckProduto.ClientDataSet := CdsProduto;
    CheckProduto.ExecutaSelecao;
  finally
    FreeAndNil(CheckProduto);
  end;
end;

procedure TfrmCadastroProduto.btnInverterSelecaoClick(Sender: TObject);
var
 CheckProduto : TCheckProduto;
begin
  { Pra evitar recodifica��o - criei uma classe para controlar a marca��o/selec��o dos produtos }

  CheckProduto := TCheckProduto.Create;
  try
    CheckProduto.FTpMarcacao   := 2;
    CheckProduto.ClientDataSet := CdsProduto;
    CheckProduto.ExecutaSelecao;
  finally
    FreeAndNil(CheckProduto);
  end;
end;

{ TCheckProduto }

constructor TCheckProduto.Create;
begin
  FClientDataSet := TClientDataSet.Create(nil);
end;

destructor TCheckProduto.Destroy;
begin
  FreeAndNil(FClientDataSet);
end;

procedure TCheckProduto.ExecutaSelecao;
var
  B : TBookmark;
begin
  { Pra evitar recodifica��o - criei uma classe para controlar a marca��o/selec��o dos produtos }
  {   0 =   MARCAR TODOS                                                                        }
  {   1 =   DESMARCAR TODOS                                                                     }
  {   2 =   INVERTER MARCA��O                                                                   }
  {   3 =   SOMENTE PRODUTOS QUE J� FORAM ENVIADOS PARA API                                     }
  {   4 =   SOMENTE PRODUTOS que N�O FORAM ENVIADOS PARA API                                    }

  B := ClientDataSet.GetBookmark;

  FClientDataSet.First;
  while not FClientDataSet.Eof do
    begin

      FClientDataSet.Edit;
      case FTpMarcacao of
        0 : FClientDataSet.FieldByName('Checado').Value := 1;
        1 : FClientDataSet.FieldByName('Checado').Value := 0;
        2 : begin
              if FClientDataSet.FieldByName('Checado').Value = 0 then FClientDataSet.FieldByName('Checado').Value := 1
              else                                                    FClientDataSet.FieldByName('Checado').Value := 0;
            end;
        3 : begin
              if FClientDataSet.FieldByName('Update').Value = 1 then FClientDataSet.FieldByName('Checado').Value := 1
              else                                                   FClientDataSet.FieldByName('Checado').Value := 0;
            end;
        4 : begin
              if FClientDataSet.FieldByName('Update').Value = 0 then FClientDataSet.FieldByName('Checado').Value := 1
              else                                                   FClientDataSet.FieldByName('Checado').Value := 0;
            end;
      end;
      FClientDataSet.Post;

      FClientDataSet.Next;
    end;

  FClientDataSet.GotoBookmark(B);
end;

end.

