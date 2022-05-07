USE [tempdb]
GO

DROP TABLE IF EXISTS [dbo].[Pedido]

GO

CREATE TABLE [dbo].[Pedido](
	[ID] INT IDENTITY(1,1) NOT NULL,
	[Pedido] INT NULL,
	[Data] DATE NOT NULL,
	[Quantidade] INT NOT NULL,
	[Valor] NUMERIC (10, 2) NOT NULL
) ON [PRIMARY]

GO

INSERT INTO [dbo].[Pedido] WITH (TABLOCK) ([Pedido], [Data], [Quantidade], [Valor]) 
SELECT TOP 10000000
	 (ABS(CHECKSUM(NEWID())) % 999999) + 1 AS Pedido
	,ISNULL(CONVERT(DATE, GETDATE() - (CHECKSUM(NEWID()) / 1000000)), GETDATE() - 10) AS [Data]
	,(ABS(CHECKSUM(NEWID())) % 350) + 1 AS Quantidade
	,ISNULL(ABS(CONVERT(NUMERIC(18,2), (CHECKSUM(NEWID()) / 1000000.5))), 0) AS [Valor]
FROM sysobjects AS a 
	,sysobjects AS b 
	,sysobjects AS c 
	,sysobjects AS d 

GO

ALTER TABLE [dbo].[Pedido] ADD CONSTRAINT PK_Pedido PRIMARY KEY(ID)

GO

--limpando os dados em cache para evitar leitura logicas
CHECKPOINT; DBCC FREEPROCCACHE; DBCC DROPCLEANBUFFERS; DBCC FREESYSTEMCACHE ('ALL')

-- Ativando as estatisticas de tempo de I/O
SET STATISTICS IO, TIME ON


--SELECT * FROM [dbo].[Pedido]

------------------------------------------------------------
--Executar em uma sessao diferente (A)
------------------------------------------------------------

SELECT 
	 [Data]
	,SUM([Valor]) AS ValorTotal
FROM [dbo].[Pedido]
WHERE [Quantidade] > 300
AND [Data] BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY [Data]
ORDER BY [Data]

------------------------------------------------------------
--Executar em uma sessao diferente (B)
------------------------------------------------------------
DECLARE @DATA DATE = ISNULL(CONVERT(DATE, GETDATE() - (CHECKSUM(NEWID()) / 1000000)), GETDATE() - 10)
	   ,@QTD INT = (ABS(CHECKSUM(NEWID())) % 100) + 1;

BEGIN TRANSACTION

UPDATE [dbo].[Pedido] SET [Quantidade] = @QTD
WHERE Data = @DATA

-- COMMIT

------------------------------------------------------------
--Executar em uma sessao diferente (C)
------------------------------------------------------------

EXEC sp_WhoIsActive @get_outer_command = 1,@get_plans = 1, @get_locks=1, @get_task_info = 2, @get_additional_info = 1,
@find_block_leaders =1, @sort_order = '[blocked_session_count] DESC',
@output_column_list = '[d%][blocked_session_count],[open_tran_count],[session_id],[blocking_session_id],[sql_text][wait_info][status]
					   [database_name][sql_command][reads][writes][query_plan][locks][additional_info]'

------------------------------------------------------------
-- Criar os seguintes indices e refazer os testes
------------------------------------------------------------

CREATE INDEX ix_01 ON Pedido (Quantidade, Data) INCLUDE (Valor)-- indice para o select
CREATE INDEX ix_02 ON Pedido (Data) -- indice para o update


-- Recriando o indice para evitar operacao de residual I/O
CREATE INDEX ix_01 ON Pedido (Data, Quantidade) INCLUDE (Valor)
WITH (DROP_EXISTING = ON)