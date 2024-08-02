/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
	   GEra uma a senha do usuário 
	   Se o @id_Gestor for nulo mostra todos os Centros de Custo (caso da Contabilidade)
	   => @CampoOrdem = 'Cod', 'Desc', 'Total'
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   09/09/2016  Geraldo          Criação
   13/02/2017  Geraldo          Alterado funcionamento, efetua o select primeira pra saber se é alteração ou inclusão
							  não considerando o @tp_Operacao
   16/02/2017  Geraldo		  - Renomeada de PR_Formatar_Dados_Para_Log_ADM_Usina para PR_Formatar_Dados_Para_Log_ADM
						  - Se já tiver senha nao altera a mesma a nao ser que seja passa no parametro 

   Obs:     
  ============================================================================
    Testar:

    declare  @Retorno   VARCHAR(4000)

    EXEC PR_Zerar_Senha_Usuario_ADM 
						@cd_Login		    = 'osmario',
						@id_Sistema		    = 4,
						@cod_Dispositivo    = 'SQL',
						@id_UsuUsiOperacao  = 1 ,
						@Retorno            = @Retorno OUTPUT

    select @Retorno    
*/  
ALTER -- CREATE
PROCEDURE dbo.PR_Zerar_Senha_Usuario_ADM (
										   @cd_Login		   VARCHAR(30),
										   @id_Sistema		   INT,
										   @cod_Dispositivo    VARCHAR(30),
										   @id_UsuUsiOperacao  INT,
										   @NovaSenha          VARCHAR(100) OUTPUT,
										   @Retorno            VARCHAR(4000) OUTPUT
									     )


AS
BEGIN
	DECLARE @id_UsuUsi INT
	      --, @NovaSenha VARCHAR(128)
		  , @DadosLog VARCHAR(4000)


    SELECT @id_UsuUsi = uu.id_UsuUsi
    FROM Usuario_Usina uu
    WHERE (uu.cd_Login = @cd_Login)

	-- Gera a nova senha temporária
	SET @NovaSenha = 'TMP' + SubString(CAST(RAND()*1000 AS VARCHAR(128)), 1, 3)

    BEGIN TRY
	   BEGIN TRANSACTION;

			UPDATE Usuario_Seguranca
				SET de_Senha = @NovaSenha
				  , fl_ObrigarAlteracaoSenha = 1
			WHERE id_UsuUsi = @id_UsuUsi


			IF @@ERROR <> 0
				BEGIN
					SET @Retorno = 'Erro ao alterar Usuario_Seguranca. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR)
				END;


    		--EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Seguranca', @id_UsuUsi, @DadosLog OUTPUT 	
			SET @DadosLog = 'id_UsuUsi: ' + CAST(@id_UsuUsi AS VARCHAR) + ' || cd_Login: '+@cd_Login

			EXEC PR_Adicionar_Log_Adm_Usina 
						null, -- @dt_Log datetime = ,
						'ALTEROU', --@tp_Log varchar(20),
						'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
						@id_UsuUsi, --@id_RegistroAcao int,
						@DadosLog, --@de_Dados varchar(4000),
						'PR_Zerar_Senha_Usuario_ADM', --@de_Origem varchar(255),
						'Gerada nova senha para o usuário.', --@de_Mensagem varchar(1000),
						NULL, --@de_Observacao varchar(1000),
						@cod_Dispositivo, --@cod_Dispositivo varchar(15),
						@id_Sistema,--@id_Sistema int,
						@id_UsuUsiOperacao, --@id_UsuUsi int,
						''  --@Retorno
			

	   COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SET @Retorno = 'Erro ao zerar senha do usuário.'

		DECLARE @de_Observacao_Log VARCHAR(1000)	

		SET @de_Observacao_Log = 'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

		EXEC PR_Adicionar_Log_Adm_Usina 
					null, -- @dt_Log datetime = ,
					'ERRO', --@tp_Log varchar(20),
					'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
					@id_UsuUsi, --@id_RegistroAcao int,
					@DadosLog, --@de_Dados varchar(4000),
					'PR_Zerar_Senha_Usuario_ADM', --@de_Origem varchar(255),
					'Erro ao zerar senha do usuário.', --@de_Mensagem varchar(1000),
					NULL, --@de_Observacao varchar(1000),
					@cod_Dispositivo, --@cod_Dispositivo varchar(15),
					@id_Sistema,--@id_Sistema int,
					@id_UsuUsiOperacao, --@id_UsuUsi int,
					''  --@Retorno
    END CATCH;

END