SET IDENTITY_INSERT dbo.Sistema ON
select IDENT_CURRENT('dbo.Sistema')
DELETE FROM sistema 
--UPDATE sistema 
--SET nm_Sistema = 'Acesso Refetório'
--    , sg_Sistema = 'AcRefeit'
--    , dt_AtivacaoSis = GETDATE()
--WHERE id_Sistema = 1

INSERT dbo.Sistema
(
    --id_Sistema,  -- this column value is auto-generated
    cd_Sistema, 
    nm_Sistema, sg_Sistema, nm_CaminhoInicioSis,
    img_Sistema, dt_AtivacaoSis, dt_DesativacaoSis
)
VALUES
(
    --1,-- id_Sistema - int
    1,
    'ADM Usina', -- nm_Sistema - varchar
    'ADMUsi', -- sg_Sistema - varchar
    null, -- nm_CaminhoInicioSis - varchar
    null, -- img_Sistema - varbinary
    '2016-03-01 00:00:00', -- dt_AtivacaoSis - datetime
    null -- dt_DesativacaoSis - datetime
)
SELECT @@IDENTITY
INSERT dbo.Sistema
(
    --id_Sistema,  -- this column value is auto-generated
    cd_Sistema, 
    nm_Sistema, sg_Sistema, nm_CaminhoInicioSis,
    img_Sistema, dt_AtivacaoSis, dt_DesativacaoSis
)
VALUES
(
    --2,-- id_Sistema - int
    2,
    'Abastecimento', -- nm_Sistema - varchar
    'Abast', -- sg_Sistema - varchar
    null, -- nm_CaminhoInicioSis - varchar
    null, -- img_Sistema - varbinary
    '2016-01-14 00:00:00', -- dt_AtivacaoSis - datetime
    null -- dt_DesativacaoSis - datetime
)
-- Acvesso Refeitório
INSERT dbo.Sistema
(
    --id_Sistema,  -- this column value is auto-generated
    cd_Sistema, 
    nm_Sistema, sg_Sistema, nm_CaminhoInicioSis,
    img_Sistema, dt_AtivacaoSis, dt_DesativacaoSis
)
VALUES
(
    --3,-- id_Sistema - int
    3,
    'Acesso Refetório', -- nm_Sistema - varchar
    'AcRefeit', -- sg_Sistema - varchar
    null, -- nm_CaminhoInicioSis - varchar
    null, -- img_Sistema - varbinary
    '2016-03-01 00:00:00', -- dt_AtivacaoSis - datetime
    null -- dt_DesativacaoSis - datetime
)
SET IDENTITY_INSERT dbo.Sistema OFF
