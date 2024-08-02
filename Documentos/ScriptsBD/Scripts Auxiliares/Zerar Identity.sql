SELECT *  -- delete
FROM dbo.Mes_Item_Orc



--SELECT *  
--FROM Item_Orc It
--WHERE  NOT exists(SELECT * FROM  dbo.Conta_Orcamentaria_Ct1_Vw CO
--     where CO.Ct1_Conta = It.Ct1_Conta COLLATE Latin1_General_CI_AS)



/*

DBCC CHECKIDENT (Item_Orc);

DELETE FROM Item_Orc
DBCC CHECKIDENT (Item_Orc, RESEED, 0);

*/