unit UUnidadeProdDAO;

interface

uses SysUtils, UGenericDAO, UUnidadeProduto,SqlExpr;

type
   TUnidadeProdutoDAO = class(TGenericDAO)
      public
       constructor Create(pConexao : TSQLConnection);
       function Insere(pUnidadeProduto : TUnidadeProduto) : Boolean;
       function Atualiza(pUnidadeProduto : TUnidadeProduto;
                     pCondicao : String) : Boolean;

       function Retorna(pCondicao : String) : TUnidadeProduto;
       function RetornaLista(pCondicao : String = '') : TColUnidadeProd;

end;

implementation

{ TUnidadeProdutoDAO }

function TUnidadeProdutoDAO.Atualiza(pUnidadeProduto: TUnidadeProduto;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pUnidadeProduto, pCondicao);
end;

constructor TUnidadeProdutoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'UNIDADEPRODUTO';
   vConexao  := pConexao;
   vClass    := TUnidadeProduto;

end;

function TUnidadeProdutoDAO.Insere(
  pUnidadeProduto: TUnidadeProduto): Boolean;
begin
   Result := inherited Insere(pUnidadeProduto, 'ID');
end;

function TUnidadeProdutoDAO.Retorna(pCondicao: String): TUnidadeProduto;
begin
   Result := TUnidadeProduto(inherited Retorna(pCondicao));
end;

function TUnidadeProdutoDAO.RetornaLista(
  pCondicao: String): TColUnidadeProd;
begin
   Result := TColUnidadeProd(inherited RetornaLista(pCondicao));
end;

end.
