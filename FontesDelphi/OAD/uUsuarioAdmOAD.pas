unit uUsuarioAdmOAD;

interface

uses
  Forms, Windows,
  ClasseUsuarioAdm,
  uFuncoesAcessoBD,
  uFuncoesUteis,
  DModule,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Comp.Client,
  Data.DB, System.IniFiles;

type
  TUsuarioAdmOAD = class(TObject)
  private
    procedure TestarCriacao;
  protected
    { protected declarations }

  public

    constructor Create;//( fdConConexao: TFDConnection );//(TipoBandoDados: Byte);
    destructor Destroy; override;

    function MontarConsulta( Condicoes : String = '';
                             Campos : String = '' ): String;

    function Excluir( cd_Login : String ) : Boolean;

    function Incluir_Alterar( cd_Login
                            , nm_Pessoa
                            , de_Senha
                            , nu_Filial
                            , nu_Mat
                            , nu_MatUnificada : String;
                              fl_Bloqueado
                            , fl_ExclusaoUsuUsi : Byte ) : Boolean;

    function PesquisarUsuario( cd_Login : String ): TUsuarioAdm;

    function PesquisarUsuario_PorMat( nu_Mat : String = '';
                                      nu_Filial : String = '';
                                      nu_MatUnificada : String = '' ): TUsuarioAdm;

    function PesquisarUsuarioID( id_UsuUsi : integer ): TUsuarioAdm;

    function PesquisarPerfilUsuario( id_UsuUsi, cd_PerSis : integer): Boolean;

    function PesquisarPerfisUsuario( id_UsuUsi : integer;
                                     var cd_PerSis : integer;
                                     var nm_PerSis : String ): Boolean;

    function UsuarioExiste( cd_Login : String ): Boolean;

    function ValidarLogin( cd_Login, de_Senha : String ): TUsuarioAdm;

    function ValidarPermissao( cd_Login: String;
                               id_Sistema : integer;
                               Permissoes: array of Variant ): Boolean;
  end;




const
  CONST_NomeArquivoIni_ADM = 'ADM_Usina.ini';




var
  UsuarioAdmOAD : TUsuarioAdmOAD;


implementation

{ TAbastecimento }

{$IFDEF MSWINDOWS}
uses Espera, uAdm_UsinaOAD, uConfig_Orcamento, uLogSistemaOAD, ClasseTiposLog;
{$ENDIF}



var
  fdqQuery: TFDQuery;
//  fdConConnection: TFDConnection;




function TUsuarioAdmOAD.MontarConsulta( Condicoes : String = '';
                                        Campos : String = '' ) : String;
begin
  TestarCriacao;

  if (Campos.Trim = '') then
    Campos := ' * ';

  Result :=
    'SELECT '+Campos+
    '     , Usu.nm_Usuario  '+
    '      '+CaracterConcat+' '' '' '+CaracterConcat+
    '       ''('''+CaracterConcat+'Usu.cd_Login'+CaracterConcat+''')'' AS CampoDesc '+
    'FROM Usuario Usu ';

  if (Condicoes <> '') then
    Result := Result + Condicoes;
end;




function TUsuarioAdmOAD.Incluir_Alterar( cd_Login
                                    , nm_Pessoa
                                    , de_Senha
                                    , nu_Filial
                                    , nu_Mat
                                    , nu_MatUnificada : String;
                                      fl_Bloqueado
                                    , fl_ExclusaoUsuUsi : Byte ) : Boolean;
var
  UsuarioAdm : TUsuarioAdm;

begin
  TestarCriacao;

  Result := False;

  with fdqQuery do
  try

    try
      UsuarioAdm := TUsuarioAdm.Create;
      UsuarioAdm.cd_Login := cd_Login;
      UsuarioAdm.nm_Pessoa := nm_Pessoa;
//      UsuarioAdm.de_Senha := de_Senha;
      UsuarioAdm.dt_CadastroUsuUsi := Now();
      UsuarioAdm.nu_Filial := nu_Filial;
      UsuarioAdm.nu_Mat := nu_Mat;
      UsuarioAdm.nu_MatUnificada := nu_MatUnificada;
      UsuarioAdm.fl_Bloqueado := fl_Bloqueado;
      UsuarioAdm.fl_ExclusaoUsuUsi := fl_ExclusaoUsuUsi;

      if not UsuarioExiste( cd_Login ) then
        SQL.Text := UsuarioAdm.MontarSQLInclusao
      else
        SQL.Text := UsuarioAdm.MontarSQLAlteracao;

      ExecSQL;

      Result := True;
    except
      on E : Exception do
        Exception.RaiseOuterException(
             Exception.Create('Erro ao gravar Usuário. '+#13+
                               E.Message));
    end;
  finally
  end;
end;






function TUsuarioAdmOAD.UsuarioExiste( cd_Login : String ): Boolean;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT cd_Login '+
                 'FROM Usuario_Usina  '+
                 'WHERE UPPER(cd_Login) = UPPER('''+cd_Login+''')' );

  if fdqQuery.IsEmpty then
    Result := False
  else
    Result := True;
  fdqQuery.Close;
end;



function TUsuarioAdmOAD.ValidarLogin( cd_Login, de_Senha: String ): TUsuarioAdm;
var
  MsgErro : String;
begin
  Result := nil;
  MsgErro := '';
  TestarCriacao;

  with fdqQuery do
  try
    fdqQuery.Close;

    fdqQuery.Open( 'SELECT * '+
                   'FROM Usuario_Usina uu '+
                   '  JOIN Usuario_Seguranca us '+
                   '    ON us.id_UsuUsi = uu.id_UsuUsi  '+
                   '  JOIN Pessoa_Usina pu '+
                   '    ON pu.id_PesUsi = uu.id_PesUsi  '+
                   'WHERE UPPER(cd_Login) = UPPER('''+cd_Login+''')');
                   //'  AND de_Senha = '''+de_Senha+'''');

    if fdqQuery.IsEmpty then
      begin
        Result := nil; //False
        MsgErro := 'Login do usuário não encontrado.' // Add em 16/04/2020
      end
    else
      if (FieldByName('fl_Bloqueado').AsBoolean.ToInteger = 1) then
        MsgErro := 'Usuário Bloqueado.' // raise Exception.Create('Usuário Bloqueado.')
      else
        if (FieldByName('fl_ExclusaoUsuUsi').AsBoolean.ToInteger = 1) then
          MsgErro := 'Usuário Excluído.' // raise Exception.Create('Usuário Excluído.')
        else
          if not (FieldByName('tp_FormatoSenha').AsInteger in [0]) then
            MsgErro := 'Formato de senha desconhecido.' //raise Exception.Create('Formato de senha desconhecido.')
          else
            if ( (FieldByName('tp_FormatoSenha').AsInteger = 0) and
                 (FieldByName('de_Senha').AsString = de_Senha) ) then
              begin
                Result := TUsuarioAdm.Criar();
                Result.id_PesUsi := FieldByName('id_PesUsi').AsInteger;
                Result.dt_CadastroPesUsi := FieldByName('dt_CadastroPesUsi').AsDateTime;
                Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
                Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsBoolean.ToInteger;

                Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
                Result.cd_Login := FieldByName('cd_Login').AsString;
                Result.dt_CadastroUsuUsi := FieldByName('dt_CadastroUsuUsi').AsDateTime;
                Result.nu_Filial := FieldByName('nu_Filial').AsString;
                Result.nu_Mat := FieldByName('nu_Mat').AsString;
                Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
                Result.fl_Bloqueado := FieldByName('fl_Bloqueado').AsBoolean.ToInteger;
                Result.fl_ExclusaoUsuUsi := FieldByName('fl_ExclusaoUsuUsi').AsBoolean.ToInteger;
              end
            else
              MsgErro := 'Usuário ou Senha inválidos.';

      // 16/04/2020 Adicionado salvamento no Log_Sistema se não autenticar.
      if (MsgErro <> '') then
        begin
          {$REGION '#Log_Sistema'}
          Log_SistemaOAD.Inserir_Log_Sistema( tlLogon
                                            , ntSemTabela
                                            , 0
                                            , 'Login: '+cd_Login
                                            , 'UsuarioAdmOAD.ValidarLogin'
                                            , 'Usuário não autenticado.'
                                            , MsgErro
                                            , NomeDoComputador+'\'+UsuarioComputador
                                            , 1 );
          {$ENDREGION}

          raise Exception.Create(MsgErro);
        end;

//    {$IFDEF MSWINDOWS}
//    if (FrmEspera <> nil) then
//      FrmEspera.Hide;//    FrmEspera.Hide;
//    {$ENDIF}
  except
    on E : Exception do
    begin
      {$IFDEF MSWINDOWS}
      if (FrmEspera <> nil) then
        FrmEspera.Hide;//    FrmEspera.Hide;
      {$ENDIF}

      if Pos(UpperCase('Timeout Expired'), UpperCase(E.Message)) > 0 then
        raise Exception.Create('Não foi possível conectar com o Banco de Dados. '+
                               'Tempo esgotado.')
      else
        if (Pos(UpperCase('Usuário Bloqueado.'), UpperCase(E.Message)) > 0) or
           (Pos(UpperCase('Usuário Excluído.'), UpperCase(E.Message)) > 0) or
           (Pos(UpperCase('Formato de senha desconhecido.'), UpperCase(E.Message)) > 0) or
           (Pos(UpperCase('Usuário ou Senha inválidos.'), UpperCase(E.Message)) > 0) or
           (Pos(UpperCase('Login do usuário não encontrado.'), UpperCase(E.Message)) > 0) then
          raise Exception.Create(E.Message)
        else
          raise Exception.Create('Não foi possível conectar ao Banco da Dados: '+
                                  fdqQuery.Connection.Params.Values['Server']+'\'+
                                  fdqQuery.Connection.Params.Values['Database']+#13+
                                  'Mensagem Original: '+#13+E.Message);
    end;
  end;
end;






function TUsuarioAdmOAD.ValidarPermissao( cd_Login: String;
                                          id_Sistema : integer;
                                          Permissoes : Array of Variant ): Boolean;
var
  i : integer;
begin
  Result := False;

  TestarCriacao;

  with fdqQuery do
  try
    fdqQuery.Close;

    fdqQuery.Open( 'SELECT * '+
                   'FROM Usuario_Usina uu '+
                   '  JOIN UsuarioUsi_PerSis up '+
                   '    ON up.id_UsuUsi = uu.id_UsuUsi  '+
                   '  JOIN Perfil_Sistema ps '+
                   '    ON ps.id_PerSis = up.id_PerSis  '+
                   'WHERE uu.cd_Login = '''+cd_Login+''''+
                   '  AND ps.id_Sistema = '+id_Sistema.ToString );

    if fdqQuery.IsEmpty then
      Result := False
    else
      for i := Low(Permissoes) to High(Permissoes) do
        if fdqQuery.Locate('id_PerSis', StrToInt(VarToStr(Permissoes[i])), []) then
          Result := True;

  except
    on E : Exception do
    begin
      if Pos(UpperCase('Timeout Expired'), UpperCase(E.Message)) > 0 then
        Application.MessageBox('Não foi possível conectar com o Banco de Dados.',
                               'Erro', MB_ICONERROR+MB_OK)
      else
        raise;
    end;
  end;
end;




procedure TUsuarioAdmOAD.TestarCriacao;
begin
  if UsuarioAdmOAD = nil then
    UsuarioAdmOAD := TUsuarioAdmOAD.Create;//(fdConConnection);
end;




function TUsuarioAdmOAD.PesquisarPerfilUsuario( id_UsuUsi,
                                                cd_PerSis: integer): Boolean;
begin
  TestarCriacao;

  DMOrcamento.fdqGeralADM.Close;
  DMOrcamento.fdqGeralADM.Open( 'SELECT uups.id_UsuUsi '+
                               'FROM dbo.UsuarioUsi_PerSis uups '+
                               '     JOIN dbo.Sistema s '+
                               '       ON s.cd_Sistema = '+IntToStr(CONST_Sistema_id_Sistema)+
                               '     JOIN dbo.Perfil_Sistema ps '+
                               '       ON ps.id_Sistema = s.id_Sistema '+
                               '      AND ps.id_PerSis = uups.id_PerSis '+
                               'WHERE id_UsuUsi = '+id_UsuUsi.ToString +
                               '  AND cd_PerSis = '+cd_PerSis.ToString );

  if DMOrcamento.fdqGeralADM.IsEmpty then
    Result := False
  else
    Result := True;
end;

function TUsuarioAdmOAD.PesquisarPerfisUsuario( id_UsuUsi: integer;
                                                var cd_PerSis : integer;
                                                var nm_PerSis : String ): Boolean;
begin
  TestarCriacao;

  DMOrcamento.fdqGeralADM.Close;
  DMOrcamento.fdqGeralADM.Open( 'SELECT s.cd_Sistema, ps.cd_PerSis, ps.nm_PerSis, s.nm_Sistema, uups.id_UsuUsi '+
                 'FROM dbo.UsuarioUsi_PerSis uups '+
                 '     JOIN dbo.Sistema s '+
                 '       ON s.cd_Sistema = '+IntToStr(CONST_Sistema_id_Sistema)+
                 '     JOIN dbo.Perfil_Sistema ps '+
                 '       ON ps.id_Sistema = s.id_Sistema '+
                 '      AND ps.id_PerSis = uups.id_PerSis '+
                 'WHERE id_UsuUsi = '''+id_UsuUsi.ToString+''' '+
                 'ORDER BY ps.cd_PerSis ' ); // Order se tiver mais de um perfil

  if DMOrcamento.fdqGeralADM.IsEmpty then
    Result := False
  else
    begin
      Result := True;
      cd_PerSis := DMOrcamento.fdqGeralADM.FieldByName('cd_PerSis').AsInteger;
      nm_PerSis := DMOrcamento.fdqGeralADM.FieldByName('nm_PerSis').AsString;
    end;
end;

function TUsuarioAdmOAD.PesquisarUsuario( cd_Login : String ): TUsuarioAdm;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT uu.* '+
                 '     , nm_Pessoa '+
                 'FROM Usuario_Usina uu   '+
                 '  LEFT JOIN Pessoa_Usina pu '+
                 '    ON pu.id_PesUsi = uu.id_PesUsi  '+
                 'WHERE cd_Login = '''+cd_Login+'''');

  if fdqQuery.IsEmpty then
//    Result := False
    Result := nil
  else
//    Result := True;
    with fdqQuery do
    begin
      Result := TUsuarioAdm.Create;
      Result.cd_Login := FieldByName('cd_Login').AsString;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.fl_Bloqueado := FieldByName('fl_Bloqueado').AsBoolean.ToInteger;
//      Result.de_Senha := ''; //*// PARAM_SENHA_PADRAO //FieldByName('de_SenhaUsu');
      Result.nu_Filial := FieldByName('nu_Filial').AsString;
      Result.nu_Mat := FieldByName('nu_Mat').AsString;
      Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
      Result.dt_CadastroPesUsi := FieldByName('dt_CadastroPesUsi').AsDateTime;
      Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsInteger;
      Result.dt_CadastroUsuUsi := FieldByName('dt_CadastroUsuUsi').AsDateTime;
      Result.fl_ExclusaoUsuUsi := FieldByName('fl_ExclusaoUsuUsi').AsInteger;
    end;
end;




function TUsuarioAdmOAD.PesquisarUsuarioId( id_UsuUsi : integer ): TUsuarioAdm;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT * '+
                 'FROM ADM_Usina.dbo.Usuario_Adm_Vw '+
//                 'FROM Usuario_Usina uu   '+
//                 '  LEFT JOIN Pessoa_Usina pu '+
//                 '    ON pu.id_PesUsi = uu.id_PesUsi  '+
                 'WHERE id_UsuUsi = '+id_UsuUsi.ToString);

  if fdqQuery.IsEmpty then
//    Result := False
    Result := nil
  else
//    Result := True;
    with fdqQuery do
    begin
      Result := TUsuarioAdm.Create;
      Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
      Result.id_PesUsi := FieldByName('id_PesUsi').AsInteger;
      Result.cd_Login := FieldByName('cd_Login').AsString;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.de_Senha := ''; //*// PARAM_SENHA_PADRAO //FieldByName('de_SenhaUsu');
      Result.fl_Bloqueado := FieldByName('fl_Bloqueado').AsBoolean.ToInteger;
      Result.dt_CadastroUsuUsi := FieldByName('dt_CadastroUsuUsi').AsDateTime;
      Result.fl_ExclusaoUsuUsi := FieldByName('fl_ExclusaoUsuUsi').AsBoolean.ToInteger;
      Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsBoolean.ToInteger;
      Result.nu_Filial := FieldByName('nu_Filial').AsString;
      Result.nu_Mat := FieldByName('nu_Mat').AsString;
      Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
    end;
end;





function TUsuarioAdmOAD.PesquisarUsuario_PorMat( nu_Mat : String = '';
                                                 nu_Filial : String = '';
                                                 nu_MatUnificada : String = '' ): TUsuarioAdm;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.SQL.Text :=  'SELECT * '+
                        'FROM ADM_Usina.dbo.Usuario_Adm_Vw '+
                        '  JOIN Pessoa_Usina pu '+
                        '    ON pu.id_PesUsi = uu.id_PesUsi  ';

  if (nu_MatUnificada.Trim <> '') then
    fdqQuery.SQL.Add('WHERE nu_MatUnificada = '''+nu_MatUnificada+''' ')
  else
    fdqQuery.SQL.Add('WHERE nu_Filial = '''+nu_Filial+''' '+
                     '  AND nu_Mat = '''+nu_Mat+''' ');

  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TUsuarioAdm.Create;
      Result.cd_Login := FieldByName('cd_Login').AsString;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.fl_Bloqueado := FieldByName('fl_Bloqueado').AsBoolean.ToInteger;
      Result.de_Senha := ''; //*// PARAM_SENHA_PADRAO //FieldByName('de_SenhaUsu');
      Result.dt_CadastroUsuUsi := FieldByName('dt_CadastroUsuUsi').AsDateTime;
      Result.nu_Filial := FieldByName('nu_Filial').AsString;
      Result.nu_Mat := FieldByName('nu_Mat').AsString;
      Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
    end;
end;

constructor TUsuarioAdmOAD.Create;//(fdConConexao: TFDConnection);
begin
  inherited Create;

//  fdConConnection := fdConConexao;
//  fdConConnection := Adm_UsinaOAD.fdConConnection; //fdConConnection.Create(nil);

//  TAdm_UsinaOAD.TestarCriacao;
  if Adm_UsinaOAD = nil then
    begin
      Adm_UsinaOAD := TAdm_UsinaOAD.Create;//(fdConConnection);
      Adm_UsinaOAD.ConfigurarConexaoDoINI;
    end;

  fdqQuery := TFDQuery.Create(Application);
//  fdqQuery.Connection := Adm_UsinaOAD.fdConConnectionADM;
  fdqQuery.Connection :=DMOrcamento.fdConADM;
end;




////////////////////////////////////////////////////////////////////////////////
destructor TUsuarioAdmOAD.Destroy;
begin
  inherited;

  fdqQuery.Free;
end;




function TUsuarioAdmOAD.Excluir(cd_Login: String): Boolean;
begin
  Result := False;
  TestarCriacao;

  try
    fdqQuery.Close;
    fdqQuery.SQL.Text := 'DELETE '+
                         'FROM Usuario_Usina  '+
                         'WHERE cd_Login = '''+cd_Login+'''';
    fdqQuery.ExecSQL;

    Result := True;
  except
    on E : Exception do
      Application.MessageBox(PChar('Erro eo excluir o usuário: '+cd_Login+#13+
                                   'Mensagem Original: '+E.Message),
                             'Erro', MB_ICONERROR+MB_OK );
  end;
end;

end.
