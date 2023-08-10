CREATE PROCEDURE ProdVendas AS
	DECLARE @data AS DATE
	SET @data = GETDATE()
SELECT * FROM VENDAS WHERE CAST(EMISSAO AS DATE) = @data;

EXECUTE sp_executesql ProdVendas;


-- bloco de descições em PROCEDURE
ALTER PROCEDURE infoCustomer 
	@codCustomer VARCHAR(8), 
	@emissao VARCHAR(8)
AS
	IF @codCustomer IS NULL OR @emissao IS NULL AND @codCustomer = '' OR @emissao = ''
		BEGIN
			PRINT 'Prenche os parametros'
			RETURN
		END
	ELSE
		BEGIN
			SELECT * 
			FROM VENDAS
			WHERE
				COD_CLIENTE = @codCustomer
				AND EMISSAO = @emissao
		END


EXEC infoCustomer @codCustomer = null , @emissao = ''
