unit LoginVcl;

interface

uses
  ClasseUsuarioADM,
  uUsuarioAdmOAD,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFrmLogin = class(TForm)
    GridPanelLayout1: TGridPanelLayout;
    Image1: TImage;
    Label1: TLabel;
    edtUsuario: TEdit;
    Label2: TLabel;
    edtSenha: TEdit;
    TopToolBar: TToolBar;
    lblUsina: TLabel;
    lblNomeSist: TLabel;
    Image8: TImage;
    ToolBar4: TToolBar;
    btnOK: TButton;
    btnSair: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtUsuarioKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtSenhaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class var UsuarioAdmLogado : TUsuarioADM;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses uConfig_Orcamento;


procedure TFrmLogin.btnOKClick(Sender: TObject);
begin
  UsuarioAdmLogado := UsuarioAdmOAD.ValidarLogin( edtUsuario.Text
                                                , edtSenha.Text );
  if (UsuarioAdmLogado <> nil) then
    begin
      ModalResult := mrOk;
    end
  else
    begin
      ShowMessage('Usuário ou Senha inválidos.');
      edtSenha.Text := '';
      edtUsuario.SetFocus;
    end;
end;

procedure TFrmLogin.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.edtSenhaKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) then
    begin
      btnOK.Setfocus;
      btnOK.OnClick(btnOK);
    end;
end;

procedure TFrmLogin.edtUsuarioKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) then
    edtSenha.Setfocus;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  Caption := CONST_NomeSistema;
  edtUsuario.SetFocus;
end;

end.

