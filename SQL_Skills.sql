-- Verificar qual produto foi cadastrado dentro da tabela de produtro e nunca foi vendido

  SELECT * FROM SB1010 WHERE B1_COD NOT IN (
    SELECT COD_PRODUTO FROM VENDAS 
    ) 
  
  -- Procururar informações sobre um produto especifico a partir do codigo de produto dentro da tabela de venda para a tabela dim de produto
  SELECT * FROM VENDAS WHERE COD_PRODUTO IN (
	    SELECT B1_COD FROM SB1010 WHERE B1_COD = '30225495'
    )
