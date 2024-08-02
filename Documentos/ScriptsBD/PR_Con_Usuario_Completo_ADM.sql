USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

/*
Alterações
Data			 Motivo
09/09/2016	 Criaçao
13/02/2017	 Testes em nu_Filial, nu_Mat para nulo e zeros a esquerda
15/02/2017	 Adicionado parametro @id_Sistema
16/02/2017	 Adicionadas funçoes FN_Buscar_UsuarioUsi_Sistema_ADM e FN_Buscar_UsuarioUsi_PerSis_ADM
22/08/2017      Comentado join com UsuarioUsi_Sistema pois estava duplicando linhas. As FN já trazem esses dados
09/08/2019	 Função FN_Buscar_UsuarioUsi_PerSis_ADM passou a aceitar mais um parâmetro: @MostarNomeSistema



PARA TESTAR

declare  @Retorno                VARCHAR(4000)

EXEC PR_Con_Usuario_Completo_ADM 
EXEC PR_Con_Usuario_Completo_ADM  null, null, null, null, 4
EXEC PR_Con_Usuario_Completo_ADM  null, null, null, null, null, null, 'nm_Pessoa', 'D'
EXEC PR_Con_Usuario_Completo_ADM  1, 6610, null, null, null, null
EXEC PR_Con_Usuario_Completo_ADM  1, 595
EXEC PR_Con_Usuario_Completo_ADM  '01', '007723', null

select @Retorno
*/

ALTER
PROCEDURE dbo.PR_Con_Usuario_Completo_ADM 
						 (
							 @nu_Filial			VARCHAR(2) = NULL,
							 @nu_Mat				VARCHAR(11) = NULL,
							 @id_UsuUsi			INTEGER = NULL,
							 @cd_Login			VARCHAR(30) = NULL,
							 @id_Sistema			INTEGER = NULL,
							 @fl_Bloqueado			BIT = NULL,
							 @OrderBy				VARCHAR(30) = NULL,
							 @ASC_DESC               CHAR(1) = 'A'
						  )
AS
BEGIN
    IF @nu_Mat IS NOT NULL
	   IF LEN(ISNULL(@nu_Mat, '')) <= 6
	   	   SET @nu_Mat = REPLICATE('0', 6-LEN(ISNULL(@nu_Mat, '')))+ISNULL(@nu_Mat, '')

    IF @nu_Filial IS NOT NULL
        IF LEN(ISNULL(@nu_Filial, '')) <= 2
	       SET @nu_Filial = REPLICATE('0', 2-LEN(ISNULL(@nu_Filial, '')))+ISNULL(@nu_Filial, '')
      
	 
    SELECT 
	      pu.* 
	    , uu.*
	    --, de_Senha
	    , tp_FormatoSenha
    	    , de_EmailSeguranca
    	    , de_PerguntaEsquecimento
    	    , de_RespostaEsquecimento
    	    , fl_Bloqueado
    	    , fl_ObrigarAlteracaoSenha
    	    , dt_UltimoLogin
    	    , dt_UltimaModificacaoSenha
    	    , dt_UltimoBloqueio
    	    , qt_TentativasSenhaErrada
    	    , qt_TentativasRespostaErrada
--	    , id_Sistema
	    , dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( uu.id_UsuUsi, @id_Sistema ) AS Sistemas
	    , dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( uu.id_UsuUsi, @id_Sistema, 1 ) AS Perfis
         , CASE 
			 WHEN @ASC_DESC = 'A' AND @OrderBy = 'cd_Login'
				THEN cd_Login
			 WHEN @ASC_DESC = 'A' AND @OrderBy = 'nu_MatUnificada'
				THEN nu_MatUnificada
			 WHEN @ASC_DESC = 'A' AND @OrderBy = 'Sistemas'
				THEN dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( uu.id_UsuUsi, @id_Sistema )
			 WHEN @ASC_DESC = 'A' AND @OrderBy = 'Perfis'
				THEN dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( uu.id_UsuUsi, @id_Sistema, 1 )
			 WHEN @ASC_DESC = 'A' --AND @OrderBy IS NULL
				THEN nm_Pessoa
			 ELSE    
				''
		 END AS Campo_ASC
         , CASE 
			 WHEN @ASC_DESC = 'D' AND @OrderBy = 'cd_Login'
				THEN cd_Login
			 WHEN @ASC_DESC = 'D' AND @OrderBy = 'nu_MatUnificada'
				THEN nu_MatUnificada
			 WHEN @ASC_DESC = 'D' AND @OrderBy = 'Sistemas'
				THEN dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( uu.id_UsuUsi, @id_Sistema )
			 WHEN @ASC_DESC = 'D' AND @OrderBy = 'Perfis'
				THEN dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( uu.id_UsuUsi, @id_Sistema, 1 )
			 WHEN @ASC_DESC = 'D' --AND @OrderBy IS NULL
				THEN nm_Pessoa
			 ELSE    
				''
		 END AS Campo_DESC

    FROM dbo.Pessoa_Usina pu
	    JOIN dbo.Usuario_Usina uu ON uu.id_PesUsi = pu.id_PesUsi
	    JOIN dbo.Usuario_Seguranca us ON us.id_UsuUsi = uu.id_UsuUsi
	    --LEFT JOIN dbo.UsuarioUsi_Sistema uus 
	    --   ON uus.id_UsuUsi = uu.id_UsuUsi

    WHERE (@nu_Mat IS NULL OR pu.nu_Mat = @nu_Mat)
      AND (@nu_Filial IS NULL OR pu.nu_Filial = @nu_Filial)
      AND (@id_UsuUsi IS NULL OR uu.id_UsuUsi = @id_UsuUsi)
      AND (@cd_Login IS NULL OR uu.cd_Login = @cd_Login)
--	 AND (@id_Sistema IS NULL OR uus.id_Sistema = @id_Sistema)
	 AND (@fl_Bloqueado IS NULL OR us.fl_Bloqueado = @fl_Bloqueado)

    ORDER BY Campo_ASC
           , Campo_DESC DESC
			  
END

