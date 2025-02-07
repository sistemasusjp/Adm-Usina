/*============================================================================    
   DESCRIÇÃO DA PROCEDURE: 
	   Consulta os Gestor de acordo co os parâmetros informados
		                                                 
   
   DATA        IMPLEMENTADOR    DESCRIÇÃO    
   26/10/2016  Geraldo          Criação 
   27/10/2016  Geraldo          Adicionado parametro @id_Gestor
   01/11/2016  Geraldo          Adicionado parametro @MostrarMat
   20/01/2017  Geraldo          Alterado padrão de @MostrarMat de 1 para 0
   22/08/2017  Geraldo          - Adicionada chamda função FN_Buscar_Area_Gestor_ADM
								- Parâmetro @Lista_id_ClassifAreaCC renomeado para @Lista_id_ClassifAreaCC VARCHAR(10)
							    - Pode consultar mais de uma área por vez (caso de Eraldo do Agrícola e Agrícola Atividades)
   10/11/2017  Geraldo          Parâmetro @Lista_id_ClassifAreaCC estava como Varchar sem tamanho
   13/11/2017  Geraldo          Ajustados parâmetros de Gestor e Área para receber vários itens de uma vez limitados por # e ;
							 - Removido @Lista_id_ClassifAreaCC
							 - Removido @id_Gestor
							 - Adicionado @Lista_AreaCC
							 - Adicionado @Lista_Gestor

   Obs:     
  ============================================================================
    Testar:

    exec PR_Con_Gestor null, null, 0 -- Por Gestor 
    exec PR_Con_Gestor  -- Por Gestor 
    exec PR_Con_Gestor '#1;#2;' -- Por Gestor
    exec PR_Con_Gestor null, '#5;#1;#2;'
*/  

ALTER -- CREATE
PROCEDURE PR_Con_Gestor
				    ( @Lista_AreaCC VARCHAR(1000) = NULL,
				      @Lista_Gestor VARCHAR(1000) = NULL,
				      @MostrarMat TINYINT = 0  )
AS
    -- Declare Para Testes do Select
    --DECLARE @id_Gestor INTEGER
    --SET @id_Gestor = NULL    -- G 23 id usu17 = 24 / g 29, Usu 23 = 92

    SET DATEFORMAT DMY;

    SELECT G.nm_Pessoa +' - '+ G.de_tp_Gestor 
              +CASE	@MostrarMat
				WHEN 1 THEN ' ('+ CAST(G.nu_MatUnificada AS varchar)+') '
				ELSE ''
			END
	      AS Descricao 
         , G.id_Gestor 
         , 1 AS Ordem 
	     , dbo.FN_Buscar_Area_Gestor_ADM(id_Gestor, 1) AS Lista_id_ClassifAreaCC 
	     , dbo.FN_Buscar_Area_Gestor_ADM(id_Gestor, 0) AS Lista_de_ClassifAreaCC 

    FROM Adm_Usina.dbo.Gestor_Adm_Vw G
	  
    WHERE G.fl_Exclusao = 0
      AND G.dt_FimExercicio IS NULL
	 AND (@Lista_Gestor IS NULL	OR CHARINDEX ( '#'+CAST(id_Gestor AS VARCHAR)+';', @Lista_Gestor ) > 0 ) -- OR id_Gestor = @id_Gestor)
      AND (@Lista_AreaCC IS NULL 
			 --OR G.id_ClassifAreaCC = @id_ClassifAreaCC
			 OR G.id_Gestor IN ( SELECT DISTINCT id_Gestor 
			                     FROM ADM_Usina.dbo.Tab_Classificacao_Area_CC tca
	                               --WHERE CHARINDEX ( CAST(tca.id_ClassifAreaCC AS VARCHAR), @Lista_AreaCC ) > 0 )
							 WHERE CHARINDEX ( '#'+CAST(TCA.id_ClassifAreaCC AS VARCHAR)+';', @Lista_AreaCC ) > 0 )
   			 OR G.id_Gestor IN ( SELECT DISTINCT id_Gestor 
			                     FROM dbo.Gestor_Centro_Custo_Adm_Vw GCC 
--	                               WHERE GCC.Ctt_CLASCC = @id_ClassifAreaCC )
	                               --WHERE CHARINDEX ( CAST(GCC.Ctt_CLASCC AS VARCHAR), @Lista_AreaCC ) > 0 ) 
							 WHERE CHARINDEX ( '#'+CAST(GCC.Ctt_CLASCC AS VARCHAR)+';', @Lista_AreaCC ) > 0 )
	     )

    ORDER BY 3, 1
    
    