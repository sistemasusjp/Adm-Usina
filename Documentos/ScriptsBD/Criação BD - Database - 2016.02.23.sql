USE Master
GO


CREATE DATABASE [ADM_Usina] ON  PRIMARY 
( NAME = N'ADM_Usina', FILENAME = N'D:\Data\ADM_Usina.mdf' , SIZE = 3072KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ADM_Usina_log', FILENAME = N'E:\Log\ADM_Usina_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ADM_Usina] SET COMPATIBILITY_LEVEL = 100
GO
ALTER DATABASE [ADM_Usina] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ADM_Usina] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ADM_Usina] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ADM_Usina] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ADM_Usina] SET ARITHABORT OFF 
GO
ALTER DATABASE [ADM_Usina] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ADM_Usina] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ADM_Usina] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [ADM_Usina] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ADM_Usina] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ADM_Usina] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ADM_Usina] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ADM_Usina] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ADM_Usina] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ADM_Usina] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ADM_Usina] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ADM_Usina] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ADM_Usina] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ADM_Usina] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ADM_Usina] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ADM_Usina] SET  READ_WRITE 
GO
ALTER DATABASE [ADM_Usina] SET RECOVERY FULL 
GO
ALTER DATABASE [ADM_Usina] SET  MULTI_USER 
GO
ALTER DATABASE [ADM_Usina] SET PAGE_VERIFY CHECKSUM  
GO
USE [ADM_Usina]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [ADM_Usina] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
