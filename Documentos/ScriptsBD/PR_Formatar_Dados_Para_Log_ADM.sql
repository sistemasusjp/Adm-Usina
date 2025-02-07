USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
Pega os dados da tabela informada e formada para inserção no Log

    DATA        IMPLEMENTADOR    DESCRIÇÃO    
    04/08/2016	 Geraldo		   Criaçao
    14/02/2017	 Geraldo		   Trocada de funçao (FN_Formatar_Dados_Para_Log_ADM_Usina) para procedure pois nao aceita utitizar
							 sp_executesql em Funçao.
							 Renomeada de PR_Formatar_Dados_Para_Log_ADM para PR_Formatar_Dados_Para_Log_ADM
    25/08/2017	 Geraldo		   Não registra a senha do usuário se for a tabela de segurança


-- Dados para teste:

DECLARE @Retorno varchar(4000)
exec DBO.[PR_Formatar_Dados_Para_Log_ADM] 'Usuario_Seguranca', 1, @Retorno OUTPUT 
SELECT @Retorno 

*/
ALTER --CREATE
PROCEDURE [dbo].[PR_Formatar_Dados_Para_Log_ADM] 
						 ( @nm_Tabela VARCHAR(256),
						   @id_Registro INTEGER,
						   @Retorno varchar(4000) OUTPUT )
-- Como FUNCTION Nao funciona. Dá erro no sp_executesql
-- Teste: SELECT DBO.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Usina', 1)
--        SELECT DBO.FN_Formatar_Dados_Para_Log__ADM_Usina('Gestor_Centro_Custo', 4)
--ALTER FUNCTION [dbo].[FN_Formatar_Dados_Para_Log__ADM_Usina] 
--						 ( @nm_Tabela VARCHAR(256),
--						   @id_Registro INTEGER )
--    RETURNS VARCHAR(4000)
AS 
BEGIN 
    --DECLARE @nm_Tabela VARCHAR(256) = 'Usuario_Usina'
    --DECLARE @id_Registro INTEGER = 1

    
    DECLARE @NomeCampoChave varchar(50)
    DECLARE @AchouTabela bit
    DECLARE @Linha nvarchar(4000)
    DECLARE @Campo varchar(256)
    DECLARE @CampoIdentity varchar(256)
    DECLARE @EhIdentity BIT
    DECLARE @TipoDados varchar(256)
    DECLARE @Tamanho smallint
    DECLARE @Posicao int


    -- Verifica Tabela/Campo
    --SET @NomeCampoChave = dbo.FN_Validar_Existencia_Tabela(@nm_Tabela)
    SET @Retorno = ''
    SET @AchouTabela = 0
    SET @Linha = ''
    SET @CampoIdentity = ''


    -- Cursor faz o pprocessamento
    DECLARE Cursor_Processar CURSOR
    FOR 
	   -- Outra opçao mais restrita SP_Columns Log_Adm_Usina 
	   SELECT sys.tables.name AS nm_Tabela
		   , sys.columns.name AS Campo
		   , sys.columns.is_identity AS EhIdentity
		   , sys.types.name AS TipoDados
		   , sys.columns.max_length AS Tamanho
		   , i.ordinal_position AS Posicao
	   FROM sys.columns
		   INNER JOIN sys.tables
			   ON sys.columns.object_id = sys.tables.object_id
		   INNER JOIN sys.types
			   ON sys.columns.user_type_id = sys.types.user_type_id
		   INNER JOIN information_schema.columns i
			   ON i.TABLE_NAME = sys.tables.name
				 AND I.COLUMN_NAME = Sys.columns.name
	   WHERE sys.tables.name = @nm_Tabela
	   ORDER BY sys.tables.name
			, i.ordinal_position
			, sys.columns.name;

    OPEN Cursor_Processar;

    FETCH NEXT FROM Cursor_Processar 
	   INTO @nm_Tabela, @Campo, @EhIdentity, @TipoDados, @Tamanho, @Posicao

	   WHILE @@FETCH_STATUS = 0
	   BEGIN
		  SET @AchouTabela = 1

		  IF @Linha <> ''
			 SET @Linha = @Linha + ' + '' || '' + ' --+ @Campo + ': '' + CAST(ISNULL('+@Campo+', ''null'') AS VARCHAR)'

		  --SET @Linha = @Linha + '''' + @Campo + ': '' + CAST(ISNULL('+@Campo+', ''null'') AS VARCHAR)'
		  SET @Linha = @Linha + '''' + @Campo + --': '' + CAST(ISNULL('+@Campo+', ''null'') AS VARCHAR)'
										  CASE 
											 WHEN @TipoDados = 'datetime' 
												THEN ': '' + ISNULL(CONVERT(VARCHAR, '+@Campo+', 121), ''null'')'
											 ELSE 
												CASE -- Não grava a senha do usuário no Log
												    WHEN Upper(@nm_Tabela) = Upper('Usuario_Seguranca') AND Upper(@Campo) = Upper('de_Senha')
													   THEN ': <Não Mostrada>'''
												    ELSE ': '' + CAST(ISNULL('+@Campo+', ''null'') AS VARCHAR)'
												END
										  END

		  IF @EhIdentity = 1
			 SET @CampoIdentity = @Campo
		  

		  FETCH NEXT FROM Cursor_Processar 
			 INTO @nm_Tabela, @Campo, @EhIdentity, @TipoDados, @Tamanho, @Posicao;

	   END;

    CLOSE Cursor_Processar;
    DEALLOCATE Cursor_Processar;

    IF @CampoIdentity = '' AND @nm_Tabela = 'Usuario_Seguranca'
	   SET @CampoIdentity = 'id_UsuUsi'
		  

    --SET @Retorno = 'SELECT ' + @Linha + ' FROM ' + @nm_Tabela + ' WHERE ' + @CampoIdentity + ' = ' + CAST(@id_Registro AS VARCHAR);
    SET @Linha = 'SELECT @Retorno = ' + @Linha + ' FROM ' + @nm_Tabela + ' WHERE ' + @CampoIdentity + ' = ' + CAST(@id_Registro AS VARCHAR);
    SELECT @Linha
    exec sp_executesql @Linha, N'@Retorno VARCHAR(4000) OUTPUT', @Retorno OUTPUT

    IF ( @AchouTabela = 0 ) 
	   SET @Retorno = 'Tabela inválida '+@nm_Tabela+'.'
 
--    return @Retorno
END

