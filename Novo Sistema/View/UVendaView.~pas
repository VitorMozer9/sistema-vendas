unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask, NumEdit, DB,
  DBClient, Grids, DBGrids, UEnumerationUtil, uMessageUtil;

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
    lblNome: TLabel;
    edtNome: TEdit;
    btnUnidadeProduto: TSpeedButton;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    mskData: TMaskEdit;
    lblData: TLabel;
    Label1: TLabel;
    edtNumeroVenda: TEdit;
    cmbPagamento: TComboBox;
    lblPagamento: TLabel;
    lblDesconto: TLabel;
    edtDesconto: TNumEdit;
    lblValor: TLabel;
    edtValor: TNumEdit;
    lblValorTotal: TLabel;
    edtTotalValor: TNumEdit;
    dbgProdutos: TDBGrid;
    dtsProdutos: TDataSource;
    cdsProdutos: TClientDataSet;
    cdsProdutosID: TIntegerField;
    cdsProdutosDescricao: TStringField;
    cdsProdutosUniPreco: TFloatField;
    cdsProdutosUniSaida: TStringField;
    cdsProdutosQuantidade: TFloatField;
    cdsProdutosTotalPreco: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
   vKey : Word;
   vEstadoTela : TEstadoTela;

   procedure CamposEnable(pOpcao : Boolean);
   procedure LimpaTela;
   procedure DefineEstadoTela;

   function ProcessaConfirmacao : Boolean;
   function ProcessaInclusao    : Boolean;
   function ProcessaVenda       : Boolean;

  public
    { Public declarations }
  end;

var
  frmVendasView: TfrmVendasView;

implementation

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
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

         if (frmVendasView <> nil) and
            (frmVendasView.Active) and
            (btnConfirmar.CanFocus)then
            btnConfirmar.SetFocus;

         Application.ProcessMessages;
      end;
   end;
end;

procedure TfrmVendasView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NEXTDLGCTL,0,0);
      end;

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
   for xI := 0 to pred(ComponentCount) do
   begin
     if (Components[xI] is TEdit) then
        (Components[xI] as TEdit).Text := EmptyStr;

     if (Components[xI] is TNumEdit) then
      begin
         (Components[xI] as TNumEdit).Value := 0;
         exit;
      end;

     if (Components[xI] is TMaskEdit) then
        (Components[xI] as TMaskEdit).Text := EmptyStr;

     if (Components[xI] is TComboBox) then
      begin
        (Components[xI] as TComboBox).Clear;
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
   //ProcessaConfirmacao;
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
//         etIncluir:   Result := ProcessaInclusao;
//         etConsultar: Result := ProcessaConsulta;
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

        if ProcessaVenda then
        begin
           TMessageUtil.Informacao('Venda cadastrado com sucesso'#13 +
             'Código cadastrado: ' + IntToStr(vObjProduto.ID));

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
//      if vObjVenda <> nil then
//         FreeAndNil(vObjVenda);
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
      end

      if (vObjVenda = nil) then
         Exit;

//      vObjVenda. := edtNumeroVenda.Text;
//      vObjVenda. := edtDesconto.Value;
//      vObjVenda. := edtValor.Value;
//      vObjVenda. := cmbPagamento.Text;
//      vObjVenda. := edtTotalValor.Value;

      //Gravação no banco
      //TVendaController.getInstancia.GravaVenda(vObjVenda);

      Result := True;

   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados da venda[View]'#13 +
         e.Message);
      end;
   end;
end;

end.
