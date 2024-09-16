unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa;

type
  TPessoaController = class
     public
       constructor Create;
       function GravaPessoa(
                   pPessoa : TPessoa) : Boolean;


  end;

implementation

{ TPessoaController }

constructor TPessoaController.Create;
begin
   inherited Create;
end;

function TPessoaController.GravaPessoa(pPessoa: TPessoa): Boolean;
var
  xPessoaDAO : TPessoaDAO;
  xAux : Integer;
begin
   try
     try
        TConexao.get.iniciaTransacao;

        Result := False;

        xPessoaDAO :=
           TPessoaDAO.Create(TConexao.get.getConn);

     finally

     end;   
   except

   end;  
end;

end.
 