unit UProdutoController;

interface

uses SysUtils, Math, StrUtils, UConexao, UProduto;

type
   TProdutoController = class
      public
         constructor Create;
         function GravaProduto (pProduto : TProduto) : Boolean;
         function RetornaCondicaoProduto(pID : Integer) : string;

      published
         class function getInstancia : TProdutoController;
   end;

implementation

uses UProdutoDAO;

var _instance : TProdutoController;

{ TProdutoController }

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
   i           : Integer;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         if pProduto.ID = 0 then
         begin
            xProdutoDAO.Insere(pProduto);
         end
         else
         begin
            xProdutoDAO.Atualiza(pProduto, RetornaCondicaoProduto(pProduto.ID));
         end;


      finally
         if (xProdutoDAO <> nil) then
            FreeAndNil(xProdutoDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.cancelaTransacao;

         raise Exception.Create(
            'Falha ao gravar dados de produto. [Controller]: '#13 +
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
