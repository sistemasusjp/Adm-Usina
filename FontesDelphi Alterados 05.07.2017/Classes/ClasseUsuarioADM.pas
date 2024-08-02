unit ClasseUsuarioADM;

interface

uses System.SysUtils, System.JSON, Data.DBXJSONReflect,
     ClasseBase;

type
  TUsuarioADM = class;

  TArr_UsuarioADM = array of TUsuarioADM;


  // Usuario
  TUsuarioADM = class(TClasseBase)
  private
    Fid_UsuUsi: integer;
    Fid_PesUsi: integer;
    Fcd_Login: String;
    Fnm_Pessoa : String;
    Fde_Senha: String;
    Ffl_Bloqueado : Byte;
    Fdt_CadastroPesUsi: TDateTime;
    Ffl_ExclusaoPesUsi : Byte;
    Fdt_CadastroUsuUsi: TDateTime;
    Ffl_ExclusaoUsuUsi : Byte;
    Fnu_Filial: String;
    Fnu_Mat: String;
    Fnu_MatUnificada: String;

  public
    property id_UsuUsi: integer read Fid_UsuUsi write Fid_UsuUsi;
    property id_PesUsi: integer read Fid_PesUsi write Fid_PesUsi;
    property cd_Login : String read Fcd_Login write Fcd_Login;
    property nm_Pessoa : String read Fnm_Pessoa write Fnm_Pessoa;
    property de_Senha : String read Fde_Senha write Fde_Senha;
    property fl_Bloqueado : Byte read Ffl_Bloqueado write Ffl_Bloqueado;
    property dt_CadastroPesUsi : TDateTime read Fdt_CadastroPesUsi write Fdt_CadastroPesUsi;
    property fl_ExclusaoPesUsi : Byte read Ffl_ExclusaoPesUsi write Ffl_ExclusaoPesUsi;
    property dt_CadastroUsuUsi : TDateTime read Fdt_CadastroUsuUsi write Fdt_CadastroUsuUsi;
    property fl_ExclusaoUsuUsi : Byte read Ffl_ExclusaoUsuUsi write Ffl_ExclusaoUsuUsi;
    property nu_Filial : String read Fnu_Filial write Fnu_Filial;
    property nu_Mat : String read Fnu_Mat write Fnu_Mat;
    property nu_MatUnificada : String read Fnu_MatUnificada write Fnu_MatUnificada;

    class function MontarConsulta(Campos : String; Condicoes : String = '' ): String;

    function MontarConsultaPelaChave : String; override;
    function MontarSQLInclusao : String; override;
    function MontarSQLAlteracao : String; override;
  end;


  // Lista_Usuario
  TLista_UsuarioADM = class
  private
    FLista_UsuarioADM : TArr_UsuarioADM;
  public
    // Permite mandar de uma única vez todos os itens
    property Listagem_Usuario : TArr_UsuarioADM read FLista_UsuarioADM write FLista_UsuarioADM;

    // Poderia estar fora da classe mas como usa o tipo de dados da classe coloquei dentro.
    class function DadosParaJSON(Lista_Usuario : TLista_UsuarioADM) : TJSONValue;
    class function JSONParaDados(JSon : TJSONValue) : TLista_UsuarioADM;
  end;



implementation


class function TLista_UsuarioADM.DadosParaJSON(Lista_Usuario : TLista_UsuarioADM) : TJSONValue;
var
  m : TJSONMarshal;
begin
  if Assigned(Lista_Usuario) then
    begin
      m := TJSONMarshal.Create(TJSONConverter.Create);
      try
        Exit(m.Marshal(Lista_Usuario));
      finally
        m.Free;
      end;
    end
  else
    Exit(TJSONNull.Create);
end;



class function TLista_UsuarioADM.JSONParaDados(JSon : TJSONValue) : TLista_UsuarioADM;
var
  jm : TJSONUnMarshal;
begin
  if JSon is TJSONNull then
    Exit(nil)
  else
    begin
      jm := TJSONUnMarshal.Create;
      try
        Exit(jm.Unmarshal(Json) as TLista_UsuarioADM);
      finally
        jm.Free;
      end;
    end;
end;



{ TUsuario }


class function TUsuarioADM.MontarConsulta( Campos : String;
                                        Condicoes : String = '' ): String;
begin
  if Trim(Campos) = '' then
    Campos := ' cd_Login, nm_Pessoa, de_Senha, fl_Bloqueado '+
              ' , dt_CadastroUsuUsi, fl_ExclusaoUsuUsi '+
              ' , nu_Filial, nu_Mat, nu_MatUnificada '+
              ' , dt_CadastroPesUsi, fl_ExclusaoPesUsi ';

  Result := 'SELECT '+Campos+
           ' FROM Usuario_Usina uu '+
           '      JOIN Pessoa_Usina pu '+
           '      ON pu.id_PesUsi = uu.id_PesUsi ';

  if Trim(Condicoes) <> '' then
    Result := Result + 'WHERE '+Condicoes;
end;





function TUsuarioADM.MontarConsultaPelaChave: String;
begin
  Result := 'SELECT * '+
            ' FROM Usuario_Usina uu '+
            '      JOIN Pessoa_Usina pu '+
            '      ON pu.id_PesUsi = uu.id_PesUsi '+
            'WHERE cd_Login = '''+cd_Login+'''';
end;




function TUsuarioADM.MontarSQLAlteracao : String;
begin
(*
  Result := 'UPDATE '+'Usuario '+
            '  SET nm_Pessoa = '+TestarCampoStringNulo(nm_Pessoa)+
            '    , de_Senha = '''+de_Senha+''' '+
            '    , fl_Bloqueado = '+fl_Bloqueado.ToString+' '+
            '    , dt_CadastroUsuUsi = '''+FormatarData(TipoBancoDados, dt_CadastroUsuUsi)+''' '+
            '    , fl_ExclusaoUsuUsi = '+fl_ExclusaoUsuUsi.ToString+' '+
            '    , nu_Filial = '+TestarCampoStringNulo(nu_Filial)+' '+
            '    , nu_Mat = '+TestarCampoStringNulo(nu_Mat)+' '+
            '    , nu_MatUnificada = '+TestarCampoStringNulo(nu_MatUnificada)+' ';
  Result := Result+
            'WHERE cd_Login = '''+cd_Login+'''';
  {$IFDEF MODULOGERENTE}
  Result := 'SET DATEFORMAT DMY '+#13+#10
            +Result;
  {$ENDIF}
*)
end;



function TUsuarioADM.MontarSQLInclusao : String;
begin
(*
  Result := 'INSERT INTO '+'Usuario '+
            ' ( cd_Login, nm_Pessoa, de_Senha, fl_Bloqueado, '+
            '   dt_CadastroUsuUsi, fl_ExclusaoUsuUsi, '+
            '   nu_Mat, nu_Filial, nu_MatUnificada ) '+
            'VALUES '+
            '( '''+cd_Login+''' '+
            ', '''+nm_Pessoa+''' '+
            ', '''+de_Senha+''' '+
            ', '+fl_Bloqueado.ToString+' '+
            ', '''+FormatarData(TipoBancoDados, dt_CadastroUsuUsi)+''' '+
            ', '+fl_ExclusaoUsuUsi.ToString+' '+
            ', '+TestarCampoStringNulo(nu_Mat)+
            ', '+TestarCampoStringNulo(nu_Filial)+
            ', '+TestarCampoStringNulo(nu_MatUnificada)+' )';
  {$IFDEF MODULOGERENTE}
  Result := 'SET DATEFORMAT DMY '+#13+#10
            +Result;
  {$ENDIF}
*)
end;


end.
