SELECT g.id_Gestor, uu.*,
      nm_Pessoa, de_Senha, nu_MatUnificada
	, dt_CadastroPesUsi
	, *
FROM ADM_Usina.dbo.Usuario_Usina uu
     JOIN ADM_Usina.dbo.Pessoa_Usina pu
	ON pu.id_PesUsi = uu.id_PesUsi
     JOIN ADM_Usina.dbo.Usuario_Seguranca us
	ON us.id_UsuUsi = uu.id_UsuUsi
	LEFT JOIN ADM_Usina.dbo.Gestor g
     ON G.id_UsuUsi = uu.id_UsuUsi
	and g.fl_Exclusao = 0 and dt_FimExercicio is null

SELECT * FROM Gestor_Adm_Vw
where fl_Exclusao = 0

SELECT * FROM  Gestor_Centro_Custo_Adm_Vw
where dt_FimGestao is null

SELECT * FROM ADM_Usina.dbo.Gestor_Centro_Custo


SELECT g.*, de_tp_Gestor
FROM ADM_Usina.dbo.Gestor g
     JOIN ADM_Usina.dbo.Tipo_Gestor_Adm_Vw tgav
	ON tgav.tp_Gestor = g.tp_Gestor
where g.fl_Exclusao = 0 and dt_FimExercicio is null




