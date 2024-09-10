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

    procedure CamposEnable(pOpcao : Boolean ); 
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
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
       VK_RETURN: //correspondente a tecla <Enter> toda vez q pressionar o enter
       begin   //sistema vai pro proximo campo, pelo comando perform
          Perform(WM_NextDlgCtl, 0, 0); //passa para o proximo campo do formulario
       end;

       VK_ESCAPE: // correspondente a tecla <ESC>
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

end.
