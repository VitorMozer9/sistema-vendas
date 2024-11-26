unit UVendaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVenda, SqlExpr,UClassFuncoes;

type
   TVendaController = class
      public
         constructor Create;
         function GravaVenda(pVenda : TVenda) : Boolean;
         function BuscaVenda(pID : Integer) : TVenda;
         function RetornaCondicaoVenda(pId : Integer) : String;
         function PesquisaVenda(pCodigoVenda : Integer;
            pDataInicio : String; pDataFim : String) : TColVenda;

      published
         class function getInstancia : TVendaController;


   end;

implementation

uses UVendaDAO;

var
   _instance : TVendaController;

{ TVendaController }

function TVendaController.BuscaVenda(pID: Integer): TVenda;
var
   xVendaDAO : TVendaDAO;
begin
   try
      try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.getInstance.getConn);

         Result := xVendaDAO.Retorna(RetornaCondicaoVenda(pID));

      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao buscar dados da venda[Controller]: '#13 +
            e.Message);
      end;
   end;
end;

constructor TVendaController.Create;
begin
   inherited Create;
end;

class function TVendaController.getInstancia: TVendaController;
begin
   if _instance = nil then
      _instance := TVendaController.Create;

   Result := _instance;
end;

function TVendaController.GravaVenda(pVenda: TVenda): Boolean;
var
   xVendaDAO : TVendaDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaDAO := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         if (pVenda.ID = 0) then
            xVendaDAO.Insere(pVenda);

         TConexao.get.confirmaTransacao;
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
       on E: Exception do
       begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar dados da venda. [Controller]'+ #13 +
            e.Message);
       end;
   end;
end;
function TVendaController.PesquisaVenda(pCodigoVenda: Integer;
  pDataInicio : String ; pDataFim: String): TColVenda;
var
   xVendaDAO : TVendaDAO;
   xListaVenda : TColVenda;
   xCondicao : string;
begin
   try
      try
         Result := nil;

         xListaVenda := nil;
         xListaVenda := TColVenda.Create;

         xVendaDAO := TVendaDAO.Create(TConexao.getInstance.getConn);

         xListaVenda :=
            xVendaDAO.RetornaColVenda(pDataInicio, pDataFim, pCodigoVenda);

         Result := xListaVenda;
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);

         if (xListaVenda <> nil) then
            FreeAndNil(xListaVenda);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar dados da venda. [Controller]'#13 +
            e.Message);
      end;
   end;
end;

function TVendaController.RetornaCondicaoVenda(pId: Integer): String;
var
   xChave : string;
begin
    xChave := 'ID';

   Result :=
   'WHERE                                             '#13+
   '    '+xChave+ ' = ' + QuotedStr(IntToStr(pId))+ ' '#13;
end;

end.
