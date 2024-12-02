Unit UCadUsuaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,UEnumerationUtil,uMessageUtil,UUsuario;

type
  TfrmCadUsua = class(TForm)
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
    lblUsuario: TLabel;
    lblNome: TLabel;
    edtUsuario: TEdit;
    chkAtivo: TCheckBox;
    rdgCargo: TRadioGroup;
    edtNome: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    vKey : Word;
    vEstadoTela : TEstadoTela;
    vObjUsuario : TUsuario;

    procedure CamposEnable(pOpcao : Boolean);
    procedure DefineEstadoTela;
    procedure LimpaTela;
    procedure CarregaDadosTela;
    procedure ConsultaPesquisa;

    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaUsuario     : Boolean;
    function ProcessaConsulta    : Boolean;
    function ProcessaAlteracao   : Boolean;
    function ProcessaExclusao    : Boolean;
    function ValidaCampos        : Boolean;

  public
    { Public declarations }
  end;

var
  frmCadUsua: TfrmCadUsua;

implementation

uses UCadUsuaController, UCadUsuaPesqView;

{$R *.dfm}

{ TfrmCadUsua }

procedure TfrmCadUsua.CamposEnable(pOpcao: Boolean);
var
   xI : Integer;
begin
   for xI := 0 to pred(ComponentCount) do
   begin
      if (Components[xI] is TEdit) then
         (Components[xI] as TEdit).Enabled := pOpcao;

      if (Components[xI] is TRadioGroup) then
         (Components[xI] as TRadioGroup).Enabled := pOpcao;

      if (Components[xI] is TCheckBox) then
         (Components[xI] as TCheckBox).Enabled := pOpcao;
   end;
end;

procedure TfrmCadUsua.DefineEstadoTela;
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

         if (frmCadUsua <> nil) and
            (frmCadUsua.Active) and
            (btnConfirmar.CanFocus)then
            btnConfirmar.SetFocus;

         Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnable(True);

         chkAtivo.Checked := True;

         if (edtUsuario.CanFocus) then
            edtUsuario.SetFocus;
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Alteração';

         if (edtUsuario.Text <> EmptyStr) then
         begin
            CamposEnable(True);

            edtUsuario.Enabled := False;
            btnAlterar.Enabled := False;
            btnConfirmar.Enabled := True;

            if (chkAtivo.CanFocus) then
               chkAtivo.SetFocus;
         end
         else
         begin
            lblUsuario.Enabled := True;
            edtUsuario.Enabled := True;

            if (edtUsuario.CanFocus) then
               edtUsuario.SetFocus;
         end;
      end;

      etExcluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Exclusão';

         if (edtUsuario.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin
            lblUsuario.Enabled := True;
            edtUsuario.Enabled := True;

            if (edtUsuario.CanFocus) then
               edtUsuario.SetFocus;
         end;
      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

          CamposEnable(False);

         if (edtUsuario.Text <> EmptyStr) then
         begin

            btnAlterar.Enabled   := True;
            btnExcluir.Enabled   := True;
            btnConfirmar.Enabled := False;

            btnAlterar.Enabled := True;
            btnExcluir.Enabled := True;
            if (btnAlterar.CanFocus) then
               btnAlterar.SetFocus;
         end
         else
         begin
            lblUsuario.Enabled := True;
            edtUsuario.Enabled := True;

            if edtUsuario.CanFocus then
               edtUsuario.SetFocus;
         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';
         ConsultaPesquisa;
      end;
   end;
end;

procedure TfrmCadUsua.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmCadUsua.LimpaTela;
var
   xAux : Integer;
begin
   for xAux := 0 to pred(ComponentCount) do
   begin
     if (Components[xAux] is TEdit) then
        (Components[xAux] as TEdit).Text := EmptyStr;

     if (Components[xAux] is TRadioGroup) then
        (Components[xAux] as TRadioGroup).ItemIndex := 0;

     if (Components[xAux] is TCheckBox) then
        (Components[xAux] as TCheckBox).Checked := False;

   end;
end;

function TfrmCadUsua.ProcessaConfirmacao: Boolean;
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
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;

   Result := True;
end;

procedure TfrmCadUsua.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmCadUsua.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmCadUsua.btnSairClick(Sender: TObject);
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

procedure TfrmCadUsua.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmCadUsua.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmCadUsua.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmCadUsua.ProcessaInclusao: Boolean;
begin
   Result := False;
   try
      try

        if ProcessaUsuario then
        begin
           TMessageUtil.Informacao('Vendedor cadastrado com sucesso.');

           vEstadoTela := etPadrao;
           DefineEstadoTela;

           Result := True;
        end;

      except
         on E : Exception do
         begin
            Raise Exception.Create(
               'Falha ao incluir os dados de vendedor[View]: '#13 +
               e.Message);
         end;
      end;
   finally
      if vObjUsuario <> nil then
         FreeAndNil(vObjUsuario);
   end;
end;

function TfrmCadUsua.ProcessaUsuario: Boolean;
var
   xInclusao : Boolean;
begin
   xInclusao := False;
   try
      Result := False;

      if not ValidaCampos then
         exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjUsuario = nil then
            vObjUsuario := TUsuario.Create;

         xInclusao := True;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjUsuario = nil then
            exit;
      end;

      if (vObjUsuario = nil) then
         Exit;

      vObjUsuario.Usuario := edtUsuario.Text;
      vObjUsuario.Senha   := edtSenha.Text;
      vObjUsuario.Nome    := edtNome.Text;
      vObjUsuario.Cargo   := rdgCargo.ItemIndex;
      vObjUsuario.Ativo   := chkAtivo.Checked;

      //Gravação no banco
      TCadUsuaController.getInstancia.GravaUsuario(vObjUsuario, xInclusao);

      Result := True;

   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados de produto. [View]'#13 +
         e.Message);
      end;
   end;
end;

function TfrmCadUsua.ValidaCampos: Boolean;
begin
   Result := False;

   if (edtUsuario.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O Usuário não pode ficar em branco.  ');

      if (edtUsuario.CanFocus) then
         edtUsuario.SetFocus;
         exit;
   end;

   if (edtSenha.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'A senha do vendedor não pode ficar em branco.  ');

      if (edtSenha.CanFocus) then
         edtSenha.SetFocus;
         exit;
   end;

   if (edtNome.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta(
         'O nome do vendedor não pode ficar em branco.  ');

      if (edtNome.CanFocus) then
         edtNome.SetFocus;
         exit;
   end;

   if (chkAtivo.Checked = False) then
   begin
      TMessageUtil.Alerta(
         'Não é possivel cadastrar vendedor inativos.');

      if (chkAtivo.CanFocus) then
         chkAtivo.SetFocus;
         exit;

   end;

   Result := True;
end;

function TfrmCadUsua.ProcessaConsulta: Boolean;
begin
   try
    Result := False;

      if (edtUsuario.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta(
            'O campo Usuário não pode ficar em branco.');

         if (edtUsuario.CanFocus) then
            edtUsuario.SetFocus;

         exit;
      end;

      vObjUsuario :=
         TCadUsuaController.getInstancia.BuscaUsuario(edtUsuario.Text);

      if (vObjUsuario <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta('Nenhum vendedor encontrado.');

         edtUsuario.Clear;

         if edtUsuario.CanFocus then
            edtUsuario.SetFocus;
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

procedure TfrmCadUsua.CarregaDadosTela;
begin
   if (vObjUsuario = nil) then
   exit;

   edtUsuario.Text         := vObjUsuario.Usuario;
   rdgCargo.ItemIndex      := vObjUsuario.Cargo;
   edtSenha.Text           := vObjUsuario.Senha;
   edtNome.Text            := vObjUsuario.Nome;
   chkAtivo.Checked        := vObjUsuario.Ativo;

   if  vEstadoTela = etAlterar then
   begin
      edtNome.Enabled    := true;
      edtSenha.Enabled   := true;
      edtUsuario.Enabled := true;
      chkAtivo.Enabled   := true;
   end;

   if vEstadoTela = etConsultar then
   begin
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;

   end;

end;

function TfrmCadUsua.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if (Trim(edtUsuario.Text) <> EmptyStr) and
         (Trim(edtNome.Text) = EmptyStr) then
      begin
         ProcessaConsulta;
         exit;
      end;

      if ProcessaUsuario then
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
            'Falha ao alterar os dados do vendedor [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmCadUsua.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if (edtUsuario.Text <> EmptyStr) and (edtNome.Text = EmptyStr) then
      begin
         ProcessaConsulta;
         exit
      end;

      if (vObjUsuario = nil) then
      begin
         TMessageUtil.Alerta('Não foi possível carregar os dados do vendedor. ');

         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         exit;
      end;

      try
         if TMessageUtil.Pergunta(
            'Confirma a exclusão dos dados do vendedor?') then
         begin
            Screen.Cursor := crHourGlass;

            TCadUsuaController.getInstancia.ExcluiUsuario(
               vObjUsuario);

            TMessageUtil.Informacao('Vendedor excluído com sucesso. ');
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
            'Falha ao excluir dados do vendedor. [View]: '#13 +
            e.Message);
      end;
   end;
end;

procedure TfrmCadUsua.ConsultaPesquisa;
begin
   if (frmCadUsuaPesq = nil) then
      frmCadUsuaPesq := TfrmCadUsuaPesq.Create(Application);

      frmCadUsuaPesq.ShowModal;

   if (frmCadUsuaPesq.mUsuario <> EmptyStr) then
   begin
      edtUsuario.Text := frmCadUsuaPesq.mUsuario;
      vEstadoTela := etConsultar;
      ProcessaConsulta;
   end
   else
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   end;

   frmCadUsuaPesq.mUsuario := EmptyStr;

   if (edtUsuario.CanFocus) then
      edtUsuario.SetFocus;
end;

procedure TfrmCadUsua.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
   if (Key in['0','1','2','3','4','5','6','7','8','9']) then
      Key := #0;
end;

procedure TfrmCadUsua.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmCadUsua := nil;
end;

end.
