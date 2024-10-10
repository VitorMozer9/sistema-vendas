unit UUnidadeProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProduto;

type
   TUnidadeProdController = class
      public
         constructor create;
         function GravaUnidadeProduto (
                     pUnidadeProduto : TUnidadeProduto) : Boolean;

         function RetornaCondicaoUnidade(pID : Integer ) : String;

      published
         class function getInstancia : TUnidadeProdController;  

   end;

implementation

uses UUnidadeProdDAO, UClassFuncoes;

{ TUnidadeProdController }

constructor TUnidadeProdController.create;
begin
   inherited create;
end;

class function TUnidadeProdController.getInstancia: TUnidadeProdController;
begin
   if _instance = nil then
      _instance := TUnidadeProdController.Create;

   Result := _instance;
end;

function TUnidadeProdController.GravaUnidadeProduto(
  pUnidadeProduto: TUnidadeProduto): Boolean;
var
   xUnidadeProdDAO : TUnidadeProdutoDAO;

begin
try
   try
      TConexao.get.iniciaTransacao;

      Result := False;

      xUnidadeProdDAO := nil;

      xUnidadeProdDAO :=
         TUnidadeProdutoDAO.Create(TConexao.get.getConn);

      if pUnidadeProduto.Id = 0 then
      begin
         xUnidadeProdDAO.Insere(pUnidadeProduto);
      end
      else
      begin
         xUnidadeProdDAO.Atualiza(
            pUnidadeProduto,RetornaCondicaoUnidade(pUnidadeProduto.Id));
      end;

      TConexao.get.confirmaTransacao;
   finally
      if xUnidadeProdDAO <> nil then
         FreeAndNil(xUnidadeProdDAO);
   end;
except
   on E : Exception do
   begin
      TConexao.get.cancelaTransacao;
      Raise Exception.Create(
         'Falha ao gravar dados de unidade de produto. [Controller]'#13 +
         e.Message);
   end;
end;  
end;

function TUnidadeProdController.RetornaCondicaoUnidade(
  pID: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE                                             '#13+
   '    '+xChave+ ' = ' + QuotedStr(IntToStr(pID))+ ' '#13;
end;

end.
 