unit UVendaItem;

interface

uses SysUtils, Classes;

type
   TVendaItem = class(TPersistent)
      private
         vID             : Integer;
         vID_Venda       : Integer;
         vID_Produto     : Integer;
         vQuantidade     : Double;
         vUnidadeSaida   : String;
         vValorDesconto  : Double;
         vValorUnitario  : Double;
         vTotalItem      : Double;
         vDescricao_Produto : String;

   public
         constructor Create;

   published
         property ID             : Integer read vID write vID;
         property ID_Venda       : Integer read vID_Venda write vID_Venda;
         property ID_Produto     : Integer read vID_Produto write vID_Produto;
         property Quantidade     : Double read vQuantidade write vQuantidade;
         property UnidadeSaida   : String read vUnidadeSaida write vUnidadeSaida;
         property ValorDesconto  : Double read vValorDesconto write vValorDesconto;
         property ValorUnitario  : Double read vValorUnitario write vValorUnitario;
         property TotalItem      : Double read vTotalItem write vTotalItem;
         property Descricao_Produto : String read vDescricao_Produto write vDescricao_Produto;

   end;

   TColVendaItem = class(TList)
      public
       function Retorna(pIndex : Integer) : TVendaItem;
       procedure Adiciona(pVendaItem : TVendaItem);
   end;

implementation

{ TColVendaItem }

procedure TColVendaItem.Adiciona(pVendaItem: TVendaItem);
begin
   Self.Add(TVendaItem(pVendaItem));
end;

function TColVendaItem.Retorna(pIndex: Integer): TVendaItem;
begin
   Result := TVendaItem(Self[pIndex]);
end;

{ TVendaItem }

constructor TVendaItem.Create;
begin
   Self.ID             := 0;
   Self.ID_Venda       := 0;
   Self.ID_Produto     := 0;
   Self.Quantidade     := 0;
   Self.UnidadeSaida := EmptyStr;
   Self.ValorDesconto  := 0;
   Self.ValorUnitario  := 0;
   Self.TotalItem      := 0;
   Self.vDescricao_Produto := EmptyStr
end;

end.
