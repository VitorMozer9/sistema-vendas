unit UUnidadeProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,UEnumerationUtil;

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
  private
    { Private declarations }
    vKey : Word;

    vEstadoTela : TEstadoTela;
  public
    { Public declarations }
  end;

var
  frmUnidadeProd: TfrmUnidadeProd;

implementation

uses uMessageUtil;

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

end.
