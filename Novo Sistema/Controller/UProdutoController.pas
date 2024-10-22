unit UProdutoController;

interface

uses SysUtils, Math, StrUtils, UConexao, UProduto;

type
   TProdutoController = class
      public
         constructor Create;
         function GravaProduto (pProduto : TProduto) : Boolean;
         function BuscaProduto(pID : Integer) : TProduto;
         function RetornaCondicaoProduto(pID : Integer) : string;

      published
         class function getInstancia : TProdutoController;
   end;

implementation

uses UProdutoDAO;

var _instance : TProdutoController;

{ TProdutoController }

function TProdutoController.BuscaProduto(pID: Integer): TProduto;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         Result := nil;

         xProdutoDAO := TProdutoDAO.Create(TConexao.getInstance.getConn);

         Result := xProdutoDAO.Retorna(RetornaCondicaoProduto(pID));

      finally
         if (xProdutoDAO <> nil) then
            FreeAndNil(xProdutoDAO);
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

constructor TProdutoController.Create;
begin
   inherited Create;
end;

class function TProdutoController.getInstancia: TProdutoController;
begin
   if _instance = nil then
      _instance := TProdutoController.Create;

   Result := _instance;
end;

function TProdutoController.GravaProduto(pProduto: TProduto): Boolean;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);
//         pProduto.ID := 2;

         if pProduto.ID = 0 then
         begin
            xProdutoDAO.Insere(pProduto);
         end
         else
         begin
            xProdutoDAO.Atualiza(pProduto, RetornaCondicaoProduto(pProduto.ID));
         end;

         TConexao.get.confirmaTransacao;

      finally
         if (xProdutoDAO <> nil) then
            FreeAndNil(xProdutoDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.cancelaTransacao;

         raise Exception.Create(
            'Falha ao gravar dados de produto [Controller]: '#13 +
            e.Message);
      end;
   end;  
end;

function TProdutoController.RetornaCondicaoProduto(pID: Integer): string;
var
   xChave : string;
begin
   xChave := 'ID';

   Result :=
   'WHERE                                             '#13+
   '    '+xChave+ ' = ' + QuotedStr(IntToStr(pID))+ ' '#13;
end;

end.
