
-- Perfis por Sistema
SELECT 
       s.nm_Sistema
	, ps.nm_PerSis
	, ps.id_PerSis
	, cd_PerSis
     
FROM ADM_Usina.dbo.Sistema s

     JOIN ADM_Usina.dbo.Perfil_Sistema ps
	   ON ps.id_Sistema = s.id_Sistema	
WHERE s.id_Sistema = 4
ORDER BY 1, 4



-- Tudos
SELECT 
       s.nm_Sistema
	, ps.nm_PerSis
	, uu.cd_Login
     , pu.nm_Pessoa
	, ps.id_PerSis
	, cd_PerSis
     , CAST(pu.id_PesUsi AS VARCHAR)+'' AS id_PesUsi
	, uu.id_UsuUsi
	, uus.id_Sistema
     , CAST(uups.id_Usu_PerSis AS VARCHAR)+'' AS id_Usu_PerSis, us.de_Senha
     
FROM ADM_Usina.dbo.Pessoa_Usina pu

     JOIN ADM_Usina.dbo.Usuario_Usina uu
	   ON uu.id_PesUsi = pu.id_PesUsi

     JOIN ADM_Usina.dbo.Sistema s
	   ON s.id_Sistema = 4

     JOIN ADM_Usina.dbo.Perfil_Sistema ps
	   ON ps.id_Sistema = s.id_Sistema	
	   
     JOIN ADM_Usina.dbo.UsuarioUsi_Sistema uus
	   ON uus.id_UsuUsi = uu.id_UsuUsi
	   AND uus.id_Sistema = s.id_Sistema

     JOIN ADM_Usina.dbo.UsuarioUsi_PerSis uups
	   ON uups.id_UsuUsi = uu.id_UsuUsi
        AND uups.id_PerSis = ps.id_PerSis

     JOIN ADM_Usina.dbo.Usuario_Seguranca us
	   ON uu.id_usuUsi = us.id_UsuUsi
WHERE s.id_Sistema = 4
  AND uu.id_UsuUsi = 22

-----------------------------------------

--DBCC CHECKIDENT ('Pessoa_Usina') -- DBCC CHECKIDENT ('Pessoa_Usina', RESEED, 9)
--DBCC CHECKIDENT ('Usuario_Usina') -- DBCC CHECKIDENT ('Usuario_Usina', RESEED, 21)
----DELETE FROM Usuario_Usina WHERE Usuario_Usina.id_UsuUsi > 21
--SELECT 
--      uu.cd_Login, uu.id_UsuUsi, pu.*, uu.*, *
--FROM ADM_Usina.dbo.Pessoa_Usina pu

--    left JOIN ADM_Usina.dbo.Usuario_Usina uu
--	   ON uu.id_PesUsi = pu.id_PesUsi

-----------------------------------------


--SELECT PS.*, UUPS.* FROM dbo.Perfil_Sistema ps 
--    LEFT JOIN dbo.UsuarioUsi_PerSis uups ON uups.id_PerSis = ps.id_PerSis
--WHERE id_Sistema = 4

--SELECT * FROM dbo.Usuario_Seguranca uups

--DBCC CHECKIDENT ('Usuario_Seguranca')
--DBCC CHECKIDENT ('UsuarioUsi_PerSis', RESEED, 11)

