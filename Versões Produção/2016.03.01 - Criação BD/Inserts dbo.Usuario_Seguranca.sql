INSERT dbo.Usuario_Seguranca
(
    id_UsuUsi,
    de_Senha,
    tp_FormatoSenha,
    de_EmailSeguranca,
    de_PerguntaEsquecimento,
    de_RespostaEsquecimento,
    fl_Bloqueado,
    fl_ObrigarAlteracaoSenha,
    dt_UltimoLogin,
    dt_UltimaModificacaoSenha,
    dt_UltimoBloqueio,
    qt_TentativasSenhaErrada,
    qt_TentativasRespostaErrada,
    de_Observacao
)
VALUES
(
    1, -- id_UsuUsi - int
    'adm#3', -- de_Senha - varchar
    0, -- tp_FormatoSenha - int
    'geraldo.santos@usjp.com.br', -- de_EmailSeguranca - varchar
    null, -- de_PerguntaEsquecimento - varchar
    null, -- de_RespostaEsquecimento - varchar
    0, -- fl_Bloqueado - bit
    0, -- fl_ObrigarAlteracaoSenha - bit
    '2016-03-01 10:09:38', -- dt_UltimoLogin - datetime
    null, -- dt_UltimaModificacaoSenha - datetime
    null, -- dt_UltimoBloqueio - datetime
    0, -- qt_TentativasSenhaErrada - int
    0, -- qt_TentativasRespostaErrada - int
    null -- de_Observacao - text
)


INSERT dbo.Usuario_Seguranca
(
    id_UsuUsi,
    de_Senha,
    tp_FormatoSenha,
    de_EmailSeguranca,
    de_PerguntaEsquecimento,
    de_RespostaEsquecimento,
    fl_Bloqueado,
    fl_ObrigarAlteracaoSenha,
    dt_UltimoLogin,
    dt_UltimaModificacaoSenha,
    dt_UltimoBloqueio,
    qt_TentativasSenhaErrada,
    qt_TentativasRespostaErrada,
    de_Observacao
)
VALUES
(
    2, -- id_UsuUsi - int
    'grj#3', -- de_Senha - varchar
    0, -- tp_FormatoSenha - int
    'geraldo.santos@usjp.com.br', -- de_EmailSeguranca - varchar
    null, -- de_PerguntaEsquecimento - varchar
    null, -- de_RespostaEsquecimento - varchar
    0, -- fl_Bloqueado - bit
    0, -- fl_ObrigarAlteracaoSenha - bit
    '2016-03-01 10:09:38', -- dt_UltimoLogin - datetime
    null, -- dt_UltimaModificacaoSenha - datetime
    null, -- dt_UltimoBloqueio - datetime
    0, -- qt_TentativasSenhaErrada - int
    0, -- qt_TentativasRespostaErrada - int
    null -- de_Observacao - text
)