unit UPrincipalView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, pngimage;

type
  TfmPrincipal = class(TForm)
  { componentes visuais
    lembre-se de renomear todos os componentes que forem adicionados
  }
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menMovimentos: TMenuItem;
    menRelVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    Image1: TImage;
    MenUniProduto: TMenuItem;
    V1: TMenuItem;

    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure MenUniProdutoClick(Sender: TObject);
    procedure menProdutosClick(Sender: TObject);
    procedure menRelVendasClick(Sender: TObject);
    procedure V1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrincipal: TfmPrincipal;

implementation
  uses
    UConexao, UClienteView, UUnidadeProdView, UProdutoView, UCadUsuaView,
  UVendaView;

{$R *.dfm}

procedure TfmPrincipal.menSairClick(Sender: TObject);
begin
   Close;
end;

procedure TfmPrincipal.FormShow(Sender: TObject);
begin
   stbBarraStatus.Panels[0].Text :=
      'Caminho BD: ' + TConexao.get.getCaminhoBanco;
end;

procedure TfmPrincipal.menClientesClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmClientes  = nil then
         frmClientes := TfrmClientes.Create(Application);

      frmClientes.Show;
   finally
      Screen.Cursor := crDefault;
   end;

end;

procedure TfmPrincipal.MenUniProdutoClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmUnidadeProd  = nil then
         frmUnidadeProd := TfrmUnidadeProd.Create(Application);

      frmUnidadeProd.Show;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmPrincipal.menProdutosClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmProdutoView  = nil then
         frmProdutoView := TfrmProdutoView.Create(Application);

      frmProdutoView.Show;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmPrincipal.menRelVendasClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmVendasView  = nil then
         frmVendasView := TfrmVendasView.Create(Application);

      frmVendasView.Show;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmPrincipal.V1Click(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmCadUsua  = nil then
         frmCadUsua := TfrmCadUsua.Create(Application);

      frmCadUsua.Show;

   finally
      Screen.Cursor := crDefault;
   end;
end;

end.
