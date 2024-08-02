unit EsquecimentoSenhaADM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Param,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls;

type
  TFrmEsquecimentoSenha = class(TForm)
    bbEnviarEmail: TBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    bbFechar: TBitBtn;
    bbPesquisar: TBitBtn;
    DBGrid1: TDBGrid;
    DBEdit1: TDBEdit;
    edtDadosPesquisa: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    procedure bbEnviarEmailClick(Sender: TObject);
    procedure bbPesquisarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbFecharClick(Sender: TObject);

  private
    { Private declarations }

    procedure PesquisarUsuario(Texto: String);
  public
    { Public declarations }

  end;

var
  FrmEsquecimentoSenha: TFrmEsquecimentoSenha;

implementation

{$R *.dfm}

uses DModule, uUsuarioAdmOAD, Email, FireDAC.Stan.Option, uConfig_Orcamento,
  uFuncoesUteis, uConfig_OrcamentoOAD;



procedure TFrmEsquecimentoSenha.bbFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEsquecimentoSenha.bbEnviarEmailClick(Sender: TObject);
begin
  if (DBGrid1.SelectedIndex = -1) then
    Application.MessageBox( 'Selecione primeiro o seu usuário na lista.',
                            'Atenção', MB_ICONWARNING+MB_OK )
  else
    with DMOrcamento do
    begin
      fdSPGeralADM.Close;
      fdSPGeralADM.StoredProcName := 'PR_Zerar_Senha_Usuario_ADM';
      fdSPGeralADM.FetchOptions.Items := [fiBlobs, fiDetails, fiMeta];
      fdSPGeralADM.Prepare;

      // Na procedure verifica Inc / Alt
      fdSPGeralADM.Params.ParamByName('@cd_Login').Value := fdqGeralADM.FieldByName('cd_Login').AsString;
      fdSPGeralADM.Params.ParamByName('@id_Sistema').Value := CONST_Sistema_id_Sistema;
      fdSPGeralADM.Params.ParamByName('@cod_Dispositivo').Value := NomeDoComputador+'\'+UsuarioComputador;
      fdSPGeralADM.Params.ParamByName('@id_UsuUsiOperacao').Value := 1; // Sempre ADM pois ninguém logou ainda
      fdSPGeralADM.Params.ParamByName('@NovaSenha').Value := '';
      fdSPGeralADM.Params.ParamByName('@NovaSenha').DataType := TFieldType.ftString;
      fdSPGeralADM.Params.ParamByName('@NovaSenha').ParamType := TParamType.ptOutput;
      fdSPGeralADM.Params.ParamByName('@Retorno').Value := '';
      fdSPGeralADM.Params.ParamByName('@Retorno').DataType := TFieldType.ftString;
      fdSPGeralADM.Params.ParamByName('@Retorno').ParamType := TParamType.ptOutput;
      fdSPGeralADM.unPrepare;
      fdSPGeralADM.Prepare;
      fdSPGeralADM.ExecProc;

      if (fdSPGeralADM.Params.ParamByName('@NovaSenha').Value <> '') then
        Enviar_Email_Esquecimento_Senha( 'Prezado(a) '+fdqGeralADM.FieldByName('nm_Pessoa').AsString
                                        , fdqGeralADM.FieldByName('de_EmailSeguranca').AsString
                                        , fdSPGeralADM.Params.ParamByName('@cd_Login').AsString
                                        , fdSPGeralADM.Params.ParamByName('@NovaSenha').AsString
                                        , Copy(DMOrcamento.nomeServidor, 1, Length('Produção' )) <> 'Produção'
                                       );
    end;
end;

procedure TFrmEsquecimentoSenha.bbPesquisarClick(Sender: TObject);
begin
  PesquisarUsuario(edtDadosPesquisa.Text);
end;

procedure TFrmEsquecimentoSenha.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with DMOrcamento.fdqGeralADM do
  begin
    Close;
    SQL.Clear;
  end;
end;

procedure TFrmEsquecimentoSenha.PesquisarUsuario(Texto: String);
begin
  with DMOrcamento.fdqGeralADM do
  begin
    Close;
    SQL.Text := 'SELECT                               '+
                '    cd_Login                         '+
                '  , de_EmailSeguranca                '+
                '  , nm_Pessoa                        '+
                '  , fl_Bloqueado                     '+
                'FROM Usuario_Usina uu                '+
                '  JOIN Usuario_Seguranca us          '+
                '    ON us.id_UsuUsi = uu.id_UsuUsi   '+
                '  JOIN Pessoa_Usina pu               '+
                '    ON pu.id_PesUsi = uu.id_PesUsi   '+
                'WHERE cd_Login LIKE ''%'+Texto+'%''  '+
                '   OR nm_Pessoa LIKE ''%'+Texto+'%'' '+
                '   OR de_EmailSeguranca LIKE ''%'+Texto+'%'' ';
    Open;

    if IsEmpty then
      Application.MessageBox( 'Usuário não encontrado.',
                              'Atenção', MB_ICONWARNING+MB_OK )
//    else
////      usuário bloqueado
//      if (RecordCount = 1) then
//        if (Application.MessageBox( PChar('Prezado usuário(a) '+#13+
//                                         FieldByName('nm_Pessoa').AsString+#13+
//                                         'Seu Usuário para Login é: '+FieldByName('cd_Login').AsString+#13+
//                                         'Deseja zerar a senha e enviar um e-mail para o endereço '+
//                                         FieldByName('de_EmailSeguranca').AsString+#13+
//                                         'Você deverá seguir as instruções deste para trocar sua senha.'),
//                                   'Atenção', MB_ICONWARNING+MB_OK ) = mrYes) then
//          begin
//          end;
  end;
end;


end.
