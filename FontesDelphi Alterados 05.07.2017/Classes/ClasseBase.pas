unit ClasseBase;

interface

uses System.SysUtils, System.JSON, Data.DBXJSONReflect;

type
  TClasseBase = class;

  TArr_ClasseBase = array of TClasseBase;



  // Lista_ClasseBase
  TLista_ClasseBase = class
  private
    FLista_ClasseBase : TArr_ClasseBase;
  public
    // Permite mandar de uma única vez todos os itens
    property Listagem_ClasseBase : TArr_ClasseBase read FLista_ClasseBase write FLista_ClasseBase;
  end;



  // ClasseBase
  TClasseBase = class
  private

    FTipoBancoDados : byte; // 0 - Sql Server    1 - SqLite
    const NomeTabela : String = '1';
  public
    constructor Criar;//(TipoBD : Byte);

    property TipoBancoDados : byte read FTipoBancoDados write FTipoBancoDados;

    function MontarConsultaPelaChave : String; virtual; abstract;
    function MontarSQLInclusao : String;  virtual; abstract;
    function MontarSQLAlteracao : String; virtual; abstract;

  end;

(*
  // CampoVariantNulo
  TCampoVariantNulo = class
  private
    FValorCampo : String;
    FENulo : Boolean;

    procedure SetCampoVariantNulo(const Value: String);
    function GetCampoVariantNulo: String;
  public
    constructor Create(Valor : TCampoVariantNulo); overload;

    property ValorCampo : String read GetCampoVariantNulo write SetCampoVariantNulo;
    property ENulo : Boolean read FENulo write FENulo;

  end;
*)


implementation

uses
  System.Variants;





{ TClasseBase }

constructor TClasseBase.Criar;//(TipoBD : Byte);
begin
  inherited;
  // 0 - Sql Server    1 - SqLite;
  {$IFDEF MODULOCLIENTE}
  FTipoBancoDados := 1
  {$ELSE}
  FTipoBancoDados := 0;
  {$ENDIF}

//  FTipoBancoDados := TipoBD;
end;



(*
{ TCampoVariantNulo }

constructor TCampoVariantNulo.Create(Valor : TCampoVariantNulo);
begin
//  inherited Create;
  Self := Valor;
end;

function TCampoVariantNulo.GetCampoVariantNulo: String;
begin
  if (Self = nil) then
    Self := TCampoVariantNulo.Create;

  if ENulo then
    Result := 'null'
  else
    Result := FValorCampo;
end;

procedure TCampoVariantNulo.SetCampoVariantNulo(const Value: String);
begin
  if (Self = nil) then
    Self := TCampoVariantNulo.Create;

  if VarIsEmpty(Value) or VarIsNull(Value) then
    ENulo := True
  else
    ENulo := False;

  FValorCampo := Value;
end;
*)

end.
