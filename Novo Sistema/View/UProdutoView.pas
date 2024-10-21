unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,UEnumerationUtil, uMessageUtil,
  UProduto, UProdutoController, NumEdit, Types;

type
  TfrmProdutoView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnSair: TBitBtn;
    btnListar: TBitBtn;
    edtDescricao: TEdit;
    lblDescricao: TLabel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblUnidade: TLabel;
    edtUnidade: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    edtUnidadeDesc: TEdit;
    Label2: TLabel;
    lblPreco: TLabel;
    edtQuantidadeEstoque: TNumEdit;
    edtPreco: TNumEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    vKey : Word;
    vEstadoTela : TEstadoTela;
    vObjProduto : TProduto;

    procedure CamposEnable(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;

    function ValidaCampos        : Boolean;
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaProduto     : Boolean;

  public
    { Public declarations }
  end;

var
  frmProdutoView: TfrmProdutoView;

implementation

uses Math;

{$R *.dfm}

procedure TfrmProdutoView.CamposEnable(pOpcao: Boolean);
var
   xAux : Integer;
begin
   for xAux := 0 to pred(ComponentCount) do
   begin
      if (Components[xAux] is TEdit) then
         (Components[xAux] as TEdit).Enabled := pOpcao;

      if (Components[xAux] is TNumEdit) then
         (Components[xAux] as TNumEdit).Enabled := pOpcao;
   end;
end;

procedure TfrmProdutoView.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnListar.Enabled    := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnable(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

         if (frmProdutoView <> nil) and
            (frmProdutoView.Active) and
            (btnConfirmar.CanFocus)then
            btnConfirmar.SetFocus;

         Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnable(True);

         edtUnidade.Enabled     := False;
         edtUnidadeDesc.Enabled := False;
         edtCodigo.Enabled      := False;

         if (edtDescricao.CanFocus) then
            edtDescricao.SetFocus;
      end;
   end;
end;

procedure TfrmProdutoView.FormKeyDown(Sender: TObject; var Key: Word;
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
               //DefineEstadoTela;
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

procedure TfrmProdutoView.LimpaTela;
var
   xI : Integer;
begin
   edtPreco.Value := 0;
   edtQuantidadeEstoque.Value := 0;

   for xI := 0 to (ComponentCount) do
   begin
      if (Components[xI] is TNumEdit) then
      begin
         (Components[xI] as TNumEdit).Value := 0;
         exit;
      end;

      if (Components[xI] is TEdit) then
         (Components[xI] as TEdit).Text := EmptyStr;
   end;
end;

function TfrmProdutoView.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
           etIncluir:   Result := ProcessaInclusao;
//         etAlterar:   Result := ProcessaAlteracao;
//         etExcluir:   Result := ProcessaExclusao;
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

procedure TfrmProdutoView.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
end;

procedure TfrmProdutoView.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnListarClick(Sender: TObject);
begin
   vEstadoTela := etListar;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutoView.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta(
         'Deseja realmente abortar esta operação?')) then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmProdutoView.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmProdutoView.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmProdutoView.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmProdutoView.ProcessaInclusao: Boolean;
begin
   Result := False;
   try
      try

        if ProcessaProduto then
        begin
           TMessageUtil.Informacao('Produto cadastrado com sucesso'#13 +
             'Código cadastrado: ' + IntToStr(vObjProduto.ID));

           vEstadoTela := etPadrao;
           DefineEstadoTela;

           Result := True;
        end;

      except
         on E : Exception do
         begin
            Raise Exception.Create(
               'Falha ao incluir os dados do produto[View]: '#13 +
               e.Message);
         end;
      end;
   finally
      if vObjProduto <> nil then
         FreeAndNil(vObjProduto);
   end;
end;

function TfrmProdutoView.ProcessaProduto: Boolean;
begin
   try
      Result := False;

      if not ValidaCampos then
         exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjProduto = nil then
            vObjProduto := TProduto.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjProduto = nil then
            exit;
      end;

      if (vObjProduto = nil) then
         Exit;

      //edtQuantidadeEstoque.Text := StringReplace(edtQuantidadeEstoque.Text, '.', ',' ,[rfReplaceAll]);
      //vObjProduto.QuantidadeDeEstoque := StrToFloat(edtQuantidadeEstoque.Text);

      //edtPreco.Text := StringReplace(edtPreco.Text, '.', ',' ,[rfReplaceAll]);
      //vObjProduto.PrecoVenda := StrToFloat(edtPreco.Text);

      vObjProduto.Descricao         := edtDescricao.Text;
      vObjProduto.QuantidadeEstoque := edtQuantidadeEstoque.Value;
      vObjProduto.PrecoVenda        := edtPreco.Value;
     //vObjProduto.Unidade_Id        :=


      //Gravação no banco
      TProdutoController.getInstancia.GravaProduto(vObjProduto);

      Result := True;

   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados de produto[View]'#13 +
         e.Message);
      end;
   end;
end;

function TfrmProdutoView.ValidaCampos: Boolean;
begin
   Result := False;

   if (edtDescricao.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'A identificação do nome do produto não pode ficar em branco.  ');

      if (edtDescricao.CanFocus) then
         edtDescricao.SetFocus;
         exit;
   end;

   if CompareValue(edtQuantidadeEstoque.Value,0,0.001) = EqualsValue then
   begin
      TMessageUtil.Alerta(
         'A Quantidade de estoque do produto não pode ficae em branco. ');

      if (edtQuantidadeEstoque.CanFocus) then
         edtQuantidadeEstoque.SetFocus;
         exit;
   end;

   if CompareValue(edtPreco.Value,0,0.001) = EqualsValue then
   begin
      TMessageUtil.Alerta(
         'O preço do produto não pode ficar em branco. ');

      if (edtPreco.CanFocus) then
         edtPreco.SetFocus;
         exit;
   end;

   Result := True;
end;



end.
