-- var with query valor

DECLARE 
	@venda AS DECIMAL(10,2)

	SET @venda = (SELECT MAX(VENDA) FROM VENDAS)
	
	SELECT D2_VALBRUT FROM SD2010 WHERE D2_VALBRUT > @venda
  
  
  DECLARE @data AS DATE;
	SET @data = GETDATE(); --Today

	IF @data > GETDATE() - 1 --yesterday. 
	BEGIN
		SELECT * FROM VENDAS WHERE CAST(EMISSAO AS DATE) = @data
	END
	ELSE
	BEGIN
		PRINT 'Nada foi vendido o dia de Hoje'
	END
