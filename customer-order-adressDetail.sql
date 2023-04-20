/*Recuperar pedidos de clientes:
/*Recuperar pedidos de clientes com endereços:

SELECT    
  C.CompanyName,     
  H.SalesOrderID,     
  H.TotalDue,    
  AD.AddressLine1,    
  AD.City,    
  AD.CountryRegion,    
  AD.PostalCode,    
  AD.StateProvince
FROM SalesLT.Customer AS C 
INNER JOIN SalesLT.SalesOrderHeader AS H    
  ON C.CustomerID = H.CustomerID
INNER JOIN SalesLT.CustomerAddress AS CA
  ON C.CustomerID = CA.CustomerID 
INNER JOIN SalesLT.Address AS AD    
ON CA.AddressID = AD.AddressID    
WHERE CA.AddressType = 'Main Office';
