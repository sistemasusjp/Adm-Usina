--------------------------------------- Admin. Usina
INSERT dbo.Pessoa_Usina
(
    --id_PesUsi - this column value is auto-generated
    nm_Pessoa, nu_Filial, nu_Mat, nu_MatUnificada, nu_Cpf,de_Ramais, dt_Nascimento,
    cd_Sexo, de_EMailPessoa, de_Observacao, dt_CadastroPesUsi, fl_ExclusaoPesUsi, de_MotivoExcPesUsi
)
VALUES
(
    -- id_PesUsi - int
    'Admin. Usina', -- nm_Pessoa - varchar
    null, -- nu_Filial - varchar
    null, -- nu_Mat - varchar
    null, -- nu_MatUnificada - varchar
    null, -- nu_Cpf - char
    null, -- de_Ramais - varchar
    null,--'2016-03-01 00:00:00', -- dt_Nascimento - datetime
    null,--'', -- cd_Sexo - char
    'geraldo.santos@usjp.com.br', -- de_EMailPessoa - varchar
    null,--'', -- de_Observacao - text
    '2016-03-01 00:00:00', -- dt_CadastroPesUsi - datetime
    0, -- fl_ExclusaoPesUsi - bit
    null -- de_MotivoExcPesUsi - varchar
)


--------------------------------------- Adm Geraldo
INSERT dbo.Pessoa_Usina
(
    --id_PesUsi - this column value is auto-generated
    nm_Pessoa, nu_Filial, nu_Mat, nu_MatUnificada, nu_Cpf,de_Ramais, dt_Nascimento,
    cd_Sexo, de_EMailPessoa, de_Observacao, dt_CadastroPesUsi, fl_ExclusaoPesUsi, de_MotivoExcPesUsi
)
VALUES
(
    -- id_PesUsi - int
    'Geraldo Ferreira', -- nm_Pessoa - varchar
    '01', -- nu_Filial - varchar
    '007723', -- nu_Mat - varchar
    '9',--null, -- nu_MatUnificada - varchar
    null, -- nu_Cpf - char
    '204, 225', -- de_Ramais - varchar
    '1980-05-13 00:00:00', -- dt_Nascimento - datetime
    'M',--'', -- cd_Sexo - char
    'geraldo.santos@usjp.com.br', -- de_EMailPessoa - varchar
    null,--'', -- de_Observacao - text
    '2016-03-01 00:00:00', -- dt_CadastroPesUsi - datetime
    0, -- fl_ExclusaoPesUsi - bit
    null -- de_MotivoExcPesUsi - varchar
)


--------------------------------------- Adm Geraldo
INSERT dbo.Pessoa_Usina
(
    --id_PesUsi - this column value is auto-generated
    nm_Pessoa, nu_Filial, nu_Mat, nu_MatUnificada, nu_Cpf,de_Ramais, dt_Nascimento,
    cd_Sexo, de_EMailPessoa, de_Observacao, dt_CadastroPesUsi, fl_ExclusaoPesUsi, de_MotivoExcPesUsi
)
VALUES
(
    -- id_PesUsi - int
    'Geraldo Ferreira', -- nm_Pessoa - varchar
    '01', -- nu_Filial - varchar
    '007723', -- nu_Mat - varchar
    '9',--null, -- nu_MatUnificada - varchar
    null, -- nu_Cpf - char
    '204, 225', -- de_Ramais - varchar
    '1980-05-13 00:00:00', -- dt_Nascimento - datetime
    'M',--'', -- cd_Sexo - char
    'geraldo.santos@usjp.com.br', -- de_EMailPessoa - varchar
    null,--'', -- de_Observacao - text
    '2016-03-01 00:00:00', -- dt_CadastroPesUsi - datetime
    0, -- fl_ExclusaoPesUsi - bit
    null -- de_MotivoExcPesUsi - varchar
)