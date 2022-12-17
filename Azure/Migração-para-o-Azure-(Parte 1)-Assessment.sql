-- Script para modelar as databases [CustomersData] e [OrdersData] disponivel no seguinte link
----------------------------------------------------------------------------------------------------------------------------------

--https://github.com/herculespsilva/ScriptsSQL/blob/main/Azure/cross-database.sql


----------------------------------------------------------------------------------------------------------------------------------
-- Procedure para simular um cenari de cross-database
----------------------------------------------------------------------------------------------------------------------------------
USE [CustomersData]
GO

CREATE OR ALTER PROCEDURE sp_findCustomersDesc_crossdb
AS

SELECT TOP 10
	 a.Name
	,SUM(b.value) AS Amount
FROM [CustomersData].[dbo].[Customers] AS a
INNER JOIN [OrdersData].[dbo].[Orders] AS b
	ON a.CustomersID = b.CustomersID
GROUP BY a.Name
ORDER BY Amount DESC


----------------------------------------------------------------------------------------------------------------------------------
-- Extended Event para monitorar sql_batch_completed no SQL Server
----------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name='XE_MonitoringBatch')
    DROP EVENT SESSION [XE_MonitoringBatch] ON SERVER
GO

CREATE EVENT SESSION [XE_MonitoringBatch] ON SERVER  
ADD EVENT sqlserver.sql_batch_completed( 
    ACTION (sqlserver.sql_text, sqlserver.client_app_name, sqlserver.client_hostname, sqlserver.database_id, sqlserver.username))
ADD TARGET package0.event_file(SET filename = N'C:\temp\XE_MonitoringBatch.xel', max_file_size = (256), max_rollover_files = (10))
WITH (EVENT_RETENTION_MODE = ALLOW_MULTIPLE_EVENT_LOSS, STARTUP_STATE = ON, TRACK_CAUSALITY = OFF)

ALTER EVENT SESSION [XE_MonitoringBatch] ON SERVER STATE = START;


