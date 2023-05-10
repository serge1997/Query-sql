-- var with query valor

DECLARE 
	@venda AS DECIMAL(10,2)

	SET @venda = (SELECT MAX(VENDA) FROM VENDAS)
	
	SELECT D2_VALBRUT FROM SD2010 WHERE D2_VALBRUT > @venda
  
  
  DECLARE @data AS DATE;
	SET @data = GETDATE(); --Today

	IF @data > GETDATE() - 1 --yesterday. 
	BEGIN
		SELECT * FROM VENDAS WHERE CAST(EMISSAO AS DATE) = @data
	END
	ELSE
	BEGIN
		PRINT 'Nada foi vendido o dia de Hoje'
	END



-- while

DECLARE @customerID AS INT = 1;D
ECLARE @fname AS NVARCHAR(20);
DECLARE @lname AS NVARCHAR(30);
	WHILE @customerID <=10BEGIN    
		SELECT @fname = FirstName, @lname = LastName FROM SalesLT.Customer        
			WHERE CustomerID = @CustomerID;    
		PRINT @fname + N' ' + @lname;    
		SET @customerID += 1;
	END;
