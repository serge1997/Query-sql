DECLARE @MAXM DATETIME 
	SELECT @MAXM = MAX(EMISSAO) FROM VENDAJOB --Attribuir resultado de um select a uma variavel
	IF @MAXM IS NULL
		BEGIN
			SELECT * FROM SD2TXT
		END
	ELSE
		BEGIN
			INSERT INTO VENDAJOB 
			SELECT * FROM SD2TXT WHERE EMISSAO > @MAXM
		END
