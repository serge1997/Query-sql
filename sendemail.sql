DECLARE @tableHTML NVARCHAR(MAX)
SET @tableHTML = N'
	<H1>RESUMO DE VENDA</H1>' + N'<table border="1">'
	+ N'<tr><th>COD_FILIAL</th><th>VENDA</th></tr>'
	+ CAST((
		SELECT
			td = V.COD_FIL, '',
			td = CAST(SUM(V.VENDA) AS NVARCHAR(MAX))
		FROM VENDAS V
		WHERE V.EMISSAO = '20230412'
		AND DUPLIC = 'S'
		GROUP BY V.COD_FIL FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX))
	+ N'</table>';
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'SENDMAIL',
    @recipients = 'bi@sentax.com.br',
    @body = @tableHTML,
	@execute_query_database = 'P12_PROD',
	@body_format = 'HTML',
	@subject = 'VENDA RESUMO'

