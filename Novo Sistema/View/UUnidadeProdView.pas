unit UUnidadeProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,UEnumerationUtil, UUnidadeProduto;

type
  TfrmUnidadeProd = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    pnlArea: TPanel;
    edtUnidade: TEdit;
    lblCodigo: TLabel;
    lblUnidade: TLabel;
    chkAtivo: TCheckBox;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    edtCodigo: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure edtUnidadeChange(Sender: TObject);
    procedure edtDescricaoChange(Sender: TObject);
  private
    { Private declarations }
    vKey : Word;

    //variáveis de tela
    vEstadoTela : TEstadoTela;
    vObjUnidadeProduto : TUnidadeProduto;

    procedure CamposEnable(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure ConsultaPesquisa;

    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaConsulta    : Boolean;
    function ProcessaUnidadeProd : Boolean;
    function ProcessaAlteracao   : Boolean;
    function ProcessaExclusao    : Boolean;


    function ValidaCampos        : Boolean;

  public
    { Public declarations }
  end;

var
  frmUnidadeProd: TfrmUnidadeProd;

implementation

uses uMessageUtil, UUnidadeProdController, UClassFuncoes, UUnidadeProdPesqView;

{$R *.dfm}
procedure TfrmUnidadeProd.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmUnidadeProd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmUnidadeProd := nil;
end;

procedure TfrmUnidadeProd.CamposEnable(pOpcao: Boolean);
var
   xAux : Integer;
begin
   for xAux := 0 to pred(ComponentCount) do
   begin

      if (Components[xAux] is TEdit) then
         (Components[xAux] as TEdit).Enabled := pOpcao;

      if (Components[xAux] is TCheckBox) then
         (Components[xAux] as TCheckBox).Enabled := pOpcao;
   end;
end;

procedure TfrmUnidadeProd.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;
   end;
end;

procedure TfrmUnidadeProd.DefineEstadoTela;
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

         if (frmUnidadeProd <> nil) and
            (frmUnidadeProd.Active) and
            (btnIncluir.CanFocus) then
               btnIncluir.SetFocus;

            Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';

         CamposEnable(True);

         edtCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if (edtUnidade.CanFocus) then
            edtUnidade.SetFocus;
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Alteração';

         if (edtCodigo.Text <> EmptyStr) then
         begin
            CamposEnable(True);

            edtCodigo.Enabled := False;
            btnAlterar.Enabled := False;
            btnConfirmar.Enabled := True;

            if (chkAtivo.CanFocus) then
               chkAtivo.SetFocus;

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

procedure TfrmUnidadeProd.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmUnidadeProd.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta(
         'Deseja realmente abortar esta operação?')) then;
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmUnidadeProd.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmUnidadeProd.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmUnidadeProd.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
         etIncluir:   Result := ProcessaInclusao;
         etAlterar:   Result := ProcessaAlteracao;
         etExcluir:   Result := ProcessaExclusao;
         etConsultar: Result := ProcessaConsulta;
      end;

      if not Result then
         Exit;
   except
      on E : Exception do
         TMessageUtil.Alerta(e.Message);
   end;

   Result := True;
end;

function TfrmUnidadeProd.ProcessaInclusao: Boolean;
begin
  try
     try
        Result := False;

        if ProcessaUnidadeProd then
        begin
           TMessageUtil.Informacao('Unidade cadastrada com sucesso'+ #13 +
           'Código cadastrado: ' + IntToStr(vObjUnidadeProduto.Id));

           vEstadoTela := etPadrao;
           DefineEstadoTela;

           Result := True;
        end;
     except
        on E : Exception do
        begin
           Raise Exception.Create(
              'Falha ao incluir dados da Unidade de Produto [View]:'+ #13 +
              e.Message);
        end;
     end;

  finally
     if (vObjUnidadeProduto <> nil) then
        FreeAndNil(vObjUnidadeProduto);
  end;
end;

function TfrmUnidadeProd.ProcessaUnidadeProd: Boolean;
begin
   try
      Result := False;

      if not ValidaCampos then
         exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjUnidadeProduto = nil then
            vObjUnidadeProduto := TUnidadeProduto.create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjUnidadeProduto = nil then
            exit;
      end;

      if (vObjUnidadeProduto = nil) then
         Exit;

      vObjUnidadeProduto.Ativo     := chkAtivo.Checked;
      vObjUnidadeProduto.Unidade   := edtUnidade.Text;
      vObjUnidadeProduto.Descricao := edtDescricao.Text;

      TUnidadeProdController.getInstancia.GravaUnidadeProduto(
         vObjUnidadeProduto);

      Result := True;

   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados da Unidade de produto[View]'#13 +
         e.Message);
      end;
   end;
end;

function TfrmUnidadeProd.ValidaCampos: Boolean;
begin
   Result := False;

    if (Trim(edtUnidade.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta('Unidade do produto não pode ficar em branco.');

      if edtUnidade.CanFocus then
         edtUnidade.SetFocus;
      exit;
   end;

   if (Trim(edtDescricao.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'Descrição da unidade de produto não pode ficar em branco.');

      if edtDescricao.CanFocus then
         edtDescricao.SetFocus;
      exit;
   end;

   Result := True;
end;

function TfrmUnidadeProd.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) and not(vEstadoTela = etConsultar) then
      begin
         TMessageUtil.Alerta(
            'O código de Unidade de Produto não pode ficar em branco');

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         exit;
      end;

      vObjUnidadeProduto :=
         TUnidadeProdController.getInstancia.BuscaUnidade(
            StrToIntDef(edtCodigo.Text, 0));

      if (vObjUnidadeProduto <> nil) or (edtCodigo.Text = '') then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta('Nenhum dado de unidade encontrado');

         edtCodigo.Clear;

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;
         exit;
      end;

      Result := True;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar dados de unidade de produto [View]: '+#13 +
         e.Message);
      end;
   end;  
end;

procedure TfrmUnidadeProd.CarregaDadosTela;
begin
   if (vObjUnidadeProduto = nil) then
      exit;

   edtCodigo.Text    := IntToStr(vObjUnidadeProduto.Id);
   chkAtivo.Checked  := vObjUnidadeProduto.Ativo;
   edtUnidade.Text   := vObjUnidadeProduto.Unidade;
   edtDescricao.Text := vObjUnidadeProduto.Descricao;
   edtCodigo.Enabled := False;

   btnCancelar.Enabled := True;
   btnAlterar.Enabled := True;
   btnExcluir.Enabled := True;

   if  vEstadoTela = etAlterar then
   begin
      edtUnidade.Enabled   := true;
      edtDescricao.Enabled := true;
      chkAtivo.Enabled     := true;
   end;

end;

function TfrmUnidadeProd.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if edtCodigo.Enabled then
      begin
         ProcessaConsulta;
         exit;
      end;

      if ProcessaUnidadeProd then
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
            'Falha ao alterar os dados de Unidade [View]: '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmUnidadeProd.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   if not (edtCodigo.Text = EmptyStr) then
      ProcessaConsulta
   else
   begin
      if vEstadoTela = etConsultar then
      begin
         ConsultaPesquisa;
      end;
   end;

   vKey := VK_CLEAR;
end;

function TfrmUnidadeProd.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if edtCodigo.Enabled then
      begin
         ProcessaConsulta;
         Exit;
      end;

      if (vObjUnidadeProduto = nil) then
      begin
         TMessageUtil.Alerta(
            'Não foi possível carregar os dados de unidade ');

         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         exit;
      end;

      try
         if TMessageUtil.Pergunta(
            'Confirma a exclusão dos dados de Unidade do Produto?') then
         begin
            Screen.Cursor := crHourGlass;

            TUnidadeProdController.getInstancia.ExcluiUnidade(
               vObjUnidadeProduto);

            TMessageUtil.Informacao('Unidade excluída com sucesso. ');
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
         'Falha ao excluir dados de unidade. [View]: '+ #13 +
         e.Message);
      end;
   end;
end;

procedure TfrmUnidadeProd.edtUnidadeChange(Sender: TObject);
begin
   edtUnidade.Text := TFuncoes.removeCaracterEspecial(edtUnidade.Text, True);
end;

procedure TfrmUnidadeProd.edtDescricaoChange(Sender: TObject);
begin
   edtDescricao.Text := TFuncoes.removeCaracterEspecial(edtDescricao.Text, True);
end;


procedure TfrmUnidadeProd.ConsultaPesquisa;
begin
   if (frmUnidadePesq = nil) then
      frmUnidadePesq := TfrmUnidadePesq.Create(Application);

      frmUnidadePesq.ShowModal;

   if (frmUnidadePesq.mUnidadeID <> 0) then
   begin
      edtCodigo.Text := IntToStr(frmUnidadePesq.mUnidadeID);
      vEstadoTela := etConsultar;
      ProcessaConsulta;
   end
   else
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   end;

   frmUnidadePesq.mUnidadeID   := 0;
   frmUnidadePesq.mUnidade := EmptyStr;

   if (edtUnidade.CanFocus) then
      edtUnidade.SetFocus;
end;

end.
