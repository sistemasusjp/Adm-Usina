USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

/*
PARA TESTAR

declare  @Retorno                VARCHAR(4000)
EXEC PR_Cad_Gestor CAST('04/08/2016' AS DATETIME), NULL, 0, 1, 1, 'INC', 1, 'sqlserver\usu_teste' @Retorno output
select @Retorno



Alterações
   Data					   Motivo
   04/08/2016	Geraldo		   Criaçao
   16/02/2017  Geraldo		   Renomeada de PR_Formatar_Dados_Para_Log_ADM_Usina para PR_Formatar_Dados_Para_Log_ADM
*/
-- =============================================
ALTER -- CREATE 
PROCEDURE [dbo].[PR_Cad_Gestor] (
							 @id_Gestor			INTEGER,
							 @dt_InicioExercicio	DATETIME,
							 @dt_FimExercicio		DATETIME,
							 @fl_Exclusao			BIT,
							 @tp_Gestor			SMALLINT,
							 @id_UsuUsi			INTEGER,
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
         DECLARE @Existe BIT;
	    DECLARE @Identity INTEGER;
	    DECLARE @DadosLog VARCHAR(4000)


         SET @Retorno = '';
         SET @tp_Operacao = UPPER(RTRIM(LTRIM(@tp_Operacao)));

         -- Verifica se já existe
	    SET @Existe = 0
	    SET @Identity = 0

	    IF ISNULL(@tp_Operacao, '') = ''
	    BEGIN
		   IF (@id_Gestor <> 0)
		   BEGIN
			 IF EXISTS( SELECT @id_Gestor
					  FROM Gestor
					  WHERE id_Gestor = @id_Gestor )
				BEGIN
				    SET @Existe = 1
				    IF ISNULL(@tp_Operacao, '') = ''
					   SET @tp_Operacao = 'ALT'
				END
			 ELSE
				BEGIN
				    IF ISNULL(@tp_Operacao, '') = ''
					   SET @tp_Operacao = 'INC'
				END
		   END
			 IF ISNULL(@tp_Operacao, '') = ''
				SET @tp_Operacao = 'INC'
	   END


         --------------------------
         -- 

         IF @tp_Operacao = 'INC'
             BEGIN
                 BEGIN TRY
				 BEGIN TRANSACTION;

                     INSERT INTO Gestor
				    ( dt_InicioExercicio, dt_FimExercicio, fl_Exclusao, 
					 tp_Gestor, id_UsuUsi )
				 VALUES
				    ( @dt_InicioExercicio, @dt_FimExercicio, @fl_Exclusao, 
					 @tp_Gestor, @id_UsuUsi )

                     IF @@ERROR <> 0
                         BEGIN
                             SET @Retorno = 'Erro ao inserir Gestor. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
                         END
				 ELSE
				    SET @Identity = @@IDENTITY

                     COMMIT TRANSACTION;

				 --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Gestor', @Identity)	
  				 EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Gestor', @Identity, @DadosLog OUTPUT 	

				 EXEC PR_Adicionar_Log_Adm_Usina 
						   null, -- @dt_Log datetime = ,
						   'INCLUIU', --@tp_Log varchar(20),
						   'Gestor', --@nm_TabelaAcao varchar(255),
						   @Identity, --@id_RegistroAcao int,
						   @DadosLog, --@de_Dados varchar(4000),
						   'PR_Cad_Gestor', --@de_Origem varchar(255),
						   'Incluído Gestor com sucesso.', --@de_Mensagem varchar(1000),
						   '', --@de_Observacao varchar(1000),
						   @Computador_Usuario, --@cod_Dispositivo varchar(15),
						   @id_Sistema,--@id_Sistema int,
						   @id_UsuUsiOperacao, --@id_UsuUsi int,
						   ''  --@Retorno
                 END TRY
                 BEGIN CATCH
                     SET @Retorno = 'Erro ao inserir Gestor. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

                     ROLLBACK TRANSACTION;
                 END CATCH;
             END;
         ELSE
             BEGIN
                 IF @tp_Operacao = 'ALT'
                     BEGIN
                         BEGIN TRY
                             BEGIN TRANSACTION;

					    UPDATE Gestor
                               SET
                                   dt_InicioExercicio = @dt_InicioExercicio,
                                   dt_FimExercicio = @dt_FimExercicio,
                                   fl_Exclusao = @fl_Exclusao,
							tp_Gestor = @tp_Gestor,
							id_UsuUsi = @id_UsuUsi
                             WHERE id_Gestor = @id_Gestor;

                             IF @@ERROR <> 0
                                 BEGIN
                                     SET @Retorno = 'Erro ao alterar Gestor. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
                                 END;

                             COMMIT TRANSACTION;

					    --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Gestor', @id_Gestor)	
  					    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Gestor', @id_Gestor, @DadosLog OUTPUT 	
					    EXEC PR_Adicionar_Log_Adm_Usina 
								 null, -- @dt_Log datetime = ,
								 'ALTEROU', --@tp_Log varchar(20),
								 'Gestor', --@nm_TabelaAcao varchar(255),
								 @id_Gestor, --@id_RegistroAcao int,
								 @DadosLog, --@de_Dados varchar(4000),
								 'PR_Cad_Gestor', --@de_Origem varchar(255),
								 'Alterado Gestor com sucesso.', --@de_Mensagem varchar(1000),
								 '', --@de_Observacao varchar(1000),
								 @Computador_Usuario, --@cod_Dispositivo varchar(15),
								 @id_Sistema,--@id_Sistema int,
								 @id_UsuUsiOperacao, --@id_UsuUsi int,
								 ''  --@Retorno
                         END TRY
                         BEGIN CATCH
                             SET @Retorno = 'Erro ao atualizar Gestor. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

                             ROLLBACK TRANSACTION;
                         END CATCH;
                     END
			 ELSE    
				 IF @tp_Operacao = 'EXC'
					BEGIN
					    BEGIN TRY
						   BEGIN TRANSACTION;
                     
						   --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Gestor', @id_Gestor)	
  						   EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Gestor', @id_Gestor, @DadosLog OUTPUT 	

						   UPDATE Gestor
						   SET
                                   fl_Exclusao = 1
						   WHERE id_Gestor = @id_Gestor;

						   IF @@ERROR <> 0
							  BEGIN
								 SET @Retorno = 'Erro ao apagar Gestor. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
							  END;

						   COMMIT TRANSACTION;

						   EXEC PR_Adicionar_Log_Adm_Usina 
									null, -- @dt_Log datetime = ,
									'EXCLUIU', --@tp_Log varchar(20),
									'Gestor', --@nm_TabelaAcao varchar(255),
									@id_Gestor, --@id_RegistroAcao int,
									@DadosLog, --@de_Dados varchar(4000),
									'PR_Cad_Gestor', --@de_Origem varchar(255),
									'Excluído Gestor com sucesso.', --@de_Mensagem varchar(1000),
									'', --@de_Observacao varchar(1000),
									@Computador_Usuario, --@cod_Dispositivo varchar(15),
									@id_Sistema,--@id_Sistema int,
									@id_UsuUsiOperacao, --@id_UsuUsi int,
									''  --@Retorno
					    END TRY
					    BEGIN CATCH
						   SET @Retorno = 'Erro ao apagar Gestor. '+'Código do erro: '+CAST(ERROR_NUMBER() AS VARCHAR)+' '+'Mensagem do erro: '+ERROR_MESSAGE();

						   ROLLBACK TRANSACTION;
					    END CATCH;
					END
		  END


         --	SELECT @Retorno

	    RETURN @Identity
         --IF @Retorno = ''
         --    BEGIN
         --        RETURN 0;
         --    END;
         --ELSE
         --    BEGIN
         --        RETURN 1;
         --    END
    END