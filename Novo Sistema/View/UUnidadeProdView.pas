unit UUnidadeProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUnidadeProd: TfrmUnidadeProd;

implementation

{$R *.dfm}



