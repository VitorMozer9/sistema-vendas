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

  TColPessoa = class(TList)
     public
       function Retorna(pIndex : Integer) : TPessoa;
       procedure

implementation

end.
 