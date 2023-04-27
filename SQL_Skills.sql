-- Verificar qual produto foi cadastrado dentro da tabela de produtro e nunca foi vendido

  SELECT * FROM SB1010 WHERE B1_COD NOT IN (
    SELECT COD_PRODUTO FROM VENDAS 
    ) 
