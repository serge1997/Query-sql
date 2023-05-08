USE [msdb]
GO

/****** Object:  Job [Atualiza BI]    Script Date: 08/05/2023 13:15:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 08/05/2023 13:15:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Atualiza BI', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'SQLPROTHEUS\Administrator', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Atualiza Vendas]    Script Date: 08/05/2023 13:15:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Atualiza Vendas', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
DECLARE @DTFILTRO AS VARCHAR(8);
SET @DTFILTRO = CONVERT(VARCHAR(8),DATEADD(DAY,-7,convert(datetime,GETDATE(),103)), 112);
 

 
delete VENDAS
WHERE EMISSAO >=@DTFILTRO;

INSERT INTO VENDAS 
SELECT 
nn.EMISSAO,	
COD_FIL,
DESC_FIL,
NF,	
TIPONF,	
GRPROD,
GRUPOPROD,
COD_PRODUTO,
PRODUTO,
QUANTI,
CFOP,
TIPO,	
isnull(REGIAO,REGIAO_VEND) REGIAO,		
COD_MUN,
MUNIC,
ESTADO,
COD_CLIENTE,
LOJA,
HISTORICO,	
COD_VEND,	
VENDEDOR,	
COD_OPERADOR,	
OPERADOR,
VEND_UA1,	
NUAVEND1,
VEND_UA2,	
NUAVEND2,	
TMK,
VENDA,
FRETE,
DEVOLUCAO,
PIPI,
IPI,
ST,
RECEITA_BRUTA,
PICMS,
ICMS,
PIS,
COFINS,
DESCONTO,
RECEITA_LIQUIDA,
CUSTO,
MARGEM_BRUTA,
P_CUSTO,
P_LUCRO,
NCM,
TIPOCLI,
IE,
SUFRAMA,
GRPTRIB,
TPESSOA,
CNAE,
SIMPLES,
MT,
NUMCTE,
SERCTE,
NQCTE,
VALFRETE,
PEDIDO,
ITEM,
PRCVEN,
FORNECEDOR,
NOTAORIGEM,
DUPLIC,
GERENTEUA1,
NOMEGERENTEUA1,
NOME_GERENTEUA1,
METAS_VEND.DIAS_MES,
METAS_VEND.DIAS_PASSADOS,
METAS_VEND.META AS META_UA1,
isnull(METAS_VEND2.META,0.01) AS META_UA2,
B1_PROC,
GERENTE_UA2,
VEND_UA2+''-''+NUAVEND2  NOME_VEND2,
REGIAO_VEND
from (

SELECT                                                                  
		SD2.D2_EMISSAO [EMISSAO],                                                   
		SD2.D2_FILIAL [COD_FIL],                                                    
		CASE                                                                        
		WHEN SD2.D2_FILIAL = ''010101'' THEN ''SENTAX - CURITIBA''                   
		WHEN SD2.D2_FILIAL = ''020201'' THEN ''GIBRALTAR - CURITIBA''                
		WHEN SD2.D2_FILIAL = ''020202'' THEN ''GIBRALTAR - FOZ DO IGUACU''           
		WHEN SD2.D2_FILIAL = ''020203'' THEN ''GIBRALTAR - JOINVILLE''               
		WHEN SD2.D2_FILIAL = ''020204'' THEN ''GIBRALTAR - MARILIA''                 
		WHEN SD2.D2_FILIAL = ''020205'' THEN ''GIBRALTAR - SAO JOSE DOS PINHAIS''    
		WHEN SD2.D2_FILIAL = ''030301'' THEN ''ARVOREDO - JOINVILLE''                
		WHEN SD2.D2_FILIAL = ''040401'' THEN ''RADICAL CONSULTORIA DE MARKETING''  END [DESC_FIL],                                                             
		SD2.D2_DOC    [NF],                                                            
		SF2.F2_TIPO   [TIPONF],                                                       
		SB1.B1_GRUPO  [GRPROD],                                                      
		SBM.BM_DESC   [GRUPOPROD],                                                    
		SD2.D2_COD    [COD_PRODUTO],                                                   
		SB1.B1_DESC   [PRODUTO],                                                      
		SD2.D2_QUANT  [QUANTI],                                                      
		SD2.D2_CF     [CFOP],                                                           
		SB1.B1_TIPO   [TIPO],                                                         
		REGIAO_VEND.X5_DESCRI [REGIAO],                                                  
		SA1.A1_COD_MUN 	 [COD_MUN],                                                   
		SA1.A1_MUN 		 [MUNIC],                                                         
		SD2.D2_EST       [ESTADO],                                                        
		SA1.A1_COD       [COD_CLIENTE],                                                   
		SA1.A1_LOJA      [LOJA],                                                         
		SA1.A1_NOME      [HISTORICO],                                                    
		SA1.A1_VEND      [COD_VEND],                                                     
		A3VEN.A3_NREDUZ  [VENDEDOR],                                                
		SUA.UA_OPERADO   [COD_OPERADOR],                                              
		SU7.U7_NOME      [OPERADOR],                                                     
		SUA.UA_VEND      [VEND_UA1],                                                     
		VEND1UA.A3_NREDUZ  [NUAVEND1],                                               
		SUA.UA_VEND2       [VEND_UA2],                                                    
		VEND2UA.A3_NREDUZ  [NUAVEND2],                                               
		CASE  WHEN SUA.UA_TMK = ''1'' THEN ''RECEPTIVO''                                
		WHEN SUA.UA_TMK = ''2'' THEN ''ATIVO''                                    
		WHEN SUA.UA_TMK = ''3'' THEN ''ACOMPANHAMENTO''                           
		WHEN SUA.UA_TMK = ''4'' THEN ''REPRESENTANTE''                            
		WHEN SUA.UA_TMK = ''5'' THEN ''RETORNO ATIVO''                            
		WHEN SUA.UA_TMK = ''6'' THEN ''COTAÇÃO''                                  
		WHEN SUA.UA_TMK = ''7'' THEN ''ORDEM DE SERVIÇO''                         
		WHEN SUA.UA_TMK = ''8'' THEN ''E-MAIL''                                   
		WHEN SUA.UA_TMK = ''9'' THEN ''WHATSAPP''                                
		WHEN SUA.UA_TMK = ''S'' THEN ''SITE'' END  [TMK] ,                                                                 
		SD2.D2_VALBRUT [VENDA],
		SD2.D2_VALFRE [FRETE],
		0 [DEVOLUCAO],                                                     
		SD2.D2_IPI [PIPI],                                                          
		SD2.D2_VALIPI [IPI],                                                        
		CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN (SD2.D2_ICMSRET)  ELSE 0 END [ST],                                                                                   
		ROUND(((SD2.D2_VALBRUT - SD2.D2_VALIPI - (CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN (SD2.D2_ICMSRET) ELSE 0 END))), 2)  [RECEITA_BRUTA],                       
		SD2.D2_PICM [PICMS], SD2.D2_VALICM [ICMS], SD2.D2_VALIMP6 [PIS], SD2.D2_VALIMP5 [COFINS], SD2.D2_DESCZFC + SD2.D2_DESCZFP      [DESCONTO],                            

		(  SD2.D2_VALBRUT - SD2.D2_VALIPI - (CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END ) -                                                    
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN (SD2.D2_DESCZFC - SD2.D2_DESCZFP) ELSE 0 END )  -                                                                         
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 ) [RECEITA_LIQUIDA],                                                                                              

		SD2.D2_CUSTO1 [CUSTO], SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                                                                               
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN SD2.D2_DESCZFC - SD2.D2_DESCZFP ELSE 0 END) -                                                                             
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 - SD2.D2_CUSTO1 -                                                                                                  
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END) [MARGEM_BRUTA],                                                                        

		SD2.D2_CUSTO1 / (SD2.D2_VALBRUT - D2_VALIPI -                                                                                                                         
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'')                                                                                                                        
		AND SD2.D2_ICMSRET < SD2.D2_VALBRUT - SD2.D2_VALIPI THEN SD2.D2_ICMSRET WHEN SD2.D2_VALBRUT - SD2.D2_VALIPI = SD2.D2_ICMSRET  THEN 1 ELSE 0 END)) * 100 [P_CUSTO], 

		( (SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                                                                                                   
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN (SD2.D2_DESCZFC - SD2.D2_DESCZFP) ELSE 0 END) -                                                                           
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 - SD2.D2_CUSTO1 -                                                                                                  
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END )) / (SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                  
		(  CASE WHEN  SD2.D2_CF NOT IN (''5949'', ''6102'') AND SD2.D2_ICMSRET < (SD2.D2_VALBRUT - SD2.D2_VALIPI) THEN SD2.D2_ICMSRET                                            
		WHEN (SD2.D2_VALBRUT - SD2.D2_VALIPI )= SD2.D2_ICMSRET THEN 1 ELSE 0 END )) * 100 ) [P_LUCRO],    

		SB1.B1_POSIPI [NCM],                                                                                                                                                    
		SA1.A1_TIPO [TIPOCLI],                                                                                                                                                  
		SA1.A1_INSCR [IE],                                                                                                                                                      
		SA1.A1_SUFRAMA [SUFRAMA],                                                                                                                                               
		SA1.A1_GRPTRIB [GRPTRIB],                                                                                                                                               
		SA1.A1_TPESSOA [TPESSOA],                                                                                                                                               
		SA1.A1_CNAE [CNAE],                                                                                                                                                     
		SA1.A1_SIMPNAC [SIMPLES],                                                                                                                                               
		SA1.A1_REGESIM [MT],                                                                                                                                                    
		isnull(Z7Z.CTE,'''') [NUMCTE],  
		''   '' [SERCTE],     		
		0 NQCTE,                                                                                                                                             
		0 [VALFRETE],
		SD2.D2_PEDIDO [PEDIDO],	
		SD2.D2_ITEM [ITEM],
		SD2.D2_PRCVEN [PRCVEN],
		SA2.A2_NOME	[FORNECEDOR],
		''''  [NOTAORIGEM],
		F4_DUPLIC DUPLIC,
		GERENTE_UA1.A3_COD AS GERENTEUA1,
		GERENTE_UA1.A3_NOME AS NOMEGERENTEUA1,
		GERENTE_UA1.A3_COD+''-''+GERENTE_UA1.A3_NOME AS NOME_GERENTEUA1,
		B1_PROC,
		GERENTE_UA2.A3_COD+'' - ''+GERENTE_UA2.A3_NOME GERENTE_UA2,
		REGIAO.X5_DESCRI [REGIAO_VEND]  
		FROM                                                                                                                                                                  
		SD2010 SD2 with (nolock) 	   
		INNER JOIN SF4010 SF4
			ON F4_FILIAL =  SUBSTRING(D2_FILIAL,1,4)
			AND F4_CODIGO = D2_TES
			AND SF4.D_E_L_E_T_<>''*''
		INNER JOIN                                                                                                                                                         
		SF2010 	SF2 with (nolock) 	                                                                                                                              
		ON SF2.F2_FILIAL = SD2.D2_FILIAL                                                                                                                                
		AND SF2.F2_DOC = SD2.D2_DOC                                                                                                                                    
		AND SF2.F2_SERIE = SD2.D2_SERIE                                                                                                                                 
		AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                                                                                                                             
		AND SF2.F2_LOJA = SD2.D2_LOJA                                                                                                                                   
		--AND SF2.F2_DUPL != '' ''                                                                                                                                          
		AND SF2.F2_TIPO IN (''N'',''D'')                                                                                                                                                   
		AND SF2.D_E_L_E_T_<>''*''	                                                                                                                                       
		LEFT JOIN                                                                                                                                                          
		(select Z7Z_FILIAL, Z7Z_NOTA, Z7Z_SERINF,SUM(Z6Z_VALTOT) VALOR,
			STUFF((select+	''; '' +  Z7Z_DOC
			from Z7Z010 AS XX with (nolock) 	
			where XX.Z7Z_NOTA=Z7Z.Z7Z_NOTA
			AND XX.Z7Z_SERINF = Z7Z.Z7Z_SERINF
			for xml path('''')),
              1, 1, '''') AS CTE
			from Z7Z010 Z7Z with (nolock) 	
				INNER JOIN Z6Z010 Z6Z with (nolock) 	
					ON Z6Z_FILIAL = Z7Z_FILIAL
					AND Z6Z_DOC = Z7Z_DOC
					AND Z6Z_SERIE =Z7Z_SERIE
					AND Z6Z.D_E_L_E_T_<>''*''
			GROUP BY Z7Z_FILIAL, Z7Z_NOTA, Z7Z_SERINF)	Z7Z                                                                                                                                
		ON Z7Z.Z7Z_FILIAL = SD2.D2_FILIAL                                                                                                                               
		AND Z7Z.Z7Z_SERINF = SD2.D2_SERIE                                                                                                                               
		AND Z7Z.Z7Z_NOTA = SD2.D2_DOC                                                                                                                                                                                                                                                                        
		LEFT JOIN                                                                                                                                                          
		SUA010 	SUA with (nolock) 	                                                                                                                                
		ON SUA.UA_FILIAL = SD2.D2_FILIAL                                                                                                                                
		AND SUA.UA_SERIE = SD2.D2_SERIE                                                                                                                                 
		AND SUA.UA_DOC = SD2.D2_DOC                                                                                                                                     
		AND SUA.D_E_L_E_T_<>''*''	                                                                                                                                      
		LEFT JOIN                                                                                                                                                          
		SU7010 	SU7  with (nolock) 	                                                                                                                             
		ON SU7.U7_COD = SUA.UA_OPERADO                                                                                                                                  
		AND SU7.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SA1010 	SA1 with (nolock) 	                                                                                                                               
		ON SA1.A1_COD = SD2.D2_CLIENTE                                                                                                                                  
		AND SA1.A1_LOJA = SD2.D2_LOJA                                                                                                                                   
		--AND SA1.A1_VEND BETWEEN %Exp:(MV_PAR03)% AND %Exp:(MV_PAR04)%                                                                                                                   
		AND SA1.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SB1010 	SB1 with (nolock) 	                                                                                                                             
		ON SB1.B1_COD = SD2.D2_COD                                                                                                                                      
		AND SB1.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SBM010 	SBM with (nolock) 	                                                                                                                               
		ON SB1.B1_GRUPO = SBM.BM_GRUPO                                                                                                                                  
		AND SBM.D_E_L_E_T_<>''*''	                                                                                                                                      
		LEFT JOIN                                                                                                                                                          
		SA3010 	 A3VEN with (nolock) 	                                                                                                                             
		ON A3VEN.A3_COD = SA1.A1_VEND                                                                                                                                   
		AND A3VEN.D_E_L_E_T_<>''*''	                                                                                                                                    
		LEFT JOIN                                                                                                                                                          
		SA3010  VEND1UA with (nolock) 	                                                                                                                           
		ON VEND1UA.A3_COD = SUA.UA_VEND                                                                                                                                 
		AND VEND1UA.D_E_L_E_T_<>''*''	
		left join SA3010 GERENTE_UA1
			on GERENTE_UA1.A3_COD = VEND1UA.A3_GEREN
			AND GERENTE_UA1.D_E_L_E_T_<>''*''
			AND GERENTE_UA1.A3_MSBLQL<>''1''                                                                                                                                   
		LEFT JOIN                                                                                                                                                          
		SA3010 	VEND2UA  with (nolock) 	                                                                                                                            
		ON VEND2UA.A3_COD = SUA.UA_VEND2                                                                                                                                
		AND VEND2UA.D_E_L_E_T_<>''*''
		left join SA3010 GERENTE_UA2 with (nolock) 	
			on GERENTE_UA2.A3_COD = VEND2UA.A3_GEREN
			AND GERENTE_UA2.D_E_L_E_T_<>''*''
			AND GERENTE_UA2.A3_MSBLQL<>''1''    
		LEFT JOIN                                                                                                                                                          
		SX5010 	 REGIAO with (nolock) 	                                                                                                                             
		ON REGIAO.X5_TABELA = ''Z4''                                                                                                                                      
		AND REGIAO.X5_CHAVE = A1_REGIAO                                                                                                                                 
		AND REGIAO.D_E_L_E_T_<>''*''	
		left JOIN SA2010  SA2
			ON A2_COD = B1_PROC
			AND A2_LOJA = B1_LOJPROC
			AND SA2.D_E_L_E_T_<>''*''   
		LEFT JOIN SCT010 SCT
			ON CT_FILIAL=''010101''
			AND CT_VEND = VEND1UA.A3_COD
			AND SCT.D_E_L_E_T_<>''*''
		left join SX5010 	 REGIAO_VEND with (nolock) 	                                                                                                                             
		ON REGIAO_VEND.X5_TABELA = ''Z4''                                                                                                                                      
		AND REGIAO_VEND.X5_CHAVE = CT_REGIAO                                                                                                                                 
		AND REGIAO_VEND.D_E_L_E_T_<>''*''	
		WHERE                                                                                                                                                                 
		SD2.D_E_L_E_T_<>''*''	    
		AND SD2.D2_CF NOT IN (''6202'',''6411'')                                                                                                                                           
		AND SD2.D2_EMISSAO >=  @DTFILTRO                                                                                 
		--AND SD2.D2_CLIENTE BETWEEN %Exp:(MV_PAR05)%   AND %Exp:(MV_PAR06)%                                                                                                   
		--AND SD2.D2_LOJA    BETWEEN %Exp:(MV_PAR07)%   AND %Exp:(MV_PAR08)%                                                                                                           
		--ORDER BY D2_EMISSAO, D2_DOC, D2_ITEM DESC
UNION ALL
SELECT	                                                                     
		SD1.D1_EMISSAO [EMISSAO],                                                   
		SD2.D2_FILIAL [COD_FIL],                                                    
		CASE                                                                        
		WHEN SD2.D2_FILIAL = ''010101'' THEN ''SENTAX - CURITIBA''                   
		WHEN SD2.D2_FILIAL = ''020201'' THEN ''GIBRALTAR - CURITIBA''                
		WHEN SD2.D2_FILIAL = ''020202'' THEN ''GIBRALTAR - FOZ DO IGUACU''           
		WHEN SD2.D2_FILIAL = ''020203'' THEN ''GIBRALTAR - JOINVILLE''               
		WHEN SD2.D2_FILIAL = ''020204'' THEN ''GIBRALTAR - MARILIA''                 
		WHEN SD2.D2_FILIAL = ''020205'' THEN ''GIBRALTAR - SAO JOSE DOS PINHAIS''    
		WHEN SD2.D2_FILIAL = ''030301'' THEN ''ARVOREDO - JOINVILLE''                
		WHEN SD2.D2_FILIAL = ''040401'' THEN ''RADICAL CONSULTORIA DE MARKETING''  END [DESC_FIL],                                                             
		SD1.D1_DOC    [NF],                                                            
		SD1.D1_TIPO   [TIPONF],                                                       
		SB1.B1_GRUPO  [GRPROD],                                                      
		SBM.BM_DESC   [GRUPOPROD],                                                    
		SD2.D2_COD    [COD_PRODUTO],                                                   
		SB1.B1_DESC   [PRODUTO],                                                      
		SD2.D2_QUANT  [QUANTI],                                                      
		SD1.D1_CF     [CFOP],                                                           
		SB1.B1_TIPO   [TIPO],                                                         
		REGIAO_VEND.X5_DESCRI [REGIAO],                                                  
		SA1.A1_COD_MUN 	 [COD_MUN],                                                   
		SA1.A1_MUN 		 [MUNIC],                                                         
		SD2.D2_EST       [ESTADO],                                                        
		SA1.A1_COD       [COD_CLIENTE],                                                   
		SA1.A1_LOJA      [LOJA],                                                         
		SA1.A1_NOME      [HISTORICO],                                                    
		SA1.A1_VEND      [COD_VEND],                                                     
		A3VEN.A3_NREDUZ  [VENDEDOR],                                                
		SUA.UA_OPERADO   [COD_OPERADOR],                                              
		SU7.U7_NOME      [OPERADOR],                                                     
		SUA.UA_VEND      [VEND_UA1],                                                     
		VEND1UA.A3_NREDUZ  [NUAVEND1],                                               
		SUA.UA_VEND2       [VEND_UA2],                                                    
		VEND2UA.A3_NREDUZ  [NUAVEND2],                                               
		CASE  WHEN SUA.UA_TMK = ''1'' THEN ''RECEPTIVO''                                
		WHEN SUA.UA_TMK = ''2'' THEN ''ATIVO''                                    
		WHEN SUA.UA_TMK = ''3'' THEN ''ACOMPANHAMENTO''                           
		WHEN SUA.UA_TMK = ''4'' THEN ''REPRESENTANTE''                            
		WHEN SUA.UA_TMK = ''5'' THEN ''RETORNO ATIVO''                            
		WHEN SUA.UA_TMK = ''6'' THEN ''COTAÇÃO''                                  
		WHEN SUA.UA_TMK = ''7'' THEN ''ORDEM DE SERVIÇO''                         
		WHEN SUA.UA_TMK = ''8'' THEN ''E-MAIL''                                   
		WHEN SUA.UA_TMK = ''9'' THEN ''WHATSAPP''                                
		WHEN SUA.UA_TMK = ''S'' THEN ''SITE'' END  [TMK] ,                                                                 
		SD1.D1_TOTAL *(-1) + D1_VALDESC [VENDA],
		SD2.D2_VALFRE *(-1)  [FRETE],
		--SD2.D2_VALDEV [DEVOLUCAO], 
		SD1.D1_TOTAL [DEVOLUCAO],		
		SD2.D2_IPI [PIPI],                                                          
		SD2.D2_VALIPI [IPI],                                                        
		CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN (SD2.D2_ICMSRET)  ELSE 0 END [ST],                                                                                   
		ROUND(((SD2.D2_VALBRUT - SD2.D2_VALIPI - (CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN (SD2.D2_ICMSRET) ELSE 0 END))), 2)  [RECEITA_BRUTA],                       
		SD2.D2_PICM [PICMS], SD2.D2_VALICM [ICMS], SD2.D2_VALIMP6 [PIS], SD2.D2_VALIMP5 [COFINS], SD2.D2_DESCZFC + SD2.D2_DESCZFP      [DESCONTO],                            

		(  SD2.D2_VALBRUT - SD2.D2_VALIPI - (CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END ) -                                                    
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN (SD2.D2_DESCZFC - SD2.D2_DESCZFP) ELSE 0 END )  -                                                                         
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 ) [RECEITA_LIQUIDA],                                                                                              

		SD2.D2_CUSTO1 [CUSTO], SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                                                                               
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN SD2.D2_DESCZFC - SD2.D2_DESCZFP ELSE 0 END) -                                                                             
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 - SD2.D2_CUSTO1 -                                                                                                  
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END) [MARGEM_BRUTA],                                                                        

		SD2.D2_CUSTO1 / (SD2.D2_VALBRUT - D2_VALIPI -                                                                                                                         
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'')                                                                                                                        
		AND SD2.D2_ICMSRET < SD2.D2_VALBRUT - SD2.D2_VALIPI THEN SD2.D2_ICMSRET WHEN SD2.D2_VALBRUT - SD2.D2_VALIPI = SD2.D2_ICMSRET  THEN 1 ELSE 0 END)) * 100 [P_CUSTO], 

		( (SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                                                                                                   
		(  CASE WHEN SD2.D2_CF NOT IN (''6110'') THEN (SD2.D2_DESCZFC - SD2.D2_DESCZFP) ELSE 0 END) -                                                                           
		SD2.D2_VALICM - SD2.D2_VALIMP6 - SD2.D2_VALIMP5 - SD2.D2_CUSTO1 -                                                                                                  
		(  CASE WHEN SD2.D2_CF NOT IN (''5949'', ''6102'') THEN SD2.D2_ICMSRET ELSE 0 END )) / (SD2.D2_VALBRUT - SD2.D2_VALIPI -                                                  
		(  CASE WHEN  SD2.D2_CF NOT IN (''5949'', ''6102'') AND SD2.D2_ICMSRET < (SD2.D2_VALBRUT - SD2.D2_VALIPI) THEN SD2.D2_ICMSRET                                            
		WHEN (SD2.D2_VALBRUT - SD2.D2_VALIPI )= SD2.D2_ICMSRET THEN 1 ELSE 0 END )) * 100 ) [P_LUCRO],    

		SB1.B1_POSIPI [NCM],                                                                                                                                                    
		SA1.A1_TIPO [TIPOCLI],                                                                                                                                                  
		SA1.A1_INSCR [IE],                                                                                                                                                      
		SA1.A1_SUFRAMA [SUFRAMA],                                                                                                                                               
		SA1.A1_GRPTRIB [GRPTRIB],                                                                                                                                               
		SA1.A1_TPESSOA [TPESSOA],                                                                                                                                               
		SA1.A1_CNAE [CNAE],                                                                                                                                                     
		SA1.A1_SIMPNAC [SIMPLES],                                                                                                                                               
		SA1.A1_REGESIM [MT],                                                                                                                                                    
		isnull(Z7Z.CTE,'''') [NUMCTE],  
		''   '' [SERCTE],    		
		0 NQCTE,                                                                                                                                             
		0 [VALFRETE],
		SD2.D2_PEDIDO [PEDIDO],	
		SD2.D2_ITEM [ITEM],
		SD2.D2_PRCVEN [PRCVEN],
		SA2.A2_NOME	[FORNECEDOR],
		SD1.D1_NFORI [NOTAORIGEM]	,
		F4_DUPLIC,
		GERENTE_UA1.A3_COD AS GERENTEUA1,
		GERENTE_UA1.A3_NOME AS NOMEGERENTEUA1,
		GERENTE_UA1.A3_COD+''-''+GERENTE_UA1.A3_NOME AS NOME_GERENTEUA1, 
		B1_PROC,
		GERENTE_UA2.A3_COD+'' - ''+GERENTE_UA2.A3_NOME as GERENTE_UA2,
		REGIAO.X5_DESCRI [REGIAO_VEND] 
		FROM                                                                                                                                                                  
		SD2010 	SD2 with (nolock) 	   
		INNER JOIN SF4010 SF4 with (nolock) 	
			ON F4_FILIAL =  SUBSTRING(D2_FILIAL,1,4)
			AND F4_CODIGO = D2_TES
			AND SF4.D_E_L_E_T_<>''*''
		INNER JOIN                                                                                                                                                         
		SF2010 	SF2 with (nolock) 	                                                                                                                              
		ON SF2.F2_FILIAL = SD2.D2_FILIAL                                                                                                                                
		AND SF2.F2_DOC = SD2.D2_DOC                                                                                                                                    
		AND SF2.F2_SERIE = SD2.D2_SERIE                                                                                                                                 
		AND SF2.F2_CLIENTE = SD2.D2_CLIENTE                                                                                                                             
		AND SF2.F2_LOJA = SD2.D2_LOJA                                                                                                                                                                                                                                                                         
		AND SF2.F2_TIPO IN (''N'',''D'')                                                                                                                                                   
		AND SF2.D_E_L_E_T_<>''*''	 
		INNER JOIN SD1010  SD1 with (nolock) 	
			ON D1_FILIAL = D2_FILIAL
			AND D1_NFORI = D2_DOC
			AND D1_SERIORI = D2_SERIE
			AND D1_ITEMORI = D2_ITEM
			AND D1_CF IN (''1202'',''2202'',''1411'',''2411'')
			AND SD1.D_E_L_E_T_<>''*''                                                                                                                                       
		LEFT JOIN                                                                                                                                                          
		(select Z7Z_FILIAL, Z7Z_NOTA, Z7Z_SERINF,SUM(Z6Z_VALTOT) VALOR,
			STUFF((select+	''; '' +  Z7Z_DOC
			from Z7Z010 AS XX with (nolock) 	
			where XX.Z7Z_NOTA=Z7Z.Z7Z_NOTA
			AND XX.Z7Z_SERINF = Z7Z.Z7Z_SERINF
			for xml path('''')),
              1, 1, '''') AS CTE
			from Z7Z010 Z7Z with (nolock) 	
				INNER JOIN Z6Z010 Z6Z
					ON Z6Z_FILIAL = Z7Z_FILIAL
					AND Z6Z_DOC = Z7Z_DOC
					AND Z6Z_SERIE =Z7Z_SERIE
					AND Z6Z.D_E_L_E_T_<>''*''
			GROUP BY Z7Z_FILIAL, Z7Z_NOTA, Z7Z_SERINF)Z7Z                                                                                                                                
		ON Z7Z.Z7Z_FILIAL = SD2.D2_FILIAL                                                                                                                               
		AND Z7Z.Z7Z_SERINF = SD2.D2_SERIE                                                                                                                               
		AND Z7Z.Z7Z_NOTA = SD2.D2_DOC                                                                                                                                                                                                                                                                     
		LEFT JOIN                                                                                                                                                          
		SUA010 	SUA with (nolock) 	                                                                                                                               
		ON SUA.UA_FILIAL = SD2.D2_FILIAL                                                                                                                                
		AND SUA.UA_SERIE = SD2.D2_SERIE                                                                                                                                 
		AND SUA.UA_DOC = SD2.D2_DOC                                                                                                                                     
		AND SUA.D_E_L_E_T_<>''*''	                                                                                                                                      
		LEFT JOIN                                                                                                                                                          
		SU7010 	SU7 with (nolock) 	                                                                                                                              
		ON SU7.U7_COD = SUA.UA_OPERADO                                                                                                                                  
		AND SU7.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SA1010 	SA1 with (nolock) 	                                                                                                                               
		ON SA1.A1_COD = SD2.D2_CLIENTE                                                                                                                                                                                                                                                   
		AND SA1.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SB1010 	SB1 with (nolock) 	                                                                                                                             
		ON SB1.B1_COD = SD2.D2_COD                                                                                                                                      
		AND SB1.D_E_L_E_T_<>''*''	                                                                                                                                      
		INNER JOIN                                                                                                                                                         
		SBM010 	SBM with (nolock) 	                                                                                                                               
		ON SB1.B1_GRUPO = SBM.BM_GRUPO                                                                                                                                  
		AND SBM.D_E_L_E_T_<>''*''	                                                                                                                                      
		LEFT JOIN                                                                                                                                                          
		SA3010 	 A3VEN  with (nolock) 	                                                                                                                           
		ON A3VEN.A3_COD = SA1.A1_VEND                                                                                                                                   
		AND A3VEN.D_E_L_E_T_<>''*''	                                                                                                                                    
		LEFT JOIN                                                                                                                                                          
		SA3010  VEND1UA with (nolock) 	                                                                                                                          
		ON VEND1UA.A3_COD = SUA.UA_VEND                                                                                                                                 
		AND VEND1UA.D_E_L_E_T_<>''*''	 
		left join SA3010 GERENTE_UA1
			on GERENTE_UA1.A3_COD = VEND1UA.A3_GEREN
			AND GERENTE_UA1.D_E_L_E_T_<>''*''
			AND GERENTE_UA1.A3_MSBLQL<>''1''                                                                                                                                 
		LEFT JOIN                                                                                                                                                          
		SA3010 	VEND2UA  with (nolock) 	                                                                                                                           
		ON VEND2UA.A3_COD = SUA.UA_VEND2                                                                                                                                
		AND VEND2UA.D_E_L_E_T_<>''*''	 
		left join SA3010 GERENTE_UA2
			on GERENTE_UA2.A3_COD = VEND2UA.A3_GEREN
			AND GERENTE_UA2.D_E_L_E_T_<>''*''
			AND GERENTE_UA2.A3_MSBLQL<>''1''   
		LEFT JOIN                                                                                                                                                          
		SX5010 	 REGIAO  with (nolock) 	                                                                                                                            
		ON REGIAO.X5_TABELA = ''Z4''                                                                                                                                      
		AND REGIAO.X5_CHAVE = A1_REGIAO                                                                                                                                 
		AND REGIAO.D_E_L_E_T_<>''*''	
				LEFT JOIN SCT010 SCT
			ON CT_FILIAL=''010101''
			AND CT_VEND = VEND1UA.A3_COD
			AND SCT.D_E_L_E_T_<>''*''
		left join SX5010 	 REGIAO_VEND with (nolock) 	                                                                                                                             
		ON REGIAO_VEND.X5_TABELA = ''Z4''                                                                                                                                      
		AND REGIAO_VEND.X5_CHAVE = CT_REGIAO                                                                                                                                 
		AND REGIAO_VEND.D_E_L_E_T_<>''*''	

		left JOIN SA2010  SA2 with (nolock) 	
			ON A2_COD = B1_PROC
			AND A2_LOJA = B1_LOJPROC
			AND SA2.D_E_L_E_T_<>''*''                                                                                                                                 
		WHERE                                                                                                                                                                 
		SD2.D_E_L_E_T_<>''*''	    
		AND SD2.D2_CF NOT IN (''6202'',''6411'')
		AND SD1.D1_EMISSAO >= @DTFILTRO  )nn  
		Left Join (select 
						STXMETA_FILIAL FILIAL,
						SUBSTRING(STXMETA_EMISSAO,1,6) ANOMES,
						STXMETA_VEND VEND,
						STXMETA_META META,
						STXMETA_TDIAS DIAS_MES,
						MAX(STXMETA_TDIASP) DIAS_PASSADOS
					from STXMETA with (nolock) 	 
					GROUP BY STXMETA_FILIAL,
						STXMETA_VEND,
						SUBSTRING(STXMETA_EMISSAO,1,6),
						STXMETA_META,
						STXMETA_TDIAS)  as METAS_VEND
				ON METAS_VEND.VEND = nn.VEND_UA1
				AND SUBSTRING(METAS_VEND.ANOMES,1,6) = SUBSTRING(nn.EMISSAO,1,6)
				Left Join (select 
						STXMETA_FILIAL FILIAL,
						SUBSTRING(STXMETA_EMISSAO,1,6) ANOMES,
						STXMETA_VEND VEND,
						STXMETA_META META,
						STXMETA_TDIAS DIAS_MES,
						MAX(STXMETA_TDIASP) DIAS_PASSADOS
					from STXMETA with (nolock) 	 
					GROUP BY STXMETA_FILIAL,
						STXMETA_VEND,
						SUBSTRING(STXMETA_EMISSAO,1,6),
						STXMETA_META,
						STXMETA_TDIAS)  as METAS_VEND2
				ON METAS_VEND2.VEND = nn.VEND_UA2
				AND SUBSTRING(METAS_VEND2.ANOMES,1,6) = SUBSTRING(nn.EMISSAO,1,6)	
				


			
', 
		@database_name=N'P12_PROD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'atualiza vendas powerbi', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220216, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'd9f54bd2-28df-46cb-a5e5-225a03156a66'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


