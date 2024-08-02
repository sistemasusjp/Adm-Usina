unit Email;

interface

uses
  Forms,
  System.Classes,
  ClipBrd;

procedure EnviarEmail( SaudacaoENome, EMailDestino, CentroCusto, Conta,
                       Valor, QuemEfetuou, Quando : String; Beta : Boolean );//(Sender : TComponent);

implementation

uses
  IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile,
  IdExplicitTLSClientServerBase, System.SysUtils, Winapi.Windows;

const
  MsgAssunto = 'Foi efetuado um lançamento no seu Centro de Custos (Orçamento USJP)';
  MsgAviso = 'Foi efetuado um lançamento no sistema Orçamento USJP no seu Centro de Custo abaixo identificado.';
  MsgEsclarec = 'Para mais esclarecimentos entre em contato com a pessoa acima identificada que efetuou o lançamento. ';
  MsgNaoResponda = 'Esta mensagem foi gerada automaticamente pelo sistema <b>Orçamento USJP</b>. Favor não responder.';



procedure EnviarEmail( SaudacaoENome, EMailDestino, CentroCusto, Conta,
                       Valor, QuemEfetuou, Quando : String; Beta : Boolean );//(Sender : TComponent);
var
  // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
//  sAnexo: string;
begin
  // instanciação dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);

  try
    // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    // Configuração do servidor SMTP (TIdSMTP)
//    IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
//    IdSMTP.UseTLS := utUseImplicitTLS;
//    IdSMTP.AuthType := satNone;
    IdSMTP.Port := 587;
    IdSMTP.Host := 'mail.infonet.com.br';
    IdSMTP.Username := 'sistemas.usjp';
    IdSMTP.Password := 'sisusjp';

    // Configuração da mensagem (TIdMessage)
//    IdMessage.From.Address := 'naoresponda@usjp.com.br';
    IdMessage.From.Name := 'Sistemas USJP';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := EMailDestino;
//    IdMessage.Recipients.Add.Text := 'destinatario2@email.com'; // opcional
//    IdMessage.Recipients.Add.Text := 'destinatario3@email.com'; // opcional
    IdMessage.Subject := MsgAssunto;
    IdMessage.Encoding := meMIME;

//    {$REGION 'Corpo em texto'}
//    // Configuração do corpo do email (TIdText)
//    IdText := TIdText.Create(IdMessage.MessageParts);
//    IdText.Body.Add('Corpo do e-mail');
//    IdText.ContentType := 'text/plain; charset=iso-8859-1';
//    {$ENDREGION}

    {$REGION 'Corpo em HTML'}
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('<html>');
    IdText.Body.Add('<body>');

    if Beta then
      IdText.Body.Add('<h3><font color="red">Atenção! Está é uma mensagem de teste e deve ser desconsiderada.</font></h3>');

    IdText.Body.Add('Prezado '+SaudacaoENome+',');
    IdText.Body.Add('<p>');
    IdText.Body.Add('<font color="black"><b>'+MsgAviso+'</b></font>');
    IdText.Body.Add('<BLOCKQUOTE>');
    IdText.Body.Add('Centro de Custo:');
    IdText.Body.Add('<font color="blue">'+CentroCusto+'</font>');
    IdText.Body.Add('<br>');
    IdText.Body.Add('Conta:');
    IdText.Body.Add('<font color="blue">'+Conta+'</font>');
    IdText.Body.Add('<br>');
    IdText.Body.Add('Valor:');
    IdText.Body.Add('<font color="blue">'+Valor+'</font>');
    IdText.Body.Add('<br>');
    IdText.Body.Add('Quem efetuou:');
    IdText.Body.Add('<font color="blue">'+QuemEfetuou+'</font>');
    IdText.Body.Add('<br>');
    IdText.Body.Add('Quando:');
    IdText.Body.Add('<font color="blue">'+Quando+'</font>');
    IdText.Body.Add('</BLOCKQUOTE>');
    IdText.Body.Add('<p>');
    IdText.Body.Add('<font color="black">'+MsgEsclarec+'</font>');
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

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        Application.MessageBox(PWideChar('Erro na conexão ou autenticação: ' +
                                          E.Message), 'Erro', MB_ICONERROR+MB_OK);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      Application.MessageBox('Mensagem enviada com sucesso!', 'Informação', MB_ICONINFORMATION+MB_OK);
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
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

end.
