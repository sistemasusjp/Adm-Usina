--SELECT * FROM UsuarioUsi_Sistema WHERE id_Sistema = 4
  
SELECT uu.id_UsuUsi, pu.id_PesUsi, cd_Login, de_Senha, nm_Pessoa, cd_PerSis, nm_PerSis, uus.id_UsuUsi_Sis, fl_Bloqueado, fl_ExclusaoPesUsi, fl_ExclusaoUsuUsi
FROM Pessoa_Usina pu 
     LEFT JOIN Usuario_Usina uu ON pu.id_PesUsi = uu.id_PesUsi
     LEFT JOIN UsuarioUsi_PerSis uups ON uups.id_UsuUsi = uu.id_UsuUsi
     LEFT JOIN Perfil_Sistema ps ON ps.id_PerSis = uups.id_PerSis AND ps.id_Sistema = 4	   
     LEFT JOIN UsuarioUsi_Sistema uus ON uus.id_UsuUsi = uu.id_UsuUsi
     LEFT JOIN Usuario_Seguranca us ON us.id_UsuUsi = uu.id_UsuUsi

ORDER BY CASE WHEN id_UsuUsi_Sis IS NULL THEN 0 ELSE 1 END, nm_Pessoa
/*
EXEC PR_Con_Usuario_Completo_ADM 

SELECT * FROM Perfil_Sistema

SELECT * FROM Log_Adm_Usina lau ORDER BY dt_Log DESC

 SELECT ps.nm_PerSis, *
	   FROM UsuarioUsi_PerSis uups
		    JOIN Perfil_Sistema ps 
		   ON uups.id_PerSis = ps.id_PerSis
		  AND ps.id_Sistema = ISNULL(4, ps.id_Sistema)
	   WHERE id_UsuUsi = 1
*/
