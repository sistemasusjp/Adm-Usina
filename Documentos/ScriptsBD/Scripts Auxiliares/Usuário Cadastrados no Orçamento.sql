 SELECT pu.nm_Pessoa, cd_Login, isnull(pu.de_EMailPessoa, ''), ISNULL(us.de_EmailSeguranca, '')
    FROM ADM_Usina.dbo.Usuario_Usina uu
	    JOIN ADM_Usina.dbo.Pessoa_Usina pu 
		  ON pu.id_PesUsi = uu.id_PesUsi
	    JOIN ADM_Usina.dbo.Usuario_Seguranca us 
		  ON us.id_UsuUsi = uu.id_UsuUsi
	    JOIN ADM_Usina.dbo.UsuarioUsi_Sistema uus
		  ON uus.id_Sistema = 4 -- 4 - Sistema de Orçamento
		 AND uus.id_UsuUsi = us.id_UsuUsi 
WHERE uu.cd_Login <> 'adm-usina'
ORDER BY pu.nm_Pessoa