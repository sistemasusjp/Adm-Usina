unit uGestorOAD;

interface

uses
  uConfig_Orcamento,
  DModule,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Comp.Client,
  Data.DB, uFuncoesUteis, ClasseGestor;

type
  TGestorOAD = class(TObject)
  private

  protected
    { protected declarations }

  public

    constructor Create;//(TipoBandoDados: Byte);
    destructor Destroy; override;

    function MontarConsulta( Condicoes : String = '';
                             Campos : String = '' ): String;

    function Incluir_Alterar( id_Gestor : integer;
                              dt_InicioExercicio : TDateTime;
                              dt_FimExercicio : Variant;
//                              fl_Exclusao : integer;
                              tp_Gestor : integer;
                              id_UsuUsi : integer (*;
                              id_ClassifAreaCC : Variant*) ) : Boolean;

    function Excluir( id_Gestor : integer ) : Boolean;

    function ConsultarGestor(id_Gestor: integer): TFDQuery;

    function ConsultarGestorUsu(id_UsuUsi : integer): TFDQuery;

    function PesquisarGestor( id_Gestor : integer ): TGestor;

    function PesquisarGestorUsu( id_UsuUsi : integer ): TGestorAtual;

    function GestorExiste( id_Gestor : integer ): Boolean;
  end;


var
  GestorOAD : TGestorOAD;


implementation

{ TGestorOAD }

uses Espera, uUsuarioAdmOAD, uLogSistemaOAD, ClasseTiposLog;


var
  fdqQuery: TFDQuery;




function TGestorOAD.MontarConsulta( Condicoes : String = '';
                                     Campos : String = '' ) : String;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  if (Campos.Trim = '') then
    Campos := ' * ';

  Result :=
    'SELECT '+Campos+
    'FROM Gestor     ';

  if (Condicoes <> '') then
    Result := Result + Condicoes;
end;




function TGestorOAD.Incluir_Alterar( id_Gestor : integer;
                                     dt_InicioExercicio : TDateTime;
                                     dt_FimExercicio : Variant;
//                                     fl_Exclusao : integer;
                                     tp_Gestor : integer;
                                     id_UsuUsi : integer (*;
                                     id_ClassifAreaCC : Variant *) ) : Boolean;
var
  Gestor : TGestor;
  OperacaoLog : TTipoLog;
  MsgLog1 : String;
  MsgLog2 : String;
  IdRegistroLog : integer;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  Result := False;

  with fdqQuery do
  try
    try
      Gestor := PesquisarGestor(id_Gestor);

      if (Gestor = nil) then
        begin
          Gestor := TGestor.Create;
//          Gestor.id_Gestor := id_Gestor;
          Gestor.dt_InicioExercicio := dt_InicioExercicio;
          Gestor.dt_FimExercicio := dt_FimExercicio;
//          Gestor.fl_Exclusao := fl_Exclusao;
          Gestor.tp_Gestor := tp_Gestor;
          Gestor.id_UsuUsi := id_UsuUsi;

//22/08/2017          Gestor.id_ClassifAreaCC := id_ClassifAreaCC;

          SQL.Text := Gestor.MontarSQLInclusao;

          {$REGION 'Pré #Log_Sistema 1'}
          OperacaoLog := tlIncluiu;
          MsgLog1 := 'Incluído';
          MsgLog2 := 'incluir';
          {$ENDREGION}
        end
      else
        begin
          Gestor.dt_InicioExercicio := dt_InicioExercicio;
          Gestor.dt_FimExercicio := dt_FimExercicio;
          Gestor.tp_Gestor := tp_Gestor;
          Gestor.id_UsuUsi := id_UsuUsi;

//22/08/2017          Gestor.id_ClassifAreaCC := id_ClassifAreaCC;

          SQL.Text := Gestor.MontarSQLAlteracao;

          {$REGION 'Pré #Log_Sistema 1'}
          OperacaoLog := tlAlterou;
          MsgLog1 := 'Alterado';
          MsgLog2 := 'alterar';
          {$ENDREGION}
        end;

      ExecSQL;

      {$REGION 'Pré #Log_Sistema 2'}
      if (OperacaoLog = tlIncluiu) then
        begin
          Close;
          SQL.Text := 'SELECT IDENT_CURRENT(''Gestor'')';
          Open;
          if not IsEmpty then
            IdRegistroLog := Fields[0].Value
          else
            IdRegistroLog := 0;
        end
      else
        IdRegistroLog := id_Gestor;
      {$ENDREGION}

      {$REGION '#Log_Sistema'}
      Log_SistemaOAD.Inserir_Log_Sistema( OperacaoLog
                                        , ntGestor__ADM
                                        , IdRegistroLog
                                        , ''
                                        , 'TGestorOAD.Incluir_Alterar'
                                        , MsgLog1+' Gestor (ADM) com sucesso', ''
                                        , NomeDoComputador+'\'+UsuarioComputador
                                        , Configuracao.UsuarioAtual.id_UsuUsi );
      {$ENDREGION}

      Result := True;
    except
      on E : Exception do
      begin
        {$REGION '#Log_Sistema'}
        Log_SistemaOAD.Inserir_Log_Sistema( tlErro
                                          , ntGestor__ADM
                                          , 0
                                          , ''
                                          , 'TGestorOAD.Incluir_Alterar'
                                          , 'Erro ao '+MsgLog2+' Gestor (ADM)'
                                          , E.Message
                                          , NomeDoComputador+'\'+UsuarioComputador
                                          , Configuracao.UsuarioAtual.id_UsuUsi );
        {$ENDREGION}

        Exception.RaiseOuterException(
             Exception.Create('Erro ao '+MsgLog2+' Gestor (ADM). '+#13+
                               E.Message));
      end;
    end;
  finally
  end;
end;







function TGestorOAD.GestorExiste( id_Gestor : integer ): Boolean;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT id_Gestor '+
                 'FROM Gestor  '+
                 'WHERE id_Gestor = '+id_Gestor.ToString);

  if fdqQuery.IsEmpty then
    Result := False
  else
    Result := True;
  fdqQuery.Close;
end;







function TGestorOAD.ConsultarGestor(id_Gestor: integer): TFDQuery;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  with fdqQuery do
  begin
    Close;
    SQl.Text := 'SELECT * FROM ADM_Usina.dbo.Gestor_Adm_Vw '+
                'WHERE id_Gestor = '+id_Gestor.ToString+
                '  AND dt_FimExercicio IS NULL '+
                '  AND fl_Exclusao = 0 ';
    Open;

    if not IsEmpty then
      Result := fdqQuery
    else
      Result := nil;
  end;
end;







function TGestorOAD.ConsultarGestorUsu(id_UsuUsi : integer): TFDQuery;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  with fdqQuery do
  begin
    Close;
    SQl.Text := 'SELECT * FROM ADM_Usina.dbo.Gestor_Adm_Vw '+
                'WHERE id_UsuUsi = '+id_UsuUsi.ToString+
                '  AND dt_FimExercicio IS NULL '+
                '  AND fl_Exclusao = 0 ';
    Open;

    if not IsEmpty then
      Result := fdqQuery
    else
      Result := nil;
  end;
end;



function TGestorOAD.PesquisarGestor( id_Gestor : integer ): TGestor;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT * '+
                 'FROM ADM_Usina.dbo.Gestor_Adm_Vw  '+
                 'WHERE id_Gestor = '+id_Gestor.ToString +
                 '  AND dt_FimExercicio IS NULL '+
                 '  AND fl_Exclusao = 0 ' );

  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TGestor.Create;
      Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
      Result.id_Gestor := FieldByName('id_Gestor').AsInteger;
      Result.dt_InicioExercicio := FieldByName('dt_InicioExercicio').AsDateTime;
      if FieldByName('dt_FimExercicio').AsDateTime = 0 then
        Result.dt_FimExercicio := varEmpty
      else
        Result.dt_FimExercicio := FieldByName('dt_FimExercicio').AsDateTime;
      Result.fl_Exclusao := FieldByName('fl_Exclusao').AsBoolean.ToInteger;
      Result.tp_Gestor := FieldByName('tp_Gestor').AsInteger;
      Result.de_tp_Gestor := FieldByName('de_tp_Gestor').AsString;
      Result.Lista_id_ClassifAreaCC := FieldByName('Lista_id_ClassifAreaCC').AsString;
      Result.Lista_de_ClassifAreaCC := FieldByName('Lista_de_ClassifAreaCC').AsString;
//22/08/2017      Result.id_ClassifAreaCC := FieldByName('id_ClassifAreaCC').AsInteger;
    end;
end;



function TGestorOAD.PesquisarGestorUsu( id_UsuUsi : integer ): TGestorAtual;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT * '+
                 'FROM ADM_Usina.dbo.Gestor_Adm_Vw  '+
                 'WHERE id_UsuUsi = '+id_UsuUsi.ToString +
                 '  AND dt_FimExercicio IS NULL '+
                 '  AND fl_Exclusao = 0 ' );

  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TGestorAtual.Create;
      Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
      Result.id_Gestor := FieldByName('id_Gestor').AsInteger;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.dt_InicioExercicio := FieldByName('dt_InicioExercicio').AsDateTime;
      if FieldByName('dt_FimExercicio').AsDateTime = 0 then
        Result.dt_FimExercicio := varEmpty
      else
        Result.dt_FimExercicio := FieldByName('dt_FimExercicio').AsDateTime;
      Result.fl_Exclusao := FieldByName('fl_Exclusao').AsBoolean.ToInteger;
      Result.tp_Gestor := FieldByName('tp_Gestor').AsInteger;
      Result.de_tp_Gestor := FieldByName('de_tp_Gestor').AsString;
      Result.Lista_id_ClassifAreaCC := FieldByName('Lista_id_ClassifAreaCC').AsString;
      Result.Lista_de_ClassifAreaCC := FieldByName('Lista_de_ClassifAreaCC').AsString;
    end;
end;






constructor TGestorOAD.Create;//(TipoBandoDados: Byte);
begin
  inherited Create;

  fdqQuery := TFDQuery.Create(nil);

  fdqQuery.Connection := DMOrcamento.fdConADM;
end;




////////////////////////////////////////////////////////////////////////////////
destructor TGestorOAD.Destroy;
begin
  inherited;

  fdqQuery.Free;
end;




function TGestorOAD.Excluir(id_Gestor: integer): Boolean;
var
  Dados : String;
begin
  if GestorOAD = nil then
    GestorOAD := TGestorOAD.Create;

  try
    // Como a exclusão é lógica os dados podem ser coletados depois
//    Dados := Log_SistemaOAD.BuscarDadosParaLog( ntGestor__ADM, id_Gestor );

    fdqQuery.Close;
//    fdqQuery.SQL.Text := 'DELETE  '+
//                         'FROM Gestor  '+
//                         'WHERE id_Gestor = '''+id_Gestor+'''';
    fdqQuery.SQL.Text := 'UPDATE Gestor '+
                         '   SET fl_Exclusao = 1 '+
                         'WHERE id_Gestor = '+id_Gestor.ToString;
    fdqQuery.ExecSQL;

    // Como a exclusão é lógica os dados podem ser coletados depois
    Dados := Log_SistemaOAD.BuscarDadosParaLog( ntGestor__ADM, id_Gestor );

    Result := True;

    {$REGION '#Log_Sistema'}
    Log_SistemaOAD.Inserir_Log_Sistema( tlExcluiu
                                      , ntGestor__ADM
                                      , id_Gestor
                                      , Dados
                                      , 'TGestorOAD.Excluir'
                                      , 'Excluído Gestor (ADM) com sucesso'
                                      , ''
                                      , NomeDoComputador+'\'+UsuarioComputador
                                      , Configuracao.UsuarioAtual.id_UsuUsi );
    {$ENDREGION}
  except
    on E : Exception do
    begin
      Result := False;
      {$REGION '#Log_Sistema'}
      Log_SistemaOAD.Inserir_Log_Sistema( tlErro
                                        , ntGestor__ADM
                                        , id_Gestor
                                        , Dados
                                        , 'TGestorOAD.Excluir'
                                        , 'Erro ao excluir Gestor (ADM)'
                                        , E.Message
                                        , NomeDoComputador+'\'+UsuarioComputador
                                        , Configuracao.UsuarioAtual.id_UsuUsi );
      {$ENDREGION}
    end;
  end;

  fdqQuery.Close;
end;

end.
