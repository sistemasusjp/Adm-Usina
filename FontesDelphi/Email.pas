unit Email;

interface

uses
  Forms,
  System.Classes,
  ClipBrd;

  procedure Enviar_Email_Aviso_Gestor( SaudacaoENome, EMailDestino, CentroCusto, Conta,
                                       Valor, QuemEfetuou, Quando : String; Beta : Boolean );

  procedure Enviar_Email_Esquecimento_Senha( SaudacaoENome, EMailDestino,
                                             Usuario, SenhaNova : String; Beta : Boolean );




implementation

uses
  IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile,
  IdExplicitTLSClientServerBase, System.SysUtils, Winapi.Windows,
  uConfig_Orcamento;

const
  Tipo_Email_Esquecimento_Senha = 0;
  Tipo_Email_Gestor = 1;

  MsgAssunto_Esquecimento_Senha = 'Esquecimento de Senha (Or�amento USJP)';
  MsgAssunto_Gestor = 'Foi efetuado um lan�amento no seu Centro de Custos (Or�amento USJP)';
  MsgAviso_Gestor = 'Foi efetuado um lan�amento no sistema Or�amento USJP no seu Centro de Custo abaixo identificado.';
  MsgEsclarec_Gestor = 'Para mais esclarecimentos entre em contato com a pessoa acima identificada que efetuou o lan�amento. ';
  MsgNaoResponda = 'Esta mensagem foi gerada automaticamente pelo sistema <b>Or�amento USJP</b>. Favor n�o responder.';

var
  // vari�veis e objetos necess�rios para o envio
  IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
//  sAnexo: string;


var
  SaudacaoENome_Local,
  EMailDestino_Local,
  CentroCusto_Local,
  Conta_Local,
  Valor_Local,
  QuemEfetuou_Local,
  Quando_Local,
  Usuario_Local,
  SenhaNova_Local : String;



procedure MontarCorpo_Email(Tipo_Email : Byte);
begin
  case Tipo_Email of
    Tipo_Email_Esquecimento_Senha :
        begin
          IdText.Body.Add('Foi solicitado o envio de uma nova senha por e-mail para acesso ao sistema '+CONST_NomeSistema+'.<br>');
          IdText.Body.Add('Essa nova senha deve ser trocada no seu pr�ximo acesso.<br>');
          IdText.Body.Add('Para alter�-la acesse o sistema com a senha abaixo e no Menu Principal � esquerda clique em Alterar Senha.<br>');
          IdText.Body.Add('<BLOCKQUOTE>');
          IdText.Body.Add('Seu Usu�rio � <b>'+Trim(Usuario_Local)+'</b>');
          IdText.Body.Add('</BLOCKQUOTE>');
//          IdText.Body.Add('<br>');
          IdText.Body.Add('<BLOCKQUOTE>');
          IdText.Body.Add('<b>Sua Nova Senha � <font color="blue">'+Trim(SenhaNova_Local)+'</font></b>');
          IdText.Body.Add('</BLOCKQUOTE>');
        end;
    Tipo_Email_Gestor :
        begin
          IdText.Body.Add('<font color="black"><b>'+MsgAviso_Gestor+'</b></font>');
          IdText.Body.Add('<BLOCKQUOTE>');
          IdText.Body.Add('Centro de Custo:');
          IdText.Body.Add('<font color="blue">'+CentroCusto_Local+'</font>');
          IdText.Body.Add('<br>');
          IdText.Body.Add('Conta:');
          IdText.Body.Add('<font color="blue">'+Conta_Local+'</font>');
          IdText.Body.Add('<br>');
          IdText.Body.Add('Valor:');
          IdText.Body.Add('<font color="blue">'+Valor_Local+'</font>');
          IdText.Body.Add('<br>');
          IdText.Body.Add('Quem efetuou:');
          IdText.Body.Add('<font color="blue">'+QuemEfetuou_Local+'</font>');
          IdText.Body.Add('<br>');
          IdText.Body.Add('Quando:');
          IdText.Body.Add('<font color="blue">'+QuemEfetuou_Local+'</font>');
          IdText.Body.Add('</BLOCKQUOTE>');
        end;
  end;
end;





// Vis�vel s� localmente
procedure EnviarEmail( Tipo_Email : Byte; Beta : Boolean );
begin
  // instancia��o dos objetos
  IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);

  try
    // Configura��o do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmClient;

    // Configura��o do servidor SMTP (TIdSMTP)
//    IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
//    IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.Port := 25;//465;
    IdSMTP.Host := 'mail.usjp.com.br';
    IdSMTP.Username := 'sistemas@usjp.com.br';
    IdSMTP.Password := 'mail@S!stema';

    IdSMTP.AuthType := satDefault;
    IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;

    // Configura��o da mensagem (TIdMessage)
//    IdMessage.From.Address := 'naoresponda@usjp.com.br';
    IdMessage.From.Name := 'Sistemas USJP';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := EMailDestino_Local;
//    IdMessage.Recipients.Add.Text := 'destinatario2@email.com'; // opcional
//    IdMessage.Recipients.Add.Text := 'destinatario3@email.com'; // opcional

    case Tipo_Email of
      Tipo_Email_Esquecimento_Senha :
          IdMessage.Subject := MsgAssunto_Esquecimento_Senha;

      Tipo_Email_Gestor :
          IdMessage.Subject := MsgAssunto_Gestor;
    end;

    IdMessage.Encoding := meMIME;

//    {$REGION 'Corpo em texto'}
//    // Configura��o do corpo do email (TIdText)
//    IdText := TIdText.Create(IdMessage.MessageParts);
//    IdText.Body.Add('Corpo do e-mail');
//    IdText.ContentType := 'text/plain; charset=iso-8859-1';
//    {$ENDREGION}

    {$REGION 'Corpo em HTML'}
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('<html>');
    IdText.Body.Add('<body>');

    if Beta then
      IdText.Body.Add('<h3><font color="red">Aten��o! Est� � uma mensagem de teste e deve ser desconsiderada.</font></h3>');

    IdText.Body.Add(SaudacaoENome_Local+',');
    IdText.Body.Add('<p>');

    MontarCorpo_Email(Tipo_Email);

    IdText.Body.Add('<p>');

    if (Tipo_Email = Tipo_Email_Gestor) then
      IdText.Body.Add('<font color="black">'+MsgEsclarec_Gestor+'</font>');

    IdText.Body.Add('<p>');
    IdText.Body.Add('<i><font color="#993300">'+MsgNaoResponda+'</font></i> ');
    IdText.Body.Add('</body>');
    IdText.Body.Add('</html>');
    IdText.ContentType := 'text/html; charset=iso-8859-1';
    {$ENDREGION}

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
//    sAnexo := 'C:\Anexo.pdf';
//    if FileExists(sAnexo) then
//      begin
//        TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
//      end;

    // Conex�o e autentica��o
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        Application.MessageBox(PWideChar('Erro na conex�o ou autentica��o: ' +
                                          E.Message), 'Erro', MB_ICONERROR+MB_OK);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      Application.MessageBox('Mensagem enviada com sucesso!', 'Informa��o', MB_ICONINFORMATION+MB_OK);
    except
      On E:Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao enviar a mensagem: ' +
                                          E.Message), 'Erro', MB_ICONERROR+MB_OK);
      end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // libera��o da DLL
    UnLoadOpenSSLLibrary;
    // libera��o dos objetos da mem�ria
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocketOpenSSL);
    FreeAndNil(IdSMTP);
  end;
end;






procedure Enviar_Email_Aviso_Gestor( SaudacaoENome, EMailDestino, CentroCusto, Conta,
                                     Valor, QuemEfetuou, Quando : String; Beta : Boolean );//(Sender : TComponent);
begin
  SaudacaoENome_Local:= SaudacaoENome;
  EMailDestino_Local:= EMailDestino;
  CentroCusto_Local:= CentroCusto;
  Conta_Local:= Conta;
  Valor_Local:= Valor;
  QuemEfetuou_Local:= QuemEfetuou;
  Quando_Local := Quando;

  EnviarEmail(Tipo_Email_Gestor, Beta);
end;


procedure Enviar_Email_Esquecimento_Senha( SaudacaoENome, EMailDestino,
                                           Usuario, SenhaNova : String; Beta : Boolean );
begin
  SaudacaoENome_Local := SaudacaoENome;
  EMailDestino_Local := EMailDestino;
  Usuario_Local := Usuario;
  SenhaNova_Local := SenhaNova;

  EnviarEmail(Tipo_Email_Esquecimento_Senha, Beta);
end;


end.
