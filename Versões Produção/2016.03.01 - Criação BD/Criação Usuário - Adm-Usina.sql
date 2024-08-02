-- Cria Usuário
USE [master]
GO
CREATE LOGIN [adm-usina] WITH PASSWORD=N'adm#9upUsi', DEFAULT_DATABASE=[Adm_Usina], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- Adiciona permissão no banco
USE [Adm_Usina]
GO
CREATE USER [adm-usina] FOR LOGIN [adm-usina] WITH DEFAULT_SCHEMA=[dbo]
GO

USE [Adm_Usina]
GO
-- ALTER ROLE [db_owner] add MEMBER [adm-usina] -- SQL 2012
EXEC sp_addrolemember N'db_owner', N'adm-usina' -- SQL 2008
GO



USE [Erp.Protheus10]
GO
CREATE USER [adm-usina] FOR LOGIN [adm-usina] WITH DEFAULT_SCHEMA=[dbo]
GO
--ALTER ROLE [db_datareader] add MEMBER [abastec] -- SQL 2012
EXEC sp_addrolemember N'db_datareader', N'adm-usina' -- SQL 2008
GO


-- sp_changedbowner @loginame = 'adm-usina'