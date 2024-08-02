unit uAdm_UsinaOAD;

interface

uses
  Windows, Forms,
  uFuncoesAcessoBD,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Comp.Client,
  Data.DB, System.IniFiles;


const
  CONST_NomeArquivoIni_ADM = 'ADM_Usina.ini';



type
  TAdm_UsinaOAD = class(TObject)
  private
    procedure TestarCriacao;

  protected

  public
    fdConConnectionADM: TFDConnection;

    constructor Create;//( fdConConexao: TFDConnection );//(TipoBandoDados: Byte);
    destructor Destroy; override;

    function ConfigurarConexao( Servidor, Banco, Usuario, Senha : String;
                                FormatoSenha : Integer ) : Boolean;

    function ConfigurarConexaoDoINI( CaminhoINI: String = '' ): Boolean;

  end;







var
  Adm_UsinaOAD : TAdm_UsinaOAD;


implementation

{ TAbastecimento }

{$IFDEF MSWINDOWS}
uses Espera;
{$ENDIF}



var
  fdqQuery: TFDQuery;





procedure TAdm_UsinaOAD.TestarCriacao;
begin
//  if Self = nil then
//    Self := TAdm_UsinaOAD.Create;//(fdConConnection);
  if Adm_UsinaOAD = nil then
    Adm_UsinaOAD := TAdm_UsinaOAD.Create;//(fdConConnection);
end;





function TAdm_UsinaOAD.ConfigurarConexao( Servidor, Banco,
                                          Usuario, Senha: String;
                                          FormatoSenha: Integer): Boolean;
begin
  Result := False;

  TestarCriacao;

  try
    fdConConnectionADM.Params.Values['Server']
             := Servidor;
    fdConConnectionADM.Params.Values['Database']
             := Banco;
    fdConConnectionADM.Params.Values['User_Name']
             := Usuario;
    fdConConnectionADM.Params.Values['Password']
             := Senha;
    Result := True;;
  except
  end;
end;



function TAdm_UsinaOAD.ConfigurarConexaoDoINI( CaminhoINI: String = '' ): Boolean;
var
  Ini : TIniFile;

begin
  TestarCriacao;

  Result := False;

  if (CaminhoINI.Trim = '') then
    CaminhoINI := ExtractFilePath(ParamStr(0));


  if FileExists( CaminhoINI+ // ExtractFilePath(ParamStr(0))+
                 CONST_NomeArquivoIni_ADM) then
    begin
      Ini := TIniFile.Create( CaminhoINI+ //ExtractFilePath(ParamStr(0))+
                              CONST_NomeArquivoIni_ADM) ;

      fdConConnectionADM.Params.Values['Server']
               := Ini.ReadString('ConexaoADM', 'Servidor', '');
      fdConConnectionADM.Params.Values['Database']
               := Ini.ReadString('ConexaoADM', 'Banco', 'AcessoRefeitorio');
      fdConConnectionADM.Params.Values['User_Name']
               := Ini.ReadString('ConexaoADM', 'Usuario', 'refeitorio');
      fdConConnectionADM.Params.Values['Password']
               := Ini.ReadString('ConexaoADM', 'Senha', 'refeitorio');

      Result := True;
    end
  else
    begin
//      if (FrmEspera <> nil) then
//        FrmEspera.Hide;

      Application.MessageBox(PChar('Arquivo de configuração do ADM não encontrado.'+#13+
                              CaminhoINI+
                              CONST_NomeArquivoIni_ADM),
                             'Erro', MB_ICONERROR+MB_OK);
    end;
end;




constructor TAdm_UsinaOAD.Create;//(fdConConexao: TFDConnection);
begin
  inherited Create;

  fdConConnectionADM := TFDConnection.Create(nil);
  fdConConnectionADM.DriverName := 'MSSQL';

  fdqQuery := TFDQuery.Create(nil);
  fdqQuery.Connection := fdConConnectionADM;
end;




////////////////////////////////////////////////////////////////////////////////
destructor TAdm_UsinaOAD.Destroy;
begin
  inherited;

  fdqQuery.Free;
end;




end.
