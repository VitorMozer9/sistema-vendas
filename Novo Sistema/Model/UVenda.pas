unit UVenda;

interface

uses SysUtils, Classes;

type
   TVenda = class(TPersistent)

      private
         vID             : Integer;
         vID_Cliente     : Integer;
         vDataVenda      : TDateTime;
         vFaturada       : Integer;
         vTotalAcrescimo : Double;
         vTotalDesconto  : Double;
         vTotalVenda     : Double;

      public
         constructor Create;

      published
         property ID             : Integer read vID write vID;
         property ID_Cliente     : Integer read vID_Cliente write vID_Cliente;
         property DataVenda      : TDateTime read vDataVenda write vDataVenda;
         property Faturada       : Integer read vFaturada write vFaturada;
         property TotalAcrescimo : Double read vTotalAcrescimo write vTotalAcrescimo;
         property TotalDesconto  : Double read vTotalDesconto write vTotalDesconto;
         property TotalVenda     : Double read vTotalVenda write vTotalVenda;

   end;

   TColVenda = class(TList)
      public
       function Retorna(pIndex : Integer) : TVenda;
       procedure Adiciona(pVenda : TVenda);
   end;

implementation

{ TColVenda }

procedure TColVenda.Adiciona(pVenda: TVenda);
begin
   Self.Add(TVenda(pProduto));
end;

function TColVenda.Retorna(pIndex: Integer): TVenda;
begin
   Result := TVenda(Self[pIndex]);
end;

{ TVenda }

constructor TVenda.Create;
begin
   Self.vID              := 0;
   Self.vID_Cliente      := 0;
   Self.vDataVenda       := 0;
   Self.vFaturada        := 0;
   Self.vTotalAcrescimo  := 0;
   Self.vTotalDesconto   := 0;
   Self.vTotalVenda      := 0;
end;
end.
