/*view para pegar as informçãoes: 
  -ULTIMO PREÇO DE COMPRA DE UM PRODUTO
  -ULTIMA DATA DE COMPRA
  - VALOR DE IMPOSTO
  
  /*View para pegar os diferentes (unico) produtos dentro ta tabela de entrada SD1010 e data de emissao
  
  CREATE VIEW VW_TEZTE 
  AS 
    SELECT DISTINCT D1_COD,
    MAX(D1_EMISSAO) AS EMISSAO 
FROM SD1010 
	GROUP BY D1_COD;
  
  
  /*VIEW para pegar os proutos dentro da SD1 inner join com a a view TEZTE on CODIGO do produto e confrontar com as data de emissão 

CREATE VIEW Vw_compras_estoque
AS
	SELECT
		V.D1_COD,
		SD.D1_DESCRIC,
		V.EMISSAO,
		SD.D1_VUNIT AS VALOR_UNITARIO,
		SD.D1_QUANT,
		SD.D1_IPI,
		SD.D1_DOC,
		ISNULL(SD.D1_ICMSRET / NULLIF(SD.D1_TOTAL,0),0) * 100 AS PRC_ICMSRET,
		SD.D1_VALIMP5,
		SD.D1_VALIMP6,
		ISNULL(D1_VALIPI / NULLIF(SD.D1_QUANT, 0), 0) AS VLIPI_UNITARIO
		FROM VW_TEZTE AS V
		INNER JOIN SD1010 AS SD
		ON V.D1_COD = SD.D1_COD
		WHERE V.EMISSAO = SD.D1_EMISSAO;
