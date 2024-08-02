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
   09/08/2019  Geraldo          Adicionado parâmetro @MostarNomeSistema

   Obs:     
  ============================================================================
    Testar:

    select dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( 1, null )
    select dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( 1, 4 )
    
*/  
ALTER
FUNCTION dbo.FN_Buscar_UsuarioUsi_PerSis_ADM ( @id_UsuUsi INT,
											   @id_Sistema INT = NULL,
											   @MostarNomeSistema BIT = 1 )
RETURNS VARCHAR(2000)
AS
BEGIN
    DECLARE @nm_PerSis VARCHAR(200)
    DECLARE @nm_Sistema VARCHAR(200)
    DECLARE @Retorno VARCHAR(2000) = ''

    DECLARE Cursor_Processar CURSOR
    FOR 
	   SELECT ps.nm_PerSis, s.nm_Sistema
	   FROM UsuarioUsi_PerSis uups
		   JOIN Perfil_Sistema ps 
		     ON uups.id_PerSis = ps.id_PerSis
		    AND ps.id_Sistema = ISNULL(@id_Sistema, ps.id_Sistema)
		   JOIN Sistema s 
		     ON s.id_Sistema = ps.id_Sistema
	   WHERE id_UsuUsi = @id_UsuUsi
	   ORDER BY nm_Sistema, nm_PerSis

    OPEN Cursor_Processar;

    FETCH NEXT FROM Cursor_Processar 
	   INTO @nm_PerSis, @nm_Sistema;

	   WHILE @@FETCH_STATUS = 0
	   BEGIN	
	      -- IF Adicionado em 09/08/2019	  
		  IF @MostarNomeSistema = 1
			SET @nm_Sistema = @nm_Sistema+'\'
		  ELSE
			SET @nm_Sistema = ''

	      IF @Retorno <> ''
			 SET @Retorno = @Retorno + ', ' + @nm_Sistema + @nm_PerSis
		  ELSE
			 SET @Retorno = @nm_Sistema + @nm_PerSis
		   

		  FETCH NEXT FROM Cursor_Processar 
			 INTO @nm_PerSis, @nm_Sistema;			   

	   END;

    CLOSE Cursor_Processar;
    DEALLOCATE Cursor_Processar
    
    RETURN @Retorno;
END