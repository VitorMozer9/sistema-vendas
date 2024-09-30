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

       function ValidaCPFCNPJ(pCPFCNPJ : String) : Boolean;

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

function TPessoaController.ValidaCPFCNPJ(pCPFCNPJ: String): Boolean;
var
   xAux            : Integer;
   xPrimeiroDigito : Integer;
   xSegundoDigito  : Integer;
   xRestoDivisao   : Integer;
   xSoma           : Integer;
   xValido         : Boolean;
begin
   Result := False;

   xAux            := 0;
   xPrimeiroDigito := 0;
   xSegundoDigito  := 0;
   xRestoDivisao   := 0;
   xSoma           := 0;
   xValido         := False;

   //TFuncoes.SoNumero(pCPFCNPJ);

   if (Length(pCPFCNPJ) <> 11) then
      exit;


   if (pCPFCNPJ = '00000000000') or (pCPFCNPJ = '11111111111') or
      (pCPFCNPJ = '22222222222') or (pCPFCNPJ = '33333333333') or
      (pCPFCNPJ = '44444444444') or (pCPFCNPJ = '55555555555') or
      (pCPFCNPJ = '66666666666') or (pCPFCNPJ = '77777777777') or
      (pCPFCNPJ = '88888888888') or (pCPFCNPJ = '99999999999') then
      exit;


   for xAux := 1 to 9 do
      xSoma := xSoma + StrToInt(pCPFCNPJ[xAux]) * (11 - xAux);

   xRestoDivisao := 11 - (xSoma mod 11);


   if (xRestoDivisao >= 10) then
      xPrimeiroDigito := 0
   else
      xPrimeiroDigito := xRestoDivisao;

   if xPrimeiroDigito <> StrToInt(pCPFCNPJ[10]) then
      exit;

   xSoma := 0;
   for xAux := 1 to 9 do
      xSoma := xSoma + StrToInt(pCPFCNPJ[xAux]) * (12 - xAux);
      xSoma := xSoma + (xPrimeiroDigito * 2);

   xRestoDivisao := 0;

   xRestoDivisao := 11 - (xSoma mod 11);
   if (xRestoDivisao >= 10) then
      xSegundoDigito := 0
   else
      xSegundoDigito := xRestoDivisao;

   if xSegundoDigito <> StrToInt(pCPFCNPJ[11]) then
   exit;

   Result := True;
end;

end.
