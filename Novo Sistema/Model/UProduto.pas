unit UProduto;

interface

uses SysUtils, Classes;

type
   TProduto = class(TPersistent)

      private
         vID                  : Integer;
         vDescricao           : String;
         vQuantidadeEstoque   : Double;
         vPrecoVenda          : Double;

      public
         constructor Create;

      published
         property ID                : Integer read vID write vID;
         property Descricao         : String  read vDescricao write vDescricao;
         property QuantidadeEstoque : Double read vQuantidadeEstoque write vQuantidadeEstoque;
         property PrecoVenda        : Double read vPrecoVenda write vPrecoVenda;
   end;

   TColProduto = class(TList) //forma de manipular uma coleção de objetos da classe TPessoa
     public
       function Retorna(pIndex : Integer) : TProduto;
       procedure Adiciona(pProduto : TProduto);
  end;

implementation

{ TProduto }

constructor TProduto.Create;
begin
   Self.vID                := 0;
   Self.vDescricao         := EmptyStr;
   Self.vQuantidadeEstoque := 0;
   Self.vPrecoVenda        := 0;
end;

{ TColPessoa }

procedure TColProduto.Adiciona(pProduto: TProduto);
begin
   Self.Add(TProduto(pProduto));
end;

function TColProduto.Retorna(pIndex: Integer): TProduto;
begin
   Result := TProduto(Self[pIndex]);
end;

end.
