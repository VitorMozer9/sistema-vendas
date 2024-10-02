unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa, UEndereco;

type
  TPessoaController = class
     public
       constructor Create;
       function GravaPessoa(
                   pPessoa : TPessoa;
                   pColEndereco : TColEndereco) : Boolean;

       function ExcluiPessoa(pPessoa : TPessoa) : Boolean;

       function BuscaPessoa(pID : Integer) : TPessoa;
       function BuscaEnderecoPessoa(pID_Pessoa : Integer) : TColEndereco;

       function ValidaCPF(pCPF : String) : Boolean;
       function ValidaCNPJ(pCNPJ : String) : Boolean;

       function RetornaCondicaoPessoa(
                   pID_Pessoa : Integer;
                   pRelacionada : Boolean = False ) : String;



     published
        class function getInstancia : TPessoaController;
  end;

implementation

uses UPessoaDAO, UEnderecoDAO, UClassFuncoes;

var
  _instance : TPessoaController;

{ TPessoaController }

function TPessoaController.BuscaEnderecoPessoa(
  pID_Pessoa: Integer): TColEndereco;
var
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := nil;

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.getInstance.getConn);

            Result :=
            xEnderecoDAO.RetornaLista(RetornaCondicaoPessoa(pID_Pessoa, True));

      finally
         if (xEnderecoDAO <> nil) then
            FreeAndNil(xEnderecoDAO);
      end;

   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao retornar dados de endereço da pessoa. [Controller]'#13 +
         e.Message);
      end;
   end;
end;

function TPessoaController.BuscaPessoa(pID: Integer): TPessoa;
var
   xPessoaDAO : TPessoaDAO; //objeto temporario
begin
   try
      try
         Result := nil; //o Create cria uma nova instancia criando uma conexão com o banco de dados

         xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
         Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
      end;
   except
      on E: Exception do //O Raise serve para gerar exceções de erro explicitas
      begin
         raise Exception.Create(
            'Falha ao buscar dados da pessoa. [Controller] '#13 +
            e.Message);
      end;
   end;
end;

constructor TPessoaController.Create;
begin
   inherited Create;
end;

function TPessoaController.ExcluiPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO := TEnderecoDAO.Create(TConexao.get.getConn);

          if (pPessoa.Id = 0) then
          Exit
          else
          begin
            xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));

            // ,True estamos usando a tabela relacionada e ela precisa de um resultado true pra executar (Boolean)
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));

          end;

          TConexao.get.confirmaTransacao;

         Result := True;
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);

         if (xEnderecoDAO <> nil) then
            FreeAndNil(xEnderecoDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao excluir os dados da pessoa. [Controller]'#13+
            e.Message);
      end;
   end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance := TPessoaController.Create;

   Result := _instance;
end;

function TPessoaController.GravaPessoa(
pPessoa: TPessoa; pColEndereco : TColEndereco): Boolean;
var
  xPessoaDAO : TPessoaDAO;
  xEnderecoDAO : TEnderecoDAO;
  xAux : Integer;
begin
   try
     try
        TConexao.get.iniciaTransacao;

        Result := False;
        //no cod diferenciei o obj de nil, logo antes instancio ela como nil
        xPessoaDAO := nil;


        xPessoaDAO :=    // aq estou passando a conexao do banco que estava na UpessoaDao para o objeto xPessoaDAO
           TPessoaDAO.Create(TConexao.get.getConn);

        xEnderecoDAO :=
         TEnderecoDAO.Create(TConexao.get.getConn);

        if pPessoa.Id = 0 then
        begin
           xPessoaDAO.Insere(pPessoa);

           for xAux := 0 to pred(pColEndereco.Count) do
              pColEndereco.Retorna(xAux).ID_Pessoa := pPessoa.Id; //amarra entre as tabelas

           xEnderecoDAO.InsereLista(pColEndereco);

        end
        else
        begin
           xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));

           xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
           xEnderecoDAO.InsereLista(pColEndereco);
        end;

        TConexao.get.confirmaTransacao;

     finally
        if (xPessoaDAO <> nil) then
           FreeAndNil(xPessoaDAO);
     end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar os dados da pessoa [Controller]. '#13+
            e.Message);
      end;

   end;
end;

function TPessoaController.RetornaCondicaoPessoa(
  pID_Pessoa: Integer; pRelacionada : Boolean): String;
var
  xChave : String;
begin
   if (pRelacionada) then
      xChave := 'ID_Pessoa'
   else
      xChave := 'ID';


   Result :=
   'WHERE                                                '#13+
   '   '+ xChave+ ' = '+ QuotedStr(IntToStr(pID_Pessoa))+' '#13; //função Quoted para substituir as aspas duplas / quadruplas

end;

function TPessoaController.ValidaCNPJ(pCNPJ: String): Boolean;
var
   xPrimeiroDigito : Integer;
   xSegundoDigito : Integer;
   xRestoDivisao  : Integer;
   xSoma          : Integer;
   I              : Integer;
   xDecremento    : Integer;
begin
   Result := False;
   xPrimeiroDigito := 0;
   xSegundoDigito  := 0;
   xRestoDivisao   := 0;
   xSoma           := 0;
   I               := 0;
   xDecremento     := 0;


   if Length(pCNPJ) <> 14 then
      exit;

   if (pCNPJ = '00000000000000') or (pCNPJ = '11111111111111') or
      (pCNPJ = '22222222222222') or (pCNPJ = '33333333333333') or
      (pCNPJ = '44444444444444') or (pCNPJ = '55555555555555') or
      (pCNPJ = '66666666666666') or (pCNPJ = '77777777777777') or
      (pCNPJ = '88888888888888') or (pCNPJ = '99999999999999') then
      exit;

   xDecremento := 10;

   for I := 5 to 12 do
   begin
      xDecremento := xDecremento -1;
      xSoma := xSoma + StrToInt(pCNPJ[I]) * (xDecremento);
   end;

   I := 0;
   xDecremento := 6;
   for I := 1 to 4 do
   begin
      xDecremento :=  xDecremento - 1;
      xSoma := xSoma + StrToInt(pCNPJ[I]) * (xDecremento);
   end;

   xRestoDivisao := 11 - (xSoma mod 11);

   if xRestoDivisao >= 10 then
      xPrimeiroDigito := 0
   else
      xPrimeiroDigito := xRestoDivisao;

   if xPrimeiroDigito <> StrToInt(pCNPJ[13]) then
   exit;

   xDecremento := 0;
   I           := 0;
   xSoma       := 0;

   xDecremento := 10;

   for I := 6 to 13 do
   begin
      xDecremento := xDecremento - 1;
      xSoma := xSoma + StrToInt(pCNPJ[I]) * (xDecremento);
   end;

   I             := 0;
   xDecremento   := 0;
   xRestoDivisao := 0;

   xDecremento   := 7;

   for I := 1 to 5 do
   begin
      xDecremento := xDecremento - 1;
      xSoma := xSoma + StrToInt(pCNPJ[I]) * (xDecremento);
      //xSoma := xSoma + (xPrimeiroDigito * 2);
   end;

   xRestoDivisao := 11 - (xSoma mod 11);

   if xRestoDivisao >= 10 then
      xSegundoDigito := 0
   else
      xSegundoDigito := xRestoDivisao;

   if xRestoDivisao <> StrToInt(pCnpj[14]) then
      exit;

    Result := true;
end;

function TPessoaController.ValidaCPF(pCPF: String): Boolean;
var
   xAux            : Integer;
   xPrimeiroDigito : Integer;
   xSegundoDigito  : Integer;
   xRestoDivisao   : Integer;
   xSoma           : Integer;
begin
   Result := False;
   xAux            := 0;
   xPrimeiroDigito := 0;
   xSegundoDigito  := 0;
   xRestoDivisao   := 0;
   xSoma           := 0;

   if (Length(pCPF) <> 11) then
      exit;

   if (pCPF = '00000000000') or (pCPF = '11111111111') or
      (pCPF = '22222222222') or (pCPF = '33333333333') or
      (pCPF = '44444444444') or (pCPF = '55555555555') or
      (pCPF = '66666666666') or (pCPF = '77777777777') or
      (pCPF = '88888888888') or (pCPF = '99999999999') then
      exit;

   for xAux := 1 to 9 do
      xSoma := xSoma + StrToInt(pCPF[xAux]) * (11 - xAux);

   xRestoDivisao := 11 - (xSoma mod 11);

   if (xRestoDivisao >= 10) then
      xPrimeiroDigito := 0
   else
      xPrimeiroDigito := xRestoDivisao;

   if xPrimeiroDigito <> StrToInt(pCPF[10]) then
      exit;

   xSoma := 0;

   for xAux := 1 to 10 do
      xSoma := xSoma + StrToInt(pCPF[xAux]) * (12 - xAux);

   xRestoDivisao := 0;
   xRestoDivisao := 11 - (xSoma mod 11);

   if (xRestoDivisao >= 10) then
      xSegundoDigito := 0
   else
      xSegundoDigito := xRestoDivisao;

   if xSegundoDigito <> StrToInt(pCPF[11]) then
      exit;

   Result := True;
end;

end.
