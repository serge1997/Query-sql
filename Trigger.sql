CREATE TRIGGER [dbo].[FORSALDO]
ON [dbo].[ITEN_SAIDA]
FOR INSERT
AS
BEGIN
	DECLARE 
		@PRODUTO INT,
		@QUANTI INT,
		@DATA DATETIME

		SELECT @DATA = SD_EMISSAO, 
			@QUANTI = SD_QUANTI,
			@PRODUTO = SD_PROD
			FROM INSERTED
	UPDATE SALDOPROD
		SET SALD_COD = @PRODUTO, 
			SALD_FINAL = SALD_FINAL - @QUANTI,
			--SALD_INICIAL = SALD_FINAL + @QUANTI,
			DATA_MOV = @DATA
		WHERE SALD_COD = @PRODUTO
END
GO
