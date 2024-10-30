unit UPrincipalView;   //nome da unit

interface

uses //units q serão utilizadas na classe
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, pngimage;

type
  TfmPrincipal = class(TForm)//nome da classe
  { componentes visuais
    lembre-se de renomear todos os componentes que forem adicionados
  }
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menVendas: TMenuItem;
    menMovimentos: TMenuItem;
    menRelVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    Image1: TImage;
    MenUniProduto: TMenuItem;
    menUsuario: TMenuItem;
    //Métodos criados ate o momento
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure MenUniProdutoClick(Sender: TObject);
    procedure menProdutosClick(Sender: TObject);
    procedure menUsuarioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrincipal: TfmPrincipal;    //variavel do formulario

implementation    //codigo fonte
  uses
     //exemplo de herança, chamou a "classe" Uconexoes
    UConexao, UClienteView, UUnidadeProdView, UProdutoView, UCadUsuaView;

{$R *.dfm}

procedure TfmPrincipal.menSairClick(Sender: TObject);
begin
  Close; //fecha o sistema
end;

procedure TfmPrincipal.FormShow(Sender: TObject);
begin
  stbBarraStatus.Panels[0].Text :=
      'Caminho BD: ' + TConexao.get.getCaminhoBanco;
end;

procedure TfmPrincipal.menClientesClick(Sender: TObject);
begin
  try       // try e finally são usados para executar um bloco
           //de codigos com segurança
     Screen.Cursor := crHourGlass; 

      if frmClientes  = nil then
         frmClientes := TfrmClientes.Create(Application);

      frmClientes.Show;  //mostra a tela de clientes
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

procedure TfmPrincipal.menUsuarioClick(Sender: TObject);
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
