unit UEndereco;

interface

uses SysUtils, Classes;

type
   TEndereco = Class(TPersistent)
      private
         vID            : Integer;
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
         property ID                 : Integer read vID            write vID;
         property Tipo_Endereco      : Integer read vTipo_Endereco write vTipo_Endereco;
         property Endereco           : String  read vEndereco      write vEndereco;
         property Numero             : String  read vNumero        write vNumero;
         property Complemento        : String  read vComplemento   write vComplemento;
         property Bairro             : String  read vBairro        write vBairro;
         property UF                 : String  read vUF            write vUF;
         property Cidade             : String  read vCidade        write vCidade;

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
   self.vID               := 0;
   self.vID_Pessoa        := 0;
   self.vTipo_Endereco    := 0;
   self.vEndereco         := EmptyStr;
   self.vNumero           := EmptyStr;
   self.vComplemento      := EmptyStr;
   self.vBairro           := EmptyStr;
   self.vUF               := EmptyStr;
   self.vCidade           := EmptyStr;

end;

{ TColEndereco }

procedure TColEndereco.Adiciona(pEndereco: TEndereco);
begin
   Self.Add(TEndereco(pEndereco));
end;

function TColEndereco.Retorna(pIndex: Integer): TEndereco;
begin
   Result := TEndereco(Self[pIndex]);
end;

end.
 
