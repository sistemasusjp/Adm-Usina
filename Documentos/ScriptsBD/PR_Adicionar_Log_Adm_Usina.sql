USE [ADM_Usina]
GO
-- =============================================
/*
Alterações
Data		   Resp.    Motivo
-----------------------------------------------
06/07/2016	   Geraldo  Criaçao
14/02/2017     Geraldo  @Retorno = '' por padrao
22/04/2020     Geraldo  Aumentado tamanho do parâmetro @cod_Dispositivo de 15 para 30
*/
-- =============================================
ALTER
PROCEDURE dbo.PR_Adicionar_Log_Adm_Usina (
						   @dt_Log datetime = null,
						   @tp_Log varchar(20),
						   @nm_TabelaAcao varchar(255),
						   @id_RegistroAcao int,
						   @de_Dados varchar(4000),
						   @de_Origem varchar(255),
						   @de_Mensagem varchar(1000),
						   @de_Observacao varchar(1000),
						   @cod_Dispositivo varchar(30),
						   @id_Sistema int,
						   @id_UsuUsi int,
						   @Retorno varchar(4000) OUTPUT )

AS
BEGIN 
    SET @Retorno = ''

    -- Verifica Usuário
    IF NOT EXISTS ( select id_UsuUsi 
				from dbo.Usuario_Usina
				where id_UsuUsi = @id_UsuUsi )
    BEGIN
	   SET @Retorno = 'Usuário inválido.'
    END

    -- Verifica Tabela
    IF NOT  (@nm_TabelaAcao = 'Gestor' 
		   OR @nm_TabelaAcao = 'Gestor_CentroCusto' 
		   OR @nm_TabelaAcao = 'Log_Adm_Usina' 
		   OR @nm_TabelaAcao = 'Perfil_Sistema' 
		   OR @nm_TabelaAcao = 'Pessoa_Usina' 
		   OR @nm_TabelaAcao = 'Sistema' 
		   OR @nm_TabelaAcao = 'Usuario_Seguranca' 
		   OR @nm_TabelaAcao = 'Usuario_Usina'  
		   OR @nm_TabelaAcao = 'UsuarioUsi_PerSis' 
		   OR @nm_TabelaAcao = 'UsuarioUsi_Sistema' ) 
    BEGIN
	   SET @Retorno = 'Tabela inválida '+@nm_TabelaAcao+'.'
    END

    IF ISNULL(@Retorno, '') = ''
	   BEGIN TRY
		  INSERT INTO dbo.Log_Adm_Usina
			    ( dt_Log,
				 tp_Log,
				 nm_TabelaAcao,
				 id_RegistroAcao,
				 de_Dados,
				 de_Origem,
				 de_Mensagem,
				 de_Observacao,
				 cod_Dispositivo,
				 id_Sistema,
				 id_UsuUsi )
		  VALUES
			   ( ISNULL(@dt_Log, getDate()),
				@tp_Log,
				@nm_TabelaAcao,
				@id_RegistroAcao,
				@de_Dados,
				@de_Origem,
				@de_Mensagem,
				@de_Observacao,
				@cod_Dispositivo,
				@id_Sistema, 
				@id_UsuUsi )

		  IF @@ERROR <> 0
		  BEGIN
			 SET @Retorno = 'Erro ao inserir Log Adm Usina. '+
							 'Código do erro: '+CAST(@@ERROR AS VARCHAR)
		  END
	   END TRY
	   BEGIN CATCH
		  SET @Retorno = 'Erro ao inserir Log Adm Usina. '+
					   'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+
					   'Mensagem do erro: '+ERROR_MESSAGE()

	   END CATCH
    
	IF @Retorno = ''
		RETURN 0
	ELSE
		RETURN 1
END
