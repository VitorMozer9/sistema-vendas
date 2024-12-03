unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask, NumEdit, DB,
  DBClient, Grids, DBGrids, UEnumerationUtil, uMessageUtil, UVenda, UVendaController,
  UPessoaController, UVendaItem, UClassFuncoes;

type
  TfrmVendasView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    pnlPagamentos: TPanel;
    pnlPedidos: TPanel;
    gbrPedidos: TGroupBox;
    pnlProdutos: TPanel;
    gbrProdutos: TGroupBox;
    edtNome: TEdit;
    btnCliente: TSpeedButton;
    lblCliente: TLabel;
    edtCodigo: TEdit;
    mskData: TMaskEdit;
    lblData: TLabel;
    lblNumeroVenda: TLabel;
    edtNumeroVenda: TEdit;
    cmbPagamento: TComboBox;
    lblPagamento: TLabel;
    lblDesconto: TLabel;
    edtDesconto: TNumEdit;
    lblValor: TLabel;
    edtValor: TNumEdit;
    lblValorTotal: TLabel;
    edtTotalValor: TNumEdit;
    dtsProdutos: TDataSource;
    cdsProdutos: TClientDataSet;
    cdsProdutosID: TIntegerField;
    cdsProdutosDescricao: TStringField;
    cdsProdutosUniPreco: TFloatField;
    cdsProdutosUniSaida: TStringField;
    cdsProdutosQuantidade: TFloatField;
    cdsProdutosTotalPreco: TFloatField;
    btnLimpar: TBitBtn;
    dbgProdutos: TDBGrid;
    lblVendedor: TLabel;
    cmbVendedor: TComboBox;
    btnVendedor: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnClienteClick(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);
    procedure edtDescontoExit(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure dbgProdutosKeyPress(Sender: TObject; var Key: Char);
    procedure cdsProdutosAfterPost(DataSet: TDataSet);
    procedure cdsProdutosBeforeDelete(DataSet: TDataSet);
    procedure edtDescontoChange(Sender: TObject);
    procedure edtCodigoChange(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgProdutosExit(Sender: TObject);
    procedure cdsProdutosAfterOpen(DataSet: TDataSet);
    procedure edtNumeroVendaChange(Sender: TObject);
    procedure cmbPagamentoChange(Sender: TObject);
    procedure cmbPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure cmbVendedorChange(Sender: TObject);
    procedure cmbVendedorKeyPress(Sender: TObject; var Key: Char);
    procedure btnVendedorClick(Sender: TObject);
    procedure cmbVendedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNumeroVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
   vKey : Word;
   vEstadoTela   : TEstadoTela;
   vObjVenda     : TVenda;
   vObjColVendaItem : TColVendaItem;
   vTotalPreco   : Double;

   procedure CamposEnable(pOpcao : Boolean);
   procedure LimpaTela;
   procedure DefineEstadoTela;
   procedure CarregaDadosTela;
   procedure CarregaProduto;
   procedure ProcessaProdutoVenda;
   procedure carregaCMB;


   function CarregaCliente      : Boolean;
   function ProcessaConfirmacao : Boolean;
   function ProcessaInclusao    : Boolean;
   function ProcessaVenda       : Boolean;
   function ProcessaVendaItem   : Boolean;
   function ProcessaConsulta    : Boolean;
   function ValidaCampos        : Boolean;
   function PesquisaProduto(pIDproduto : Integer) : Boolean;

  public
    { Public declarations }

  end;

var
  frmVendasView: TfrmVendasView;

implementation

uses Types, Math, UClientesPesqView, UClienteView,UPessoa,UProduto,UProdutoController,
   UVendaItemController, UProdutoPesqView, UVendaPesqView,UUsuario, UCadUsuaController,
  UCadUsuaView;

{$R *.dfm}

procedure TfrmVendasView.CamposEnable(pOpcao: Boolean);
var
   xI : Integer;
begin
   for xI := 0 to pred(ComponentCount) do
   begin

      if (Components[xI] is TEdit) then
         (Components[xI] as TEdit).Enabled := pOpcao;

      if (Components[xI] is TNumEdit) then
         (Components[xI] as TNumEdit).Enabled := pOpcao;

      if (Components[xI] is TMaskEdit) then
         (Components[xI] as TMaskEdit).Enabled := pOpcao;

      if (Components[xI] is TDBGrid) then
         (Components[xI] as TDBGrid).Enabled := pOpcao;

      if (Components[xI] is TComboBox) then
         (Components[xI] as TComboBox).Enabled := pOpcao;

   end;
end;

procedure TfrmVendasView.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir,etConsultar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir,etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnable(False);
         cmbPagamento.Enabled := False;
         btnLimpar.Enabled := False;
         btnCliente.Enabled := False;
         btnVendedor.Enabled := False;
         LimpaTela;


         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

         if (frmVendasView <> nil) and
            (frmVendasView.Active) and
            (btnConfirmar.CanFocus)then
            btnConfirmar.SetFocus;

         cmbPagamento.Text := EmptyStr;
          cmbVendedor.Text := EmptyStr;

         Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnable(True);

         btnLimpar.Enabled      := True;
         btnCliente.Enabled     := True;
          btnVendedor.Enabled := True;
         cmbPagamento.Enabled   := True;
         edtTotalValor.Enabled  := False;
         edtNumeroVenda.Enabled := False;
         edtNome.Enabled        := False;
         edtValor.Enabled       := False;
         mskData.Enabled        := False;

         mskData.Text := DateTimeToStr(Now);

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;
      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

         CamposEnable(False);
         btnCliente.Enabled := False;
         btnLimpar.Enabled := True;


         if (edtNumeroVenda.Text <> EmptyStr) then
         begin
            edtNumeroVenda.Enabled  := False;
            btnConfirmar.Enabled := False;

            if (btnConfirmar.CanFocus) then
               btnConfirmar.SetFocus;
         end
         else
         begin
            lblNumeroVenda.Enabled := True;
            edtNumeroVenda.Enabled := True;

            if edtNumeroVenda.CanFocus then
               edtNumeroVenda.SetFocus;
         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';

         if (frmVendaPesqView = nil) then
         frmVendaPesqView := TfrmVendaPesqView.Create(Application);

         frmVendaPesqView.ShowModal;

         if (frmVendaPesqView.mVendaID <> 0) then
         begin
            edtNumeroVenda.Text := IntToStr(frmVendaPesqView.mVendaID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;
      end;
   end;
end;

procedure TfrmVendasView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_ESCAPE:
      begin
         if vEstadoTela <> etPadrao then
         begin
            if (TMessageUtil.Pergunta(
               'Deseja abortar esta operação?')) then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
            if (TMessageUtil.Pergunta(
               'Deseja sair da rotina?')) then
               Close;
         end;
      end;
   end;
end;

procedure TfrmVendasView.LimpaTela;
var
   xI : Integer;
begin
   vTotalPreco := 0;
   edtValor.Value := 0;
   mskData.Text := EmptyStr;
   edtDesconto.Value := 0;

   for xI := 0 to pred(ComponentCount) do
   begin
     if (Components[xI] is TEdit) then
        (Components[xI] as TEdit).Text := EmptyStr;

     if (edtTotalValor.Value <> 0) then
      edtTotalValor.Value := 0;

     if (Components[xI] is TComboBox) then
      begin
        (Components[xI] as TComboBox).ItemIndex := -1;
      end;

      if (not cdsProdutos.IsEmpty) then
         cdsProdutos.EmptyDataSet;
   end;
end;

procedure TfrmVendasView.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmVendasView.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmVendasView.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmVendasView.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendasView.btnCancelarClick(Sender: TObject);
begin
    vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmVendasView.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta('Deseja realmente abortar esta operação?')) then
      begin
         vEstadoTela  := etPadrao;
         DefineEstadoTela;
      end;
   end
   else;
      Close;
end;

function TfrmVendasView.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
         etIncluir: Result := ProcessaInclusao;
         etConsultar: Result := ProcessaConsulta;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;

   Result := True;
end;

function TfrmVendasView.ProcessaInclusao: Boolean;
begin
    Result := False;
   try
      try
        if (ProcessaVenda) and (ProcessaVendaItem)  then
        begin
           TMessageUtil.Informacao('Venda cadastrada com sucesso.'#13 +
             'Código cadastrado: ' + IntToStr(vObjVenda.ID));

           vEstadoTela := etPadrao;
           DefineEstadoTela;

           Result := True;
        end;

      except
         on E : Exception do
         begin
            Raise Exception.Create(
               'Falha ao incluir os dados da venda[View]: '#13 +
               e.Message);
         end;
      end;
   finally
      if (vObjVenda <> nil) then
         FreeAndNil(vObjVenda);
   end;
end;

function TfrmVendasView.ProcessaVenda: Boolean;
begin
   try
      Result := False;

      if not ValidaCampos then
         exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjVenda = nil then
            vObjVenda := TVenda.Create;
      end;

      if (vObjVenda = nil) then
         Exit;

      vObjVenda.ID_Cliente     := StrToInt(edtCodigo.Text);
      vObjVenda.TotalDesconto  := edtDesconto.Value;
      vObjVenda.ValorVenda     := edtValor.Value;
      vObjVenda.DataVenda      := Now;
      vObjVenda.TotalVenda     := edtTotalValor.Value;
      vObjVenda.FormaPagamento := cmbPagamento.Text;
      vObjVenda.NomeCliente    := edtNome.Text;
      vObjVenda.Vendedor       := cmbVendedor.Text;

      TVendaController.getInstancia.GravaVenda(vObjVenda);

      Result := True;
   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados da venda. [View]'#13 +
         e.Message);
      end;
   end;
end;

function TfrmVendasView.ValidaCampos: Boolean;
begin
   Result := False;

   if (edtCodigo.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O código do cliente não pode ficar em branco.  ');

      if (edtCodigo.CanFocus) then
         edtCodigo.SetFocus;
         exit;
   end;

   if (edtNome.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O nome do cliente não pode ficar em branco.  ');

      if (edtNome.CanFocus) then
         edtNome.SetFocus;
         exit;
   end;

   if (cmbPagamento.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'A forma de pagamento da venda não pode ficar em branco.  ');

      if (cmbPagamento.CanFocus) then
         cmbPagamento.SetFocus;
         exit;
   end;

   if (cmbVendedor.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O nome do vendedor não pode ficar em branco. ');

      if (cmbVendedor.CanFocus) then
         cmbVendedor.SetFocus;
         exit;
   end;

   if (dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger = 0) then
   begin
      TMessageUtil.Alerta(
         'O código do produto não pode ficar em branco.  ');

      dbgProdutos.SetFocus;
      dbgProdutos.SelectedIndex := 0;
      exit;
   end;


   Result := True;
end;

procedure TfrmVendasView.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmVendasView.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
   cmbPagamento.Items.Clear;
   cmbPagamento.Items.Add('Cartão de crédito');
   cmbPagamento.Items.Add('Cartão de Débito');
   cmbPagamento.Items.Add('Dinheiro');
   cmbPagamento.Items.Add('Pix');
   carregaCMB;

   cdsProdutos.Open;
end;

procedure TfrmVendasView.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmVendasView.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtNumeroVenda.Text = EmptyStr) and (frmClientesPesq.mClienteID = 0) then
      begin
         TMessageUtil.Alerta('Número da venda não pode ficar em branco. ');

         if (edtNumeroVenda.CanFocus) then
            edtNumeroVenda.SetFocus;

         exit;
      end;

      vObjVenda :=
         TVendaController.getInstancia.BuscaVenda(
            StrToIntDef(edtNumeroVenda.Text, 0));

      vObjColVendaItem :=
         TVendaItemController.getInstancia.BuscaVendaItem(
            StrToIntDef(edtNumeroVenda.Text, 0));

      if (vObjVenda <> nil) then
      begin
         CarregaDadosTela;
         CarregaCliente;
      end
      else
      begin
         TMessageUtil.Alerta('Nenhum dado de venda encontrado.');

         edtNumeroVenda.Clear;

         if (edtNumeroVenda.CanFocus) then
            edtNumeroVenda.SetFocus;
         exit;
      end;

      Result := True;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao processar dados de consulta de venda [View]: '#13 +
            e.Message);
      end;
   end;
end;

procedure TfrmVendasView.CarregaDadosTela;
var
   xAux : Integer;
begin
   if (vObjVenda = nil) and (frmClientesPesq.mClienteID <> 0) then
      CarregaCliente
   else
   begin
      edtNumeroVenda.Text        := IntToStr(vObjVenda.ID);
      edtCodigo.Text             := IntToStr(vObjVenda.ID_Cliente);
      mskData.Text               := DateTimeToStr(vObjVenda.DataVenda);
      cmbPagamento.Text          := vObjVenda.FormaPagamento;
      cmbVendedor.Text           := vObjVenda.Vendedor;
      edtValor.Value             := vObjVenda.ValorVenda;
      edtDesconto.Value          := vObjVenda.TotalDesconto;
      edtTotalValor.Value        := vObjVenda.TotalVenda;
      btnCancelar.Enabled        := True;
   end;

   if (vObjColVendaItem = nil) then
      exit
   else
   begin
      for xAux := 0 to pred(vObjColVendaItem.Count) do
      begin
         cdsProdutos.Append;
         cdsProdutosID.Value         := vObjColVendaItem.Retorna(xAux).ID_Produto;
         cdsProdutosDescricao.Value  := vObjColVendaItem.Retorna(xAux).Descricao_Produto;
         cdsProdutosUniPreco.Value   := vObjColVendaItem.Retorna(xAux).ValorUnitario;
         cdsProdutosUniSaida.Value   := vObjColVendaItem.Retorna(xAux).UnidadeSaida;
         cdsProdutosQuantidade.Value := vObjColVendaItem.Retorna(xAux).Quantidade;
         cdsProdutosTotalPreco.Value := vObjColVendaItem.Retorna(xAux).TotalItem;
         cdsProdutos.Post;
      end;
   end;
end;

procedure TfrmVendasView.btnClienteClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmClientes  = nil then
            frmClientes := TfrmClientes.Create(Application);

         frmClientes.Show;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmVendasView.edtCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if vKey = VK_RETURN then
   begin
      if (edtCodigo.Text = EmptyStr) Then
      begin
         Screen.Cursor := crHourGlass;
         if frmClientesPesq  = nil then
            frmClientesPesq := TfrmClientesPesq.Create(Application);

         frmClientesPesq.ShowModal;
         if (frmClientesPesq.mClienteID <> 0) then
         begin
            edtCodigo.Text := IntToStr(frmClientesPesq.mClienteID);
            CarregaCliente;
         end;
         Screen.Cursor := crDefault;
      end
      else
      begin
         CarregaCliente;
         if (edtCodigo.Text <> EmptyStr) then
         begin
            if (cmbVendedor.CanFocus) then
               cmbVendedor.SetFocus;
         end;
      end;
   end;

   vKey := VK_CLEAR;
end;


function TfrmVendasView.CarregaCliente: Boolean;
var
   xPessoa : TPessoa;
begin
   try                                                    //count
      Result := False;
      xPessoa := TPessoa.Create;

      xPessoa :=
         TPessoa(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtCodigo.Text, 0)));

      if (xPessoa <> nil) then
         edtNome.Text := xPessoa.Nome
      else
      begin
         TMessageUtil.Alerta('Nenhum cliente encontrado para o código informado.');
         edtCodigo.Text := EmptyStr;
         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         Exit;
      end;
      DefineEstadoTela;
   finally
      if (xPessoa <> nil) then
         FreeAndNil(xPessoa);
   end;
end;


procedure TfrmVendasView.edtCodigoExit(Sender: TObject);
begin
   if (edtCodigo.Text = EmptyStr) then
      edtNome.Text := EmptyStr;
end;

procedure TfrmVendasView.edtDescontoExit(Sender: TObject);
begin
   if (CompareValue(edtDesconto.Value,100,0.001) = GreaterThanValue) then
   begin
      edtDesconto.Value := 100;
   end;
end;

procedure TfrmVendasView.btnLimparClick(Sender: TObject);
begin
   LimpaTela;
   vEstadoTela := etPadrao;
   DefineestadoTela;
end;

Procedure TfrmVendasView.ProcessaProdutoVenda;
var
   xIDProduto : Integer;
   xProduto   : TProduto;
begin
   try
      try
         xIDProduto := 0;
         xProduto := nil;
         xProduto := TProduto.Create;

         xIDProduto :=
            dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger;

         if xIDProduto = 0 then
         begin
            PesquisaProduto(xIDProduto);
            exit;
         end;

         xProduto :=
            TProdutoController.getInstancia.BuscaProduto(xIDProduto);

         if xProduto = nil then
         begin
            TMessageUtil.Alerta('Nenhum Produto encontrado.');
            exit;
         end;

         dbgProdutos.DataSource.DataSet.First;

         while not dbgProdutos.DataSource.DataSet.Eof do
         begin
            if (dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger = xIDProduto)
               and (dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString <> EmptyStr) then
            begin
               dbgProdutos.DataSource.DataSet.Edit;
               dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat :=
                  dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat + 1;
               dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat :=
                  dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat *
                  dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
               dbgProdutos.DataSource.DataSet.Post;

               exit;
            end;
            dbgProdutos.DataSource.DataSet.Next;
         end;

         if(xProduto <> nil) then
         begin
            dbgProdutos.DataSource.DataSet.Edit;
            dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString := xProduto.Descricao;
            dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat := xProduto.PrecoVenda;
            dbgProdutos.DataSource.DataSet.FieldByName('UniSaida').AsString := xProduto.Unidade;
            dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat := 1;
            dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat:=
               dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat *
               dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
            dbgProdutos.DataSource.DataSet.Post;
            exit;
         end;

      finally
         if (xProduto <> nil) then
            FreeAndNil(xProduto);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao processar dados da venda do item. [View]'+#13 +
            e.Message);
      end;
   end;
end;

procedure TfrmVendasView.dbgProdutosKeyPress(Sender: TObject;
  var Key: Char);

begin
   if (vKey = VK_RETURN) then
   begin
      if (dbgProdutos.SelectedIndex = 0) then
      begin
         ProcessaProdutoVenda;
         if dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString = '' then
         begin
            dbgProdutos.DataSource.DataSet.Edit;
            dbgProdutos.DataSource.DataSet.FieldByName('ID').AsString := '';
            exit
         end;

         dbgProdutos.SelectedIndex := 4;
         exit;
      end;

      if (dbgProdutos.SelectedIndex = 4) then
      begin
         dbgProdutos.DataSource.DataSet.Edit;
         dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat :=
            dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat *
            dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
         dbgProdutos.DataSource.DataSet.Post;
      end;

      if (dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString <> EmptyStr)
         and (dbgProdutos.SelectedIndex = 4) then
      begin
         dbgProdutos.DataSource.DataSet.Append;
         dbgProdutos.SelectedIndex := 0;
      end;
   end;

   vKey := VK_CLEAR;
end;

procedure TfrmVendasView.cdsProdutosAfterPost(DataSet: TDataSet);
var
   xPrecoProduto, xQuantidade, xTotalProduto  : Double;
begin
   vTotalPreco := 0;
   dbgProdutos.DataSource.DataSet.DisableControls;
   try
      if vEstadoTela = etIncluir then
      begin
         dbgProdutos.DataSource.DataSet.First;
         while not dbgProdutos.DataSource.DataSet.Eof do
         begin
            xPrecoProduto := dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat;
            xQuantidade := dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
            xTotalProduto := xPrecoProduto * xQuantidade;
            vTotalPreco := vTotalPreco + xTotalProduto;
            dbgProdutos.DataSource.DataSet.Next;

            edtTotalValor.Value := vTotalPreco;
         end;
      end;
   finally
      dbgProdutos.DataSource.DataSet.EnableControls;
   end;
end;

procedure TfrmVendasView.cdsProdutosBeforeDelete(DataSet: TDataSet);
var
   xPrecoProduto, xQuantidade, xTotalProduto  : Double;
begin
   xPrecoProduto := dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat;
   xQuantidade := dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
   xTotalProduto := xPrecoProduto * xQuantidade;
   vTotalPreco := vTotalPreco - xTotalProduto;

   edtTotalValor.Value := vTotalPreco;
   dbgProdutos.SelectedIndex := 0;
end;

procedure TfrmVendasView.edtDescontoChange(Sender: TObject);
var
   xDesconto : Double;
begin
   if (vTotalPreco = 0) then
      vTotalPreco := edtTotalValor.Value;

   vTotalPreco := 0;

   cdsProdutos.First;
   while not cdsProdutos.Eof do
   begin
      vTotalPreco := vTotalPreco + (cdsProdutosQuantidade.Value * cdsProdutosUniPreco.Value);
      cdsProdutos.Next;
   end;

   if (edtDesconto.Value <> 0) then
   begin
      xDesconto := vTotalPreco * (edtDesconto.Value / 100);
      edtTotalValor.Value := (vTotalPreco - xDesconto);
   end
   else
      edtTotalValor.Value := vTotalPreco;

   if (vEstadoTela = etIncluir) then
      edtValor.Value := xDesconto;

   if (vEstadoTela = etIncluir) and (edtDesconto.Value = 0) then
      edtValor.Value := 0;
end;

procedure TfrmVendasView.edtCodigoChange(Sender: TObject);
begin
   edtCodigo.Text := TFuncoes.removeCaracterEspecial(edtCodigo.Text, true);
   edtCodigo.Text := TFuncoes.SoNumero(edtCodigo.Text);

   if (edtCodigo.Text = EmptyStr) then
      edtNome.Text := EmptyStr;
end;

function TfrmVendasView.PesquisaProduto(pIDproduto: Integer): Boolean;
begin
   Result := False;
   pIDproduto := 0;

   pIDproduto :=
               dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger;

   if (vKey = VK_RETURN) then
   begin

      if (pIDproduto = 0) then
      begin
         Screen.Cursor := crHourGlass;
         if (frmProdutoPesq = nil) then
            frmProdutoPesq := TfrmProdutoPesq.Create(Application);

         frmProdutoPesq.ShowModal;
         if (frmProdutoPesq.mProdutoID <> 0) then
         begin
            pIDproduto := frmProdutoPesq.mProdutoID;
            CarregaProduto;
         end;
         Screen.Cursor := crDefault;
      end;
      vKey := VK_CLEAR;
      Result := True;
   end;
end;

procedure TfrmVendasView.CarregaProduto;
var
   xProduto : TProduto;
   xIDProduto : Integer;
begin
   try
      xProduto := nil;
      xProduto := TProduto.Create;

      xIDProduto := frmProdutoPesq.mProdutoID;

      xProduto :=
         TProdutoController.getInstancia.BuscaProduto(xIDProduto);

      if xProduto = nil then
      begin
         TMessageUtil.Alerta('Nenhum produto encontrado. ');
         exit;
      end;

      dbgProdutos.DataSource.DataSet.First;
      while not dbgProdutos.DataSource.DataSet.Eof do
      begin
         if (dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger = xIDProduto)
            and (dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString <> EmptyStr) then
         begin
            dbgProdutos.DataSource.DataSet.Edit;
            dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat :=
               dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat + 1;
            dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat :=
               dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat *
               dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
            dbgProdutos.DataSource.DataSet.Post;

            if (dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString <> EmptyStr)
               and (dbgProdutos.SelectedIndex = 4) then
            begin
               dbgProdutos.DataSource.DataSet.Append;
               dbgProdutos.SelectedIndex := 0;
            end;
            exit;
         end;
         dbgProdutos.DataSource.DataSet.Next;
      end;

      if (dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString <> EmptyStr)
            and (dbgProdutos.SelectedIndex = 0) then
      begin
         dbgProdutos.DataSource.DataSet.Append;
      end;

      if(xProduto <> nil) then
      begin
         dbgProdutos.DataSource.DataSet.Edit;
         dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger :=  xProduto.ID;
         dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString := xProduto.Descricao;
         dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat := xProduto.PrecoVenda;
         dbgProdutos.DataSource.DataSet.FieldByName('UniSaida').AsString := xProduto.Unidade;
         dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat := 1;
         dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat:=
            dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat *
            dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
         dbgProdutos.DataSource.DataSet.Post;
         exit;
      end;
   finally
      if (xProduto <> nil) then
         FreeAndNil(xProduto);
   end;
end;

function TfrmVendasView.ProcessaVendaItem: Boolean;
var
   xVendaItem  : TVendaItem;
begin
   try
      try
         Result := False;
         xVendaItem := nil;
         vObjColVendaItem := nil;

         if not ValidaCampos then
            exit;

         if vEstadoTela = etIncluir then
         begin
            if (xVendaItem = nil) then
               xVendaItem := TVendaItem.Create;

            if vObjColVendaItem = nil then
               vObjColVendaItem := TColVendaItem.Create;
         end;

         if (xVendaItem = nil) then
            Exit;

         cdsProdutos.First;
         while not cdsProdutos.Eof do
         begin
            xVendaItem := TVendaItem.Create;

            xVendaItem.ID_Venda      := vObjVenda.ID;
            xVendaItem.ID_Produto    := dbgProdutos.DataSource.DataSet.FieldByName('ID').AsInteger;
            xVendaItem.Quantidade    := dbgProdutos.DataSource.DataSet.FieldByName('Quantidade').AsFloat;
            xVendaItem.UnidadeSaida  := dbgProdutos.DataSource.DataSet.FieldByName('UniSaida').AsString;
            xVendaItem.Descricao_Produto  := dbgProdutos.DataSource.DataSet.FieldByName('Descricao').AsString;
            xVendaItem.ValorDesconto := edtValor.Value;
            xVendaItem.ValorUnitario := dbgProdutos.DataSource.DataSet.FieldByName('UniPreco').AsFloat;
            xVendaItem.TotalItem     := dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco').AsFloat; //xPrecoTotal;

            vObjColVendaItem.Adiciona(xVendaItem);
            cdsProdutos.Next;
         end;
         TVendaItemController.getInstancia.GravaVendaItem(vObjColVendaItem);

         Result := True;
      finally
         if (xVendaItem <> nil) then
            FreeAndNil(xVendaItem);

         if (vObjColVendaItem <> nil) then
            FreeAndNil(vObjColVendaItem);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados do produto vendido. [View]'#13 +
         e.Message);
      end;
   end;
end;

procedure TfrmVendasView.dbgProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;
   if vKey = VK_DELETE then
   begin
      if (TMessageUtil.Pergunta(
      'Deseja mesmo excluir este produto?')) then
      begin
         if not (dbgProdutos.DataSource.DataSet.IsEmpty) then
            dbgProdutos.DataSource.DataSet.Delete;
      end;
      vKey := VK_CLEAR;
   end;
end;


procedure TfrmVendasView.dbgProdutosExit(Sender: TObject);
begin
   cdsProdutos.Last;
   if (cdsProdutosDescricao.Value = EmptyStr) and (cdsProdutos.RecordCount <> 0) then
      dbgProdutos.DataSource.DataSet.Delete;
end;

procedure TfrmVendasView.cdsProdutosAfterOpen(DataSet: TDataSet);
begin
   (dbgProdutos.DataSource.DataSet.FieldByName('UniPreco') as TFloatField).DisplayFormat := 'R$ ##,##0.00';
   (dbgProdutos.DataSource.DataSet.FieldByName('TotalPreco') as TFloatField).DisplayFormat := 'R$ ##,##0.00';
end;

procedure TfrmVendasView.edtNumeroVendaChange(Sender: TObject);
begin
   edtNumeroVenda.Text := TFuncoes.removeCaracterEspecial(edtNumeroVenda.Text, true);
   edtNumeroVenda.Text := TFuncoes.SoNumero(edtNumeroVenda.Text);
end;

procedure TfrmVendasView.cmbPagamentoChange(Sender: TObject);
begin
   cmbPagamento.Text := TFuncoes.removeCaracterEspecial(cmbPagamento.Text, true);
   cmbPagamento.Text := TFuncoes.SoNumero(cmbPagamento.Text);
end;

procedure TfrmVendasView.cmbPagamentoKeyPress(Sender: TObject;
  var Key: Char);
begin
    if (Key in['0','1','2','3','4','5','6','7','8','9']) then
      Key := #0;
end;

procedure TfrmVendasView.carregaCMB;
var
   xListaVendedor   : TColUsuario;
   xAux             : Integer;
   xCadUsua         : TUsuario;
begin
   try
      xListaVendedor := TColUsuario.Create;

      xListaVendedor :=
         TCadUsuaController.getInstancia.PesquisaUsuario('');

      cmbVendedor.Items.Clear;

      if (xListaVendedor = nil) then
         Exit;

      for xAux := 0 to pred(xListaVendedor.Count) do
      begin
         xCadUsua := xListaVendedor[xAux];

         cmbVendedor.Items.AddObject(xCadUsua.Nome, xCadUsua);
      end;
   finally
      if(xListaVendedor <> nil) then
         FreeAndNil(xListaVendedor);
   end;
end;

procedure TfrmVendasView.cmbVendedorChange(Sender: TObject);
begin
   cmbVendedor.Text := TFuncoes.removeCaracterEspecial(cmbVendedor.Text, true);
   cmbVendedor.Text := TFuncoes.SoNumero(cmbVendedor.Text);
end;

procedure TfrmVendasView.cmbVendedorKeyPress(Sender: TObject;
  var Key: Char);
begin
   if (Key in['0','1','2','3','4','5','6','7','8','9']) then
      Key := #0;
end;

procedure TfrmVendasView.btnVendedorClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmCadUsua  = nil then
            frmCadUsua := TfrmCadUsua.Create(Application);

         frmCadUsua.ShowModal;

       carregaCMB;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmVendasView.cmbVendedorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if vKey = VK_RETURN then
   begin
      if (edtCodigo.Text <> EmptyStr) then
      begin
         dbgProdutos.SelectedIndex := 0;
         dbgProdutos.SetFocus;
      end;
   end;
end;

procedure TfrmVendasView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmVendasView := nil;
end;

procedure TfrmVendasView.edtNumeroVendaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if vKey = VK_RETURN then
   begin
      ProcessaConsulta;
   end;
   vKey := VK_CLEAR;
end;

end.
