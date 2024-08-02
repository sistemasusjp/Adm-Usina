
----------------------------------------------------------------------------------------------------------------
-- Criação da View Gestor_Centro_Custo_Adm_Vw						
-- select * from Gestor_Centro_Custo_Adm_Vw
IF object_id(N'dbo.Gestor_Centro_Custo_Adm_Vw', 'V') IS NOT NULL
	DROP VIEW dbo.Gestor_Centro_Custo_Adm_Vw
GO

CREATE VIEW dbo.Gestor_Centro_Custo_Adm_Vw AS 
    
    SELECT gcc.*
         , CTT.CTT_DESC01
         , CTT.D_E_L_E_T_
         , CTT.CTT_CLASCC
         , g.fl_Exclusao
         , g.dt_InicioExercicio
         , g.dt_FimExercicio
         , g.tp_Gestor
         --, g.id_ClassifAreaCC
	    , tg.de_tp_Gestor
         , pu.nu_Mat, pu.nu_Filial, pu.nu_MatUnificada, pu.nm_Pessoa
         , pu.fl_ExclusaoPesUsi, uu.fl_ExclusaoUsuUsi, uu.id_UsuUsi

    FROM ADM_Usina.dbo.Gestor_Centro_Custo gcc
	    JOIN [Erp.Protheus10].dbo.CTT010 ctt
		  ON ctt.Ctt_Custo = gcc.Ctt_Custo
			-- 20/03/2018 O Protheus voltou a utilizar a tabela de Centro de Custo da forma antiga
	        -- AND Ctt.CTT_FILIAL = '01' -- 03/03/2018 Adicionada para burlar problrma gerado pelo protheus pois a tabela passou a ser por filial
	    JOIN ADM_Usina.dbo.Gestor g
		  ON g.id_Gestor = gcc.id_Gestor
	    JOIN ADM_Usina.dbo.Usuario_Usina uu
		  ON uu.id_UsuUsi = g.id_UsuUsi
	    JOIN ADM_Usina.dbo.Pessoa_Usina pu 
		  ON pu.id_PesUsi = uu.id_PesUsi
	    JOIN ADM_Usina.dbo.Tipo_Gestor_Adm_Vw tg
		  ON g.tp_Gestor = tg.tp_Gestor
                                          
 
GO