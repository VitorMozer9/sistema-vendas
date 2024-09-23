unit UPessoa;

interface

uses SysUtils, Classes;

type
  TPessoa = class(TPersistent)

     private
       vId                  : Integer;
       vTipo_Pessoa         : Integer;
       vNome                : String;
       vFisica_Juridica     : Integer;
       vIdentificadorPessoa : String;  //numero de CPF, CNPJ , PASSAPORTE
       vAtivo               : Boolean;

     public
       constructor Create;

       //classe de leitura, não será debugada, usa para criar os objetos

     published
       property Id                  : Integer read vId write vId;
       property Tipo_Pessoa         : Integer read vTipo_Pessoa write vTipo_Pessoa;
       property Nome                : String  read vNome write vNome;
       property Fisica_Juridica     : Integer read vFisica_Juridica write vFisica_Juridica;
       property IdentificadorPessoa : String  read vIdentificadorPessoa write vIdentificadorPessoa;
       property Ativo               : Boolean read vAtivo write vAtivo;


  end;

  TColPessoa = class(TList) //forma de manipular uma coleção de objetos da classe TPessoa
     public
        //Retorna um objeto da Calsse TPessoa (ID, nome, tipo_pessoa, etc)
       function Retorna(pIndex : Integer) : TPessoa;
       //Adiciona um obj TPessoa a lista (Coleção de pessoas que quermos os dados)
       procedure Adiciona(pPessoa : TPessoa);

  end;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin

  Self.vId                  := 0;
  Self.vTipo_Pessoa         := 0;
  Self.vNome                := EmptyStr;
  Self.vFisica_Juridica     := 0;
  Self.vIdentificadorPessoa := EmptyStr; // é tipo a inicialização 0 dos inteiros
  Self.vAtivo               := False;

end;

{ TColPessoa }

procedure TColPessoa.Adiciona(pPessoa: TPessoa);
begin
   Self.Add(TPessoa(pPessoa));
end;

function TColPessoa.Retorna(pIndex: Integer): TPessoa;
begin
   Result := TPessoa(Self[pIndex]);
end;

end.
