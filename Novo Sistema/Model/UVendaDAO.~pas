unit UVendaDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db , Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UVenda, UConexao;

type
   TVendaDAO = class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pVenda : TVenda) : Boolean;
         function InsereLista(pColVenda : TColVenda) : Boolean;
         function Atualiza(pVenda : TVenda; pCondicao : String) : Boolean;
         function Retorna(pCondicao : String) : TVenda;
         function RetornaLista(pCondicao : String = '') : TColVenda;
         function RetornaColVenda(pDataIni: String; pDataFim: String;
            pCodVenda: Integer): TColVenda;
   end;

implementation

{ TVendaDAO }

function TVendaDAO.Atualiza(pVenda: TVenda; pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pVenda, pCondicao);
end;

constructor TVendaDAO.Create(pConexao: TSQLConnection);
begin
   inherited  Create;
   vEntidade := 'VENDA';
   vConexao := pConexao;
   vClass := TVenda;
end;

function TVendaDAO.Insere(pVenda: TVenda): Boolean;
begin
   Result := inherited Insere(pVenda, 'ID');
end;

function TVendaDAO.InsereLista(pColVenda: TColVenda): Boolean;
begin
   Result := inherited InsereLista(pColVenda);
end;

function TVendaDAO.Retorna(pCondicao: String): TVenda;
begin
   Result := TVenda(inherited Retorna(pCondicao));
end;

function TVendaDAO.RetornaColVenda(pDataIni, pDataFim: String;
  pCodVenda: Integer): TColVenda;
var
   xQryColVenda: TSQLQuery;
   vConexao: TSQLConnection;
begin
   try
      try
         xQryColVenda := nil;
         xQryColVenda := TSQLQuery.Create(Nil);
         xQryColVenda.SQLConnection := TConexao.getConn.Create;
         xQryColVenda.Close;
         xQryColVenda.SQL.Clear;
         xQryColVenda.SQL.Text :=
            'SELECT * FROM VENDA                               '+
            ' WHERE (DATAVENDA BETWEEN :DATAINIC AND :DATAFIM )';

         if pCodVenda > 0 then
          xQryColVenda.SQL.Text := xQryColVenda.SQL.Text +
            '   AND (VENDA.ID = :CODVENDA)';

         pDataIni := '01/11/2024';
         pDataFim := '25/11/2024';
         pCodVenda := 1;        

         xQryColVenda.ParamByName('DATAINIC').AsDate := StrToDate(pDataIni);
         xQryColVenda.ParamByName('DATAFIM').AsDate := StrToDate(pDataFim);

         if pCodVenda > 0 then
            xQryColVenda.ParamByName('CODVENDA').AsInteger := pCodVenda;

         xQryColVenda.Open;

         if not xQryColVenda.IsEmpty then
         begin
            // popula seu obg de COL
            exit;
         end;
      except
         on E: Exception do
            raise Exception.Create('Falha ao buscar vendas no banco de dados.' +
               E.Message);
      end;
   finally
      if xQryColVenda <> nil then
      begin
         xQryColVenda.Close;
         FreeAndNil(xQryColVenda);
      end;
   end;
end;

function TVendaDAO.RetornaLista(pCondicao: String): TColVenda;
begin
   Result := TColVenda(inherited RetornaLista(pCondicao));
end;



end.
 