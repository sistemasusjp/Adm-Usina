SELECT * FROM dbo.Pessoa_Usina pu
SELECT * FROM dbo.Usuario_Usina uu
SELECT * FROM Usuario_Seguranca us
-- select ident_current('dbo.Usuario_Usina')
-- DBCC CHECKIDENT ('Usuario_Usina', RESEED, 2)
--delete from Pessoa_Usina WHERE id_PesUsi = 4
-----------------------------------------------------------
--------------------- Pessoa_Usina -----------------------
INSERT dbo.Pessoa_Usina
(
    --Id_PesUsi - this column value is auto-generated
    nm_Pessoa,
    nu_Filial,
    nu_Mat,
    nu_MatUnificada,
    --nu_Cpf,
    -- de_Ramais,
    dt_Nascimento,
    --cd_Sexo,
    de_EmailPessoa,
    --de_Observacao,
    dt_CadastroPesUsi
    --fl_ExclusaoPesUsi,
    --de_MotivoExcPesUsi
)
VALUES
(
    -- Id_PesUsi - int
    'Dennis Aragao', -- nm_Pessoa - varchar
    '01',--'00', -- nu_Filial - varchar
    '007190',--'000000', -- nu_Mat - varchar
    '1',--'00000000', -- nu_MatUnificada - varchar
    --NULL, -- nu_Cpf - char
    --NULL, -- de_Ramais - varchar
    '1978-03-28 00:00:00', -- dt_Nascimento - datetime
    --'M', -- cd_Sexo - char
    'dennis.santos@usjp.com.br', -- de_EMailPessoa - varchar
    --NULL, -- de_Observacao - text
    '2016-03-04 08:48:13' -- dt_CadastroPesUsi - datetime
    --0, -- fl_ExclusaoPesUsi - bit
    --NULL -- de_MotivoExcPesUsi - varchar
)



-----------------------------------------------------------
--------------------- Usuario_Usina -----------------------
--SET IDENTITY_INSERT dbo.Usuario_Usina ON
INSERT dbo.Usuario_Usina
(
    --Id_UsuUsi, -- this column value is auto-generated
    Id_PesUsi,
    cd_Login,
    --fl_Externo,
    --fl_AtivoUsuUsi,
    dt_CadastroUsuUsi
    --fl_ExclusaoUsuUsi,
    --de_MotivoExcUsuUsi
)
VALUES
(
    -- Id_UsuUsi - int
    3, -- Id_PesUsi - int
    'dennis', -- cd_Login - varchar
    --0, -- fl_Externo - bit
    --1, -- fl_AtivoUsuUsi - bit
    '2016-03-04 00:00:00' -- dt_CadastroUsuUsi - datetime
    --0, -- fl_ExclusaoUsuUsi - bit
    --NULL -- de_MotivoExcUsuUsi - varchar
)
SELECT @@IDENTITY
--SET IDENTITY_INSERT dbo.Usuario_Usina OFF


-----------------------------------------------------------
------------------ Usuario_Seguranca ----------------------
INSERT dbo.Usuario_Seguranca
(
    Id_UsuUsi,
    de_Senha,
    tp_FormatoSenha,
    de_EmailSeguranca,
    de_PerguntaEsquecimento,
    de_RespostaEsquecimento,
    --fl_Bloqueado,
    --fl_ObrigarAlteracaoSenha,
    dt_UltimoLogin,
    dt_UltimaModificacaoSenha,
    dt_UltimoBloqueio,
    qt_TentativasSenhaErrada,
    qt_TentativasRespostaErrada,
    de_Observacao
)
VALUES
(
    3, -- Id_UsuUsi - int
    '123Mudar', -- de_Senha - varchar
    0, -- tp_FormatoSenha - int
    'dennis.santos@usjp.com.br', -- de_EmailSeguranca - varchar
    NULL, -- de_PerguntaEsquecimento - varchar
    NULL, -- de_RespostaEsquecimento - varchar
    --0, -- fl_Bloqueado - bit
    --0, -- fl_ObrigarAlteracaoSenha - bit
    NULL,--'2016-02-24 08:38:30', -- dt_UltimoLogin - datetime
    NULL,--'2016-02-24 08:38:30', -- dt_UltimaModificacaoSenha - datetime
    NULL,--'2016-02-24 08:38:30', -- dt_UltimoBloqueio - datetime
    0, -- qt_TentativasSenhaErrada - int
    0, -- qt_TentativasRespostaErrada - int
    '' -- de_Observacao - text
)
SELECT @@IDENTITY