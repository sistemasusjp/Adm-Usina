
----------------------------------------------------------------------------------------------------------------
-- Criação da View Funcionario_Protheus_VW					Utilizada: CPP
-- select * from DBO.Funcionario_Protheus_VW
--
-- RA_SITFOLH: (T)ransferido	(D)emitido		(F)érias	  (A)    ?????????
IF object_id(N'dbo.Funcionario_Protheus_VW', 'V') IS NOT NULL
	DROP VIEW dbo.Funcionario_Protheus_VW
GO
SET DATEFORMAT DMY
GO
CREATE VIEW dbo.Funcionario_Protheus_VW AS 
	SELECT DISTINCT
		   CONVERT( NUMERIC, CONVERT(VARCHAR, CONVERT(NUMERIC,RA_FILIAL))
		                   + CONVERT(VARCHAR, CONVERT(NUMERIC,RA_MAT)) ) AS nu_MatUnificada
	     , RA_FILIAL, RA_MAT, RA_CC, RA_NOME, RA_DEMISSA
		, RA_CIC, RA_SEXO, RA_NASC

	FROM [Erp.Protheus10].dbo.SRA010
	WHERE ( ( RTRIM(RA_DEMISSA) = '' 
 			  AND (RA_SITFOLH <> 'D' AND RA_SITFOLH <> 'T')
		    )
		  )
	  AND D_E_L_E_T_ = ''
	  AND RA_FILIAL <> ''

GO
