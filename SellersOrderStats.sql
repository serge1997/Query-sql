CREATE VIEW SellersStats AS
	WITH Stat 
		AS
	(
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY d.SalesOrderId ORDER BY d.SalesOrderID) Orderqty, d.SalesOrderID,
			H.SalesPersonID
		FROM Sales.SalesOrderDetail d
		INNER JOIN Sales.SalesOrderHeader H
			ON H.SalesOrderID = D.SalesOrderID
	)SELECT SalesOrderID, SalesPersonID, MAX(Orderqty) TotalItens FROM Stat
		GROUP BY SalesOrderID, SalesPersonID


--Database AdventureWorks Mycrosoft
--Dentro da tabela de itens de pedido faz a repartição de
-- itens de pedidos por Pedido. Por exemplo o numero de pedido: 53756 tem 12 itens.
-- Então aqui teremos o Numero de Pedido, quantiade de itens, e o codigo do vendedor
