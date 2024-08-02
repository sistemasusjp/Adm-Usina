USE [ADM_Usina]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: Retorna as áreas que o Gestor (Gerente) é responsável
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   22/08/2017  Geraldo          Criação
   22/08/2017  Geraldo          Add @TipoRetorno
								0 - Retorna código
								1 - Retorna descrição
   30/08/2018  Geraldo          Corrigido para quando for retornar o campo colocar o "#" na frente e o ";" atrás

   Obs:     
  ============================================================================
    Testar:

    select dbo.FN_Buscar_Area_Gestor_ADM ( 07, 0 )
    select dbo.FN_Buscar_Area_Gestor_ADM ( 07, 1 )
    select dbo.FN_Buscar_Area_Gestor_ADM ( 13 )
    select dbo.FN_Buscar_Area_Gestor_ADM ( 16 )
    
*/  
ALTER
FUNCTION dbo.FN_Buscar_Area_Gestor_ADM ( @id_Gestor INT, @TipoRetorno INT = 0 )
RETURNS VARCHAR(2000)
AS
BEGIN
    DECLARE @de_ClassifAreaCC VARCHAR(200)
    DECLARE @Retorno VARCHAR(2000) = ''

    DECLARE Cursor_Processar CURSOR
    FOR 
	   SELECT CASE 
				WHEN @TipoRetorno = 0 THEN de_ClassifAreaCC
				ELSE '#'+CAST(id_ClassifAreaCC AS VARCHAR)+';'
			END AS de_ClassifAreaCC
	   FROM ADM_Usina.dbo.Tab_Classificacao_Area_CC
	   WHERE id_Gestor = @id_Gestor
	   ORDER BY de_ClassifAreaCC

    OPEN Cursor_Processar;

    FETCH NEXT FROM Cursor_Processar 
	   INTO @de_ClassifAreaCC;

	   WHILE @@FETCH_STATUS = 0
	   BEGIN		  
	       IF @Retorno <> ''
			 IF @TipoRetorno = 1 -- Código
				SET @Retorno = @Retorno + ' ' + @de_ClassifAreaCC
			ELSE
				SET @Retorno = @Retorno + ', ' + @de_ClassifAreaCC
		  ELSE
			 SET @Retorno = @de_ClassifAreaCC
		   

		  FETCH NEXT FROM Cursor_Processar 
			 INTO @de_ClassifAreaCC;			   

	   END;

    CLOSE Cursor_Processar;
    DEALLOCATE Cursor_Processar
    
    RETURN @Retorno;
END