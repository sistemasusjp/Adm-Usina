/*
 * ER/Studio 8.0 SQL Code Generation
 * Project :      ADM Global
 *
 * Date Created : Tuesday, August 22, 2017 10:33:19
 * Target DBMS : Microsoft SQL Server 2008
 */

USE [Adm-Usina]
go
/* 
 * TABLE: Centro_Custo_Ctt 
 */

CREATE TABLE Centro_Custo_Ctt(
    Ctt_Custo            varchar(9)    NOT NULL,
    id_CentroCustoCtt    int           IDENTITY(1,1),
    id_ClassifAreaCC     int           NULL,
    tp_Visao             smallint      NULL,
    CONSTRAINT PK_Centro_Custo_Ctt PRIMARY KEY CLUSTERED (Ctt_Custo)
)
go



IF OBJECT_ID('Centro_Custo_Ctt') IS NOT NULL
    PRINT '<<< CREATED TABLE Centro_Custo_Ctt >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Centro_Custo_Ctt >>>'
go

/* 
 * TABLE: Gestor 
 */

CREATE TABLE Gestor(
    id_Gestor             int         IDENTITY(1,1),
    dt_InicioExercicio    datetime    NOT NULL,
    dt_FimExercicio       datetime    NULL,
    fl_Exclusao           bit         DEFAULT 0 NOT NULL,
    tp_Gestor             smallint    NOT NULL,
    id_UsuUsi             int         NOT NULL,
    CONSTRAINT PK_Gestor PRIMARY KEY CLUSTERED (id_Gestor)
)
go



IF OBJECT_ID('Gestor') IS NOT NULL
    PRINT '<<< CREATED TABLE Gestor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Gestor >>>'
go

/* 
 * TABLE: Gestor_Centro_Custo 
 */

CREATE TABLE Gestor_Centro_Custo(
    id_GestorCentroCusto    int           IDENTITY(1,1),
    id_Gestor               int           NOT NULL,
    Ctt_Custo               varchar(9)    NOT NULL,
    dt_InicioGestao         datetime      NOT NULL,
    dt_FimGestao            datetime      NULL,
    CONSTRAINT PK_Gestor_Centro_Custo PRIMARY KEY CLUSTERED (id_GestorCentroCusto)
)
go



IF OBJECT_ID('Gestor_Centro_Custo') IS NOT NULL
    PRINT '<<< CREATED TABLE Gestor_Centro_Custo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Gestor_Centro_Custo >>>'
go

/* 
 * TABLE: Log_Adm_Usina 
 */

CREATE TABLE Log_Adm_Usina(
    id_LogAdmUsina     int              IDENTITY(1,1),
    dt_Log             datetime         NOT NULL,
    tp_Log             varchar(20)      NOT NULL,
    nm_TabelaAcao      varchar(255)     NULL,
    id_RegistroAcao    int              NULL,
    de_Dados           varchar(4000)    NULL,
    de_Origem          varchar(255)     NOT NULL,
    de_Mensagem        varchar(1000)    NULL,
    de_Observacao      varchar(1000)    NULL,
    Cod_Dispositivo    varchar(15)      NULL,
    id_Sistema         int              NULL,
    id_UsuUsi          int              NOT NULL,
    CONSTRAINT PK_Log_Adm_Usina PRIMARY KEY CLUSTERED (id_LogAdmUsina)
)
go



IF OBJECT_ID('Log_Adm_Usina') IS NOT NULL
    PRINT '<<< CREATED TABLE Log_Adm_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Log_Adm_Usina >>>'
go

/* 
 * TABLE: Perfil_Sistema 
 */

CREATE TABLE Perfil_Sistema(
    id_PerSis               int             IDENTITY(1,1),
    id_Sistema              int             NOT NULL,
    cd_PerSis               int             NOT NULL,
    nm_PerSis               varchar(100)    NOT NULL,
    de_PerSis               varchar(255)    NOT NULL,
    dt_AtivacaoPerSis       datetime        NOT NULL,
    dt_DesativacaoPerSis    datetime        NULL,
    CONSTRAINT PK_Perfil_Sistema PRIMARY KEY CLUSTERED (id_PerSis)
)
go



IF OBJECT_ID('Perfil_Sistema') IS NOT NULL
    PRINT '<<< CREATED TABLE Perfil_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Perfil_Sistema >>>'
go

/* 
 * TABLE: Pessoa_Usina 
 */

CREATE TABLE Pessoa_Usina(
    id_PesUsi             int             IDENTITY(1,1),
    nm_Pessoa             varchar(300)    NOT NULL,
    nu_Filial             varchar(2)      NULL,
    nu_Mat                varchar(11)     NULL,
    nu_MatUnificada       varchar(11)     NULL,
    nu_Cpf                char(11)        NULL,
    de_Ramais             varchar(30)     NULL,
    dt_Nascimento         datetime        NULL,
    cd_Sexo               char(1)         NULL,
    de_EMailPessoa        varchar(255)    NULL,
    de_Observacao         text            NULL,
    dt_CadastroPesUsi     datetime        NOT NULL,
    fl_ExclusaoPesUsi     bit             DEFAULT 0 NOT NULL,
    de_MotivoExcPesUsi    varchar(255)    NULL,
    CONSTRAINT PK_Pessoa_Usina PRIMARY KEY CLUSTERED (id_PesUsi)
)
go



IF OBJECT_ID('Pessoa_Usina') IS NOT NULL
    PRINT '<<< CREATED TABLE Pessoa_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Pessoa_Usina >>>'
go

/* 
 * TABLE: Sistema 
 */

CREATE TABLE Sistema(
    id_Sistema             int              IDENTITY(1,1),
    cd_Sistema             int              NOT NULL,
    nm_Sistema             varchar(100)     NOT NULL,
    sg_Sistema             varchar(15)      NULL,
    nm_CaminhoInicioSis    varchar(255)     NULL,
    img_Sistema            varbinary(10)    NULL,
    dt_AtivacaoSis         datetime         NOT NULL,
    dt_DesativacaoSis      datetime         NULL,
    CONSTRAINT PK_Sistema PRIMARY KEY CLUSTERED (id_Sistema)
)
go



IF OBJECT_ID('Sistema') IS NOT NULL
    PRINT '<<< CREATED TABLE Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Sistema >>>'
go

/* 
 * TABLE: Tab_Classificacao_Area_CC 
 */

CREATE TABLE Tab_Classificacao_Area_CC(
    id_ClassifAreaCC    int            IDENTITY(1,1),
    de_ClassifAreaCC    varchar(30)    NOT NULL,
    Ctt_ClasCC          varchar(1)     NOT NULL,
    dt_Ativacao         datetime       NOT NULL,
    dt_Desativacao      datetime       NULL,
    id_Gestor           int            NULL,
    CONSTRAINT PK_Tab_Classificacao_Area_CC PRIMARY KEY CLUSTERED (id_ClassifAreaCC)
)
go



IF OBJECT_ID('Tab_Classificacao_Area_CC') IS NOT NULL
    PRINT '<<< CREATED TABLE Tab_Classificacao_Area_CC >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Tab_Classificacao_Area_CC >>>'
go

/* 
 * TABLE: Usuario_Seguranca 
 */

CREATE TABLE Usuario_Seguranca(
    id_UsuUsi                      int             NOT NULL,
    de_Senha                       varchar(128)    NOT NULL,
    tp_FormatoSenha                int             NOT NULL,
    de_EmailSeguranca              varchar(255)    NULL,
    de_PerguntaEsquecimento        varchar(255)    NULL,
    de_RespostaEsquecimento        varchar(128)    NULL,
    fl_Bloqueado                   bit             DEFAULT 0 NOT NULL,
    fl_ObrigarAlteracaoSenha       bit             DEFAULT 0 NOT NULL,
    dt_UltimoLogin                 datetime        NULL,
    dt_UltimaModificacaoSenha      datetime        NULL,
    dt_UltimoBloqueio              datetime        NULL,
    qt_TentativasSenhaErrada       int             DEFAULT 0 NOT NULL,
    qt_TentativasRespostaErrada    int             DEFAULT 0 NOT NULL,
    de_Observacao                  text            NULL,
    CONSTRAINT PK_Usuario_Seguranca PRIMARY KEY CLUSTERED (id_UsuUsi)
)
go



IF OBJECT_ID('Usuario_Seguranca') IS NOT NULL
    PRINT '<<< CREATED TABLE Usuario_Seguranca >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Usuario_Seguranca >>>'
go

/* 
 * TABLE: Usuario_Usina 
 */

CREATE TABLE Usuario_Usina(
    id_UsuUsi             int             IDENTITY(1,1),
    id_PesUsi             int             NOT NULL,
    cd_Login              varchar(30)     NOT NULL,
    fl_Externo            bit             DEFAULT 0 NOT NULL,
    dt_CadastroUsuUsi     datetime        NOT NULL,
    fl_ExclusaoUsuUsi     bit             DEFAULT 0 NOT NULL,
    de_MotivoExcUsuUsi    varchar(255)    NULL,
    CONSTRAINT PK_Usuario_Usina PRIMARY KEY CLUSTERED (id_UsuUsi)
)
go



IF OBJECT_ID('Usuario_Usina') IS NOT NULL
    PRINT '<<< CREATED TABLE Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Usuario_Usina >>>'
go

/* 
 * TABLE: UsuarioUsi_PerSis 
 */

CREATE TABLE UsuarioUsi_PerSis(
    id_Usu_PerSis    int    IDENTITY(1,1),
    id_UsuUsi        int    NOT NULL,
    id_PerSis        int    NOT NULL,
    CONSTRAINT PK_UsuarioUsi_PerSis PRIMARY KEY CLUSTERED (id_Usu_PerSis)
)
go



IF OBJECT_ID('UsuarioUsi_PerSis') IS NOT NULL
    PRINT '<<< CREATED TABLE UsuarioUsi_PerSis >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE UsuarioUsi_PerSis >>>'
go

/* 
 * TABLE: UsuarioUsi_Sistema 
 */

CREATE TABLE UsuarioUsi_Sistema(
    id_UsuUsi_Sis           int         IDENTITY(1,1),
    id_Sistema              int         NOT NULL,
    id_UsuUsi               int         NOT NULL,
    dt_AtivacaoUsuSis       datetime    NOT NULL,
    dt_DesativacaoUsuSis    datetime    NULL,
    CONSTRAINT PK_UsuarioUsi_Sistema PRIMARY KEY CLUSTERED (id_UsuUsi_Sis)
)
go



IF OBJECT_ID('UsuarioUsi_Sistema') IS NOT NULL
    PRINT '<<< CREATED TABLE UsuarioUsi_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE UsuarioUsi_Sistema >>>'
go

/* 
 * INDEX: UK_Centro_Custo_Ctt 
 */

CREATE UNIQUE INDEX UK_Centro_Custo_Ctt ON Centro_Custo_Ctt(id_CentroCustoCtt)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Centro_Custo_Ctt') AND name='UK_Centro_Custo_Ctt')
    PRINT '<<< CREATED INDEX Centro_Custo_Ctt.UK_Centro_Custo_Ctt >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Centro_Custo_Ctt.UK_Centro_Custo_Ctt >>>'
go

/* 
 * INDEX: FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC 
 */

CREATE INDEX FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC ON Centro_Custo_Ctt(id_ClassifAreaCC)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Centro_Custo_Ctt') AND name='FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC')
    PRINT '<<< CREATED INDEX Centro_Custo_Ctt.FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Centro_Custo_Ctt.FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC >>>'
go

/* 
 * INDEX: UK_Gestor 
 */

CREATE UNIQUE INDEX UK_Gestor ON Gestor(id_UsuUsi, dt_InicioExercicio)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gestor') AND name='UK_Gestor')
    PRINT '<<< CREATED INDEX Gestor.UK_Gestor >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gestor.UK_Gestor >>>'
go

/* 
 * INDEX: FK_Gestor__Usuario_Usina 
 */

CREATE INDEX FK_Gestor__Usuario_Usina ON Gestor(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gestor') AND name='FK_Gestor__Usuario_Usina')
    PRINT '<<< CREATED INDEX Gestor.FK_Gestor__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gestor.FK_Gestor__Usuario_Usina >>>'
go

/* 
 * INDEX: UK_Gestor_Centro_Custo 
 */

CREATE UNIQUE INDEX UK_Gestor_Centro_Custo ON Gestor_Centro_Custo(id_Gestor, dt_InicioGestao)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gestor_Centro_Custo') AND name='UK_Gestor_Centro_Custo')
    PRINT '<<< CREATED INDEX Gestor_Centro_Custo.UK_Gestor_Centro_Custo >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gestor_Centro_Custo.UK_Gestor_Centro_Custo >>>'
go

/* 
 * INDEX: FK_Gestor_Centro_Custo__Gestor 
 */

CREATE INDEX FK_Gestor_Centro_Custo__Gestor ON Gestor_Centro_Custo(id_Gestor)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gestor_Centro_Custo') AND name='FK_Gestor_Centro_Custo__Gestor')
    PRINT '<<< CREATED INDEX Gestor_Centro_Custo.FK_Gestor_Centro_Custo__Gestor >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gestor_Centro_Custo.FK_Gestor_Centro_Custo__Gestor >>>'
go

/* 
 * INDEX: FK_Gestor_Centro_Custo__Centro_Custo_Ctt 
 */

CREATE INDEX FK_Gestor_Centro_Custo__Centro_Custo_Ctt ON Gestor_Centro_Custo(Ctt_Custo)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gestor_Centro_Custo') AND name='FK_Gestor_Centro_Custo__Centro_Custo_Ctt')
    PRINT '<<< CREATED INDEX Gestor_Centro_Custo.FK_Gestor_Centro_Custo__Centro_Custo_Ctt >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gestor_Centro_Custo.FK_Gestor_Centro_Custo__Centro_Custo_Ctt >>>'
go

/* 
 * INDEX: FK_Log_Adm_Usina__Sistema 
 */

CREATE INDEX FK_Log_Adm_Usina__Sistema ON Log_Adm_Usina(id_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Log_Adm_Usina') AND name='FK_Log_Adm_Usina__Sistema')
    PRINT '<<< CREATED INDEX Log_Adm_Usina.FK_Log_Adm_Usina__Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Log_Adm_Usina.FK_Log_Adm_Usina__Sistema >>>'
go

/* 
 * INDEX: FK_Log_Adm_Usina__Usuario_Usina 
 */

CREATE INDEX FK_Log_Adm_Usina__Usuario_Usina ON Log_Adm_Usina(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Log_Adm_Usina') AND name='FK_Log_Adm_Usina__Usuario_Usina')
    PRINT '<<< CREATED INDEX Log_Adm_Usina.FK_Log_Adm_Usina__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Log_Adm_Usina.FK_Log_Adm_Usina__Usuario_Usina >>>'
go

/* 
 * INDEX: IDX_Perfil_Sistema__Sistema 
 */

CREATE INDEX IDX_Perfil_Sistema__Sistema ON Perfil_Sistema(id_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Perfil_Sistema') AND name='IDX_Perfil_Sistema__Sistema')
    PRINT '<<< CREATED INDEX Perfil_Sistema.IDX_Perfil_Sistema__Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Perfil_Sistema.IDX_Perfil_Sistema__Sistema >>>'
go

/* 
 * INDEX: UK_Perfil_Sistema 
 */

CREATE UNIQUE INDEX UK_Perfil_Sistema ON Perfil_Sistema(id_Sistema, cd_PerSis)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Perfil_Sistema') AND name='UK_Perfil_Sistema')
    PRINT '<<< CREATED INDEX Perfil_Sistema.UK_Perfil_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Perfil_Sistema.UK_Perfil_Sistema >>>'
go

/* 
 * INDEX: FK_Perfil_Sistema__Sistema 
 */

CREATE INDEX FK_Perfil_Sistema__Sistema ON Perfil_Sistema(id_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Perfil_Sistema') AND name='FK_Perfil_Sistema__Sistema')
    PRINT '<<< CREATED INDEX Perfil_Sistema.FK_Perfil_Sistema__Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Perfil_Sistema.FK_Perfil_Sistema__Sistema >>>'
go

/* 
 * INDEX: UK_Pessoa_Usina_Mat_Filial 
 */

CREATE UNIQUE INDEX UK_Pessoa_Usina_Mat_Filial ON Pessoa_Usina(nu_Filial, nu_Mat)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Pessoa_Usina') AND name='UK_Pessoa_Usina_Mat_Filial')
    PRINT '<<< CREATED INDEX Pessoa_Usina.UK_Pessoa_Usina_Mat_Filial >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Pessoa_Usina.UK_Pessoa_Usina_Mat_Filial >>>'
go

/* 
 * INDEX: IDX_Pessoa_Usina_nu_MatUnificada 
 */

CREATE UNIQUE INDEX IDX_Pessoa_Usina_nu_MatUnificada ON Pessoa_Usina(nu_MatUnificada)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Pessoa_Usina') AND name='IDX_Pessoa_Usina_nu_MatUnificada')
    PRINT '<<< CREATED INDEX Pessoa_Usina.IDX_Pessoa_Usina_nu_MatUnificada >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Pessoa_Usina.IDX_Pessoa_Usina_nu_MatUnificada >>>'
go

/* 
 * INDEX: UK_Sistema 
 */

CREATE UNIQUE INDEX UK_Sistema ON Sistema(cd_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Sistema') AND name='UK_Sistema')
    PRINT '<<< CREATED INDEX Sistema.UK_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Sistema.UK_Sistema >>>'
go

/* 
 * INDEX: FK_Tab_Classificacao_Area_CC__Gestor 
 */

CREATE INDEX FK_Tab_Classificacao_Area_CC__Gestor ON Tab_Classificacao_Area_CC(id_Gestor)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Tab_Classificacao_Area_CC') AND name='FK_Tab_Classificacao_Area_CC__Gestor')
    PRINT '<<< CREATED INDEX Tab_Classificacao_Area_CC.FK_Tab_Classificacao_Area_CC__Gestor >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Tab_Classificacao_Area_CC.FK_Tab_Classificacao_Area_CC__Gestor >>>'
go

/* 
 * INDEX: IDX_Usuario_Seguranca__Usuario_Usina 
 */

CREATE INDEX IDX_Usuario_Seguranca__Usuario_Usina ON Usuario_Seguranca(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Usuario_Seguranca') AND name='IDX_Usuario_Seguranca__Usuario_Usina')
    PRINT '<<< CREATED INDEX Usuario_Seguranca.IDX_Usuario_Seguranca__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Usuario_Seguranca.IDX_Usuario_Seguranca__Usuario_Usina >>>'
go

/* 
 * INDEX: FK_Usuario_Seguranca__Usuario_Usina 
 */

CREATE INDEX FK_Usuario_Seguranca__Usuario_Usina ON Usuario_Seguranca(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Usuario_Seguranca') AND name='FK_Usuario_Seguranca__Usuario_Usina')
    PRINT '<<< CREATED INDEX Usuario_Seguranca.FK_Usuario_Seguranca__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Usuario_Seguranca.FK_Usuario_Seguranca__Usuario_Usina >>>'
go

/* 
 * INDEX: UK_Usuario_Usina_cd_Login 
 */

CREATE UNIQUE INDEX UK_Usuario_Usina_cd_Login ON Usuario_Usina(cd_Login)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Usuario_Usina') AND name='UK_Usuario_Usina_cd_Login')
    PRINT '<<< CREATED INDEX Usuario_Usina.UK_Usuario_Usina_cd_Login >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Usuario_Usina.UK_Usuario_Usina_cd_Login >>>'
go

/* 
 * INDEX: IDX_Usuario_Usina__Pessoa_Usina 
 */

CREATE INDEX IDX_Usuario_Usina__Pessoa_Usina ON Usuario_Usina(id_PesUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Usuario_Usina') AND name='IDX_Usuario_Usina__Pessoa_Usina')
    PRINT '<<< CREATED INDEX Usuario_Usina.IDX_Usuario_Usina__Pessoa_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Usuario_Usina.IDX_Usuario_Usina__Pessoa_Usina >>>'
go

/* 
 * INDEX: FK_Usuario_Usina__Pessoa_Usina 
 */

CREATE INDEX FK_Usuario_Usina__Pessoa_Usina ON Usuario_Usina(id_PesUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Usuario_Usina') AND name='FK_Usuario_Usina__Pessoa_Usina')
    PRINT '<<< CREATED INDEX Usuario_Usina.FK_Usuario_Usina__Pessoa_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Usuario_Usina.FK_Usuario_Usina__Pessoa_Usina >>>'
go

/* 
 * INDEX: UK_UsuarioUsi_PerSis 
 */

CREATE UNIQUE INDEX UK_UsuarioUsi_PerSis ON UsuarioUsi_PerSis(id_UsuUsi, id_PerSis)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_PerSis') AND name='UK_UsuarioUsi_PerSis')
    PRINT '<<< CREATED INDEX UsuarioUsi_PerSis.UK_UsuarioUsi_PerSis >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_PerSis.UK_UsuarioUsi_PerSis >>>'
go

/* 
 * INDEX: IDX_UsuarioUsi_PerSis__Perfil_Sistema 
 */

CREATE INDEX IDX_UsuarioUsi_PerSis__Perfil_Sistema ON UsuarioUsi_PerSis(id_PerSis)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_PerSis') AND name='IDX_UsuarioUsi_PerSis__Perfil_Sistema')
    PRINT '<<< CREATED INDEX UsuarioUsi_PerSis.IDX_UsuarioUsi_PerSis__Perfil_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_PerSis.IDX_UsuarioUsi_PerSis__Perfil_Sistema >>>'
go

/* 
 * INDEX: IDX_UsuarioUsi_PerSis__Usuario_Usina 
 */

CREATE INDEX IDX_UsuarioUsi_PerSis__Usuario_Usina ON UsuarioUsi_PerSis(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_PerSis') AND name='IDX_UsuarioUsi_PerSis__Usuario_Usina')
    PRINT '<<< CREATED INDEX UsuarioUsi_PerSis.IDX_UsuarioUsi_PerSis__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_PerSis.IDX_UsuarioUsi_PerSis__Usuario_Usina >>>'
go

/* 
 * INDEX: FK_UsuarioUsi_PerSis__Perfil_Sistema 
 */

CREATE INDEX FK_UsuarioUsi_PerSis__Perfil_Sistema ON UsuarioUsi_PerSis(id_PerSis)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_PerSis') AND name='FK_UsuarioUsi_PerSis__Perfil_Sistema')
    PRINT '<<< CREATED INDEX UsuarioUsi_PerSis.FK_UsuarioUsi_PerSis__Perfil_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_PerSis.FK_UsuarioUsi_PerSis__Perfil_Sistema >>>'
go

/* 
 * INDEX: FK_UsuarioUsi_PerSis__Usuario_Usina 
 */

CREATE INDEX FK_UsuarioUsi_PerSis__Usuario_Usina ON UsuarioUsi_PerSis(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_PerSis') AND name='FK_UsuarioUsi_PerSis__Usuario_Usina')
    PRINT '<<< CREATED INDEX UsuarioUsi_PerSis.FK_UsuarioUsi_PerSis__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_PerSis.FK_UsuarioUsi_PerSis__Usuario_Usina >>>'
go

/* 
 * INDEX: UK_UsuarioUsi_Sistema 
 */

CREATE UNIQUE INDEX UK_UsuarioUsi_Sistema ON UsuarioUsi_Sistema(id_Sistema, id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_Sistema') AND name='UK_UsuarioUsi_Sistema')
    PRINT '<<< CREATED INDEX UsuarioUsi_Sistema.UK_UsuarioUsi_Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_Sistema.UK_UsuarioUsi_Sistema >>>'
go

/* 
 * INDEX: IDX_UsuarioUsi_Sistema__Sistema 
 */

CREATE INDEX IDX_UsuarioUsi_Sistema__Sistema ON UsuarioUsi_Sistema(id_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_Sistema') AND name='IDX_UsuarioUsi_Sistema__Sistema')
    PRINT '<<< CREATED INDEX UsuarioUsi_Sistema.IDX_UsuarioUsi_Sistema__Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_Sistema.IDX_UsuarioUsi_Sistema__Sistema >>>'
go

/* 
 * INDEX: IDX_UsuarioUsi_Sistema__Usuario_Usina 
 */

CREATE INDEX IDX_UsuarioUsi_Sistema__Usuario_Usina ON UsuarioUsi_Sistema(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_Sistema') AND name='IDX_UsuarioUsi_Sistema__Usuario_Usina')
    PRINT '<<< CREATED INDEX UsuarioUsi_Sistema.IDX_UsuarioUsi_Sistema__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_Sistema.IDX_UsuarioUsi_Sistema__Usuario_Usina >>>'
go

/* 
 * INDEX: FK_UsuarioUsi_Sistema__Usuario_Usina 
 */

CREATE INDEX FK_UsuarioUsi_Sistema__Usuario_Usina ON UsuarioUsi_Sistema(id_UsuUsi)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_Sistema') AND name='FK_UsuarioUsi_Sistema__Usuario_Usina')
    PRINT '<<< CREATED INDEX UsuarioUsi_Sistema.FK_UsuarioUsi_Sistema__Usuario_Usina >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_Sistema.FK_UsuarioUsi_Sistema__Usuario_Usina >>>'
go

/* 
 * INDEX: FK_UsuarioUsi_Sistema__Sistema 
 */

CREATE INDEX FK_UsuarioUsi_Sistema__Sistema ON UsuarioUsi_Sistema(id_Sistema)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('UsuarioUsi_Sistema') AND name='FK_UsuarioUsi_Sistema__Sistema')
    PRINT '<<< CREATED INDEX UsuarioUsi_Sistema.FK_UsuarioUsi_Sistema__Sistema >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX UsuarioUsi_Sistema.FK_UsuarioUsi_Sistema__Sistema >>>'
go

/* 
 * TABLE: Centro_Custo_Ctt 
 */

ALTER TABLE Centro_Custo_Ctt ADD CONSTRAINT FK_Centro_Custo_Ctt__Tab_Classificacao_Area_CC 
    FOREIGN KEY (id_ClassifAreaCC)
    REFERENCES Tab_Classificacao_Area_CC(id_ClassifAreaCC)
go


/* 
 * TABLE: Gestor 
 */

ALTER TABLE Gestor ADD CONSTRAINT FK_Gestor__Usuario_Usina 
    FOREIGN KEY (id_UsuUsi)
    REFERENCES Usuario_Usina(id_UsuUsi)
go


/* 
 * TABLE: Gestor_Centro_Custo 
 */

ALTER TABLE Gestor_Centro_Custo ADD CONSTRAINT FK_Gestor_Centro_Custo__Centro_Custo_Ctt 
    FOREIGN KEY (Ctt_Custo)
    REFERENCES Centro_Custo_Ctt(Ctt_Custo)
go

ALTER TABLE Gestor_Centro_Custo ADD CONSTRAINT FK_Gestor_Centro_Custo__Gestor 
    FOREIGN KEY (id_Gestor)
    REFERENCES Gestor(id_Gestor)
go


/* 
 * TABLE: Log_Adm_Usina 
 */

ALTER TABLE Log_Adm_Usina ADD CONSTRAINT FK_Log_Adm_Usina__Sistema 
    FOREIGN KEY (id_Sistema)
    REFERENCES Sistema(id_Sistema)
go

ALTER TABLE Log_Adm_Usina ADD CONSTRAINT FK_Log_Adm_Usina__Usuario_Usina 
    FOREIGN KEY (id_UsuUsi)
    REFERENCES Usuario_Usina(id_UsuUsi)
go


/* 
 * TABLE: Perfil_Sistema 
 */

ALTER TABLE Perfil_Sistema ADD CONSTRAINT FK_Perfil_Sistema__Sistema 
    FOREIGN KEY (id_Sistema)
    REFERENCES Sistema(id_Sistema)
go


/* 
 * TABLE: Tab_Classificacao_Area_CC 
 */

ALTER TABLE Tab_Classificacao_Area_CC ADD CONSTRAINT FK_Tab_Classificacao_Area_CC__Gestor 
    FOREIGN KEY (id_Gestor)
    REFERENCES Gestor(id_Gestor)
go


/* 
 * TABLE: Usuario_Seguranca 
 */

ALTER TABLE Usuario_Seguranca ADD CONSTRAINT FK_Usuario_Seguranca__Usuario_Usina 
    FOREIGN KEY (id_UsuUsi)
    REFERENCES Usuario_Usina(id_UsuUsi)
go


/* 
 * TABLE: Usuario_Usina 
 */

ALTER TABLE Usuario_Usina ADD CONSTRAINT FK_Usuario_Usina__Pessoa_Usina 
    FOREIGN KEY (id_PesUsi)
    REFERENCES Pessoa_Usina(id_PesUsi)
go


/* 
 * TABLE: UsuarioUsi_PerSis 
 */

ALTER TABLE UsuarioUsi_PerSis ADD CONSTRAINT FK_UsuarioUsi_PerSis__Perfil_Sistema 
    FOREIGN KEY (id_PerSis)
    REFERENCES Perfil_Sistema(id_PerSis)
go

ALTER TABLE UsuarioUsi_PerSis ADD CONSTRAINT FK_UsuarioUsi_PerSis__Usuario_Usina 
    FOREIGN KEY (id_UsuUsi)
    REFERENCES Usuario_Usina(id_UsuUsi)
go


/* 
 * TABLE: UsuarioUsi_Sistema 
 */

ALTER TABLE UsuarioUsi_Sistema ADD CONSTRAINT FK_UsuarioUsi_Sistema__Sistema 
    FOREIGN KEY (id_Sistema)
    REFERENCES Sistema(id_Sistema)
go

ALTER TABLE UsuarioUsi_Sistema ADD CONSTRAINT FK_UsuarioUsi_Sistema__Usuario_Usina 
    FOREIGN KEY (id_UsuUsi)
    REFERENCES Usuario_Usina(id_UsuUsi)
go


