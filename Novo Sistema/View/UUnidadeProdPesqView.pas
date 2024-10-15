unit UUnidadeProdPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids,UMessageUtil;

type
  TfrmUnidadePesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
    grbFiltrar: TGroupBox;
    lblUnidade: TLabel;
    lblInfo: TLabel;
    edtUnidade: TEdit;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    dbgResultadoBusca: TDBGrid;
    dtsUnidade: TDataSource;
    cdsUnidade: TClientDataSet;
    cdsUnidadeID: TIntegerField;
    cdsUnidadeUnidade: TStringField;
    cdsUnidadeDescricao: TStringField;
    cdsUnidadeAtivo: TIntegerField;
    cdsUnidadeAtivoDesc: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }

    vKey : Word;

    procedure LimpaTela;
  public
    { Public declarations }
  end;

var
  frmUnidadePesq: TfrmUnidadePesq;

implementation

{$R *.dfm}




procedure TfrmUnidadePesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NEXTDLGCTL, 0, 0 );
      end;

      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina?') then
            Close;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;

         if (ActiveControl = dbgResultadoBusca) then
            exit;

          Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;

end.
