unit UVendaPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids, Mask,uMessageUtil, UVenda, UVendaController, UClassFuncoes;

type
  TfrmVendaPesqView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlArea: TPanel;
    grbFiltrar: TGroupBox;
    grbResultado: TGroupBox;
    lblDataInicio: TLabel;
    lblCodigoDaVenda: TLabel;
    edtCodigo: TEdit;
    btnFiltrar: TBitBtn;
    mskDataInicio: TMaskEdit;
    lblDataFim: TLabel;
    mskDataFim: TMaskEdit;
    lblAte: TLabel;
    dbgPesquisaVenda: TDBGrid;
    dtsVendaPesq: TDataSource;
    cdsVendaPesq: TClientDataSet;
    cdsVendaPesqCodigoVenda: TIntegerField;
    cdsVendaPesqNomeCliente: TStringField;
    cdsVendaPesqTotalVenda: TFloatField;
    cdsVendaPesqDataVenda: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsVendaPesqBeforeDelete(DataSet: TDataSet);
    procedure dbgPesquisaVendaDblClick(Sender: TObject);
    procedure dbgPesquisaVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cdsVendaPesqAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    vKey : Word;

    procedure LimpaTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;

  public
    { Public declarations }
    mVendaID : Integer;
    mNomeCliente : string;
  end;

var
  frmVendaPesqView: TfrmVendaPesqView;

implementation

{$R *.dfm}

{ TfrmVendaPesqView }

procedure TfrmVendaPesqView.LimpaTela;
var
   xI : Integer;
begin
   for xI := 0 to pred(ComponentCount) do
   begin
      if (Components[xI] is TEdit) then
         (Components[xI] as TEdit).Text := EmptyStr;

       if (Components[xI] is TMaskEdit) then
        (Components[xI] as TMaskEdit).Text := EmptyStr;
   end;

   if (not cdsVendaPesq.IsEmpty) then
      cdsVendaPesq.EmptyDataSet;

   if (mskDataInicio.CanFocus) then
      (mskDataInicio.SetFocus);
end;

procedure TfrmVendaPesqView.FormKeyDown(Sender: TObject; var Key: Word;
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

         if (ActiveControl = dbgPesquisaVenda) then
            exit;

          Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;

procedure TfrmVendaPesqView.ProcessaPesquisa;
var
   xListaVenda : TColVenda;
   xID_Venda   : Integer;
   xAux        : Integer;
begin
   try
      try
         xID_Venda := 0;
         xListaVenda := TColVenda.Create;

         if (edtCodigo.Text <> EmptyStr) then
            xID_Venda := StrToInt(edtCodigo.Text);

         if (TFuncoes.SoNumero(mskDataInicio.Text) = EmptyStr) or
            ( Length(TFuncoes.SoNumero(mskDataInicio.Text)) <> 8 )  then
            mskDataInicio.Text := '01/01/1999';

         if (TFuncoes.SoNumero(mskDataFim.Text) = EmptyStr) or
            ( Length(TFuncoes.SoNumero(mskDataFim.Text)) <> 8 ) then
            mskDataFim.Text := '01/01/2999';

             xListaVenda :=
               TVendaController.getInstancia.PesquisaVenda(xId_Venda, mskDataInicio.Text, mskDataFim.Text);

         cdsVendaPesq.EmptyDataSet;

         if xListaVenda <> nil then
         begin
            for xAux := 0 to pred(xListaVenda.Count) do
            begin
               if xListaVenda.Retorna(xAux).ID <> 0 then
               begin
                  cdsVendaPesq.Append;
                  cdsVendaPesqCodigoVenda.Value := xListaVenda.Retorna(xAux).ID;
                  cdsVendaPesqNomeCliente.Value := xListaVenda.Retorna(xAux).NomeCliente;
                  cdsVendaPesqDataVenda.Text :=
                     FormatDateTime('dd/mm/yyyy',xListaVenda.Retorna(xAux).DataVenda);
                  cdsVendaPesqTotalVenda.Value := xListaVenda.Retorna(xAux).TotalVenda;
                  cdsVendaPesq.Post;
               end;
            end;
         end;

         if (cdsVendaPesq.RecordCount = 0) then
         begin
            if mskDataInicio.CanFocus then
               mskDataInicio.SetFocus;

            TMessageUtil.Alerta(
               'Nenhuma venda encontrada para este filtro.');
         end
         else
         begin
            cdsVendaPesq.First;

            if dbgPesquisaVenda.CanFocus then
               dbgPesquisaVenda.SetFocus;
         end;

      finally
         if (xListaVenda <> nil) then
            FreeAndNil(xListaVenda);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar dados da venda '#13 +
            e.Message);
      end;
   end;
end;

procedure TfrmVendaPesqView.ProcessaConfirmacao;
begin
   if not cdsVendaPesq.IsEmpty then
   begin
      mVendaID       := cdsVendaPesqCodigoVenda.Value;
      mNomeCliente     := cdsVendaPesqNomeCliente.Value;
      Self.ModalResult := mrOk;
      LimpaTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma venda selecionado.');
      if mskDataInicio.CanFocus then
         mskDataInicio.SetFocus;
   end;
end;

procedure TfrmVendaPesqView.btnFiltrarClick(Sender: TObject);
begin
   mVendaID := 0;
   mNomeCliente := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmVendaPesqView.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendaPesqView.btnLimparClick(Sender: TObject);
begin
   mVendaID := 0;
   mNomeCliente := EmptyStr;
   LimpaTela;
end;

procedure TfrmVendaPesqView.btnSairClick(Sender: TObject);
begin
   LimpaTela;
   Close;
end;

procedure TfrmVendaPesqView.cdsVendaPesqBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmVendaPesqView.dbgPesquisaVendaDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendaPesqView.dbgPesquisaVendaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;
end;

procedure TfrmVendaPesqView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   //frmVendaPesqView := nil;
   LimpaTela;
end;

procedure TfrmVendaPesqView.FormShow(Sender: TObject);
begin
   if (edtCodigo.CanFocus) then
      edtCodigo.SetFocus;
end;

procedure TfrmVendaPesqView.cdsVendaPesqAfterOpen(DataSet: TDataSet);
begin
   (dbgPesquisaVenda.DataSource.DataSet.FieldByName('TotalVenda') as TFloatField).DisplayFormat := 'R$ ##,##0.00';
end;

end.
