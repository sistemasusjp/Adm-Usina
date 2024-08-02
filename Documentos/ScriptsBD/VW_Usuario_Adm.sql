
----------------------------------------------------------------------------------------------------------------
-- Criação da View Usuario_Adm_Vw						
-- select * from Usuario_Adm_Vw
IF object_id(N'dbo.Usuario_Adm_Vw', 'V') IS NOT NULL
	DROP VIEW dbo.Usuario_Adm_Vw
GO

CREATE VIEW dbo.Usuario_Adm_Vw AS 
    
    SELECT uu.*
         , pu.nu_Mat, pu.nu_Filial, pu.nu_MatUnificada, pu.nm_Pessoa
	    , pu.fl_ExclusaoPesUsi, pu.de_MotivoExcPesUsi, pu.de_EMailPessoa
	    , us.fl_Bloqueado--, func.RA_NOME
         , CASE fl_Bloqueado
              WHEN 0 THEN 'Não'
              WHEN 1 THEN 'Sim'
           END AS de_fl_Bloqueado
    FROM ADM_Usina.dbo.Usuario_Usina uu
	    JOIN ADM_Usina.dbo.Pessoa_Usina pu 
		  ON pu.id_PesUsi = uu.id_PesUsi
	    JOIN ADM_Usina.dbo.Usuario_Seguranca us 
		  ON us.id_UsuUsi = uu.id_UsuUsi
	  -- LEFT JOIN [Erp.Protheus10].dbo.SRA010 Func
		 -- ON func.Ra_Mat = pu.nu_Mat
		 --AND func.Ra_Filial = pu.nu_Filial
                                          
    WHERE uu.fl_ExclusaoUsuUsi = 0
--	 AND us.fl_Bloqueado = 0
  
GO

