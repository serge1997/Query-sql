-- Verificar qual produto foi cadastrado dentro da tabela de produtro e nunca foi vendido

  SELECT * FROM SB1010 WHERE B1_COD NOT IN (
    SELECT COD_PRODUTO FROM VENDAS 
    ) 
  
  -- Procururar informações sobre um produto especifico a partir do codigo de produto dentro da tabela de venda para a tabela dim de produto
  SELECT * FROM VENDAS WHERE COD_PRODUTO IN (
	    SELECT B1_COD FROM SB1010 WHERE B1_COD = '30225495'
    )
    
    
--Cliente cadastrado que nunca fez uma compra uma compra. 
--SA1010 Tabela de cliente, VENDAS tabela de venda
SELECT * FROM SA1010 AS S WHERE NOT EXISTS(
	SELECT * FROM VENDAS AS V WHERE V.COD_CLIENTE = S.A1_COD
)

-- somente where os valores da coluna Size são numericos. 
-- ISNUMERIC(Size) = 1 => 1 represesente True
-- ISNUMERIC(Size) = 0 => retorna os valores dentro da coluna size não são numericos. O 0 => false
SELECT Name, Size AS NumericSize FROM SalesLT.Product WHERE ISNUMERIC(Size) = 1;

-- Exemplo com o IIF

SELECT Name, IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Non-Numeric') AS SizeTypeFROM SalesLT.Product;
