SELECT * FROM dbo.Sistema s

INSERT dbo.UsuarioUsi_Sistema
(
    --id_UsuUsi_Sis - this column value is auto-generated
    id_Sistema,
    id_UsuUsi,
    dt_AtivacaoUsuSis,
    dt_DesativacaoUsuSis
)
VALUES
(
    -- id_UsuUsi_Sis - int
    3, -- id_Sistema - int
    3, -- id_UsuUsi - int
    '2016-03-01 00:00:00', -- dt_AtivacaoUsuSis - datetime
    null -- dt_DesativacaoUsuSis - datetime
)


INSERT dbo.UsuarioUsi_Sistema
(
    --id_UsuUsi_Sis - this column value is auto-generated
    id_Sistema,
    id_UsuUsi,
    dt_AtivacaoUsuSis,
    dt_DesativacaoUsuSis
)
VALUES
(
    -- id_UsuUsi_Sis - int
    2, -- id_Sistema - int
    2, -- id_UsuUsi - int
    '2016-01-14 00:00:00', -- dt_AtivacaoUsuSis - datetime
    null -- dt_DesativacaoUsuSis - datetime
)


INSERT dbo.UsuarioUsi_Sistema
(
    --id_UsuUsi_Sis - this column value is auto-generated
    id_Sistema,
    id_UsuUsi,
    dt_AtivacaoUsuSis,
    dt_DesativacaoUsuSis
)
VALUES
(
    -- id_UsuUsi_Sis - int
    3, -- id_Sistema - int
    2, -- id_UsuUsi - int
    '2016-03-01 00:00:00', -- dt_AtivacaoUsuSis - datetime
    null -- dt_DesativacaoUsuSis - datetime
)