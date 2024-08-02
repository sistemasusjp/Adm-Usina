unit CadUsuarioADM;

interface

uses
  uFormModal,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFormPadrao, FMX.ListBox, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  ClasseFuncionario_Protheus, FMX.Edit, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, FMX.ScrollBox, FMX.Memo;

type
  TFrmCadUsuario = class(TFrmPadrao)
    lboxCadastro: TListBox;
    ListBoxGroupHeader3: TListBoxGroupHeader;
    ListBoxItem8: TListBoxItem;
    lblDetMatricula: TLabel;
    ListBoxItem9: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    lblDetSitFolha: TLabel;
    ListBoxItem5: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    edtLogin: TEdit;
    rbtnAtivoNao: TRadioButton;
    rbtnAtivoSim: TRadioButton;
    btnVoltar: TButton;
    btnOK: TButton;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    lblFilial: TLabel;
    lblDetFilial: TLabel;
    edtNome: TEdit;
    edtSenha: TEdit;
    btnConDepart: TButton;
    TmrModal: TTimer;
    ListBoxItem1: TListBoxItem;
    ClearEditButton1: TClearEditButton;
    Layout2: TLayout;
    cbGrupoUsu: TComboBox;
    btnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnConDepartClick(Sender: TObject);
    procedure TmrModalTimer(Sender: TObject);
    procedure ClearEditButton1Click(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    Modal : TFormModal;

    function CriticarCampos: Boolean;
    procedure VerificarPermissoes;
    { Private declarations }
  public
    { Public declarations }

    Inclusao : Boolean;
  end;

var
  FrmCadUsuario: TFrmCadUsuario;

implementation

{$R *.fmx}

uses Pesquisar,
  {$IFDEF MODULOCLIENTE}
  DModuleCliente,
  {$ENDIF}
  {$IFDEF MODULOGERENTE}
  DModuleGerente,
  {$ENDIF}
  ConUsuario, uUsuarioOAD, uFuncoesUteisFMX, ClasseGrupoUsu, TiposDeDados;



procedure TFrmCadUsuario.VerificarPermissoes;
begin
  btnExcluir.Enabled := (Configuracao.UsuaroAtual.cd_GrupoUsu in [3]);
  btnOK.Enabled := (Configuracao.UsuaroAtual.cd_GrupoUsu in [3, 5]);

  if not (Configuracao.UsuaroAtual.cd_GrupoUsu in [3, 5]) then
    begin
      edtLogin.Enabled := False;
      edtNome.Enabled := False;
      ClearEditButton1.Enabled := False;
      btnConDepart.Enabled := False;
      rbtnAtivoNao.Enabled := False;
      rbtnAtivoSim.Enabled := False;
      cbGrupoUsu.Enabled := False;

      btnOK.Enabled := True;
      edtSenha.SetFocus;
    end;
end;


procedure TFrmCadUsuario.ClearEditButton1Click(Sender: TObject);
begin
  inherited;
  lblDetMatricula.Text.Empty;
  lblDetFilial.Text.Empty;
  edtNome.Text.Empty;
end;



function TFrmCadUsuario.CriticarCampos : Boolean;
begin
  Result := True;

  if Inclusao then
    if (edtLogin.Text = '') then
      begin
        Result := False;
        ShowMessage('Informe o login.');
      end
    else
      if UsuarioOAD.UsuarioExiste(edtLogin.Text) then
        begin
          Result := False;
          ShowMessage('Login de usuário já cadastrado, informe um diferente.');
        end;

  if Result and (edtNome.Text.Trim = '') then
    begin
      Result := False;
      ShowMessage('Informe o nome.');
    end;

  if Result and (edtSenha.Text.Trim = '') then
    begin
      Result := False;
      ShowMessage('Informe a senha.');
    end;

  if Result and not rbtnAtivoNao.IsChecked and not rbtnAtivoSim.IsChecked  then
    begin
      Result := False;
      ShowMessage('Informe se está ativo ou não.');
    end;

  if Result and (cbGrupoUsu.ItemIndex = -1)  then
    begin
      Result := False;
      ShowMessage('Selecione o Grupo.');
    end;
end;



procedure TFrmCadUsuario.btnConDepartClick(Sender: TObject);
begin
  inherited;

  Tag := 0;
  TmrModal.Enabled := True;

  Modal := TFormModal.GetInstance;
  Modal.FFormDestino := Self;
  TipoPesquisa := pesqOperador;
  Modal.FFormModalCom := TFrmPesquisar;
  Modal.PrepararForm;
  Modal.Show; // Tem que ser o último comando pois esse Show não é modal
end;

procedure TFrmCadUsuario.btnExcluirClick(Sender: TObject);
begin
  inherited;

  if UpperCase(edtLogin.Text) = UpperCase('adm') then
    ShowMessage('O usuário administrador não pode ser excluído.')
  else
    if MessageDlg('Tem certeza que deseja excluir o usuário '+
                        edtLogin.Text+' ('+edtNome.Text+')'
                  , TMsgDlgType.mtConfirmation,
                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0
                   ) = mrYes then
      if UsuarioOAD.Excluir(edtLogin.Text) then
        begin
          ShowMessage('Excluído com sucesso.');
          FrmCadUsuario.ModalResult := mrOk;
        end;
end;

procedure TFrmCadUsuario.btnOKClick(Sender: TObject);
var
  fl_Ativo : Byte;

begin
  inherited;

  if CriticarCampos then
    with FrmConUsuario.fdqUsuario do
    begin
       // Ativo
      if rbtnAtivoSim.IsChecked then
        fl_Ativo := 1
      else
        fl_Ativo := 0;

      if UsuarioOAD.Incluir_Alterar( edtLogin.Text
                                   , edtNome.Text
                                   , edtSenha.Text
                                   , lblDetMatricula.Text
                                   , lblDetFilial.Text
                                   , fl_Ativo
                                   , Integer(cbGrupoUsu.Items.Objects[cbGrupoUsu.ItemIndex]) ) then
        begin
          if not Inclusao then
            ShowMessage('Alterado com sucesso.')
          else
            ShowMessage('Incluído com sucesso.');
          FrmCadUsuario.ModalResult := mrOk;
        end;
    end;

end;

procedure TFrmCadUsuario.btnVoltarClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmCadUsuario.FormShow(Sender: TObject);
begin
  inherited;

  {$IFDEF MODULOCLIENTE}
  with DMCliente  do
  {$ENDIF}
  {$IFDEF MODULOGERENTE}
  with DMGerente  do
  {$ENDIF}
  begin
    fdqGeral.Close;
    fdqGeral.Open(TGrupo_Usu.MontarConsulta('', 'fl_Ativo = 1'));
    MontaComboFDObjeto(fdqGeral, cbGrupoUsu, 'cd_GrupoUsu', 'de_GrupoUsu');
  end;

  with FrmConUsuario.fdqUsuario do
  begin
    if not Inclusao then
      begin
        edtLogin.Enabled := False;
        edtLogin.Text := FieldByName('cd_LoginUsu').AsString;

        lblDetMatricula.Text := FieldByName('Ra_Mat').AsString;
        lblDetFilial.Text := FieldByName('Ra_Filial').AsString;

        edtNome.Text := FieldByName('nm_Usuario').AsString;
        edtSenha.Text := FieldByName('de_SenhaUsu').AsString;

        rbtnAtivoNao.IsChecked := FieldByName('fl_Ativo').AsBoolean.ToInteger = 0;
        rbtnAtivoSim.IsChecked := FieldByName('fl_Ativo').AsBoolean.ToInteger = 1;

        cbGrupoUsu.ItemIndex := cbGrupoUsu.Items.IndexOfObject(TObject(FieldByName('cd_GrupoUsu').AsInteger));
      end
    else
      begin
        btnExcluir.Visible := False;
        edtLogin.Enabled := True;
        edtLogin.Text := '';
        edtNome.Text := '';
        edtSenha.Text := '123Mudar';
        lblDetMatricula.Text := '';
        lblDetFilial.Text := '';
        rbtnAtivoSim.IsChecked := True;

        cbGrupoUsu.ItemIndex := -1;
      end;
  end;

  VerificarPermissoes;
end;




procedure TFrmCadUsuario.TmrModalTimer(Sender: TObject);
var
  i : byte;
begin
  inherited;
  if (Modal <> nil) then
    if Modal.Fechou then
      begin
        TmrModal.Enabled := False;

        lblDetMatricula.Text := Copy( UltimaPesquisa.Operador_Cod_Func
                                 , 2, Length(UltimaPesquisa.Operador_Cod_Func)-1);
        for i := 1 to 6-lblDetMatricula.Text.Length do
          lblDetMatricula.Text := '0'+lblDetMatricula.Text;

        lblDetFilial.Text := '0'+Copy(UltimaPesquisa.Operador_Cod_Func, 1, 1);
        edtNome.Text := Trim(UltimaPesquisa.Operador_Fun_Nome);
      end;
end;

end.


