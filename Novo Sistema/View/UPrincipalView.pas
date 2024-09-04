unit UPrincipalView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TfmPrincipal = class(TForm)
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menVendas: TMenuItem;
    menMovimentos: TMenuItem;
    menRelVendas: TMenuItem;
    menSair: TMenuItem;
    procedure menSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrincipal: TfmPrincipal;

implementation

{$R *.dfm}

procedure TfmPrincipal.menSairClick(Sender: TObject);
begin
  Close; //fecha o sistema
end;

end.
