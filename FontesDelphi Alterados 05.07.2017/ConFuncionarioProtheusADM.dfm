inherited FrmConFuncionarioProtheusADM: TFrmConFuncionarioProtheusADM
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = ''
  ClientHeight = 421
  ClientWidth = 794
  ExplicitWidth = 800
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTopo: TPanel
    Width = 794
    ExplicitWidth = 794
    inherited imgLogoSistema: TImage
      Left = 739
      ExplicitLeft = 689
    end
    inherited lblNomeSist: TLabel
      Width = 634
      Caption = 'Consulta de Funcion'#225'rios (Protheus)'
      ExplicitWidth = 350
    end
  end
  inherited pnlRodape: TPanel
    Top = 372
    Width = 794
    ExplicitTop = 372
    ExplicitWidth = 794
    inherited lblServBanco_Usuario: TLabel
      Width = 394
    end
    inherited btnOK: TBitBtn
      Left = 694
      ExplicitLeft = 694
    end
    inherited btnAlterar: TBitBtn
      Visible = False
    end
    inherited btnNovo: TBitBtn
      Visible = False
    end
    inherited btnExcluir: TBitBtn
      Visible = False
    end
  end
  inherited StatusBar: TStatusBar
    Top = 402
    Width = 794
    ExplicitTop = 402
    ExplicitWidth = 794
  end
  inherited pnlPesquisa: TPanel
    Width = 794
    ExplicitWidth = 794
    inherited lblPesquisa: TLabel
      Width = 788
    end
    inherited edtPesquisa: TEdit
      Width = 788
      ExplicitWidth = 788
    end
  end
  inherited DBGrid: TDBGrid
    Width = 794
    Height = 279
    Columns = <
      item
        Expanded = False
        FieldName = 'RA_NOME'
        Title.Caption = 'Nome'
        Width = 394
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RA_FILIAL'
        Title.Caption = 'Filial'
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RA_MAT'
        Title.Caption = 'Matr'#237'cula'
        Width = 105
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nu_MatUnificada'
        Title.Caption = 'Filial/Mat'
        Visible = False
      end>
  end
  inherited fdqPesquisa: TFDQuery
    Connection = DMOrcamento.fdConADM
  end
end
