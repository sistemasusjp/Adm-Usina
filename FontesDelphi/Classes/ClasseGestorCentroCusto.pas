unit ClasseGestorCentroCusto;

interface

uses System.SysUtils, System.JSON, Data.DBXJSONReflect, ClasseBase;

type
  TGestor_Centro_Custo = class;

  TArr_Gestor_Centro_Custo = array of TGestor_Centro_Custo;


  // Gestor_Centro_Custo
  TGestor_Centro_Custo = class(TClasseBase)
  private
    Fid_GestorCentroCusto : integer;
    Fid_Gestor : integer;
    FCtt_Custo : String;
    Fdt_InicioGestao : TDateTime;
    Fdt_FimGestao : Variant;
 public
    property id_GestorCentroCusto : integer read Fid_GestorCentroCusto write Fid_GestorCentroCusto;
    property id_Gestor : integer read Fid_Gestor write Fid_Gestor;
    property Ctt_Custo : String read FCtt_Custo write FCtt_Custo;
    property dt_InicioGestao : TDateTime read Fdt_InicioGestao write Fdt_InicioGestao;
    property dt_FimGestao : Variant read Fdt_FimGestao write Fdt_FimGestao;

    class function MontarConsulta( Campos : String;  Condicoes : String = '' ): String; //override;
    function MontarConsultaPelaChave : String; override;
    function MontarConsultaPelaChave_Parametrizada: String;

    function MontarSQLInclusao : String; override;
    function MontarSQLAlteracao : String; override;
  end;


  // Lista_Gestor_Centro_Custo
  TLista_Gestor_Centro_Custo = class
  private
    FLista_Gestor_Centro_Custo : TArr_Gestor_Centro_Custo;
  public
    // Permite mandar de uma única vez todos os itens
    property Listagem_Gestor_Centro_Custo : TArr_Gestor_Centro_Custo read FLista_Gestor_Centro_Custo write FLista_Gestor_Centro_Custo;

    // Poderia estar fora da classe mas como usa o tipo de dados da classe coloquei dentro.
    class function DadosParaJSON(Lista_Gestor_Centro_Custo : TLista_Gestor_Centro_Custo) : TJSONValue;
    class function JSONParaDados(JSon : TJSONValue) : TLista_Gestor_Centro_Custo;
  end;



implementation


class function TLista_Gestor_Centro_Custo.DadosParaJSON(Lista_Gestor_Centro_Custo : TLista_Gestor_Centro_Custo) : TJSONValue;
var
  m : TJSONMarshal;
begin
  if Assigned(Lista_Gestor_Centro_Custo) then
    begin
      m := TJSONMarshal.Create(TJSONConverter.Create);
      try
        Exit(m.Marshal(Lista_Gestor_Centro_Custo));
      finally
        m.Free;
      end;
    end
  else
    Exit(TJSONNull.Create);
end;



class function TLista_Gestor_Centro_Custo.JSONParaDados(JSon : TJSONValue) : TLista_Gestor_Centro_Custo;
var
  jm : TJSONUnMarshal;
begin
  if JSon is TJSONNull then
    Exit(nil)
  else
    begin
      jm := TJSONUnMarshal.Create;
      try
        Exit(jm.Unmarshal(Json) as TLista_Gestor_Centro_Custo);
      finally
        jm.Free;
      end;
    end;
end;



{ TGestor_Centro_Custo }

class function TGestor_Centro_Custo.MontarConsulta( Campos : String;
                                                    Condicoes : String = '' ): String;
begin
  if Trim(Campos) = '' then
    Campos := '  id_GestorCentroCusto, dt_InicioGestao, dt_FimGestao '+
              ', fl_Exclusao, id_Gestor, Ctt_Custo ';

  Result := 'SELECT '+Campos+
           ' FROM Gestor_Centro_Custo ';

  if Trim(Condicoes) <> '' then
    Result := Result + 'WHERE '+Condicoes;
end;




function TGestor_Centro_Custo.MontarConsultaPelaChave: String;
begin
  Result := 'SELECT * '+
            'FROM Gestor_Centro_Custo '+
            'WHERE id_GestorCentroCusto = '+id_GestorCentroCusto.ToString;
end;



function TGestor_Centro_Custo.MontarConsultaPelaChave_Parametrizada: String;
begin
  Result := 'SELECT * '+
            'FROM Gestor_Centro_Custo '+
            'WHERE id_GestorCentroCusto = :id_GestorCentroCusto ';
end;



function TGestor_Centro_Custo.MontarSQLAlteracao : String;
begin
  Result := 'UPDATE '+'Gestor_Centro_Custo '+
            '  SET id_Gestor = '+id_Gestor.ToString+
            '    , Ctt_Custo = '''+Ctt_Custo+''''+
            '    , dt_InicioGestao = '''+FormatDateTime('dd-mm-yyyy', dt_InicioGestao)+''' ';

  if dt_FimGestao = varEmpty then
    Result := Result +
            '    , dt_FimGestao = null '
  else
    Result := Result+
            '    , dt_FimGestao = '''+FormatDateTime('dd-mm-yyyy', dt_FimGestao)+''' ';

  Result := Result +
            'WHERE id_GestorCentroCusto = '+id_GestorCentroCusto.ToString;

  Result := 'SET DATEFORMAT dmy '+#13+
            Result;
end;




function TGestor_Centro_Custo.MontarSQLInclusao : String;
begin
  Result := 'INSERT INTO '+'Gestor_Centro_Custo '+
            ' ( id_Gestor '+
            ' , Ctt_Custo '+
            ' , dt_InicioGestao '+
            ' , dt_FimGestao ) '+
            'VALUES '+
            '( '+id_Gestor.ToString+' '+
            ', '''+Ctt_Custo+''' '+  // dt_FimGestao
            ', '''+FormatDateTime('dd-mm-yyyy', dt_InicioGestao)+''' '+
            ', null ) ';

  Result := 'SET DATEFORMAT dmy '+#13+
            Result;
end;

end.
