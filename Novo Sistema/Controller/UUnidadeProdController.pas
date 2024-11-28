unit UUnidadeProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProduto, SqlExpr;

type
   TUnidadeProdController = class
      public
         constructor create;
         function GravaUnidadeProduto (
                     pUnidadeProduto : TUnidadeProduto; pInclusao : Boolean) : Boolean;

         function ExcluiUnidade (pUnidadeProd : TUnidadeProduto) : Boolean;

         function BuscaUnidade(pUnidade : string) : TUnidadeProduto;
         function PesquisaUnidade(pUnidade : String) : TColUnidadeProd;
         function RetornaCondicaoUnidade(pUnidade : String ) : String;
         //function RetornaProdutoUnidade(pCodProduto : Integer) : TUnidadeProduto;

      published
         class function getInstancia : TUnidadeProdController;  

   end;

implementation

uses UUnidadeProdDAO, UClassFuncoes;

var
   _instance : TUnidadeProdController;

{ TUnidadeProdController }

function TUnidadeProdController.BuscaUnidade(
  pUnidade: String): TUnidadeProduto;
var
   xUnidadeDAO : TUnidadeProdutoDAO;
begin
   try
      try
         Result := nil;

         xUnidadeDAO := TUnidadeProdutoDAO.Create(TConexao.getInstance.getConn);

         Result := xUnidadeDAO.Retorna(RetornaCondicaoUnidade(pUnidade));

      finally
         if (xUnidadeDAO <> nil) then
            FreeAndNil(xUnidadeDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao retornar dados da Unidade de Produto. [Controller]'#13 +
         e.Message);
      end;
   end;  
end;

constructor TUnidadeProdController.create;
begin
   inherited create;
end;

function TUnidadeProdController.ExcluiUnidade(
  pUnidadeProd: TUnidadeProduto): Boolean;
var
   xUnidadeDAO : TUnidadeProdutoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xUnidadeDAO := TUnidadeProdutoDAO.Create(TConexao.get.getConn);

         if (pUnidadeProd.Unidade = EmptyStr) then
            exit
         else
         begin
            xUnidadeDAO.Deleta(RetornaCondicaoUnidade(pUnidadeProd.Unidade));
         end;

         TConexao.get.confirmaTransacao;

         Result := True;
      finally
         if (xUnidadeDAO <> nil) then
            FreeAndNil(xUnidadeDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         raise Exception.Create(
            'Falha ao excluir dados de unidade de produto. [Controller]'+ #13 +
            e.Message);
      end;
   end;
end;

class function TUnidadeProdController.getInstancia: TUnidadeProdController;
begin
   if _instance = nil then
      _instance := TUnidadeProdController.Create;

   Result := _instance;
end;

function TUnidadeProdController.GravaUnidadeProduto(
  pUnidadeProduto: TUnidadeProduto; pInclusao : Boolean): Boolean;
var
   xUnidadeProdDAO : TUnidadeProdutoDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xUnidadeProdDAO := nil;

         xUnidadeProdDAO := TUnidadeProdutoDAO.Create(TConexao.get.getConn);

         if pInclusao then
            xUnidadeProdDAO.Insere(pUnidadeProduto)
         else
            xUnidadeProdDAO.Atualiza(
               pUnidadeProduto,RetornaCondicaoUnidade(pUnidadeProduto.Unidade));

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

function TUnidadeProdController.PesquisaUnidade(
  pUnidade: String): TColUnidadeProd;
var
   xUnidadeDAO : TUnidadeProdutoDAO;
   xCondicao : string;
begin
   try
      try
         Result := nil;

         xUnidadeDAO :=
            TUnidadeProdutoDAO.Create(TConexao.getInstance.getConn);

         xCondicao :=
            IfThen(pUnidade <> EmptyStr,
            'WHERE                                            '#13 +
            '    (UNIDADE LIKE UPPER(''%' + pUnidade + '%'' ))'#13 +
               'ORDER BY UNIDADE, DESCRICAO ', EmptyStr);

         Result := xUnidadeDAO.RetornaLista(xCondicao);

      finally
       if (xUnidadeDAO <> nil) then
         FreeAndNil(xUnidadeDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao buscar os dados da Unidade de Produto [Controller]'#13 +
            e.Message);
      end;
   end;        
end;

function TUnidadeProdController.RetornaCondicaoUnidade(
  pUnidade : String): String;
var
   xChave : string;
begin
   xChave := 'UNIDADE';

   Result :=
   'WHERE                                             '#13+
   '    '+xChave+ ' = ' + QuotedStr(pUnidade)+ ' '#13;
end;

end.
