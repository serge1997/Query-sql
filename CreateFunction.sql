CREATE FUNCTION VendasTV()
	RETURNS
	@SellOfDay TABLE 
		( EMISSAO DATE, CODIGO_VENDEDOR VARCHAR(15), VENDA MONEY)
AS
	BEGIN
		INSERT INTO @SellOfDay
			SELECT EMISSAO, COD_VEND, VENDA FROM VENDAS;
		RETURN;
	END
SELECT * FROM VendasTV()