UPDATE 
	SF1010
SET F1_UFDESTR = 'MS'
	FROM SF1010 SF 
	INNER JOIN SD1010 SD
		ON SF.F1_FILIAL = SD.D1_FILIAL
		AND SF.F1_DOC = SD.D1_DOC
		AND SF.F1_SERIE = SD.D1_SERIE
		AND SF.D_E_L_E_T_ <> '*'
		AND SD.D_E_L_E_T_ <> '*'
	WHERE F1_UFDESTR = ''
		AND F1_DTDIGIT > '20230701'
		AND F1_FILIAL = '020204' 
		AND F1_ESPECIE = 'CTE' 
		AND SD.D1_CF = '2353'



UPDATE 
	SF1010
	SET F1_UFDESTR = SA.A1_EST
FROM SF1010 SF
	INNER JOIN Z7Z010 Z7
		ON Z7.Z7Z_FILIAL = SF.F1_FILIAL
		AND Z7.Z7Z_DOC = SF.F1_DOC
		AND Z7.Z7Z_SERIE = SF.F1_SERIE
		AND Z7.D_E_L_E_T_ <> '*'
	INNER JOIN SA1010 SA
		ON SA.A1_COD = Z7Z_CLIENT
WHERE F1_DTDIGIT > '20230630'
AND F1_DTDIGIT < '20230801'
AND F1_UFDESTR = ''
AND F1_FILIAL = '020201'
AND F1_ESPECIE = 'CTE'
