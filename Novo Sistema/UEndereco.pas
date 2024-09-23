unit UEndereco;

interface

uses SysUtils, Classes;

type
   TEndereco = Class(TPersistent)
      private
         vId            : Integer;
         // tabela de relacionamento entre pessoa e endereco
         vID_Pessoa     : Integer;
         vTipo_Endereco : Integer;
         vEndereco      : String;
         vNumero        : String;
         vComplemento   : String;
         vBairro        : String;
         vUF            : String;
         vCidade        : String;

      public
         constructor Create; //inicializar objetos

      published
         property vId                 : Integer read vId            write vId;
         property vTipo_Endereco      : Integer read vTipo_Endereco write vTipo_Endereco;
         property vEndereco           : String  read vEndereco      write vEndereco;
         property vNumero             : String  read vNumero        write vNumero;
         property vComplemento        : String  read vComplemento   write vComplemento;
         property vBairro             : String  read vBairro        write vBairro;
         property vUF                 : String  read vUF            write vUF;
         property vCidade             : String  read vCidade        write vCidade;

   end;

   TColEndereco = Class(TList)
      public
         function Retorna(pIndex : Integer) : TEndereco;
         procedure Adiciona(pEndereco : TEndereco);

   end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
   self.vId               := 0;
   self.vID_Pessoa        := 0;
   self.vTipo_Endereco    := 0;
   self.vEndereco         := EmptyStr;
   self.vNumero           := EmptyStr;
   self.vComplemento      := EmptyStr;
   self.vBairro           := EmptyStr;
   self.vUF               := EmptyStr;
   self.vCidade           := EmptyStr;

end;

end.
 
