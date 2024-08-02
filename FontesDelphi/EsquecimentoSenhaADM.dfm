object FrmEsquecimentoSenha: TFrmEsquecimentoSenha
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Esquecimento de usu'#225'rio/senha'
  ClientHeight = 351
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  DesignSize = (
    560
    351)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 10
    Width = 252
    Height = 13
    Caption = 'Passo 1: Informe Nome OU E-mail OU Usu'#225'rio'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 11
    Top = 273
    Width = 534
    Height = 13
    Caption = 
      'Passo 4: Clique abaixo e ser'#225' para enviada uma senha tempor'#225'ria ' +
      'e instru'#231#245'es para seu e-mail'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 11
    Top = 65
    Width = 220
    Height = 13
    Caption = 'Passo 2: Identifique seu usu'#225'rio abaixo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 11
    Top = 216
    Width = 527
    Height = 13
    Caption = 
      'Passo 3: Se desejar receber nova senha clique no seu nome acima ' +
      'e confira seu e-mail abaixo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bbEnviarEmail: TBitBtn
    Left = 19
    Top = 291
    Width = 197
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enviar Nova Senha por E-mail'
    TabOrder = 0
    OnClick = bbEnviarEmailClick
  end
  object bbFechar: TBitBtn
    Left = 441
    Top = 317
    Width = 100
    Height = 30
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = bbFecharClick
  end
  object bbPesquisar: TBitBtn
    Left = 400
    Top = 25
    Width = 141
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Pesquisar'
    Default = True
    TabOrder = 2
    OnClick = bbPesquisarClick
  end
  object DBGrid1: TDBGrid
    Left = 19
    Top = 82
    Width = 522
    Height = 118
    Anchors = [akLeft, akTop, akRight]
    DataSource = DMOrcamento.dsGeralADM
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'cd_Login'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Title.Caption = 'Usu'#225'rio'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nm_Pessoa'
        Title.Caption = 'Nome'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'de_EmailSeguranca'
        Title.Caption = 'E-mail'
        Width = 150
        Visible = True
      end>
  end
  object DBEdit1: TDBEdit
    Left = 19
    Top = 232
    Width = 310
    Height = 24
    DataField = 'de_EmailSeguranca'
    DataSource = DMOrcamento.dsGeralADM
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object edtDadosPesquisa: TEdit
    Left = 19
    Top = 29
    Width = 366
    Height = 21
    TabOrder = 5
  end
end
