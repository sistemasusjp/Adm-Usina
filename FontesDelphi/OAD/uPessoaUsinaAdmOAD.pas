unit uPessoaUsinaAdmOAD;

interface

uses
  ClassePessoaUsinaAdm,
  uFuncoesAcessoBD,
  uFuncoesUteis,
  Forms, Windows,
  DModule,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Comp.Client,
  Data.DB, System.IniFiles;

type
  TPessoaUsinaAdmOAD = class(TObject)
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

    function Incluir_Alterar( id_PesUsi: integer;
                              nm_Pessoa, nu_Filial, nu_Mat,
                              nu_MatUnificada, nu_Cpf: String;
                              de_Ramais: String;
                              dt_Nascimento: TDateTime;
                              cd_Sexo: String;
                              de_EmailPessoa: String;
                              de_Observacao: String;
//                              dt_CadastroPesUsi: TDateTime;
                              fl_ExclusaoPesUsi : Byte;
                              de_MotivoExcPesUsi : String
                             ) : Boolean;

    function PesquisarPessoa_PorMat( nu_Mat : String = '';
                                     nu_Filial : String = '';
                                     nu_MatUnificada : String = '' ) : TPessoaUsinaADM;

    function PesquisarUsuarioID( id_PesUsi : integer ): TPessoaUsinaADM;

    function PessoaUsinaExiste( id_PesUsi : integer ): Boolean;
    function PessoaUsinaExiste_PorMat( nu_Mat : String = '';
                                       nu_Filial : String = '';
                                       nu_MatUnificada : String = '' ) : Boolean;

  end;




const
  CONST_NomeArquivoIni_ADM = 'ADM_Usina.ini';




var
  PessoaUsinaAdmOAD : TPessoaUsinaAdmOAD;


implementation

{ TAbastecimento }

{$IFDEF MSWINDOWS}
uses Espera, uAdm_UsinaOAD, uConfig_Orcamento;
{$ENDIF}



var
  fdqQuery: TFDQuery;
//  fdConConnection: TFDConnection;




function TPessoaUsinaAdmOAD.MontarConsulta( Condicoes : String = '';
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




function TPessoaUsinaAdmOAD.Incluir_Alterar( id_PesUsi: integer;
                                             nm_Pessoa, nu_Filial, nu_Mat,
                                             nu_MatUnificada, nu_Cpf: String;
                                             de_Ramais: String;
                                             dt_Nascimento: TDateTime;
                                             cd_Sexo: String;
                                             de_EmailPessoa: String;
                                             de_Observacao: String;
                                             //dt_CadastroPesUsi: TDateTime;
                                             fl_ExclusaoPesUsi : Byte;
                                             de_MotivoExcPesUsi : String ) : Boolean;
var
  PessoaUsinaADM : TPessoaUsinaADM;

begin
  TestarCriacao;

  Result := False;

  with fdqQuery do
  try
    try
      PessoaUsinaADM := TPessoaUsinaADM.Create;
      PessoaUsinaADM.id_PesUsi := id_PesUsi;
      PessoaUsinaADM.nm_Pessoa := nm_Pessoa;
      PessoaUsinaADM.nu_Filial := nu_Filial;
      PessoaUsinaADM.nu_Mat := nu_Mat;
      PessoaUsinaADM.nu_MatUnificada := nu_MatUnificada;
      PessoaUsinaADM.nu_Cpf := nu_Cpf;
      PessoaUsinaADM.de_Ramais := de_Ramais;
      PessoaUsinaADM.dt_Nascimento := dt_Nascimento;
      PessoaUsinaADM.cd_Sexo := cd_Sexo;
      PessoaUsinaADM.de_EmailPessoa := de_EmailPessoa;
      PessoaUsinaADM.de_Observacao := de_Observacao;
//      PessoaUsinaADM.dt_CadastroPesUsi := dt_CadastroPesUsi;//Now();
      PessoaUsinaADM.fl_ExclusaoPesUsi := fl_ExclusaoPesUsi;
      PessoaUsinaADM.de_MotivoExcPesUsi := de_MotivoExcPesUsi;

      if not PessoaUsinaExiste( fl_ExclusaoPesUsi ) then
        SQL.Text := PessoaUsinaADM.MontarSQLInclusao
      else
        SQL.Text := PessoaUsinaADM.MontarSQLAlteracao;

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




function TPessoaUsinaAdmOAD.PessoaUsinaExiste( id_PesUsi : integer ): Boolean;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT id_PesUsi '+
                 'FROM Pessoa_Usina  '+
                 'WHERE id_PesUsi = '+id_PesUsi.ToString+')' );

  if fdqQuery.IsEmpty then
    Result := False
  else
    Result := True;
  fdqQuery.Close;
end;




function TPessoaUsinaAdmOAD.PessoaUsinaExiste_PorMat( nu_Mat : String = '';
                                                      nu_Filial : String = '';
                                                      nu_MatUnificada : String = '' ): Boolean;
begin
  TestarCriacao;

  fdqQuery.Close;
  if (nu_MatUnificada.Trim <> '') then
    fdqQuery.Open( 'SELECT id_PesUsi '+
                   'FROM Pessoa_Usina  '+
                   'WHERE nu_MatUnificada = '''+nu_MatUnificada+''' ')
  else
    fdqQuery.Open( 'SELECT id_PesUsi '+
                   'FROM Pessoa_Usina '+
                   'WHERE nu_Mat = '''+nu_Mat+''' '+
                   '  AND nu_Filial = '''+nu_Filial+''' ' );

  if fdqQuery.IsEmpty then
    Result := False
  else
    Result := True;
  fdqQuery.Close;
end;



//function TPessoaUsinaAdmOAD.ValidarLogin( cd_Login, de_Senha: String ): TPessoaUsinaADM;
//begin
//  Result := nil;
//  TestarCriacao;
//
//  with fdqQuery do
//  try
//    fdqQuery.Close;
//
//    fdqQuery.Open( 'SELECT * '+
//                   'FROM Usuario_Usina uu '+
//                   '  JOIN Usuario_Seguranca us '+
//                   '    ON us.id_UsuUsi = uu.id_UsuUsi  '+
//                   '  JOIN Pessoa_Usina pu '+
//                   '    ON pu.id_PesUsi = uu.id_PesUsi  '+
//                   'WHERE UPPER(cd_Login) = UPPER('''+cd_Login+''')');
//                   //'  AND de_Senha = '''+de_Senha+'''');
//
//    if fdqQuery.IsEmpty then
//      Result := nil //False
//    else
//      if (FieldByName('fl_Bloqueado').AsBoolean.ToInteger = 1) then
//        raise Exception.Create('Usuário Bloqueado.')
//      else
//        if (FieldByName('fl_ExclusaoUsuUsi').AsBoolean.ToInteger = 1) then
//          raise Exception.Create('Usuário Excluído.')
//        else
//          if not (FieldByName('tp_FormatoSenha').AsInteger in [0]) then
//            raise Exception.Create('Formato de senha desconhecido.')
//          else
//            if ( (FieldByName('tp_FormatoSenha').AsInteger = 0) and
//                 (FieldByName('de_Senha').AsString = de_Senha) ) then
//              begin
//                Result := TPessoaUsinaADM.Criar();
//                Result.id_PesUsi := FieldByName('id_PesUsi').AsInteger;
//                Result.dt_CadastroPesUsi := FieldByName('dt_CadastroPesUsi').AsDateTime;
//                Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
//                Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsBoolean.ToInteger;
//
//                Result.id_UsuUsi := FieldByName('id_UsuUsi').AsInteger;
//                Result.cd_Login := FieldByName('cd_Login').AsString;
//                Result.dt_CadastroUsuUsi := FieldByName('dt_CadastroUsuUsi').AsDateTime;
//                Result.nu_Filial := FieldByName('nu_Filial').AsString;
//                Result.nu_Mat := FieldByName('nu_Mat').AsString;
//                Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
//                Result.fl_Bloqueado := FieldByName('fl_Bloqueado').AsBoolean.ToInteger;
//                Result.fl_ExclusaoUsuUsi := FieldByName('fl_ExclusaoUsuUsi').AsBoolean.ToInteger;
//              end;
//
////    {$IFDEF MSWINDOWS}
////    if (FrmEspera <> nil) then
////      FrmEspera.Hide;//    FrmEspera.Hide;
////    {$ENDIF}
//  except
//    on E : Exception do
//    begin
//      {$IFDEF MSWINDOWS}
//      if (FrmEspera <> nil) then
//        FrmEspera.Hide;//    FrmEspera.Hide;
//      {$ENDIF}
//
//      if Pos(UpperCase('Timeout Expired'), UpperCase(E.Message)) > 0 then
//          raise Exception.Create('Não foi possível conectar com o Banco de Dados. '+
//                                 'Tempo esgotado.')
//      else
//        if (Pos(UpperCase('Usuário Bloqueado.'), UpperCase(E.Message)) > 0) or
//           (Pos(UpperCase('Usuário Excluído.'), UpperCase(E.Message)) > 0) or
//           (Pos(UpperCase('Formato de senha desconhecido.'), UpperCase(E.Message)) > 0) then
//          raise Exception.Create(E.Message)
//        else
//          raise Exception.Create('Não foi possível conectar ao Banco da Dados: '+
//                                  fdqQuery.Connection.Params.Values['Server']+'\'+
//                                  fdqQuery.Connection.Params.Values['Database']+#13+
//                                  'Mensagem Original: '+#13+E.Message);
//    end;
//  end;
//end;








procedure TPessoaUsinaAdmOAD.TestarCriacao;
begin
  if PessoaUsinaAdmOAD = nil then
    PessoaUsinaAdmOAD := TPessoaUsinaAdmOAD.Create;//(fdConConnection);
end;





function TPessoaUsinaAdmOAD.PesquisarPessoa_PorMat( nu_Mat : String = '';
                                                    nu_Filial : String = '';
                                                    nu_MatUnificada : String = '' ) : TPessoaUsinaADM;
begin
  TestarCriacao;

  fdqQuery.Close;
  if (nu_MatUnificada.Trim <> '') then
    fdqQuery.Open( 'SELECT * '+
                   'FROM Pessoa_Usina '+
                   'WHERE nu_MatUnificada = '''+nu_MatUnificada+'''' );
    fdqQuery.Open( 'SELECT * '+
                   'FROM Pessoa_Usina '+
                   'WHERE nu_Mat = '''+nu_Mat+''' '+
                   '  AND nu_Filial = '''+nu_Filial+''' ' );

  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TPessoaUsinaADM.Create;
      Result.id_PesUsi := FieldByName('id_PesUsi').AsInteger;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.nu_Filial := FieldByName('nu_Filial').AsString;
      Result.nu_Mat := FieldByName('nu_Mat').AsString;
      Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
      Result.nu_Cpf := FieldByName('nu_Cpf').AsString;
      Result.de_Ramais := FieldByName('de_Ramais').AsString;
      Result.dt_Nascimento := FieldByName('dt_Nascimento').AsDateTime;
      Result.cd_Sexo := FieldByName('cd_Sexo').AsString;
      Result.de_EmailPessoa := FieldByName('de_EmailPessoa').AsString;
      Result.de_Observacao := FieldByName('de_Observacao').AsString;
      Result.dt_CadastroPesUsi := FieldByName('dt_CadastroPesUsi').AsDateTime;
      Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsInteger;
      Result.de_MotivoExcPesUsi := FieldByName('de_MotivoExcPesUsi').AsString;
    end;
end;




function TPessoaUsinaAdmOAD.PesquisarUsuarioId( id_PesUsi : integer ): TPessoaUsinaADM;
begin
  TestarCriacao;

  fdqQuery.Close;
  fdqQuery.Open( 'SELECT * '+
                 'FROM Pessoa_Usina '+
                 'WHERE id_PesUsi = '+id_PesUsi.ToString);

  if fdqQuery.IsEmpty then
    Result := nil
  else
    with fdqQuery do
    begin
      Result := TPessoaUsinaADM.Create;
      Result.id_PesUsi := FieldByName('id_PesUsi').AsInteger;
      Result.nm_Pessoa := FieldByName('nm_Pessoa').AsString;
      Result.nu_Filial := FieldByName('nu_Filial').AsString;
      Result.nu_Mat := FieldByName('nu_Mat').AsString;
      Result.nu_MatUnificada := FieldByName('nu_MatUnificada').AsString;
      Result.nu_Cpf := FieldByName('nu_Cpf').AsString;
      Result.de_Ramais := FieldByName('de_Ramais').AsString;
      Result.dt_Nascimento := FieldByName('dt_Nascimento').AsDateTime;
      Result.cd_Sexo := FieldByName('cd_Sexo').AsString;
      Result.de_EmailPessoa := FieldByName('de_EmailPessoa').AsString;
      Result.de_Observacao := FieldByName('de_Observacao').AsString;
      Result.dt_CadastroPesUsi := FieldByName('dt_CadastroPesUsi').AsDateTime;
      Result.fl_ExclusaoPesUsi := FieldByName('fl_ExclusaoPesUsi').AsBoolean.ToInteger;
      Result.de_MotivoExcPesUsi := FieldByName('de_MotivoExcPesUsi').AsString;
    end;
end;





constructor TPessoaUsinaAdmOAD.Create;//(fdConConexao: TFDConnection);
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
  fdqQuery.Connection := Adm_UsinaOAD.fdConConnectionADM;
end;




////////////////////////////////////////////////////////////////////////////////
destructor TPessoaUsinaAdmOAD.Destroy;
begin
  inherited;

  fdqQuery.Free;
end;




function TPessoaUsinaAdmOAD.Excluir(cd_Login: String): Boolean;
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
