/*
select * from Pessoa_Usina
select * from Usuario_Usina
select * from Usuario_Seguranca


SELECT * FROM [Erp.Protheus10].dbo.SRA010
WHERE RA_NOME LIKE '%Jose Valdeck Barbosa%'

*/
DECLARE @Identity INT
DECLARE @id_UsuUsi INT
DECLARE @Mat CHAR(6)
DECLARE @Fil Char(2)
DECLARE @Nome VARCHAR(50)
DECLARE @login VARCHAR(50)

SET @Mat = '000579'
SET @Fil = '02'
SET @Nome ='Samuel Alves dos Santos'
SET @login = 'samuelalves'

INSERT INTO dbo.Pessoa_Usina
(
    --id_PesUsi - this column value is auto-generated
    nm_Pessoa,
    nu_Filial,
    nu_Mat,
    nu_MatUnificada,
    dt_CadastroPesUsi,
    fl_ExclusaoPesUsi
)
VALUES
(
    -- id_PesUsi - int
    RTRIM(@Nome), -- nm_Pessoa - varchar
    @Fil, -- nu_Filial - varchar
    @Mat, -- nu_Mat - varchar
    '', -- nu_MatUnificada - varchar
    '2016-01-01 00:00:00', -- dt_CadastroPesUsi - datetime
    0 -- fl_ExclusaoPesUsi - bit
)

SET @Identity = @@IDENTITY
SELECT 'Pessoa_Usina '+CAST(@Identity AS VARCHAR)

-- select * from Pessoa_Usina
-- select * from Usuario_Usina

INSERT INTO dbo.Usuario_Usina
([id_PesUsi], [cd_Login], [dt_CadastroUsuUsi])
VALUES
(@Identity, @login, getdate())

SET @Identity = @@IDENTITY
SET @id_UsuUsi = @Identity
SELECT 'Usuario_Usina '+CAST(@Identity AS VARCHAR)

INSERT INTO [dbo].[Usuario_Seguranca]
([id_UsuUsi], [de_Senha], [tp_FormatoSenha])
VALUES
(@Identity, '1', 0)

SELECT 'Usuario_Seguranca', @@IDENTITY


INSERT dbo.Gestor
(
    --id_Gestor - this column value is auto-generated
    dt_InicioExercicio,
    dt_FimExercicio,
    fl_Exclusao,
    tp_Gestor,
    id_UsuUsi
)
VALUES
(
    -- id_Gestor - int
    '2016-01-01 00:00:00', -- dt_InicioExercicio - datetime
    NULL, -- dt_FimExercicio - datetime
    0, -- fl_Exclusao - bit
    2, -- tp_Gestor - smallint
    @id_UsuUsi -- id_UsuUsi - int
)
SET @Identity = @@IDENTITY
SELECT 'Gestor '+CAST(@Identity AS VARCHAR)