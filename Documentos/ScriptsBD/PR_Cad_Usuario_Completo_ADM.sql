USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
	   Consulta o Resumo do Orçado agrupado com Centros de Custo e Conta
	   Se o @id_Gestor for nulo mostra todos os Centros de Custo (caso da Contabilidade)
	   => @CampoOrdem = 'Cod', 'Desc', 'Total'
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   09/09/2016  Geraldo          Criação
   13/02/2017  Geraldo          Alterado funcionamento, efetua o select primeira pra saber se é alteração ou inclusão
							      não considerando o @tp_Operacao
   16/02/2017  Geraldo		   - Renomeada de PR_Formatar_Dados_Para_Log_ADM_Usina para PR_Formatar_Dados_Para_Log_ADM
						       - Se já tiver senha nao altera a mesma a nao ser que seja passa no parametro 
   23/04/2020  Geraldo		   Adicionado fl_Bloqueado

   Obs:     
  ============================================================================
    Testar:

    declare  @Retorno                VARCHAR(4000)
    EXEC PR_Cad_Gestor CAST('04/08/2016' AS DATETIME), NULL, 0, 1, 1, 'INC', 1, 'sqlserver\usu_teste' @Retorno output
    select @Retorno
    
*/  
ALTER 
PROCEDURE dbo.PR_Cad_Usuario_Completo_ADM (
											 @id_PesUsi				int = NULL,
											 @nm_Pessoa				VARCHAR(300),
											 @nu_Filial				VARCHAR(2),
											 @nu_Mat				VARCHAR(11),
											 @nu_MatUnificada		VARCHAR(11),
											 @nu_Cpf				VARCHAR(11) = NULL,
											 @de_Ramais				VARCHAR(30) = NULL,
											 @dt_Nascimento			datetime = NULL,
											 @cd_Sexo				CHAR(1) = NULL,
											 @de_EMailPessoa		VARCHAR(255),
											 @de_Observacao			text = NULL,

											 @id_UsuUsi				INTEGER = NULL,
											 @cd_Login				VARCHAR(30),

											 @de_Senha				VARCHAR(128) = NULL,
											 @tp_FormatoSenha		INTEGER,
											 @de_EmailSeguranca	    VARCHAR(255) = NULL,
											 @fl_Bloqueado			BIT,

											 @tp_Operacao			CHAR(3),
											 @id_UsuUsiOperacao		INTEGER,
											 @Computador_Usuario	VARCHAR(30),
											 @id_Sistema			INT,
											 @Retorno               VARCHAR(4000) OUTPUT
										  )


AS
BEGIN
    --DECLARE @Erro varchar
    --DECLARE @Exportou_para_GATEC bit
    --DECLARE @Exportou_para_PROTHEUS bit
    DECLARE @Existe BIT;
    DECLARE @DadosLog VARCHAR(4000)
    DECLARE @Observacao VARCHAR(1000)
    DECLARE @PassoAtual VARCHAR(20)
    DECLARE @OperacaoAtual VARCHAR(20)


    SET @Retorno = '';
    SET @tp_Operacao = UPPER(RTRIM(LTRIM(@tp_Operacao)));

    -- Verifica se já existe
    SET @Existe = 0

    -- Comentado em 13/02/2017
    --IF ISNULL(@tp_Operacao, '') = ''
    --BEGIN
	   --SET @Retorno = 'Operaçao inválida.';
    --END

    IF LTRIM(RTRIM(@nu_Filial)) <> '' AND NOT(@nu_Filial IS NULL)
	   SET @nu_MatUnificada = CAST(CAST(@nu_Filial AS int) AS varchar)

    IF LTRIM(RTRIM(@nu_Mat)) <> '' AND NOT(@nu_Mat IS NULL)
	   IF NOT(@nu_MatUnificada IS NULL)
		  SET @nu_MatUnificada = @nu_MatUnificada + CAST(CAST(@nu_Mat AS int) AS varchar)
	   ELSE
		  SET @nu_MatUnificada = CAST(CAST(@nu_Mat AS int) AS varchar)

    --------------------------
    -- 
    BEGIN TRY
	   BEGIN TRANSACTION;

			 -- Pessoa ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'Pessoa_Usina'

			 IF NOT EXISTS( SELECT id_PesUsi FROM Pessoa_Usina WHERE id_PesUsi = @id_PesUsi )
				BEGIN
				    -- Pessoa INC ------------------------------------------------------------------------------------------------------
    	  			    SET @OperacaoAtual = 'inserir'

				    INSERT INTO dbo.Pessoa_Usina
					   ( --id_PesUsi - this column value is auto-generated
						  nm_Pessoa, nu_Filial, nu_Mat, nu_MatUnificada, de_Ramais, dt_CadastroPesUsi )
				    
				    VALUES
					   ( -- id_PesUsi - int
						  RTRIM(@nm_Pessoa), -- nm_Pessoa - varchar
						  @nu_Filial, -- nu_Filial - varchar
						  @nu_Mat, -- nu_Mat - varchar
						  @nu_MatUnificada,
						  @de_Ramais, -- de_Ramais
						  getdate() -- dt_CadastroPesUsi - datetime
					   )

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao inserir Pessoa_Usina. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END
				    ELSE
					   SET @id_PesUsi = @@IDENTITY

				    -- Log: Pessoa_Usina -----------------------------------------------------------------
				    SET @PassoAtual = 'Log: Pessoa_Usina'
				    --SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

--				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Pessoa_Usina', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Pessoa_Usina', @id_PesUsi, @DadosLog OUTPUT 	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'INCLUIU', --@tp_Log varchar(20),
							 'Pessoa_Usina', --@nm_TabelaAcao varchar(255),
							 @id_PesUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Incluído Pessoa_Usina com sucesso.', --@de_Mensagem varchar(1000),
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

				    UPDATE Pessoa_Usina
				    SET
					   nm_Pessoa = ISNULL(@nm_Pessoa, nm_Pessoa)
					   , nu_Filial = ISNULL(@nu_Filial, nu_Filial)
					   , nu_Mat = ISNULL(@nu_Mat, nu_Mat)
					   , nu_MatUnificada = ISNULL(@nu_MatUnificada, nu_MatUnificada)
					   , de_EMailPessoa =  ISNULL(@de_EMailPessoa, de_EMailPessoa)
					   , de_Observacao = ISNULL(@de_Observacao, de_Observacao)
				    WHERE id_PesUsi = @id_PesUsi;

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao alterar Pessoa_Usina. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END;


				    -- Log: Pessoa_Usina -----------------------------------------------------------------
		  		    SET @PassoAtual = 'Log: Pessoa_Usina'
				    --SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)

				    --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Pessoa_Usina', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Pessoa_Usina', @id_PesUsi, @DadosLog OUTPUT 	
				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'ALTEROU', --@tp_Log varchar(20),
							 'Pessoa_Usina', --@nm_TabelaAcao varchar(255),
							 @id_PesUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Alterada Pessoa_Usina com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 ''  --@Retorno
				END



			 -- Usuário usina ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'Usuario_Usina'

			 IF NOT EXISTS( SELECT id_UsuUsi FROM Usuario_Usina WHERE id_UsuUsi = @id_UsuUsi )
				BEGIN
				    -- Usuario_Usina INC ------------------------------------------------------------------------------------------------------
		  		    SET @OperacaoAtual = 'inserir'

				    INSERT INTO dbo.Usuario_Usina
					   (id_PesUsi, cd_Login, dt_CadastroUsuUsi)
				    VALUES
					   (@id_PesUsi, @cd_Login, getdate())

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao inserir Usuario_Usina. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END
				    ELSE
					   SET @id_UsuUsi = @@IDENTITY

				    -- Log: Usuario_Usina INC -----------------------------------------------------------------
				    SET @PassoAtual = 'Log: Usuario_Usina'
				    SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)+
								', @id_UsuUsi = ' + CAST(@id_UsuUsi AS VARCHAR)

--				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Usina', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Usina', @id_UsuUsi, @DadosLog OUTPUT 	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'INCLUIU', --@tp_Log varchar(20),
							 'Usuario_Usina', --@nm_TabelaAcao varchar(255),
							 @id_UsuUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Incluído Usuario_Usina com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 ''  --@Retorno
				END
			 ELSE
				BEGIN
				    -- Usuario_Usina ALT ---------------------------------------------------------------------------------------------------
		  		    SET @OperacaoAtual = 'atualizar'

				    UPDATE dbo.Usuario_Usina
				    SET cd_Login = @cd_Login
				    WHERE id_UsuUsi = @id_UsuUsi

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao alterar Usuario_Usina. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END

				    -- Log: Usuario_Usina ALT -----------------------------------------------------------------
		  		    SET @PassoAtual = 'Log: Usuario_Usina'
				    SET @Observacao = '@id_PesUsi = ' + CAST(@id_PesUsi AS VARCHAR)+
								', @id_UsuUsi = ' + CAST(@id_UsuUsi AS VARCHAR)

--				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Usina', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Usina', @id_UsuUsi, @DadosLog OUTPUT 	
				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'ALTEROU', --@tp_Log varchar(20),
							 'Usuario_Usina', --@nm_TabelaAcao varchar(255),
							 @id_UsuUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Alterada Usuario_Usina com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 ''  --@Retorno
				END


			 -- Segurança ------------------------------------------------------------------------------------------------------
			 SET @PassoAtual = 'Usuario_Seguranca'

			 IF NOT EXISTS( SELECT id_UsuUsi FROM Usuario_Seguranca WHERE id_UsuUsi = @id_UsuUsi )
				BEGIN
				    -- Segurança INC ------------------------------------------------------------------------------------------------------
		  			   SET @OperacaoAtual = 'inserir'

				    IF (@de_Senha = '') OR (@de_Senha = NULL)
					   SET @de_Senha = '1' -- Senha Padrão (colocar em Parametro)

				    INSERT INTO Usuario_Seguranca
					   (id_UsuUsi, de_Senha, tp_FormatoSenha, de_EmailSeguranca, fl_Bloqueado)
				    VALUES
					   (@id_UsuUsi, @de_Senha, @tp_FormatoSenha, @de_EmailSeguranca, @fl_Bloqueado)

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao inserir Usuario_Seguranca. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END



				    -- Log: Usuario_Seguranca INC -----------------------------------------------------------------
				    SET @PassoAtual = 'Log: Usuario_Seguranca'
--				    SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Seguranca', @id_UsuUsi)	
    				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Seguranca', @id_UsuUsi, @DadosLog OUTPUT 	
				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'INCLUIU', --@tp_Log varchar(20),
							 'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
							 @id_UsuUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Incluído Usuario_Seguranca com sucesso.', --@de_Mensagem varchar(1000),
							 @Observacao, --@de_Observacao varchar(1000),
							 @Computador_Usuario, --@cod_Dispositivo varchar(15),
							 @id_Sistema,--@id_Sistema int,
							 @id_UsuUsiOperacao, --@id_UsuUsi int,
							 ''  --@Retorno
				END
			 ELSE
				BEGIN
				    -- Usuario_Seguranca ATU ------------------------------------------------------------------------------------------------------
		  		    SET @OperacaoAtual = 'atualizar'

				    IF (@de_Senha = '') OR (@de_Senha = NULL)
					   SET @de_Senha = (SELECT de_Senha FROM Usuario_Seguranca WHERE id_UsuUsi = @id_UsuUsi)

				    UPDATE Usuario_Seguranca
				      SET de_Senha = ISNULL(@de_Senha, de_Senha)
					   , tp_FormatoSenha = ISNULL(@tp_FormatoSenha, tp_FormatoSenha)
					   , de_EmailSeguranca = ISNULL(@de_EmailSeguranca, de_EmailSeguranca)
					   , fl_Bloqueado = ISNULL(@fl_Bloqueado, fl_Bloqueado)					   
				    WHERE id_UsuUsi = @id_UsuUsi

				    IF @@ERROR <> 0
					   BEGIN
						  SET @Retorno = 'Erro ao alterar Usuario_Seguranca. '+'Código do erro: '+CAST(@@ERROR AS VARCHAR);
					   END

				    -- Log: Usuario_Seguranca ATU ------------------------------------------------------------------------------------------------
		  		    SET @PassoAtual = 'Log: Usuario_Seguranca'

				    --SET @DadosLog = dbo.FN_Formatar_Dados_Para_Log__ADM_Usina('Usuario_Seguranca', @id_UsuUsi)	
				    EXEC DBO.PR_Formatar_Dados_Para_Log_ADM 'Usuario_Seguranca', @id_UsuUsi, @DadosLog OUTPUT 	

				    EXEC PR_Adicionar_Log_Adm_Usina 
							 null, -- @dt_Log datetime = ,
							 'ALTEROU', --@tp_Log varchar(20),
							 'Usuario_Seguranca', --@nm_TabelaAcao varchar(255),
							 @id_UsuUsi, --@id_RegistroAcao int,
							 @DadosLog, --@de_Dados varchar(4000),
							 'PR_Cad_Usuario_Completo_ADM', --@de_Origem varchar(255),
							 'Alterada Usuario_Seguranca com sucesso.', --@de_Mensagem varchar(1000),
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
				+' - id_PesUsi: '+ISNULL(CAST(@id_PesUsi AS VARCHAR), '')
				+' - id_UsuUsi: '+ISNULL(CAST(@id_UsuUsi AS VARCHAR), '')
				+' - cd_Login: '+ISNULL(@cd_Login, '')
				+' - nu_Mat: '+ISNULL(@nu_Mat, '')
				+' - nu_Filial: '+ISNULL(@nu_Filial, '')
				+' - nu_MatUnificada: '+ISNULL(@nu_MatUnificada, '')
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