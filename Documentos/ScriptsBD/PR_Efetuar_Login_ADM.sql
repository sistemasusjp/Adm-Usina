USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
	   Verifica se o usuário pode efetuar o login de acordo com os dados fornecidos
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   25/08/2017  Geraldo          Criação

   Obs:     
  ============================================================================
    Testar:

    declare  @Retorno                VARCHAR(4000)
    EXEC PR_Efetuar_Login_ADM 
    select @Retorno
    
*/  
ALTER
PROCEDURE dbo.PR_Efetuar_Login_ADM (
							 --@id_UsuUsi			INTEGER,
							 @cd_Login			VARCHAR(30) = NULL,
							 @de_Senha			VARCHAR(128) = NULL,
							 @tp_Operacao			CHAR(3),
							 @id_UsuUsiOperacao		INTEGER,
							 @Computador_Usuario	VARCHAR(30),
							 @id_Sistema			INT,
							 @Retorno                VARCHAR(4000) OUTPUT
						  )


AS
BEGIN
    --DECLARE @Erro varchar
    --DECLARE @Exportou_para_GATEC bit
    --DECLARE @Exportou_para_PROTHEUS bit
    --DECLARE @Existe BIT;
    --DECLARE @Identity INTEGER;
    DECLARE @de_MensagemLog VARCHAR(4000)
    DECLARE @OperacaoAtual VARCHAR(20) = ''

    DECLARE  @id_UsuUsiAtual INT
           , @fl_BloqueadoAtual INT
		 , @fl_ExclusaoUsuUsiAtual INT
		 , @tp_FormatoSenhaAtual INT
		 , @de_SenhaAtual VARCHAR(128)
		 
    SET @Retorno = '';

    IF (@de_Senha = '')
	   SET @de_Senha = NULL 

    --------------------------
    -- 
    BEGIN TRY
	   BEGIN TRANSACTION;

		  SELECT @id_UsuUsiAtual = uu.id_UsuUsi
			  , @fl_BloqueadoAtual = fl_Bloqueado
			  , @fl_ExclusaoUsuUsiAtual = fl_ExclusaoUsuUsi
			  , @tp_FormatoSenhaAtual = tp_FormatoSenha
			  , @de_SenhaAtual = de_Senha
		  FROM Usuario_Usina uu 
			 JOIN Usuario_Seguranca us 
			 ON us.id_UsuUsi = uu.id_UsuUsi  
			 JOIN Pessoa_Usina pu 
			 ON pu.id_PesUsi = uu.id_PesUsi  
		  WHERE UPPER(cd_Login) = UPPER(@cd_Login)


	   IF @id_UsuUsiAtual IS NULL
		 SET @Retorno = 'Usuário não encontrado.'
	   ELSE
		IF (@fl_BloqueadoAtual = 1) 
		    SET @Retorno = 'Usuário Bloqueado.'
		ELSE
		  IF (@fl_ExclusaoUsuUsiAtual  = 1) 
			 SET @Retorno = 'Usuário Excluído.'
		  ELSE
		    IF NOT (@tp_FormatoSenhaAtual IN (0))
			    SET @Retorno = 'Formato de senha desconhecido.'
		    ELSE
			 IF ( @tp_FormatoSenhaAtual = 0 AND @de_SenhaAtual = @de_Senha ) 
				SET @Retorno = ''

	   IF @Retorno = ''
		  BEGIN
			 SET @de_MensagemLog = 'Login efetuado com sucesso.'

			 UPDATE Usuario_Seguranca 
				SET dt_UltimoLogin = GETDATE()
			 WHERE id_UsuUsi = @id_UsuUsiAtual
		  END
	   ELSE
		  SET @de_MensagemLog = @Retorno

	   EXEC PR_Adicionar_Log_Adm_Usina 
				null, -- @dt_Log datetime = ,
				'LOGIN', --@tp_Log varchar(20),
				NULL, --@nm_TabelaAcao varchar(255),
				NULL, --@id_RegistroAcao int,
				NULL, --@de_Dados varchar(4000),
				'PR_Efetuar_Login_ADM', --@de_Origem varchar(255),
				@de_MensagemLog, --@de_Mensagem varchar(1000),
				NULL, --@de_Observacao varchar(1000),
				@Computador_Usuario, --@cod_Dispositivo varchar(15),
				@id_Sistema,--@id_Sistema int,
				@id_UsuUsiOperacao, --@id_UsuUsi int,
				'' --@Retorno				

    END TRY
    BEGIN CATCH
	   SET @Retorno = 'Erro ao efetuar Login'
				+' - id_UsuUsi: '+ISNULL(CAST(@id_UsuUsiAtual AS VARCHAR), '')
				+'. PR_Efetuar_Login_ADM. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

	   ROLLBACK TRANSACTION;
    END CATCH;



    --	SELECT @Retorno

    IF @Retorno = ''
	   BEGIN
		  RETURN 0;
	   END;
    ELSE
	   BEGIN
		  RETURN 1;
	   END
END