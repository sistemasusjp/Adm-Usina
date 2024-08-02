-------------------------------------------------------------------------------
-- Trigger TGR_Atualizar_Matricula_Unificada 
-- Atualiza o campo nu_MatUnificada a partir de nu_Filial e nu_Mat
-- Data		Resp.	Motivo
-- 25/02/2016	Geraldo   Criaçao	 
-- 
ALTER -- CREATE
TRIGGER dbo.TGR_Atualizar_Matricula_Unificada 
ON dbo.Pessoa_Usina
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
            (   SELECT *
                FROM INSERTED )
        BEGIN
            DECLARE @Id_PesUsi int
			   , @nu_Mat VARCHAR(11)
			   , @nu_Filial VARCHAR(2)
			   , @matUnificadaAntiga VARCHAR(11)
			   , @matUnificada VARCHAR(11)

            SET @matUnificada = NULL

		  SELECT @Id_PesUsi = Id_PesUsi
			  , @nu_Mat = nu_Mat
			  , @nu_Filial = nu_Filial
			  , @matUnificadaAntiga = nu_MatUnificada
            FROM INSERTED 

            IF LTRIM(RTRIM(@nu_Filial)) <> ''
			 AND NOT(@nu_Filial IS NULL)
                SET @matUnificada = CAST(CAST(@nu_Filial AS int) AS varchar)

            IF LTRIM(RTRIM(@nu_Mat)) <> ''
			 AND NOT(@nu_Mat IS NULL)
                IF NOT(@matUnificada IS NULL)
                    SET @matUnificada = @matUnificada + CAST(CAST(@nu_Mat AS int) AS varchar)
                ELSE
				SET @matUnificada = CAST(CAST(@nu_Mat AS int) AS varchar)

		  
			 UPDATE Pessoa_Usina
				SET nu_MatUnificada = @matUnificada
			 WHERE Id_PesUsi = @Id_PesUsi
        END
END