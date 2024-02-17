USE db_clientes
GO
--------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAS BASICAS SQL BATCH E STATEMENT
--------------------------------------------------------------------------------------------------------------------------------

-- QUERY 1 - TOP 10 CLIENTES MAIS VELHOS CADASTRADOS NO BANCO DE DADOS
SELECT TOP 10 
	* 
FROM cliente 
ORDER BY dt_nascimento DESC

-- QUERY 2 - TOP 10 CLIENTES QUE MAIS GASTARAM
SELECT TOP 10 
	 c.nome
	,SUM(valor) AS valor_total
FROM pedido AS p
INNER JOIN cliente AS c
	ON p.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY valor_total DESC

GO

--------------------------------------------------------------------------------------------------------------------------------
-- SQL Batch Statement com Procedure
--------------------------------------------------------------------------------------------------------------------------------

-- AS MESMAS CONSULTAS FORAM COLOCADAS DENTRO DE UM PROCEDURE
CREATE  OR ALTER PROCEDURE stp_consulta_clientes AS
BEGIN
	
	-- QUERY 1 - TOP 10 CLIENTES MAIS VELHOS CADASTRADOS NO BANCO DE DADOS
	SELECT TOP 10 
		* 
	FROM cliente 
	ORDER BY dt_nascimento DESC

	-- QUERY 2 - TOP 10 CLIENTES QUE MAIS GASTARAM
	SELECT TOP 10 
		 c.nome
		,SUM(valor) AS valor_total
	FROM pedido AS p
	INNER JOIN cliente AS c
		ON p.id_cliente = c.id_cliente
	GROUP BY c.nome
	ORDER BY valor_total DESC

END

-- EXECUTANDO A PROCEDURE
EXEC stp_consulta_clientes