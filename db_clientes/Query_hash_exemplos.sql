USE [master]
GO
ALTER DATABASE [db_clientes] SET COMPATIBILITY_LEVEL = 150
GO

USE db_clientes
GO

-----------------------------------------------------------------------------------------------------
-- Exemplo View
-----------------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW dbo.vw_total_pedidos_cleinte 
AS
-- QUERY 2 - TOP 10 CLIENTES QUE MAIS GASTARAM
SELECT TOP 10 
	 c.nome
	,SUM(valor) AS valor_total
FROM pedido AS p
INNER JOIN cliente AS c
	ON p.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY valor_total DESC

SELECT * FROM vw_total_pedidos_cliente

GO

-----------------------------------------------------------------------------------------------------
-- Exemplo Synonym
-----------------------------------------------------------------------------------------------------

SELECT nome FROM dbo.cliente
GO

CREATE SYNONYM cliente  
FOR [SQL2022].db_clientes.dbo.cliente;  
GO

-- de forma implicita esta referenciando a tabela cliente no schema venda
SELECT nome FROM dbo.cliente

GO

-----------------------------------------------------------------------------------------------------
-- Parte pratica
-----------------------------------------------------------------------------------------------------

-- As queries são iguais?
USE db_clientes
GO

SELECT
	* 
FROM cliente 
WHERE nome = 'Hércules'
AND 1 = 1 -- FILTRO PARA IMPEDIR O PARAMETERIZATION SIMPLE

SELECT
	* 
FROM cliente 
WHERE nome = 'Lucas'
AND 1 = 1 -- FILTRO PARA IMPEDIR O PARAMETERIZATION SIMPLE 

GO

-- Consultar os planos de execuções em cache
SELECT 
	 ecp.cacheobjtype
	,ecp.objtype
	,eqs.query_hash
	,est.[text]
	,ecp.usecounts
	,eqs.plan_handle
FROM sys.dm_exec_cached_plans AS ecp
CROSS APPLY sys.dm_exec_sql_text (ecp.plan_handle) AS est
INNER JOIN sys.dm_exec_query_stats AS eqs
	ON ecp.plan_handle = eqs.plan_handle
WHERE 1 = 1
	AND [text] NOT LIKE '%sys.%'
	AND [text] LIKE '%SELECT%cliente%nome%'
ORDER BY creation_time ASC

GO

-- Agrupamento das queries pelo texto
SELECT 
	 est.[text]
	,COUNT(*) AS cnt
FROM sys.dm_exec_cached_plans AS ecp
CROSS APPLY sys.dm_exec_sql_text (ecp.plan_handle) AS est
INNER JOIN sys.dm_exec_query_stats AS eqs
	ON ecp.plan_handle = eqs.plan_handle
WHERE 1 = 1
	AND [text] NOT LIKE '%sys.%'
	AND [text] LIKE '%SELECT%cliente%nome%'
GROUP BY est.[text]

-- tentando contornar o problema dos texto da query serem diferentes
SELECT 
	 LEFT(est.[text], 40)
	,COUNT(*) AS cnt
FROM sys.dm_exec_cached_plans AS ecp
CROSS APPLY sys.dm_exec_sql_text (ecp.plan_handle) AS est
INNER JOIN sys.dm_exec_query_stats AS eqs
	ON ecp.plan_handle = eqs.plan_handle
WHERE 1 = 1
	AND [text] NOT LIKE '%sys.%'
	AND [text] LIKE '%SELECT%cliente%nome%'
GROUP BY LEFT(est.[text], 40)

-----------------------------------------------------------------------------------------------------
-- Forma correta de agrupamento
-----------------------------------------------------------------------------------------------------
SELECT 
	 eqs.query_hash
	,COUNT(*) AS cnt
FROM sys.dm_exec_cached_plans AS ecp
CROSS APPLY sys.dm_exec_sql_text (ecp.plan_handle) AS est
INNER JOIN sys.dm_exec_query_stats AS eqs
	ON ecp.plan_handle = eqs.plan_handle
WHERE 1 = 1
	AND [text] NOT LIKE '%sys.%'
	AND [text] LIKE '%SELECT%cliente%nome%'
GROUP BY  eqs.query_hash