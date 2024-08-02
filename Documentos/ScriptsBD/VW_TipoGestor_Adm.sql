
----------------------------------------------------------------------------------------------------------------
-- Criação da View Tipo_Gestor_Adm_Vw						
-- select * from Tipo_Gestor_Adm_Vw
IF object_id(N'dbo.Tipo_Gestor_Adm_Vw', 'V') IS NOT NULL
	DROP VIEW dbo.Tipo_Gestor_Adm_Vw
GO

CREATE VIEW dbo.Tipo_Gestor_Adm_Vw AS 
    
    SELECT 1 AS tp_Gestor, 'Diretor' AS de_tp_Gestor
    UNION
    SELECT 2, 'Gerente'
    UNION
    SELECT 3, 'Gestor' 
 
GO