unit UClientesPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids, UMessageUtil, UPessoa, UPessoaController;

type
  TfrmClientesPesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
    grbFiltrar: TGroupBox;
    lblNome: TLabel;
    edtNome: TEdit;
    lblInfo: TLabel;
    btnFiltrar: TBitBtn;
    gbrGrid: TGroupBox;
    dbgCliente: TDBGrid;
    dtsCliente: TDataSource;
    cdsCliente: TClientDataSet;
    cdsClienteID: TIntegerField;
    cdsClienteNome: TStringField;
    cdsClienteAtivo: TIntegerField;
    cdsClienteDescricaoAtivo: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
   
  private
    { Private declarations }
   vKey : Word;

   procedure LimparTela;
   procedure ProcessaPesquisa;
  public
    { Public declarations }
    mClienteID   : Integer;
    mClienteNome : String;

  end;

var
  frmClientesPesq: TfrmClientesPesq;

implementation

uses Math, StrUtils;

{$R *.dfm}

procedure TfrmClientesPesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NextDlgCtl, 0 , 0);
      end;

      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina?') then
            Close;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;

         if (ActiveControl = dbgCliente) then
            exit;

          Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;

procedure TfrmClientesPesq.LimparTela;
var
   I : Integer;
begin
   for I := 0 to pred(ComponentCount) do
   begin
      if (Components[I] is TEdit) then
         (Components[I] as TEdit).Text := EmptyStr;
   end;

   if (not cdsCliente.IsEmpty) then
      cdsCliente.EmptyDataSet;

   if (edtNome.CanFocus) then
      edtNome.SetFocus;


end;

procedure TfrmClientesPesq.ProcessaPesquisa;
var
   xListaCliente : TColPessoa;
   xAux          : Integer;
begin
   try
      try
         xListaCliente := TColPessoa.Create;

         XListaCliente :=
            TPessoaController.getInstancia.PesquisaPessoa(Trim(edtNome.Text));

         cdsCliente.EmptyDataSet;

         if xListaCliente <> nil then
         begin
            for xAux := 0 to pred(xListaCliente.Count) do
            begin
               cdsCliente.Append;
               cdsClienteID.Value    := xListaCliente.Retorna(xAux).Id;
               cdsClienteNome.Value  := xListaCliente.Retorna(xAux).Nome;

               cdsClienteAtivo.Value :=
                  IfThen(xListaCliente.Retorna(xAux).Ativo,1, 0);

               cdsClienteDescricaoAtivo.Value :=
                  IfThen(
                     xListaCliente.Retorna(xAux).DescricaoAtivo, 'Sim', 'Não');
               cdsCliente.Post;
            end;
         end;

         if (cdsCliente.RecordCount = 0) then
         begin
            if edtNome.CanFocus then
               edtNome.SetFocus;

            TMessageUtil.Alerta('Nenhum cliente encontrado para este filtro');
         end
         else
         begin
            cdsCliente.First;

            if dbgCliente.CanFocus then
               dbgCliente.SetFocus;
         end;
      finally
         if (xListaCliente <> nil) then
            FreeAndNil(xListaCliente);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao pesquisar dados da Pessoa [View]: '#13 +
            e.Message);
      end;
   end;
end;

end.

