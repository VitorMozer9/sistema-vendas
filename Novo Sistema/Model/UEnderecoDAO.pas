unit UEnderecoDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db , Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UEndereco;


type

  TEnderecoDAO = class(TGenericDAO)
     public
       constructor Create(pConexao : TSQLConnection);
       function Insere(pEndereco : TEndereco) : Boolean; //a variavel pPessoa terá todos os atributos da classe pessoa
       function InsereLista(pColEndereco : TColEndereco) : Boolean;
       function Atualiza(pEndereco : TEndereco; pCondicao : String) : Boolean;
       function Retorna(pCondicao : String) : TEndereco;
       function RetornaLista(pCondicao : String = '') : TColEndereco;

  end;

implementation

{ TEnderecoDAO }

function TEnderecoDAO.Atualiza(pEndereco: TEndereco;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pEndereco, pCondicao);
end;

constructor TEnderecoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;   // create da GenericDAO, assim consigo inicializar os objetos da generic dao
   vEntidade := 'ENDERECO';
   vConexao  := pConexao;
   vClass    := TEndereco;
end;

function TEnderecoDAO.Insere(pEndereco: TEndereco): Boolean;
begin
   {herdou o insere da genericDAO que na genericDAO recebe dois parametros,
   um objeto de TEndereco e uma string 'ID'}
   Result := inherited Insere(pEndereco, 'ID');
end;

function TEnderecoDAO.InsereLista(pColEndereco: TColEndereco): Boolean;
begin
   //herda da genericdao o inserelista que pede um objeto de TColEndereco
   Result := inherited InsereLista(pColEndereco);
end;

function TEnderecoDAO.Retorna(pCondicao: String): TEndereco;
begin
   //Aq ja rola o seguinte na classe TEndereco, ja existe um metodo retorna,então estamos referenciando ele na genericdao pelo inherited
   Result := TEndereco(inherited Retorna(pCondicao));  //exemplo de cast
end;

function TEnderecoDAO.RetornaLista(pCondicao: String): TColEndereco;
begin
    Result := TColEndereco(inherited RetornaLista(pCondicao));
end;

end.
