unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls;

type
  TfrmProdutoView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutoView: TfrmProdutoView;

implementation

{$R *.dfm}

end.
