USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   15/02/2017  Geraldo          Criação
   16/02/2017  Geraldo          

   Obs:     
  ============================================================================
    Testar:

    DECLARE  @Retorno                VARCHAR(4000)
	EXEC PR_Cad_UsuarioUsi_PerSis_ADM NULL, 52, 4, 2, 'INC', 1, 'SQL',  @Retorno output
	SELECT @Retorno
    
*/  
ALTER 
PROCEDURE dbo.PR_Cad_UsuarioUsi_PerSis_ADM (
							 @id_Usu_PerSis		int = NULL,
							 @id_UsuUsi			int,
							 @id_Sistema			int,
							 @cd_PerSis			int,

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
    DECLARE @id_PerSis int
    DECLARE @DadosLog VARCHAR(4000)
    DECLARE @Observacao VARCHAR(1000)
    DECLARE @PassoAtual VARCHAR(20)
    DECLARE @OperacaoAtual VARCHAR(20)


    SET @Retorno = '';
    SET @tp_Operacao = UPPER(RTRIM(LTRIM(@tp_Operacao)));

    -- Verifica se já existe
    SET @Existe = 0


    --------------------------
    -- 
    BEGIN TRY
	   IF @tp_Operacao = 'INC' OR @tp_Operacao = 'ALT'
		  BEGIN
			 BEGIN TRANSACTION;

			 -- Pessoa ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'UsuarioUsi_PerSis'

			 IF @id_PerSis IS NULL
				SET @id_PerSis = (SELECT id_PerSis FROM Perfil_Sistema ps WHERE ps.cd_PerSis = @cd_PerSis AND ps.id_Sistema = @id_Sistema)

			 IF NOT EXISTS( SELECT id_Usu_PerSis 
						  FROM UsuarioUsi_PerSis
							 --JOIN Perfil_Sistema ps ON ps.cd_PerSis = @cd_PerSis AND ps.id_Sistema = @id_Sistema	   
						  WHERE id_UsuUsi = @id_UsuUsi
						    AND id_PerSis = @id_PerSis )
				BEGIN
				    -- Pessoa INC ------------------------------------------------------------------------------------------------------
    	  			    SET @OperacaoAtual = 'inserir'

				    INSERT INTO UsuarioUsi_PerSis
					   (id_UsuUsi, id_PerSis)
				    VALUES
					   (@id_UsuUsi, @id_PerSis)

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao inserir UsuarioUsi_PerSis. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END
				    ELSE
					   SET @id_Usu_PerSis = @@IDENTITY

				    -- Log: UsuarioUsi_PerSis -----------------------------------------------------------------
				    SET @PassoAtual = 'Log: UsuarioUsi_PerSis'
				    --SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

	   --				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('UsuarioUsi_PerSis', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'UsuarioUsi_PerSis', @id_Usu_PerSis, @DadosLog OUTPUT 	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'INCLUIU', --@tp_Log varchar(20),
							 'UsuarioUsi_PerSis', --@nm_TabelaAcao varchar(255),
							 @id_Usu_PerSis, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_UsuarioUsi_PerSis_ADM', --@de_Origem varchar(255),
							 'Incluído UsuarioUsi_PerSis com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 @Retorno				
				END
			 ELSE
				BEGIN
				    -- Pessoa ATU ------------------------------------------------------------------------------------------------------
		  		    SET @OperacaoAtual = 'atualizar'

				    UPDATE UsuarioUsi_PerSis
				    SET
					   id_UsuUsi = ISNULL(@id_UsuUsi, id_UsuUsi)
					 , id_PerSis = ISNULL(@id_PerSis, id_PerSis)
				    WHERE id_Usu_PerSis = @id_Usu_PerSis

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao alterar UsuarioUsi_PerSis. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END;


				    -- Log: UsuarioUsi_PerSis -----------------------------------------------------------------
		  		    SET @PassoAtual = 'Log: UsuarioUsi_PerSis'
				    --SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

				    --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('UsuarioUsi_PerSis', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'UsuarioUsi_PerSis', @id_Usu_PerSis, @DadosLog OUTPUT 	
				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'ALTEROU', --@tp_Log varchar(20),
							 'UsuarioUsi_PerSis', --@nm_TabelaAcao varchar(255),
							 @id_Usu_PerSis, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_UsuarioUsi_PerSis_ADM', --@de_Origem varchar(255),
							 'Alterada UsuarioUsi_PerSis com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 @Retorno
				END

			 COMMIT TRANSACTION;
		  END
	   ELSE
		  IF @tp_Operacao = 'EXC'
		  BEGIN
			 -- Pessoa ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'UsuarioUsi_PerSis'

			 IF @id_PerSis IS NULL
				SET @id_PerSis = (SELECT id_PerSis FROM Perfil_Sistema ps WHERE ps.cd_PerSis = @cd_PerSis AND ps.id_Sistema = @id_Sistema)

			 IF @id_Usu_PerSis IS NULL
				SET @id_Usu_PerSis = (  SELECT id_Usu_PerSis FROM UsuarioUsi_PerSis 
								    WHERE id_UsuUsi = @id_UsuUsi
									 AND id_PerSis = @id_PerSis )

			 IF EXISTS( SELECT id_Usu_PerSis 
					  FROM UsuarioUsi_PerSis
					  WHERE id_Usu_PerSis = @id_Usu_PerSis )
				BEGIN
		  		    BEGIN TRANSACTION;
				    -- Pessoa INC ------------------------------------------------------------------------------------------------------
    	  			    SET @OperacaoAtual = 'excluir'

    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'UsuarioUsi_PerSis', @id_Usu_PerSis, @DadosLog OUTPUT 	

				    DELETE FROM UsuarioUsi_PerSis
				    WHERE id_Usu_PerSis = @id_Usu_PerSis 

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao excluir UsuarioUsi_PerSis. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END

				    -- Log: UsuarioUsi_PerSis -----------------------------------------------------------------
				    SET @PassoAtual = 'Log: UsuarioUsi_PerSis'
				    --SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

	   --				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('UsuarioUsi_PerSis', @id_UsuUsi)	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'EXCLUIU', --@tp_Log varchar(20),
							 'UsuarioUsi_PerSis', --@nm_TabelaAcao varchar(255),
							 @id_Usu_PerSis, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_UsuarioUsi_PerSis_ADM', --@de_Origem varchar(255),
							 'Excluído UsuarioUsi_PerSis com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 @Retorno				
		  		    COMMIT TRANSACTION;
				END
		  END


    END TRY
    BEGIN CATCH
	   SET @Retorno = 'Erro ao '+@OperacaoAtual+' '+@PassoAtual
				+' - id_Usu_PerSis: '+ISNULL(CAST(@id_Usu_PerSis AS VARCHAR), '')
				+' - id_Sistema: '+ISNULL(@id_Sistema, '')
				+' - cd_PerSis: '+ISNULL(@cd_PerSis, '')
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