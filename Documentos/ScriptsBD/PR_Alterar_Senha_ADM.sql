USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
	   Altera a senha ou reseta para a senha padrão.
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   14/02/2016  Geraldo          Criação
   16/02/2017  Geraldo		    Renomeada de PR_Formatar_Dados_Para_Log_ADM_Usina para PR_Formatar_Dados_Para_Log_ADM
   22/04/2020  Geraldo		    Passou a gravar 0 (false) no campo fl_ObrigarAlteracaoSenha ao fazer Update

   Obs:     
  ============================================================================
    Testar:

    declare  @Retorno                VARCHAR(4000)
    EXEC PR_Alterar_Senha_ADM 
    select @Retorno
    
*/  
ALTER
PROCEDURE dbo.PR_Alterar_Senha_ADM (
									 @id_UsuUsi			INTEGER,
									 @de_Senha			VARCHAR(128) = NULL,
									 @tp_FormatoSenha		INTEGER = NULL,
									 @de_EmailSeguranca	     VARCHAR(255) = NULL,
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
    DECLARE @DadosLog VARCHAR(4000)
    DECLARE @Observacao VARCHAR(1000)
    DECLARE @PassoAtual VARCHAR(40) = ''
    DECLARE @OperacaoAtual VARCHAR(20) = ''


    SET @Retorno = '';
    SET @tp_Operacao = UPPER(RTRIM(LTRIM(@tp_Operacao)));

    ---- Verifica se já existe
    --SET @Existe = 0
    --SET @Identity = 0

    -- Comentado em 13/02/2017
    --IF ISNULL(@tp_Operacao, '') = ''
    --BEGIN
	   --SET @Retorno = 'Operaçao inválida.';
    --END

    IF (@de_Senha = '')
	   SET @de_Senha = NULL 

    --------------------------
    -- 
    BEGIN TRY
	   BEGIN TRANSACTION;

			 -- Pessoa ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'Usuario_Usina'

			 IF NOT EXISTS( SELECT id_UsuUsi FROM Usuario_Usina WHERE id_UsuUsi = @id_UsuUsi )
				BEGIN
				    -- Registra no Log que o usuário não existe
				    SET @PassoAtual = 'Log: Usuario_Usina não existe'
				    --SET @Observacao = '@id_UsuUsi = ' + CAST(@id_UsuUsi AS VARCHAR)

				    --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Usina', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Usina', @id_UsuUsi, @DadosLog OUTPUT 	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'ERRO', --@tp_Log varchar(20),
							 'Usuario_Usina', --@nm_TabelaAcao varchar(255),
							 @id_UsuUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Alterar_Senha_ADM', --@de_Origem varchar(255),
							 'Usuario_Usina não existe.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 '' --@Retorno				
				END
			 ELSE
				IF NOT EXISTS( SELECT id_UsuUsi FROM Usuario_Seguranca WHERE id_UsuUsi = @id_UsuUsi )				   
				    BEGIN
					   -- Segurança INC ------------------------------------------------------------------------------------------------------
		  			   SET @OperacaoAtual = 'inserir'
					   SET @PassoAtual = 'Usuario_Seguranca'

					   INSERT INTO Usuario_Seguranca
						  (id_UsuUsi, de_Senha, tp_FormatoSenha, de_EmailSeguranca)
					   VALUES
						  (@id_UsuUsi, @de_Senha, @tp_FormatoSenha, @de_EmailSeguranca)

					   IF @@ERROR <> 0
						  BEGIN
							 SET @Retorno = 'Erro ao inserir Usuario_Seguranca. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
						  END
						  
					   -- Log: Usuario_Seguranca INC -----------------------------------------------------------------
					   SET @PassoAtual = 'Log: Usuario_Seguranca'
--					   SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Seguranca', @id_UsuUsi)	
    					   EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Seguranca', @id_UsuUsi, @DadosLog OUTPUT 	
					   EXEC PR_Adicionar_Log_Adm_Usina 
								null, -- @dt_Log datetime = ,
								'INCLUIU', --@tp_Log varchar(20),
								'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
								@id_UsuUsi, --@id_RegistroAcao int,
								@DadosLog, --@de_Dados varchar(4000),
								'PR_Alterar_Senha_ADM', --@de_Origem varchar(255),
								'Incluído Usuario_Seguranca com sucesso.', --@de_Mensagem varchar(1000),
								@Observacao, --@de_Observacao varchar(1000),
								@Computador_Usuario, --@cod_Dispositivo varchar(15),
								@id_Sistema,--@id_Sistema int,
								@id_UsuUsiOperacao, --@id_UsuUsi int,
								'' --@Retorno
				    END
				ELSE
				    BEGIN
					   -- Usuario_Seguranca ATU ------------------------------------------------------------------------------------------------------
	   		  		   SET @OperacaoAtual = 'atualizar'

					   -- Se for para resetar a senha
					   IF @tp_Operacao = 'RES'
					   BEGIN
						  --CRIAR ESSA TABELA NO ADM => SELECT @de_Senha = de_ValorParam FROM Parametro WHERE nm_Param = 'SenhaPadrao'
						  SET @de_Senha = '123Mudar'
					   END


					   UPDATE Usuario_Seguranca
						  SET de_Senha = ISNULL(@de_Senha, de_Senha)
						    , tp_FormatoSenha = ISNULL(@tp_FormatoSenha, tp_FormatoSenha)
						    , de_EmailSeguranca = ISNULL(@de_EmailSeguranca, de_EmailSeguranca)
						    , dt_UltimaModificacaoSenha = GETDATE()
							, fl_ObrigarAlteracaoSenha = 0 -- Add 22/04/2020
					   WHERE id_UsuUsi = @id_UsuUsi

					   IF @@ERROR <> 0
						  BEGIN
							 SET @Retorno = 'Erro ao alterar Usuario_Seguranca. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
						  END
					   ELSE


					   -- Log: Usuario_Seguranca ATU ------------------------------------------------------------------------------------------------
		  			   SET @PassoAtual = 'Log: Usuario_Seguranca'
--					   SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Seguranca', @id_UsuUsi)	
    				   EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Seguranca', @id_UsuUsi, @DadosLog OUTPUT 	

					   EXEC PR_Adicionar_Log_Adm_Usina 
								null, -- @dt_Log datetime = ,
								'ALTEROU', --@tp_Log varchar(20),
								'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
								@id_UsuUsi, --@id_RegistroAcao int,
								@DadosLog, --@de_Dados varchar(4000),
								'PR_Alterar_Senha_ADM', --@de_Origem varchar(255),
								'Alterada Usuario_Seguranca com sucesso.', --@de_Mensagem varchar(1000),
								@Observacao, --@de_Observacao varchar(1000),
								@Computador_Usuario, --@cod_Dispositivo varchar(15),
								@id_Sistema,--@id_Sistema int,
								@id_UsuUsiOperacao, --@id_UsuUsi int,
								'' --@Retorno

				    END

	   COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
	   SET @Retorno = 'Erro ao '+@OperacaoAtual+' '+@PassoAtual
				+' - id_UsuUsi: '+ISNULL(CAST(@id_UsuUsi AS VARCHAR), '')
				+'. PR_Alterar_Senha_ADM. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

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