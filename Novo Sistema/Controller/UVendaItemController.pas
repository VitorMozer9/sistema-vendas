unit UVendaItemController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendaItem, SqlExpr,UClassFuncoes, UProduto,
   UProdutoController, UVenda;

type
   TVendaItemController = class
      public
         constructor Create;
         function GravaVendaItem(pColVendaItem : TColVendaItem) : Boolean;

         function BuscaVendaItem(pID_Venda : Integer) : TColVendaItem;
         function RetornaCondicaoVendaItem(pID_Venda : Integer) : String;

      published
         class function getInstancia : TVendaItemController;
   end;

implementation

uses UVendaItemDAO, UProdutoDAO;

var
   _instance : TVendaItemController;

{ TVendaItemController }

function TVendaItemController.BuscaVendaItem(pID_Venda: Integer): TColVendaItem;
var
   xVendaItemDAO : TVendaItemDAO;
begin
   try
      try
         Result := nil;

         xVendaItemDAO := TVendaItemDAO.Create(TConexao.getInstance.getConn);

         Result := xVendaItemDAO.RetornaLista(RetornaCondicaoVendaItem(pID_Venda));

      finally
         if (xVendaItemDAO <> nil) then
            FreeAndNil(xVendaItemDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao buscar dados do produto[Controller]: '#13 +
            e.Message);
      end;
   end;
end;

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

function TVendaItemController.GravaVendaItem(pColVendaItem : TColVendaItem): Boolean;
var
   xVendaItemDAO : TVendaItemDAO;
   xAux          : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaItemDAO := nil;
         xVendaItemDAO := TVendaItemDAO.Create(TConexao.get.getConn);

         if (pColVendaItem.Retorna(0).ID = 0) then
            xVendaItemDAO.InsereLista(pColVendaItem);

         TConexao.get.confirmaTransacao;
      finally
         if (xVendaItemDAO <> nil) then
            FreeAndNil(xVendaItemDAO)
      end
   except
      on E: Exception do
       begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar dados do Item Venda. [Controller]'+ #13 +
            e.Message);
       end;
   end;
end;

function TVendaItemController.RetornaCondicaoVendaItem(
  pID_Venda: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID_VENDA';

   Result :=
   'WHERE                                                   '#13+
   '    '+xChave+ ' = ' + QuotedStr(IntToStr(pID_Venda))+ ' '#13;
end;

end.
