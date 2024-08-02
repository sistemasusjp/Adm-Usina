
----------------------------------------------------------------------------------------------------------------
-- Criação da View Gestor_Adm_Vw						
-- select * from Gestor_Adm_Vw

-- 21/09/2021	Geraldo		Adicionados JOINS com UsuarioUsi_PerSis e Perfil_Sistema para criticar campos de exclusão e ativação
-- 24/09/2021	Geraldo		Adicionado cd_PerSis = '3' -- 3 = Gestor: Osmário tem dois perfis
IF object_id(N'dbo.Gestor_Adm_Vw', 'V') IS NOT NULL
	DROP VIEW dbo.Gestor_Adm_Vw
GO

CREATE VIEW dbo.Gestor_Adm_Vw AS 
    
    SELECT 
		 pu.nm_Pessoa
         , g.id_UsuUsi
         , g.id_Gestor
         , g.tp_Gestor
	    , tg.de_tp_Gestor
	    , dbo.FN_Buscar_Area_Gestor_ADM(G.id_Gestor, 1) AS Lista_id_ClassifAreaCC
	    , dbo.FN_Buscar_Area_Gestor_ADM(G.id_Gestor, 0) AS Lista_de_ClassifAreaCC
         , g.dt_InicioExercicio
         , g.dt_FimExercicio
	    --, tca.id_ClassifAreaCC
	    --, tca.de_ClassifAreaCC
	    , pu.nu_Mat, pu.nu_Filial, pu.nu_MatUnificada
         , g.fl_Exclusao
	    , pu.fl_ExclusaoPesUsi
         , uu.fl_ExclusaoUsuUsi

    FROM ADM_Usina.dbo.Gestor g
	    JOIN ADM_Usina.dbo.Usuario_Usina uu
		  ON uu.id_UsuUsi = g.id_UsuUsi
	    JOIN ADM_Usina.dbo.Pessoa_Usina pu 
		  ON pu.id_PesUsi = uu.id_PesUsi
	    JOIN ADM_Usina.dbo.Tipo_Gestor_Adm_Vw tg
		  ON g.tp_Gestor = tg.tp_Gestor
	   -- LEFT JOIN ADM_Usina.dbo.Tab_Classificacao_Area_CC tca
		  --ON tca.id_Gestor = g.id_Gestor
   -- Daqui pra baixo adicionado dia 21/09/2021
		 JOIN UsuarioUsi_PerSis ups
		   ON ups.id_UsuUsi = G.id_UsuUsi
		 JOIN Perfil_Sistema ps
		   ON ps.id_PerSis= ups.id_PerSis
		  AND ps.cd_PerSis <> '8' -- 8 = Edição Folha: Osmário tem dois perfis Gestor e Ed. Folha

	WHERE fl_Exclusao = 0
	  AND fl_ExclusaoUsuUsi = 0
	  AND g.dt_FimExercicio is null
	  AND id_Sistema = 4
 
GO
