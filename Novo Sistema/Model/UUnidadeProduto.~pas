unit UUnidadeProduto;

interface

uses SysUtils, Classes;

type
   TUnidadeProduto = Class(TPersistent)

      private
         vId        : Integer;
         vAtivo     : Boolean;
         vUnidade   : String;
         vDescricao : String;

      public
         constructor create;

         procedure Adiciona(pUnidadeProd : TUnidadeProduto);

      published
       property Id        : Integer read vId write vId;
       property Ativo     : Boolean read vAtivo write vAtivo;
       property Unidade   : String  read vUnidade write vUnidade;
       property Descricao : String  read vDescricao write vDescricao;



   end;

   TColUnidadeProd = class(TList)
      public
         function Retorna(pIndex : Integer) : TUnidadeProduto;

   end;

implementation

{ TUnidadeProduto }

procedure TUnidadeProduto.Adiciona(pUnidadeProd: TUnidadeProduto);
begin
   Self.Adiciona(TUnidadeProduto(pUnidadeProd));
end;

constructor TUnidadeProduto.create;
begin
   Self.vId        := 0;
   Self.vAtivo     := False;
   Self.vUnidade   := EmptyStr;
   Self.vDescricao := EmptyStr;
end;


{ TColUnidadeProd }

function TColUnidadeProd.Retorna(pIndex: Integer): TUnidadeProduto;
begin
   Result := TUnidadeProduto(Self[pIndex]);
end;

end.


