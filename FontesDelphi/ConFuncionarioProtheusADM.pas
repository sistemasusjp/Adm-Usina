unit ConFuncionarioProtheusADM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _ConPadrao, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  Vcl.ComCtrls;

type
  TFrmConFuncionarioProtheusADM = class(T_FrmConPadrao)
    procedure FormCreate(Sender: TObject);
  protected
    { Private declarations }

//    class function MontarSQLPesquisa( Condicoes : String;
//                                      OrderBy : String = ''): String; override;
    class function MontarSQLPesquisa( Condicoes : String;
                                      OrderBy : String = '';
                                      dsAscDesc : String = '' ): String; override;

  public
    { Public declarations }

    class function Pesquisar( fdQuery : TfdQuery;
                              nu_MatUnificada : String ) : Boolean; override;
  end;

var
  FrmConFuncionarioProtheusADM: TFrmConFuncionarioProtheusADM;

implementation

{$R *.dfm}

uses uFuncoesUteis, uFuncoesAcessoBD;



procedure TFrmConFuncionarioProtheusADM.FormCreate(Sender: TObject);
begin
  inherited;
//  Coluna := 0;
end;

class function TFrmConFuncionarioProtheusADM.MontarSQLPesquisa( Condicoes : String;
                                                                OrderBy : String = '';
                                                                dsAscDesc : String = '' ): String;
begin
  Result := 'SELECT '+
            '     * '+
            'FROM Funcionario_Protheus_VW Func ';

  if (Condicoes <> '') then
    Result := Result + ' WHERE '+Condicoes;

  if (OrderBy <> '') then
    Result := Result + ' ORDER BY ' + OrderBy;
end;




class function TFrmConFuncionarioProtheusADM.Pesquisar( fdQuery: TfdQuery;
                                                      nu_MatUnificada: String): Boolean;
begin
  Result := False;

  if ( (nu_MatUnificada.Trim <> '') and SoNumeros(nu_MatUnificada) ) then
    with fdQuery do
    begin
      Close;
      SQL.Text := MontarSQLPesquisa(' nu_MatUnificada = '+nu_MatUnificada);
      Open;

      if not IsEmpty then
        if (RecordCount = 1)  then
          begin
            Result := True;
          end;
    end;
end;

end.
