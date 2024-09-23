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

end.
 