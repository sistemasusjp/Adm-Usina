USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   16/02/2017  Geraldo          Criação
   11/03/2020  Geraldo			Adicionada crítica em dt_DesativacaoUsuSis
   Obs:     
  ============================================================================
    Testar:

    select dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( 1, null )
    select dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( 1, 4 )
    
*/  
ALTER
FUNCTION dbo.FN_Buscar_UsuarioUsi_Sistema_ADM ( @id_UsuUsi INT,
								        @id_Sistema INT = NULL )
RETURNS VARCHAR(2000)
AS
BEGIN
    DECLARE @nm_Sistema VARCHAR(200)
    DECLARE @Retorno VARCHAR(2000) = ''

    DECLARE Cursor_Processar CURSOR
    FOR 
	   SELECT s.nm_Sistema
	   FROM UsuarioUsi_Sistema uus
		   JOIN Usuario_Usina uu
		     ON uu.id_UsuUsi = uus.id_UsuUsi
		   JOIN Sistema s 
		     ON s.id_Sistema = uus.id_Sistema
	   WHERE uus.id_UsuUsi = @id_UsuUsi
	     AND uus.id_Sistema = ISNULL(@id_Sistema, uus.id_Sistema)
	     AND uus.dt_DesativacaoUsuSis IS NULL

	   ORDER BY nm_Sistema

    OPEN Cursor_Processar;

    FETCH NEXT FROM Cursor_Processar 
	   INTO @nm_Sistema;

	   WHILE @@FETCH_STATUS = 0
	   BEGIN		  
	       IF @Retorno <> ''
			 SET @Retorno = @Retorno + ', ' + @nm_Sistema
		  ELSE
			 SET @Retorno = @nm_Sistema
		   

		  FETCH NEXT FROM Cursor_Processar 
			 INTO @nm_Sistema;			   

	   END;

    CLOSE Cursor_Processar;
    DEALLOCATE Cursor_Processar
    
    RETURN @Retorno;
END