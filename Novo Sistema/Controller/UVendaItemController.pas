unit UVendaItemController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendaItem, SqlExpr,UClassFuncoes, UProduto,
   UProdutoController;

type
   TVendaItemController = class
      public
         constructor Create;
         //function BuscaProdutoVendaItem(pId : Integer) : TColProduto;
         //function RetornaCondicaoVendaProduto(pId : Integer) : String;

      published
         class function getInstancia : TVendaItemController;
   end;

implementation

uses UVendaItemDAO, UProdutoDAO;

var
   _instance : TVendaItemController;

{ TVendaItemController }

constructor TVendaItemController.Create;
begin
   inherited Create;
end;

class function TVendaItemController.getInstancia: TVendaItemController;
begin
   if _instance = nil then
      _instance := TVendaItemController.Create;

   Result := _instance;
end;

end.
