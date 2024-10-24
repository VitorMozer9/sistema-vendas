unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,UEnumerationUtil, uMessageUtil,
  UProduto, UProdutoController, NumEdit, Types, UProdutoPesqView;

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
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);
  private
    { Private declarations }
    vKey : Word;
    vEstadoTela : TEstadoTela;
    vObjProduto : TProduto;

    procedure CamposEnable(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure ConsultaPesquisa;

    function ValidaCampos           : Boolean;
    function ProcessaConfirmacao    : Boolean;
    function ProcessaInclusao       : Boolean;
    function ProcessaConsulta       : Boolean;
    function ProcessaProduto        : Boolean;
    function ProcessaAlteracao      : Boolean;
    function ProcessaExclusao       : Boolean;

  public
    { Public declarations }
  end;

var
  frmProdutoView: TfrmProdutoView;

implementation

uses Math, UUnidadeProdDAO, UUnidadeProdController, UUnidadeProduto;

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

         edtUnidade.Enabled := False;
         edtUnidadeDesc.Enabled := False;
         edtCodigo.Enabled      := False;

         if (edtDescricao.CanFocus) then
            edtDescricao.SetFocus;
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Alteração';

         if (edtCodigo.Text <> EmptyStr) then
         begin
            CamposEnable(True);

//            edtUnidade.Enabled := False;
            edtUnidadeDesc.Enabled := False;
            edtCodigo.Enabled := False;
            btnAlterar.Enabled := False;
            btnConfirmar.Enabled := True;

            if (edtDescricao.CanFocus) then
               edtDescricao.SetFocus;

         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;
         end;
      end;

      etExcluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Exclusão';

         if (edtCodigo.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;
         end;
      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

         CamposEnable(False);

         if (edtCodigo.Text <> EmptyStr) then
         begin
            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := True;
            btnExcluir.Enabled   := True;
            btnConfirmar.Enabled := False;

            if (btnAlterar.CanFocus) then
               btnAlterar.SetFocus;
         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if edtCodigo.CanFocus then
               edtCodigo.SetFocus;
         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';
         ConsultaPesquisa;
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
           etAlterar:   Result := ProcessaAlteracao;
           etExcluir:   Result := ProcessaExclusao;
           etConsultar: Result := ProcessaConsulta;
           //etPesquisar: Result := ProcessaPesquisa;
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
   DefineEstadoTela;
end;

procedure TfrmProdutoView.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
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

      vObjProduto.Descricao         := edtDescricao.Text;
      //vObjProduto.Unidade_Id        := StrToInt(edtUnidade.Text);
      vObjProduto.QuantidadeEstoque := edtQuantidadeEstoque.Value;
      vObjProduto.PrecoVenda        := edtPreco.Value;

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



function TfrmProdutoView.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Código do produto não pode ficar em branco.');

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         exit;
      end;

      vObjProduto :=
         TProdutoController.getInstancia.BuscaProduto(
            StrToIntDef(edtCodigo.Text, 0));

      if (vObjProduto <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta('Nenhum dado de produto encontrado.');

         edtCodigo.Clear;

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;
         exit;
      end;

      Result := True;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao processar dados de consulta de produto [View]: '#13 +
            e.Message);
      end;
   end;
end;

procedure TfrmProdutoView.CarregaDadosTela;
var
   xObjUnidadeProduto : TUnidadeProduto;
begin
   if (vObjProduto = nil) then
      exit;

   edtCodigo.Text             := IntToStr(vObjProduto.ID);
   edtDescricao.Text          := vObjProduto.Descricao;
   edtQuantidadeEstoque.Value := vObjProduto.QuantidadeEstoque;
   edtPreco.Value             := vObjProduto.PrecoVenda;

   try
      if vObjProduto.Unidade_ID <> 0 then
      begin
         xObjUnidadeProduto := nil;
         xObjUnidadeProduto := TUnidadeProduto.create;
         xObjUnidadeProduto := TUnidadeProdController.getInstancia.RetornaProdutoUnidade(vObjProduto.ID);
         edtUnidade.Text := xObjUnidadeProduto.Unidade;
         edtUnidadeDesc.Text := xObjUnidadeProduto.Descricao;

         if  xObjUnidadeProduto <> nil then
             edtUnidadeDesc.Text :=  xObjUnidadeProduto.Descricao;
      end;
   finally
      if xObjUnidadeProduto <> nil then
         FreeAndNil(xObjUnidadeProduto);
   end;

   btnCancelar.Enabled := True;
   btnAlterar.Enabled  := True;
   btnExcluir.Enabled  := True;

   if  vEstadoTela = etAlterar then
   begin
      edtDescricao.Enabled         := true;
      edtQuantidadeEstoque.Enabled := true;
      edtPreco.Enabled             := true;
   end;
end;

procedure TfrmProdutoView.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   begin
      ProcessaConsulta;
   end;
   //else
      vKey := VK_CLEAR;
end;

function TfrmProdutoView.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if edtCodigo.Enabled then
      begin
         ProcessaConsulta;
         exit;
      end;

      if ProcessaProduto then
      begin
         TMessageUtil.Informacao('Dados alterados com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao alterar os dados de Produto [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmProdutoView.ProcessaExclusao: Boolean;
begin
   Result := False;
   try
      if (edtCodigo.Text <> EmptyStr) and
         (Trim(edtDescricao.Text) = EmptyStr) and
         (CompareValue(edtPreco.Value,0,0.001) = EqualsValue) then
      begin
         ProcessaConsulta;
         exit;
      end;

      if (vObjProduto = nil) then
      begin
         TMessageUtil.Alerta(
            'Não foi possível carregar os dados de Produto. ');

         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         exit;
      end;

      try
         if TMessageUtil.Pergunta(
               'Confirma a exclusão dos dados do Produto?') then
         begin
            Screen.Cursor := crHourGlass;

            TProdutoController.getInstancia.ExcluiProduto(vObjProduto);

            TMessageUtil.Informacao('Produto excluído com sucesso. ');
         end
         else
         begin
            LimpaTela;
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            exit;
         end;

      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;

      Result := True;

      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;

   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao excluir dados do Produto. [View]: '+ #13 +
         e.Message);
      end;
   end;
end;

procedure TfrmProdutoView.ConsultaPesquisa;
begin
   if (frmProdutoPesq = nil) then
      frmProdutoPesq := TfrmProdutoPesq.Create(Application);

      frmProdutoPesq.ShowModal;

   if (frmProdutoPesq.mProdutoID <> 0) then
   begin
      edtCodigo.Text := IntToStr(frmProdutoPesq.mProdutoID);
      vEstadoTela := etConsultar;
      ProcessaConsulta;
   end
   else
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   end;
end;


end.
