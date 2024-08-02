unit ConUsuarioADM;

interface

uses
  {$IFDEF MODULOCLIENTE}
  DModuleCliente,
  {$ENDIF}
  {$IFDEF MODULOGERENTE}
  DModuleGerente,
  {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFormPadrao, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Grid,
  Data.Bind.Grid,
  FMX.ListView.Types, System.Rtti, FMX.Effects, FMX.Filter.Effects,
  FMX.Grid, FMX.ListBox, FMX.ListView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uFuncoesUteisFMX,
  uFuncionarioOAD, FMX.Edit;


type
  TFrmConUsuario = class(TFrmPadrao)
    lvConsulta: TListView;
    pnlConFuncTop: TPanel;
    Image7: TImage;
    Label2: TLabel;
    BindingsList1: TBindingsList;
    BindSourceDB2: TBindSourceDB;
    btnVoltar: TButton;
    AniIndicator1: TAniIndicator;
    lblDica: TLabel;
    fdqUsuario: TFDQuery;
    Panel1: TPanel;
    edtPesquisa: TEdit;
    btnPesquisar: TButton;
    LinkFillControlToField1: TLinkFillControlToField;
    layPesquisa: TLayout;
    fdqUsuariocd_LoginUsu: TStringField;
    fdqUsuarionm_Usuario: TStringField;
    fdqUsuariofl_Ativo: TBooleanField;
    fdqUsuariode_SenhaUsu: TStringField;
    fdqUsuariocd_GrupoUsu: TIntegerField;
    fdqUsuariodt_CadastroUsu: TDateTimeField;
    fdqUsuarioRa_Mat: TStringField;
    fdqUsuarioCampoDesc: TLargeintField;
    Layout2: TLayout;
    btnAdicionar: TButton;
    btnAlterar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvConsultaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure edtPesquisaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure fdqUsuarioAfterScroll(DataSet: TDataSet);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure VerificarPermissoes;
  public
    { Public declarations }
  end;

var
  FrmConUsuario: TFrmConUsuario;

implementation

{$R *.fmx}


uses
  CadUsuario, uUsuarioOAD, TiposDeDados;

procedure TFrmConUsuario.btnAdicionarClick(Sender: TObject);
begin
  inherited;

  FrmCadUsuario := TFrmCadUsuario.Create(Self);
  FrmCadUsuario.Inclusao := True;
  if FrmCadUsuario.ShowModal = mrOk then
    btnPesquisarClick(btnAlterar);
  FrmCadUsuario.Close;
end;

procedure TFrmConUsuario.btnAlterarClick(Sender: TObject);
var
  ID : string;
begin
  ID := GetSelectedValue(lvConsulta).ToString;

  if ID = '' then
    ShowMessage('Selecione um item para continuar.')
  else
    begin
      FrmCadUsuario := TFrmCadUsuario.Create(Self);
      {$IFDEF ANDROID}
      FrmCadUsuario.Show;
      {$ELSE}
      if FrmCadUsuario.ShowModal = mrOk then
        btnPesquisarClick(btnAlterar);

      FrmCadUsuario.Close;
      {$ENDIF}
    end;
end;

procedure TFrmConUsuario.btnPesquisarClick(Sender: TObject);
begin
  inherited;
//  if (edit1.Text.Length >= 2) then
    with fdqUsuario do
    begin
      AniIndicator1.Visible := True;
      Application.ProcessMessages;

      Close;
      SQL.Text := UsuarioOAD.MontarConsulta(
                       ' WHERE ( Usu.cd_LoginUsu like ''%'+edtPesquisa.Text+'%'' '+
                       '      OR Usu.nm_Usuario like ''%'+edtPesquisa.Text+'%'' ) ');
      SQL.Text := SQL.Text
                  +'ORDER BY nm_Usuario ';

      if not Active then
        Open;

      AniIndicator1.Visible := False;
      Application.ProcessMessages;
    end;
end;

procedure TFrmConUsuario.btnVoltarClick(Sender: TObject);
begin
  inherited;
  FrmConUsuario.Close;
end;

procedure TFrmConUsuario.edtPesquisaKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if (edtPesquisa.Text.Length >= 2) then
    with fdqUsuario do
    begin
      AniIndicator1.Visible := True;
      Application.ProcessMessages;

      Close;
      SQL.Text := UsuarioOAD.MontarConsulta(
                       ' WHERE ( Usu.cd_LoginUsu like ''%'+edtPesquisa.Text+'%'' '+
                       '      OR Usu.nm_Usuario like ''%'+edtPesquisa.Text+'%'' ) ');

      if not Active then
        Open;

      AniIndicator1.Visible := False;
      Application.ProcessMessages;
    end;
end;

procedure TFrmConUsuario.fdqUsuarioAfterScroll(DataSet: TDataSet);
begin
  inherited;
//  label2.Text := 'Consulta de Funcionários '+fdqUsuario.RecordCount.ToString();
end;

procedure TFrmConUsuario.FormCreate(Sender: TObject);
begin
  inherited;

  AniIndicator1.Visible := False;
  lblDica.Text := 'Informe parte do nome ou da matrícula. '+
  //'Informe pelo menos 3 caracteres para buscar. '+
       'Clique em um item para ver os detalhes ou alterar.';

  {$IFDEF MODULOCLIENTE}
  layPesquisa.Height := 130;
  fdqUsuario.Connection := DMCliente.fdConAbastecimentoCliente;
  fdqUsuario.ConnectionName := DMCliente.fdConAbastecimentoCliente.ConnectionName;
  {$ENDIF}
  {$IFDEF MODULOGERENTE}
  fdqUsuario.Connection := DMGerente.fdConAbastecimentoGerente;
  {$ENDIF}
  fdqUsuario.Fields.Clear;
  fdqUsuario.Close;
end;

procedure TFrmConUsuario.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

//  if Key = vkHardwareBack then

end;

procedure TFrmConUsuario.FormShow(Sender: TObject);
begin
  inherited;

  VerificarPermissoes;
end;

procedure TFrmConUsuario.lvConsultaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Chave : String;
begin
  if lvConsulta.Selected <> nil then
    with fdqUsuario do
    begin
      Chave := GetSelectedValue(lvConsulta).ToString;
      Locate('CampoDesc', Chave, []);
(*
      FrmCadUsuario := TFrmCadUsuario.Create(Self);
//      FrmCadUsuario.Exibir( FieldByName('Matrícula').AsString,
//                                FieldByName('Filial').AsString );

      {$IFDEF ANDROID}
      FrmCadUsuario.Show;
      {$ELSE}
      FrmCadUsuario.ShowModal;
      FrmCadUsuario.Close;
      {$ENDIF}
*)
    end;
end;

procedure TFrmConUsuario.VerificarPermissoes;
begin
  btnAlterar.Enabled := (Configuracao.UsuaroAtual.cd_GrupoUsu in [3]);
  btnAdicionar.Enabled := (Configuracao.UsuaroAtual.cd_GrupoUsu in [3, 5]);

  if not (Configuracao.UsuaroAtual.cd_GrupoUsu in [3, 5]) then
    begin
      edtPesquisa.Enabled := False;
      btnPesquisar.Enabled := False;
      btnAlterar.Enabled := True;

      edtPesquisa.Text := Configuracao.UsuaroAtual.cd_LoginUsu;
      btnPesquisar.OnClick(btnPesquisar);
    end;
end;

end.


