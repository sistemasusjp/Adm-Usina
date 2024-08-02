unit ClasseGestor;

interface

uses System.SysUtils, System.JSON, Data.DBXJSONReflect, ClasseBase, System.Variants;

type
  TGestor = class;

  TArr_Gestor = array of TGestor;


  // Gestor
  TGestor = class(TClasseBase)
  private
    Fid_Gestor : integer;
    Fid_UsuUsi : integer;
    Fdt_InicioExercicio : TDate;
    Fdt_FimExercicio : Variant;
    Ffl_Exclusao : Byte;
    Ftp_Gestor : integer;
    Fde_tp_Gestor: String;
    Fid_ClassifAreaCC: Variant;

 public
    property id_Gestor : integer read Fid_Gestor write Fid_Gestor;
    property id_UsuUsi : integer read Fid_UsuUsi write Fid_UsuUsi;
    property dt_InicioExercicio : TDate read Fdt_InicioExercicio write Fdt_InicioExercicio;
    property dt_FimExercicio : Variant read Fdt_FimExercicio write Fdt_FimExercicio;
    property fl_Exclusao : Byte read Ffl_Exclusao write Ffl_Exclusao;
    property tp_Gestor : integer read Ftp_Gestor write Ftp_Gestor;
    property de_tp_Gestor: String read Fde_tp_Gestor write Fde_tp_Gestor;
    property id_ClassifAreaCC: Variant read Fid_ClassifAreaCC write Fid_ClassifAreaCC;

    class function MontarConsulta( Campos : String;  Condicoes : String = '' ): String; //override;
    function MontarConsultaPelaChave : String; override;
    function MontarConsultaPelaChave_Parametrizada: String;

    function MontarSQLInclusao : String; override;
    function MontarSQLAlteracao : String; override;
  end;


  // Lista_Gestor
  TLista_Gestor = class
  private
    FLista_Gestor : TArr_Gestor;
  public
    // Permite mandar de uma única vez todos os itens
    property Listagem_Gestor : TArr_Gestor read FLista_Gestor write FLista_Gestor;

    // Poderia estar fora da classe mas como usa o tipo de dados da classe coloquei dentro.
    class function DadosParaJSON(Lista_Gestor : TLista_Gestor) : TJSONValue;
    class function JSONParaDados(JSon : TJSONValue) : TLista_Gestor;
  end;



implementation


class function TLista_Gestor.DadosParaJSON(Lista_Gestor : TLista_Gestor) : TJSONValue;
var
  m : TJSONMarshal;
begin
  if Assigned(Lista_Gestor) then
    begin
      m := TJSONMarshal.Create(TJSONConverter.Create);
      try
        Exit(m.Marshal(Lista_Gestor));
      finally
        m.Free;
      end;
    end
  else
    Exit(TJSONNull.Create);
end;



class function TLista_Gestor.JSONParaDados(JSon : TJSONValue) : TLista_Gestor;
var
  jm : TJSONUnMarshal;
begin
  if JSon is TJSONNull then
    Exit(nil)
  else
    begin
      jm := TJSONUnMarshal.Create;
      try
        Exit(jm.Unmarshal(Json) as TLista_Gestor);
      finally
        jm.Free;
      end;
    end;
end;



{ TGestor }

class function TGestor.MontarConsulta( Campos : String;
                                       Condicoes : String = '' ): String;
begin
  if Trim(Campos) = '' then
    Campos := '  id_Gestor, id_UsuUsi, dt_InicioExercicio, dt_FimExercicio '+
              ', fl_Exclusao, tp_Gestor, id_ClassifAreaCC ';

  Result := 'SELECT '+Campos+
           ' FROM Gestor ';

  if Trim(Condicoes) <> '' then
    Result := Result + 'WHERE '+Condicoes;
end;




function TGestor.MontarConsultaPelaChave: String;
begin
  Result := 'SELECT * '+
            'FROM Gestor '+
            'WHERE id_Gestor = '+id_Gestor.ToString;
end;



function TGestor.MontarConsultaPelaChave_Parametrizada: String;
begin
  Result := 'SELECT * '+
            'FROM Gestor '+
            'WHERE id_Gestor = :id_Gestor ';
end;



function TGestor.MontarSQLAlteracao : String;
begin
  Result := 'UPDATE '+'Gestor '+
            '  SET dt_InicioExercicio = '''+FormatDateTime('dd-mm-yyyy', dt_InicioExercicio)+''' '+
            '    , fl_Exclusao = '+fl_Exclusao.ToString+
            '    , tp_Gestor = '+tp_Gestor.ToString+
            '    , id_UsuUsi = '+id_UsuUsi.ToString;

  if dt_FimExercicio = varEmpty then
    Result := Result +
            '    , dt_FimExercicio = null '
  else
    Result := Result+
            '    , dt_FimExercicio = '''+FormatDateTime('dd-mm-yyyy', dt_FimExercicio)+''' ';

  if id_ClassifAreaCC = varEmpty then
    Result := Result +
            '    , id_ClassifAreaCC = null '
  else
    Result := Result+
            '    , id_ClassifAreaCC = '+VarToStr(id_ClassifAreaCC);

  Result := 'SET DATEFORMAT dmy '+#13+
            Result +
            'WHERE id_Gestor = '+id_Gestor.ToString;
end;




function TGestor.MontarSQLInclusao : String;
begin
  Result := 'INSERT INTO '+'Gestor '+
            ' ( dt_InicioExercicio '+
            ' , dt_FimExercicio '+
            ' , fl_Exclusao '+
            ' , tp_Gestor '+
            ' , id_UsuUsi '+
            ' , id_ClassifAreaCC ) '+
            'VALUES '+
            '( '''+FormatDateTime('dd-mm-yyyy', dt_InicioExercicio)+''' '+
            ', null '+  // dt_FimExercicio
            ', '+fl_Exclusao.ToString+' '+
            ', '+tp_Gestor.ToString+' '+
            ', '+id_UsuUsi.ToString;

  if id_ClassifAreaCC = varEmpty then
    Result := Result +
            '    , null ) '
  else
    Result := Result+
            '    , '+VarToStr(id_ClassifAreaCC)+' ) ';

  Result := 'SET DATEFORMAT dmy '+#13+
            Result;
end;

end.
