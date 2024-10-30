unit UCadUsuaDAO;

interface

uses SysUtils, UGenericDAO, UUsuario,SqlExpr;

type
   TCadUsuaDAO = class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pUsuario    : TUsuario) : Boolean;
         function InsereLista(pColUsuario : TColUsuario) : Boolean;
         function Atualiza(pUsuario  : TUsuario;pCondicao : String) : Boolean;
         function Retorna(pCondicao  : String) : TUsuario;
         function RetornaLista(pCondicao : String = '') : TColUsuario;
   end;

implementation

{ TCadUsuaDAO }

function TCadUsuaDAO.Atualiza(pUsuario: TUsuario;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pUsuario, pCondicao);
end;

constructor TCadUsuaDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'CADUSUA';
   vConexao  := pConexao;
   vClass    := TUsuario;
end;

function TCadUsuaDAO.Insere(pUsuario: TUsuario): Boolean;
begin
   Result := inherited Insere(pUsuario, 'USUARIO');
end;

function TCadUsuaDAO.InsereLista(pColUsuario: TColUsuario): Boolean;
begin
    Result := inherited InsereLista(pColUsuario);
end;

function TCadUsuaDAO.Retorna(pCondicao: String): TUsuario;
begin
   Result := TUsuario(inherited Retorna(pCondicao));
end;

function TCadUsuaDAO.RetornaLista(pCondicao: String): TColUsuario;
begin
   Result := TColUsuario(inherited RetornaLista(pCondicao));
end;

end.
