unit LoginVcl;

interface

uses
  uUsuarioAdmOAD, ClasseUsuarioADM,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ToolWin, Vcl.ComCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP;

type
  TFrmLogin = class(TForm)
    pnlTopo: TPanel;
    Label1: TLabel;
    ImgAutenticacao: TImage;
    lbledtUsuario: TLabeledEdit;
    lbledtSenha: TLabeledEdit;
    Panel1: TPanel;
    bbOK: TBitBtn;
    bbSair: TBitBtn;
    ImgSistema: TImage;
    lblServidor: TLabel;
    lblEsquecimentoSenha: TLabel;
    procedure bbOKClick(Sender: TObject);
    procedure lbledtUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblEsquecimentoSenhaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class var UsuarioAdmLogado : TUsuarioADM;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses uAdm_UsinaOAD, uConfig_Orcamento, Email, DModule, uFuncoesUteis,
  EsquecimentoSenhaADM;

procedure TFrmLogin.bbOKClick(Sender: TObject);
begin
  try
    UsuarioAdmLogado := UsuarioAdmOAD.ValidarLogin( lbledtUsuario.Text
                                                  , lbledtSenha.Text );
    if (UsuarioAdmLogado <> nil) then
      begin
        ModalResult := mrOk;
      end
    else
      begin
        Application.MessageBox('Usuário ou Senha inválidos.',
                               'Atenção', MB_ICONWARNING+MB_OK );
        lbledtSenha.Text := '';
        lbledtUsuario.SetFocus;
      end;
  except
    on E : Exception do
    begin
      Application.MessageBox(PWideChar('Não foi possível efetuar o Login. '+#13+
                                       E.Message),
                             'Atenção', MB_ICONWARNING+MB_OK );
    end;
  end;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  if (Copy(DMOrcamento.nomeServidor, 1, Length('Desenvolvimento' )) <> 'Desenvolvimento') then
    begin
      lbledtUsuario.Clear;
      lbledtSenha.Clear;
    end;

//  lblServidor.Caption := Copy(DMOrcamento.nomeServidor, 1, Pos('/', DMOrcamento.nomeServidor));
  lblServidor.Font.Color := clBlack;
  lblServidor.Caption := '';
  if (Copy(DMOrcamento.nomeServidor, 1, Length('Produção' )) <> 'Produção') then
    begin
      lblServidor.Caption := Copy(DMOrcamento.nomeServidor, 1, Pos('\', DMOrcamento.nomeServidor)-1);

      if (DMOrcamento.fdConOrcamento.Params.Values['Server'] = '192.168.4.10') then
        lblServidor.Font.Color := clRed
      else
        if (DMOrcamento.fdConOrcamento.Params.Values['Server'] = '192.168.4.11') then
          lblServidor.Font.Color := $002894FF;
    end;

  if (NomeDoComputador = '01USJP06B') and
     (Copy(DMOrcamento.nomeServidor, 1, Length('Desenvolvimento' )) = 'Desenvolvimento') then
    begin
      lbledtUsuario.Text := '1';
      lbledtSenha.Text := '1';
      bbOK.SetFocus;
    end
  else
    if (NomeDoComputador = '01USJP06B') and
       (Copy(DMOrcamento.nomeServidor, 1, Length('Homologação' )) = 'Homologação') then
      begin
        lbledtUsuario.Text := 'adm-usina';
        lbledtSenha.Text := '1';
        bbOK.SetFocus;
      end
    else
      if (NomeDoComputador = '01USJP06B') and
         (Copy(DMOrcamento.nomeServidor, 1, Length('Desconhecido' )) = 'Desconhecido') then
        begin
          lbledtUsuario.Text := '1';
          lbledtSenha.Text := '1';
          bbOK.SetFocus;
        end
      else
        lbledtUsuario.SetFocus;
end;

procedure TFrmLogin.lbledtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    begin
      bbOK.Setfocus;
      bbOK.OnClick(bbOK);
    end;
end;

procedure TFrmLogin.lbledtUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    lbledtSenha.Setfocus;
end;

procedure TFrmLogin.lblEsquecimentoSenhaClick(Sender: TObject);
begin
  FrmEsquecimentoSenha := TFrmEsquecimentoSenha.Create(Self);
  FrmEsquecimentoSenha.ShowModal;
  FrmEsquecimentoSenha.Free;
end;

end.
