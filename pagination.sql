-- 
  1)Vai selecionar os 10 primeiros da cláusula ORDER BY.  
  2) Vai pular os dez primeiros e selecionar os 10 proximos.
--


SELECT
	D1_COD,
	D1_EMISSAO,
	D1_VUNIT,
	D1_QUANT,
	D1_TOTAL
FROM SD1010
ORDER BY D1_EMISSAO DESC OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
