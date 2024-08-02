SELECT * FROM dbo.Pessoa_Usina pu
SELECT * FROM dbo.Usuario_Usina uu
SELECT * FROM Usuario_Seguranca us

SELECT * 
 FROM Usuario_Usina uu 
      JOIN Pessoa_Usina pu 
      ON pu.id_PesUsi = uu.id_PesUsi 
WHERE cd_Login = 'adM-usinA'

SELECT *
FROM Usuario_Usina uu
     JOIN Usuario_Seguranca us
     ON us.id_UsuUsi = uu.id_UsuUsi
WHERE UPPER(cd_Login) = UPPER('adm-usina');


sp_help UsuarioUsi_PerSis