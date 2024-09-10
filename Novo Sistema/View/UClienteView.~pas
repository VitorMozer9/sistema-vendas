unit UClienteView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, Mask , UEnumerationUtil;

type
  TfrmClientes = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    chkAtivo: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    CheckBox1: TCheckBox;
    rdgTipoPessoa: TRadioGroup;
    lblCPFCNPJ: TLabel;
    edtCPFCNPJ: TMaskEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    grbEndereco: TGroupBox;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblNumero: TLabel;
    Edit1: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblUF: TLabel;
    cmbUF: TComboBox;
    lblCidade: TLabel;
    edtCidade: TEdit;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    vKey : Word;

    //variaveis de classe
    vEstadoTela : TEstadoTela;

    procedure CamposEnable(pOpcao: Boolean);
    procedure LimpaTela; //não precisa de parametro pois a unica função é limpar a tela
    procedure DefineEstadoTela;
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
   uMessageUtil, Consts;

{$R *.dfm}

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);  //KeyDown
begin
   vKey := Key;  //nossa variavel privada recebe a variavel da procedure keydown

   case vKey of
       VK_RETURN: //correspondente a tecla <Enter> toda vez q pressionar o enter
       begin   //sistema vai pro proximo campo, pelo comando perform
          Perform(WM_NextDlgCtl, 0, 0); //passa para o proximo campo do formulario
       end;

       VK_ESCAPE: //correspondente a tecla <ESC>
       begin
          if (TMessageUtil.Pergunta(
             'Deseja realmente abortar esta opreação?')) then
             Close;   //fecha o formulario
       end;

    end;

end;

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmClientes := nil;
end;

procedure TfrmClientes.CamposEnable(pOpcao: Boolean);
var
   i: Integer; //variavel auxiliar do comando de repetição
begin
   for i := 0 to pred(ComponentCount) do
   begin
     //se o campo for do tipo edit
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

     //Se o campo for de maskEdit
      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

     //se for do tipo Radio Group
      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).Enabled := pOpcao;

      //se for do tipo Combo box
      if (Components[i] is TComboBox) then
         (Components[i] as TComboBox).Enabled := pOpcao;

      //se for do tipo check box
      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;

   end;

   grbEndereco.Enabled := pOpcao;
end;

procedure TfrmClientes.LimpaTela;
var
  i : Integer;
begin
  for i := 0 to pred(ComponentCount) do
   begin
     if (Components[i] is TEdit) then
        (Components[i] as TEdit).Text := EmptyStr;

     if (Components[i] is TMaskEdit) then
        (Components[i] as TMaskEdit).Text := EmptyStr;

     if (Components[i] is TRadioGroup) then
        (Components[i] as TRadioGroup).ItemIndex := 0;

     if (Components[i] is TComboBox) then  //padrao -1
      begin
        (Components[i] as TComboBox).Clear;
        (Components[i] as TComboBox).ItemIndex := -1;
      end;


     if (Components[i] is TCheckBox) then //então define
        (Components[i] as TCheckBox).Checked := False;

   end;
end;

procedure TfrmClientes.DefineEstadoTela;
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
end;

end.
