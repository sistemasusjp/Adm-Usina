unit ClasseLogAdmUsina;

interface

uses System.SysUtils, System.JSON, Data.DBXJSONReflect, ClasseBase;

type
  TLog_Adm_Usina = class;

  TArr_Log_Adm_Usina = array of TLog_Adm_Usina;


  // Log_Adm_Usina
  TLog_Adm_Usina = class(TClasseBase)
  private
    Fid_LogAdmUsina : integer;
    Fdt_Log : TDateTime;
    Ftp_Log : String;
    Fnm_TabelaAcao : String;
    Fid_RegistroAcao : integer;
    Fde_Dados : String;
    Fde_Origem : String;
    Fde_Mensagem : String;
    Fde_Observacao : String;
    FCod_Dispositivo : String;
    Fid_Sistema : integer;
    Fid_UsuUsi : integer;
 public
    property id_LogAdmUsina : integer read Fid_LogAdmUsina write Fid_LogAdmUsina;
    property dt_Log : TDateTime read Fdt_Log write Fdt_Log;
    property tp_Log : String read Ftp_Log write Ftp_Log;
    property nm_TabelaAcao : String read Fnm_TabelaAcao write Fnm_TabelaAcao;
    property id_RegistroAcao : integer read Fid_RegistroAcao write Fid_RegistroAcao;
    property de_Dados : String read Fde_Dados write Fde_Dados;
    property de_Origem : String read Fde_Origem write Fde_Origem;
    property de_Mensagem : String read Fde_Mensagem write Fde_Mensagem;
    property de_Observacao : String read Fde_Observacao write Fde_Observacao;
    property Cod_Dispositivo : String read FCod_Dispositivo write FCod_Dispositivo;
    property id_Sistema : integer read Fid_Sistema write Fid_Sistema;
    property id_UsuUsi : integer read Fid_UsuUsi write Fid_UsuUsi;

    class function MontarConsulta( Campos : String;  Condicoes : String = '' ): String; //override;
    function MontarConsultaPelaChave : String; override;
    function MontarConsultaPelaChave_Parametrizada: String;

    function MontarSQLInclusao : String; override;
    function MontarSQLAlteracao : String; override;
  end;


  // Lista_Log_Adm_Usina
  TLista_Log_Adm_Usina = class
  private
    FLista_Log_Adm_Usina : TArr_Log_Adm_Usina;
  public
    // Permite mandar de uma única vez todos os itens
    property Listagem_Log_Adm_Usina : TArr_Log_Adm_Usina read FLista_Log_Adm_Usina write FLista_Log_Adm_Usina;

    // Poderia estar fora da classe mas como usa o tipo de dados da classe coloquei dentro.
    class function DadosParaJSON(Lista_Log_Adm_Usina : TLista_Log_Adm_Usina) : TJSONValue;
    class function JSONParaDados(JSon : TJSONValue) : TLista_Log_Adm_Usina;
  end;



implementation


class function TLista_Log_Adm_Usina.DadosParaJSON(Lista_Log_Adm_Usina : TLista_Log_Adm_Usina) : TJSONValue;
var
  m : TJSONMarshal;
begin
  if Assigned(Lista_Log_Adm_Usina) then
    begin
      m := TJSONMarshal.Create(TJSONConverter.Create);
      try
        Exit(m.Marshal(Lista_Log_Adm_Usina));
      finally
        m.Free;
      end;
    end
  else
    Exit(TJSONNull.Create);
end;



class function TLista_Log_Adm_Usina.JSONParaDados(JSon : TJSONValue) : TLista_Log_Adm_Usina;
var
  jm : TJSONUnMarshal;
begin
  if JSon is TJSONNull then
    Exit(nil)
  else
    begin
      jm := TJSONUnMarshal.Create;
      try
        Exit(jm.Unmarshal(Json) as TLista_Log_Adm_Usina);
      finally
        jm.Free;
      end;
    end;
end;



{ TLog_Adm_Usina }

class function TLog_Adm_Usina.MontarConsulta( Campos : String;
                                            Condicoes : String = '' ): String;
begin
  if Trim(Campos) = '' then
    Campos := '  id_LogAdmUsina, dt_Log, tp_Log, nm_TabelaAcao, id_RegistroAcao, de_Dados, de_Origem  '+
              ', de_Mensagem, de_Observacao, Cod_Dispositivo, id_Sistema, id_UsuUsi ';

  Result := 'SELECT '+Campos+
           ' FROM Log_Adm_Usina ';

  if Trim(Condicoes) <> '' then
    Result := Result + 'WHERE '+Condicoes;
end;




function TLog_Adm_Usina.MontarConsultaPelaChave: String;
begin
  Result := 'SELECT * '+
            'FROM Log_Adm_Usina '+
            'WHERE id_LogAdmUsina = '+id_LogAdmUsina.ToString;
end;



function TLog_Adm_Usina.MontarConsultaPelaChave_Parametrizada: String;
begin
  Result := 'SELECT * '+
            'FROM Log_Adm_Usina '+
            'WHERE id_LogAdmUsina = :id_LogAdmUsina ';
end;



function TLog_Adm_Usina.MontarSQLAlteracao : String;
begin
  Result := 'UPDATE '+'Log_Adm_Usina '+
            '  SET dt_Log = '''+FormatDateTime('dd-mm-yyyy hh:mm', dt_Log)+''' '+
            '    , tp_Log = '''+tp_Log+''''+
            '    , nm_TabelaAcao = '''+nm_TabelaAcao+''''+
            '    , id_RegistroAcao = '+id_RegistroAcao.ToString+
            '    , de_Dados = '''+de_Dados+''''+
            '    , de_Origem = '''+de_Origem+''''+
            '    , de_Mensagem = '''+de_Mensagem+''''+
            '    , de_Observacao = '''+de_Observacao+''''+
            '    , Cod_Dispositivo = '''+Cod_Dispositivo+''''+
            '    , id_Sistema = '+id_Sistema.ToString+
            '    , id_UsuUsi = '+id_UsuUsi.ToString+
            'WHERE id_LogAdmUsina = '+id_LogAdmUsina.ToString;
end;





function TLog_Adm_Usina.MontarSQLInclusao : String;
begin
  Result := 'INSERT INTO '+'Log_Adm_Usina '+
            ' ( dt_Log '+
            ' , tp_Log '+
            ' , nm_TabelaAcao '+
            ' , id_RegistroAcao '+
            ' , de_Dados '+
            ' , de_Origem '+
            ' , de_Mensagem '+
            ' , de_Observacao '+
            ' , Cod_Dispositivo '+
            ' , id_Sistema '+
            ' , id_UsuUsi ) '+
            'VALUES '+
            '( '''+FormatDateTime('dd-mm-yyyy hh:mm', dt_Log)+''' '+
            ', '''+tp_Log+''''+
            ', '''+nm_TabelaAcao+''''+
            ', '+id_RegistroAcao.ToString+
            ', '''+de_Dados+''''+
            ', '''+de_Origem+''''+
            ', '''+de_Mensagem+''''+
            ', '''+de_Observacao+''''+
            ', '''+Cod_Dispositivo+''''+
            ', '+id_Sistema.ToString+
            ', '+id_UsuUsi.ToString+' ) ';
end;

end.
