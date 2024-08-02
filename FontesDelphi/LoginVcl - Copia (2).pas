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
    IdSMTP1: TIdSMTP;
    ImgSistema: TImage;
    procedure bbOKClick(Sender: TObject);
    procedure lbledtUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtSenhaKeyPress(Sender: TObject; var Key: Char);
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

uses uAdm_UsinaOAD, uConfig_Orcamento, Email;

procedure TFrmLogin.bbOKClick(Sender: TObject);
begin
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

end.
