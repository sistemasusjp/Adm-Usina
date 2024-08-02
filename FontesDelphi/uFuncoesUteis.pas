unit uFuncoesUteis;

interface

uses
  Windows, Winapi.Messages,
  Vcl.StdCtrls, Vcl.Forms,
  FireDAC.Comp.Client,
  System.UITypes, System.Classes, System.Variants,
  System.SysUtils, IdIPWatch,
  Data.Bind.Components, System.Rtti,
  ClipBrd;



procedure AjustarConfigRegionais;

procedure ReporConfigRegionais;

procedure Clipboard_GravarString(const Str: string);

procedure Clipboard_ObterString(out Str: string);


function IPGet : String;

function FormatarData(TipoBD : Byte; Data: TDateTime; Segundos : Boolean = False): String;

function GetSelectedValue(AObject: TObject): TValue;

procedure GravarLog(Memo : TMemo; Mensagem : String; AtualizarTela : Boolean = True);

{$IFDEF MSWINDOWS}
function NomeDoComputador: String;
{$ENDIF}

function RemoverAspas(Texto : String): String;

function TestarCampoNulo(ValorCampo: Variant): String;

function TestarCampoStringNulo(ValorCampo: String): String;

function TestarCampoNumeriroNulo(ValorCampo: String): String;

function SoNumeros(S : String) : Boolean;

function SoNumeros2(S : String) : Boolean;

function SemanaDoAno(Data: TDateTime{; var Year: Word}): Word;

function UltimoDiaMes(Mdt: TDateTime) : TDateTime;


function CalcularPeriodo( TipoPeriodo : String;
                          InicioOuFim : Integer;
                          DataPeriodo : TDateTime;
                          Hora_Inicio_Periodo : String = '';
                          Hora_Fim_Periodo : String = '' ) : TDateTime;


function GetDataBase0 : Integer;

function HoraInteiroParaDataHora(I : Double) : TDateTime;

function DataHoraParaDataInteiro(D : TDateTime) : Double;

function TratarErroSincronizacao(Mensagem : String) : String;

{$IFDEF MSWINDOWS}
procedure RolarMemo(Memo: TMemo; Direction: Integer);

function VersaoAtual(VersaoOuCompilac : Byte = 0; Arquivo : String = '') : String;
{$ENDIF}





implementation



uses
  System.Types, uConfig_AcessoRefeitorio;

const
  cSegundosPorDia = 24 * 60 * 60;


var
  PontoDecimal : Char;
  FDataBase0 : Integer = 0;




procedure Clipboard_GravarString(const Str: string);
begin
  ClipBoard.SetTextBuf(PWideChar(Str));
end;


procedure Clipboard_ObterString(out Str: string);
begin
  ClipBoard.GetTextBuf(PWideChar(Str), SizeOf(ClipBoard.ToString));
end;



procedure AjustarConfigRegionais;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  PontoDecimal := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
end;



procedure ReporConfigRegionais;
begin
  FormatSettings.DecimalSeparator := PontoDecimal;
end;



function IPGet : String;
var
  r : TIdIPWatch;
begin
  Result := '';
  r := TIdIPWatch.Create(nil);
  Result := r.LocalIP;
  r.free;
end;




function FormatarData( TipoBD : Byte; Data: TDateTime;
                       Segundos : Boolean = False): String;
var
  Formato : String;
begin
//  case TipoBD of
//    0  : if Segundos then
//           Result := FormatDateTime('dd-mm-yyyy hh:mm:ss', Data) // Sql Server
//         else
//           Result := FormatDateTime('dd-mm-yyyy hh:mm', Data); // Sql Server
//    1  : if Segundos then
//           Result := FormatDateTime('yyyy-mm-dd hh:mm:ss', Data) // SqLite
//         else
//           Result := FormatDateTime('yyyy-mm-dd hh:mm', Data); // SqLite
//  end;

  case TipoBD of
    0  : Formato := FormatDateTime('dd-mm-yyyy hh:mm', Data); // Sql Server
    1  : Formato := FormatDateTime('yyyy-mm-dd hh:mm', Data); // SqLite
  end;

  if Segundos then
    Formato := Formato + ':ss';

  Result := FormatDateTime(Formato, Data);
end;



function GetSelectedValue(AObject : TObject): TValue;
var
  LEditor : IBindListEditorCommon;
begin
  LEditor := GetBindEditor(AObject, IBindListEditorCommon) as IBindListEditorCommon;
  Result := LEditor.SelectedValue;
end;



procedure GravarLog(Memo : TMemo; Mensagem : String; AtualizarTela : Boolean = True);
begin
  Memo.Lines.Insert(0, FormatDateTime('hh:mm:ss ', now())+' '+Mensagem);
  //RolarMemo(Memo, SB_LINEDOWN);
  if AtualizarTela then
    Application.ProcessMessages;
end;


{$IFDEF MSWINDOWS}
function NomeDoComputador: String;
var
   ComputerPointer: PChar; //Usando dessa forma dá erro (as vezes) de Invalid Pointer no Windows 10
//   Computer: String;
   CSize: DWORD;
begin
//  Computer := #0; Usando dessa forma dá erro (as vezes) de Invalid Pointer no Windows 10
  CSize:= Windows.MAX_COMPUTERNAME_LENGTH + 1;
  try
    GetMem(ComputerPointer,CSize);// Usando dessa forma dá erro (as vezes) de Invalid Pointer no Windows 10
//    SetLength(Computer,CSize);
    if Windows.GetComputerName(PChar(ComputerPointer), CSize) then
      Result := ComputerPointer;

  finally
//    FreeMem(ComputerPointer); Usando dessa forma dá erro (as vezes) de Invalid Pointer no Windows 10
  end;
end;
{$ENDIF}



function RemoverAspas(Texto : String): String;
begin
  Result := StringReplace(Texto, Chr(39), ' ', [rfReplaceAll]);
end;




function TestarCampoNulo(ValorCampo: Variant): String;
begin
//  if (ValorCampo = Unassigned) then //or (ValorCampo = varNull) then
  if VarIsNull(ValorCampo) or VarIsEmpty(ValorCampo) then
    Result := 'null'
  else
    Result := ValorCampo;
end;


function TestarCampoStringNulo(ValorCampo: String): String;
begin
  if (ValorCampo = 'null') or (ValorCampo = '') then
    Result := 'null'
  else
    Result := ''''+ValorCampo+''''; // ValorCampo;
end;



function TestarCampoNumeriroNulo(ValorCampo: String): String;
begin
  if (ValorCampo = 'null') or (ValorCampo = '') then
    Result := 'null'
  else
    Result := ValorCampo;
end;



function SemanaDoAno(Data: TDateTime{; var Year: Word}): Word;
var
  Y, M, D: Word;
  FDay: Word;
  Days: Integer;
  JanF: TDateTime;
begin
  try
    DecodeDate(Data, Y, M, D);
    //Year := Y;
    JanF := EncodeDate(Y, 1, 1);
    FDay := DayOfWeek(JanF);
    Days := Trunc(Int(Data) - JanF) + (7 - DayOfWeek(Data - 1)) +
      (7 * ord(FDay in [2 .. 5]));
    Result := Days div 7;

    if Result = 0 then
    begin
      if (DayOfWeek(EncodeDate(Y - 1, 1, 1)) > 5) or
        (DayOfWeek(EncodeDate(Y - 1, 12, 31)) < 5) then
        Result := 52
      else
        Result := 53;
      //Year := Y - 1;
    end
    else if Result = 53 then
    begin
      if (FDay > 5) or (DayOfWeek(EncodeDate(Y, 12, 31)) < 5) then
      begin
        Result := 1;
        //Year := Y + 1;
      end;
    end;
  except
    Result := 0;
  end;
end;



function SoNumeros(S : String) : Boolean;
var
  i: integer;
begin
  Result := TryStrToInt(S, i);
end;



function SoNumeros2(S : String) : Boolean;
begin
  // Se o valor for negativo, quer dizer q nao conseguiu converter.
  // O -1 é o valor default em case de erro de conversao, e pode ser modificado a vontade
  Result := StrtoIntDef(S, -1) >= 0;
end;





function UltimoDiaMes(Mdt: TDateTime) : TDateTime;
//retorna o ultimo dia o mes, de uma data fornecida
var
  ano, mes, dia : word;
  mDtTemp : TDateTime;

begin
  Decodedate(mDt, ano, mes, dia);
  mDtTemp := (mDt - dia) + 33;
  Decodedate(mDtTemp, ano, mes, dia);
  Result := mDtTemp - dia;
end;






function CalcularPeriodo( TipoPeriodo : String;
                          InicioOuFim : Integer;
                          DataPeriodo : TDateTime;
                          Hora_Inicio_Periodo : String = '';
                          Hora_Fim_Periodo : String = '' ) : TDateTime;
var
  Semana : Word;
  i : Integer;

begin
  TipoPeriodo := UpperCase(Trim(TipoPeriodo));

  if StrToDateTime(FormatDateTime('dd/mm/yyyy hh:mm:ss', DataPeriodo)) >=
     StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Inicio_Periodo, DataPeriodo)) then
    DataPeriodo := StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Inicio_Periodo, DataPeriodo))
  else
    DataPeriodo := StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Fim_Periodo, DataPeriodo))-1;

  if TipoPeriodo = 'S' then
    begin
      Semana := SemanaDoAno(DataPeriodo);
      i := 1;
      DataPeriodo := DataPeriodo - (i * -InicioOuFim);
      while (i <= 7) and (Semana = SemanaDoAno(DataPeriodo)) do
      begin
        inc(i, -InicioOuFim);
        DataPeriodo := DataPeriodo - (1 * -InicioOuFim);
      end;

      if InicioOuFim = -1 then
        Result := StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Inicio_Periodo, DataPeriodo + (1 * -InicioOuFim)))
      else
        Result := StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Fim_Periodo, DataPeriodo + (1 * -InicioOuFim)))
                  + 1; // +1 pra fechar o período correto pois não encerra às 0:00 / 23:59
    end
  else
    if InicioOuFim = -1 then
      Result := StrToDateTime(FormatDateTime('01/mm/yyyy '+Hora_Inicio_Periodo, DataPeriodo))
    else
      Result := StrToDateTime(FormatDateTime('dd/mm/yyyy '+Hora_Fim_Periodo, UltimoDiaMes(DataPeriodo)))
                  + 1; // +1 pra fechar o período correto pois não encerra às 0:00 / 23:59
end;




function GetDataBase0 : Integer;
begin
  if FDataBase0 = 0 then //pra não fazer o calc td hora
    FDataBase0 := Trunc(EncodeDate(1970, 1, 1));

  Result := FDataBase0;
end;




function HoraInteiroParaDataHora(I : Double) : TDateTime;
begin
  Result := FloatToDateTime(i);
//  Result := I / cSegundosPorDia + GetDataBase0;
end;




function DataHoraParaDataInteiro(D : TDateTime) : Double;
begin
//  Result := Trunc((D - GetDataBase0) * cSegundosPorDia);
//  Result := (D - GetDataBase0) * cSegundosPorDia;
  Result := D;
end;




function TratarErroSincronizacao(Mensagem : String) : String;
begin
  if Pos(UpperCase('Connection Closed Gracefully'), UpperCase(Mensagem)) > 0 then
    Result := 'Conexão com servidor perdida.'
  else
    if Pos(UpperCase('Connection reset by peer'), UpperCase(Mensagem)) > 0 then
      Result := 'Conexão finalizada pelo servidor.'
    else
      if Pos(UpperCase('Network is unreachable'), UpperCase(Mensagem)) > 0 then
        Result := 'Dispositivo não conectado à rede.'
      else
        if Pos(UpperCase('No route to host'), UpperCase(Mensagem)) > 0 then
          Result := 'Servidor não encontrado na rede.'
        else
          if Pos(UpperCase('Connection timed out'), UpperCase(Mensagem)) > 0 then
            Result := 'Conexão com o servidor demorou mais do que o esperado.'
          else
            if Pos(UpperCase('Connection Refused'), UpperCase(Mensagem)) > 0 then
              Result := 'Conexão com o servidor negada.'
            else
              if Pos(UpperCase('Read timeout'), UpperCase(Mensagem)) > 0 then
                Result := 'Tempo para conexão/comunicação esgotado.'
              else
                Result := 'Mensagem Original: '+Mensagem;
end;




{$IFDEF MSWINDOWS}
//  RolarMemo(Memo1, SB_LINEUP); // Rola para o início
//  RolarMemo(Memo1, SB_LINEDOWN); // Rola para o final
procedure RolarMemo(Memo: TMemo; Direction: Integer);
var
  ScrollMessage: TWMVScroll;
  I: Integer;
begin
  ScrollMessage.Msg := WM_VSCROLL;
  Memo.Lines.BeginUpdate;
  try
    for I := 0 to Memo.Lines.Count do
    begin
     ScrollMessage.ScrollCode := Direction;
     ScrollMessage.Pos := 0;
     Memo.Dispatch(ScrollMessage);
    end;
  finally
    Memo.Lines.EndUpdate;
  end;
end;



function VersaoAtual(VersaoOuCompilac : Byte = 0; Arquivo : String = '') : String;
const
  // Parâmetros de versão
  InfoStr : array[1..11] of String = ( 'CompanyName',
                                       'FileDescription',
                                       'FileVersion',
                                       'InternalName',
                                       'LegalCopyRight',
                                       'LegalTradeMarks',
                                       'OriginalFileName',
                                       'ProductName',
                                       'ProductVersion',
                                       'Comments',
                                       'Author');
  // Labels de apresentação
  LabelStr : array[1..11] of String = ( 'Companhia',
                                        'Descrição',
                                        'Versão do arquivo',
                                        'Nome Interno',
                                        'CopyRight',
                                        'Marca registrada',
                                        'Nome original',
                                        'Nome do produto',
                                        'Versão do produto',
                                        'Comentários',
                                        'Autor');

var
  TamVer, i, ipontos : integer;
  Dummy : DWord;
  Tam : UINT;
  VerInfo : PChar;
  Valor,
  Translation : Pointer;
  VerBegin, Versao, Compilac, Pontos : String;

begin
  if Arquivo = '' then
    Arquivo := ParamStr(0);

  // Obtém tamanho da informação de versão
  TamVer := GetFileVersionInfoSize(PChar(Arquivo), Dummy);

  // Se o tamanho for maior que 0 é porque tem a informação de versão
  if TamVer > 0 then
    begin
      // Aloca memória para armazenar a versão
      GetMem(VerInfo, TamVer);

      // Obtém informação de versão
      GetFileVersionInfo(PChar(Arquivo), 0, TamVer, VerInfo);
      // Obtém informação de língua
      VerQueryValue(VerInfo, '\\VarFileInfo\\Translation', Translation, Tam);
      // Inicia a variável para obter informações
      VerBegin := '\\StringFileInfo\\'+
                  IntToHex(LoWord(LongInt(Translation^)), 4)+
                  IntToHex(HiWord(LongInt(Translation^)), 4)+'\\';
      // Obtém as informações
      for i := 1 to 11 do
        if VerQueryValue(VerInfo, PChar(VerBegin+InfoStr[i]), Valor, Tam) then
          // Se Tam > 0 então tem a informação
          if Tam > 0 then
            if i = 3 then
              begin
                Pontos := '';
                Versao := '';
                Compilac := '';
                for ipontos := 1 to Length(String(PChar(Valor))) do
                  if Pontos = '...' then
                    Compilac := Compilac+String(PChar(Valor))[ipontos]
                  else
                    begin
                      if String(PChar(Valor))[ipontos] = '.' then
                        Pontos := Pontos+String(PChar(Valor))[ipontos];

                      if Pontos <> '...' then
                         Versao := Versao+String(PChar(Valor))[ipontos]
                    end;

                case VersaoOuCompilac of
                  0  :  Result := Versao;
                  1  :  Result := Compilac;
                end;
              end;

      // Libera a memória alocada
      FreeMem(VerInfo, TamVer);
    end
  else
    if Arquivo = ParamStr(0) then
      Result := '5'
    else
      Result := ''
end;
{$ENDIF}

end.

