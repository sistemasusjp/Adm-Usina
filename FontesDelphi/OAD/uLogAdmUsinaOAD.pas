unit uLogAdmUsinaOAD;

interface

uses
  Forms, Windows,
  DModule,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Comp.Client, FireDac.Stan.Option, FireDac.Stan.Param,
  Data.DB, ClasseLogAdmUsina, ClasseTiposLog;

type
  ////////////
  TNomeTabelaAdm = ( ntGestor,
                     ntGestor_CentroCusto,
                     ntLog_Adm_Usina,
                     ntPerfil_Sistema,
                     ntPessoa_Usina,
                     ntSistema,
                     ntUsuario_Seguranca,
                     ntUsuario_Usina,
                     ntUsuarioUsi_PerSis,
                     ntUsuarioUsi_Sistema );


  TLog_Adm_UsinaOAD = class(TObject)
  private
    function BuscarDadosParaLog( NomeTabela : TNomeTabelaAdm; //nm_TabelaOrigem: String;
                                 id_Registro: integer ): String;

  protected
    { protected declarations }

  public

    constructor Create;//(TipoBandoDados: Byte);
    destructor Destroy; override;

//    function InserirLog_Adm_UsinaViaClasse( NovoLog : TLog_Adm_Usina
//                                         ): Boolean;


    function Inserir_Log_Adm_Usina( dt_Log : TDateTime;
                                      TipoLog : TTipoLog;
                                      NomeTabela : TNomeTabelaAdm;//nm_TabelaAcao : String;
                                      id_RegistroAcao : integer;
                                      de_Dados : String;
                                      de_Origem : String;
                                      de_Mensagem : String;
                                      de_Observacao : String;
                                      cod_Dispositivo : String;
                                      id_Sistema : integer;
                                      id_UsuUsi : integer
                                     ): Boolean;


    function MontarConsulta( Condicoes : String = '';
                             Campos : String = '' ): String;

    function Pesquisar_Log_Adm_Usina( tp_Log : String = '';
                                        nm_TabelaAcao : String = '';
                                        id_RegistroAcao : integer = 0 ): TLog_Adm_Usina;
  end;


const
  CONST_NomeTabelaAdm : array of String
                         = ['Gestor',
                            'Gestor_CentroCusto',
                            'Log_Adm_Usina',
                            'Perfil_Sistema',
                            'Pessoa_Usina',
                            'Sistema',
                            'Usuario_Seguranca',
                            'Usuario_Usina',
                            'UsuarioUsi_PerSis',
                            'UsuarioUsi_Sistema'];

  CONST_ChaveTabelaAdm : array of String
                         = ['id_Gestor', //'Gestor',
		                        'id_GestorCentroCusto', //'Gestor_CentroCusto'', //',
		                        'id_LogAdmUsina', //'Log_Adm_Usina'', //',
		                        'id_PerSis', //'Perfil_Sistema'', //',
		                        'id_PesUsi', //'Pessoa_Usina'', //',
		                        'id_Sistema', //'Sistema'', //',
		                        'id_UsuUsi', //'Usuario_Seguranca'', //',
		                        'id_UsuUsi', //'Usuario_Usina'', //',
		                        'id_Usu_PerSis', //'UsuarioUsi_PerSis'', //',
		                        'id_UsuUsi_Sis' //'UsuarioUsi_Sistema'', //',
                            ];

var
  Log_Adm_UsinaOAD : TLog_Adm_UsinaOAD;


implementation

{ TLog_Adm_UsinaOAD }

uses Espera;


var
  fdqQuery: TFDQuery;
  fdStoreProc: TFDStoredProc;




function TLog_Adm_UsinaOAD.MontarConsulta( Condicoes : String = '';
                                          Campos : String = '' ) : String;
begin
  if Log_Adm_UsinaOAD = nil then
    Log_Adm_UsinaOAD := TLog_Adm_UsinaOAD.Create;

  if (Campos.Trim = '') then
    Campos := ' * ';

  Result :=
    'SELECT '+Campos+
    'FROM Log_Adm_Usina ';

  if (Condicoes <> '') then
    Result := Result + Condicoes;
end;




function TLog_Adm_UsinaOAD.BuscarDadosParaLog( NomeTabela : TNomeTabelaAdm; //nm_TabelaOrigem : String;
                                             id_Registro : integer
                                           ): String;
var
  i : integer;
begin
  if Log_Adm_UsinaOAD = nil then
    Log_Adm_UsinaOAD := TLog_Adm_UsinaOAD.Create;

  Result := '';

  fdqQuery.Close;
  fdqQuery.SQL.Text :=
        'SELECT * '+
        'FROM '+CONST_NomeTabelaAdm[Integer(NomeTabela)]+' '+
        'WHERE '+CONST_ChaveTabelaAdm[Integer(NomeTabela)]+' = '+id_Registro.ToString;
  fdqQuery.Open;

  if not fdqQuery.IsEmpty then
    for i := 0 to fdqQuery.Fields.Count-1 do
    begin
//      if (fdqQuery.Fields[i].DataType = TFieldType.ftString) then
      if (Result <> '') then
        Result := Result + ' || ';

      Result := Result + fdqQuery.Fields[i].FieldName
                       + ': '+VarToStr(fdqQuery.Fields[i].Value);
//psa_id: 1 || Exclusão de todos os perfis, atuais, do usuário; para inclusão dos novos.
    end;
end;




function TLog_Adm_UsinaOAD.Inserir_Log_Adm_Usina( dt_Log : TDateTime;
                                                    TipoLog : TTipoLog;
                                                    NomeTabela : TNomeTabelaAdm;//nm_TabelaAcao : String;
                                                    id_RegistroAcao : integer;
                                                    de_Dados : String;
                                                    de_Origem : String;
                                                    de_Mensagem : String;
                                                    de_Observacao : String;
                                                    cod_Dispositivo : String;
                                                    id_Sistema : integer;
                                                    id_UsuUsi : integer
                                                  ): Boolean;
begin
  if Log_Adm_UsinaOAD = nil then
    Log_Adm_UsinaOAD := TLog_Adm_UsinaOAD.Create;

  try
//    fdqQuery.Close;
//    fdqQuery.SQL.Text := NovoLog.MontarSQLInclusao;
//    fdqQuery.ExecSQL;
    with fdStoreProc do
    begin
      Result := True;

      StoredProcName := 'PR_Adicionar_Log_Adm_Usina';
      Prepare;
      FetchOptions.Items := [fiBlobs,fiDetails]; // [fiBlobs,fiDetails,fiMeta]

//      ParamByName('@dt_Log').Value := null; // A procedure pega data/hora do servidor
      ParamByName('@tp_Log').Value := CONST_TipoLog[Integer(TipoLog)];
      ParamByName('@nm_TabelaAcao').Value := CONST_NomeTabelaAdm[Integer(NomeTabela)]; // nm_TabelaOrigem;
      ParamByName('@id_RegistroAcao').Value := id_RegistroAcao;
      ParamByName('@de_Dados').Value := BuscarDadosParaLog( NomeTabela
                                                          , id_RegistroAcao ); //de_Dados;
      ParamByName('@de_Origem').Value := de_Origem;
      ParamByName('@de_Mensagem').Value := de_Mensagem;
      ParamByName('@de_Observacao').Value := de_Observacao;
      ParamByName('@Cod_Dispositivo').Value := Cod_Dispositivo;
      ParamByName('@id_Sistema').Value := id_Sistema;
      ParamByName('@id_UsuUsi').Value := id_UsuUsi;
      ParamByName('@Retorno').Value := '';

      Prepared := False;
      Prepare;

      ExecProc;

      if (ParamByName('@Retorno').Value <> '') then
        begin
          Result := False;
          Application.MessageBox(PWideChar(VarToStr(ParamByName('@Retorno').Value)),
                                 'Atenção', MB_ICONWARNING+MB_OK);
        end;
    end;
  except
    on E : Exception do
    begin
      Result := False;

      if fdStoreProc.ParamByName('@Retorno').Value <> '' then
        E.Message := 'Erro ao incluir Log. '+
                     'Mensagem Retornada da PR_Adicionar_Log_Adm_Usina: '+
                                  fdStoreProc.ParamByName('@Retorno').Value+
                     'Mensagem original '+E.Message
      else
        E.Message := 'Erro ao incluir Log. '+
                     'Mensagem original '+E.Message;

      raise E;
    end;
  end;
end;


//function TLog_Adm_UsinaOAD.InserirLog_Adm_UsinaViaClasse( NovoLog : TLog_Adm_Usina
//                                                    ): Boolean;
//begin
//  Result := True;
//
//  if Log_Adm_UsinaOAD = nil then
//    Log_Adm_UsinaOAD := TLog_Adm_UsinaOAD.Create;
//
//  Result := InserirLog_Adm_Usina( NovoLog.id_UsuUsi,
//                                NovoLog.nm_TabelaOrigem,
//                                NovoLog.id_Registro,
//                                NovoLog.tp_Log,
//                                NovoLog.nm_Modulo,
//                                NovoLog.de_Dados,
//                                NovoLog.de_Observacao );
//end;





function TLog_Adm_UsinaOAD.Pesquisar_Log_Adm_Usina( tp_Log : String = '';
                                                      nm_TabelaAcao : String = '';
                                                      id_RegistroAcao : integer = 0 ): TLog_Adm_Usina;
begin
  if Log_Adm_UsinaOAD = nil then
    Log_Adm_UsinaOAD := TLog_Adm_UsinaOAD.Create;

  fdqQuery.Close;
  fdqQuery.SQL.Text := 'SELECT * '+
                       'FROM Log_Adm_Usina  ';

  // tp_Log
  if (tp_Log <> '') then
    if Pos(UpperCase('WHERE'), UpperCase(fdqQuery.SQL.Text)) > 0 then
      fdqQuery.SQL.Add('AND tp_Log = '''+tp_Log+'''')
    else
      fdqQuery.SQL.Add('WHERE tp_Log = '''+tp_Log+'''');

  // nm_TabelaAcao
  if (nm_TabelaAcao <> '') then
    if Pos(UpperCase('WHERE'), UpperCase(fdqQuery.SQL.Text)) > 0 then
      fdqQuery.SQL.Add('AND nm_TabelaAcao = '''+nm_TabelaAcao+'''')
    else
      fdqQuery.SQL.Add('WHERE nm_TabelaAcao = '''+nm_TabelaAcao+'''');

  // id_RegistroAcao
  if (id_RegistroAcao <> 0) then
    if Pos(UpperCase('WHERE'), UpperCase(fdqQuery.SQL.Text)) > 0 then
      fdqQuery.SQL.Add('AND id_RegistroAcao = '+id_RegistroAcao.ToString)
    else
      fdqQuery.SQL.Add('WHERE id_RegistroAcao = '+id_RegistroAcao.ToString);


  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TLog_Adm_Usina.Create;
      Result.id_LogAdmUsina := FieldByName('id_LogAdmUsina').AsInteger;
      Result.dt_Log := FieldByName('dt_Log').AsDateTime;
      Result.tp_Log := FieldByName('tp_Log').AsString;
      Result.nm_TabelaAcao := FieldByName('nm_TabelaAcao').AsString;
      Result.id_RegistroAcao := FieldByName('id_RegistroAcao').AsInteger;
      Result.de_Dados := FieldByName('de_Dados').AsString;
      Result.de_Origem := FieldByName('de_Origem').AsString;
      Result.de_Mensagem := FieldByName('de_Mensagem').AsString;
      Result.de_Observacao := FieldByName('de_Observacao').AsString;
      Result.Cod_Dispositivo := FieldByName('Cod_Dispositivo').AsString;
      Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
      Result.id_Sistema := FieldByName('id_Sistema').AsInteger;
    end;
end;






constructor TLog_Adm_UsinaOAD.Create;//(TipoBandoDados: Byte);
begin
  inherited Create;

  fdqQuery := TFDQuery.Create(nil);
  fdqQuery.Connection := DMOrcamento.fdConADM;

  fdStoreProc := TFDStoredProc.Create(nil);
  fdStoreProc.Connection := DMOrcamento.fdConADM;
end;




////////////////////////////////////////////////////////////////////////////////
destructor TLog_Adm_UsinaOAD.Destroy;
begin
  inherited;

  fdqQuery.Free;
  fdStoreProc.Free;
end;




end.
