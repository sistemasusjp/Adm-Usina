USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   16/02/2017  Geraldo          Criação
   16/02/2017  Geraldo          

   Obs:     
  ============================================================================
    Testar:

    DECLARE  @Retorno                VARCHAR(4000)
	EXEC PR_Cad_UsuarioUsi_Sistema_ADM NULL, 4, 52, 'INC', 1, 'SQL',  @Retorno output
	SELECT @Retorno
    
    
*/  
ALTER 
PROCEDURE dbo.PR_Cad_UsuarioUsi_Sistema_ADM (
							 @id_UsuUsi_Sis		int = NULL,
							 @id_Sistema			int,
							 @id_UsuUsi			int,

							 @tp_Operacao			CHAR(3),
							 @id_UsuUsiOperacao		INTEGER,
							 @Computador_Usuario	VARCHAR(30),
							 @Retorno                VARCHAR(4000) OUTPUT
						  )


AS
BEGIN
    --DECLARE @Erro varchar
    --DECLARE @Exportou_para_GATEC bit
    --DECLARE @Exportou_para_PROTHEUS bit
    DECLARE @Existe BIT;
    DECLARE @DadosLog VARCHAR(4000)
    DECLARE @Observacao VARCHAR(1000)
    DECLARE @PassoAtual VARCHAR(30)
    DECLARE @OperacaoAtual VARCHAR(30)


    SET @Retorno = '';
    SET @tp_Operacao = UPPER(RTRIM(LTRIM(@tp_Operacao)));

    -- Verifica se já existe
    SET @Existe = 0


    --------------------------
    -- 
    BEGIN TRY
	   BEGIN TRANSACTION;

		  -- Pessoa ------------------------------------------------------------------------------------------------------
		  SET @PassoAtual = 'UsuarioUsi_Sistema'

		  IF NOT EXISTS( SELECT id_UsuUsi_Sis 
					   FROM UsuarioUsi_Sistema
						  --JOIN UsuarioUsi_Sistema ps ON ps.id_Sistema = @id_Sistema AND ps.id_Sistema = @id_Sistema	   
					   WHERE id_UsuUsi = @id_UsuUsi
					     AND id_Sistema = @id_Sistema
						AND dt_DesativacaoUsuSis IS NULL )
			 BEGIN
				-- Pessoa INC ------------------------------------------------------------------------------------------------------
    	  			SET @OperacaoAtual = 'inserir'

				INSERT INTO UsuarioUsi_Sistema
				    (id_UsuUsi, id_Sistema, dt_AtivacaoUsuSis)
				VALUES
				    (@id_UsuUsi, @id_Sistema, getdate())

				IF @@ERROR <> 0
				    BEGIN
					   SET @Retorno = 'Erro ao inserir UsuarioUsi_Sistema. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
				    END
				ELSE
				    SET @id_UsuUsi_Sis = @@IDENTITY

				-- Log: UsuarioUsi_Sistema -----------------------------------------------------------------
				SET @PassoAtual = 'Log: UsuarioUsi_Sistema'

    				EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'UsuarioUsi_Sistema', @id_UsuUsi_Sis, @DadosLog OUTPUT 	

				EXEC PR_Adicionar_Log_Adm_Usina 
						  null, -- @dt_Log datetime = ,
						  'INCLUIU', --@tp_Log varchar(20),
						  'UsuarioUsi_Sistema', --@nm_TabelaAcao varchar(255),
						  @id_UsuUsi_Sis, --@id_RegistroAcao int,
						  @DadosLog, --@de_Dados varchar(4000),
						  'PR_Cad_UsuarioUsi_Sistema_ADM', --@de_Origem varchar(255),
						  'Incluído UsuarioUsi_Sistema com sucesso.', --@de_Mensagem varchar(1000),
						  @Observacao, --@de_Observacao varchar(1000),
						  @Computador_Usuario, --@cod_Dispositivo varchar(15),
						  @id_Sistema,--@id_Sistema int,
						  @id_UsuUsiOperacao, --@id_UsuUsi int,
						  ''  --@Retorno				
			 END
		  ELSE
			 BEGIN
				-- Pessoa ATU ------------------------------------------------------------------------------------------------------
		  		SET @OperacaoAtual = 'atualizar'

				UPDATE UsuarioUsi_Sistema
				SET
				    id_UsuUsi = ISNULL(@id_UsuUsi, id_UsuUsi)
				  , id_Sistema = ISNULL(@id_Sistema, id_Sistema)
				WHERE id_UsuUsi_Sis = @id_UsuUsi_Sis

				IF @@ERROR <> 0
				    BEGIN
					   SET @Retorno = 'Erro ao alterar UsuarioUsi_Sistema. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
				    END;


				-- Log: UsuarioUsi_Sistema -----------------------------------------------------------------
		  		SET @PassoAtual = 'Log: UsuarioUsi_Sistema'
				--SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

				--SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('UsuarioUsi_Sistema', @id_UsuUsi)	
    				EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'UsuarioUsi_Sistema', @id_UsuUsi_Sis, @DadosLog OUTPUT 	
				EXEC PR_Adicionar_Log_Adm_Usina 
						  null, -- @dt_Log datetime = ,
						  'ALTEROU', --@tp_Log varchar(20),
						  'UsuarioUsi_Sistema', --@nm_TabelaAcao varchar(255),
						  @id_UsuUsi_Sis, --@id_RegistroAcao int,
						  @DadosLog, --@de_Dados varchar(4000),
						  'PR_Cad_UsuarioUsi_Sistema_ADM', --@de_Origem varchar(255),
						  'Alterada UsuarioUsi_Sistema com sucesso.', --@de_Mensagem varchar(1000),
						  @Observacao, --@de_Observacao varchar(1000),
						  @Computador_Usuario, --@cod_Dispositivo varchar(15),
						  @id_Sistema,--@id_Sistema int,
						  @id_UsuUsiOperacao, --@id_UsuUsi int,
						  ''  --@Retorno
			 END

	   COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
	   SET @Retorno = 'Erro ao '+@OperacaoAtual+' '+@PassoAtual
				+' - id_UsuUsi_Sis: '+ISNULL(CAST(@id_UsuUsi_Sis AS VARCHAR), '')
				+' - id_Sistema: '+ISNULL(@id_Sistema, '')
				+' - id_UsuUsi: '+ISNULL(CAST(@id_UsuUsi AS VARCHAR), '')
				+'. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

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