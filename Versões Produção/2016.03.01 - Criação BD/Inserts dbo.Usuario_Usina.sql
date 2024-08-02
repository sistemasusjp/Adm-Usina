--------------------------------------- Admin. Usina
INSERT dbo.Usuario_Usina
(
    --id_UsuUsi - this column value is auto-generated
    id_PesUsi,
    cd_Login,
    fl_Externo,
    dt_CadastroUsuUsi,
    fl_ExclusaoUsuUsi,
    de_MotivoExcUsuUsi
)
VALUES
(
    -- id_UsuUsi - int
    1, -- id_PesUsi - int
    'adm-usina', -- cd_Login - varchar
    0, -- fl_Externo - bit
    '2016-03-01 00:00:00', -- dt_CadastroUsuUsi - datetime
    0, -- fl_ExclusaoUsuUsi - bit
    null -- de_MotivoExcUsuUsi - varchar
)


--------------------------------------- Adm Geraldo
INSERT dbo.Usuario_Usina
(
    --id_UsuUsi - this column value is auto-generated
    id_PesUsi,
    cd_Login,
    fl_Externo,
    dt_CadastroUsuUsi,
    fl_ExclusaoUsuUsi,
    de_MotivoExcUsuUsi
)
VALUES
(
    -- id_UsuUsi - int
    1, -- id_PesUsi - int
    'adm-geraldo', -- cd_Login - varchar
    0, -- fl_Externo - bit
    '2016-03-01 00:00:00', -- dt_CadastroUsuUsi - datetime
    0, -- fl_ExclusaoUsuUsi - bit
    null -- de_MotivoExcUsuUsi - varchar
)
