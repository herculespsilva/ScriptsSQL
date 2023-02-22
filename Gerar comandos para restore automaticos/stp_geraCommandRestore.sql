USE [master]
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'stp_geraCommandRestore')
	DROP PROCEDURE [stp_geraCommandRestore]

GO

CREATE PROCEDURE stp_geraCommandRestore (
	 @DATABASE VARCHAR(100) = NULL					-- Especifique o nome da database ou NULL para pegar o comando de todas databases
	,@RETENCAO INT = -24							-- Parametro que fornece o tempo em horas que se deseja criar os comandos de RESTORE EX. ultimas 24 horas
	,@UNC VARCHAR(100) = 'N' --'\\SERVERNAME_UNC'	-- Especifique o nome do servidor que sera considerado para o diretório UNC ou NULL para coletar o valor do @@SERVERNAME, ou N para desconsiderar esse parametro
	,@OPTIMIZATION CHAR(1) = 'Y'					-- Especifique o valor 'Y' para adicionar os parametros de optimization ou 'N' para desconsiderar
	,@TYPE VARCHAR(10) = NULL						-- Informa os tipos de backups que serao considerados, Ex. 'D' para FULL, 'I' para DIFF, 'L' para LOG ou NULL para considerar todos
) AS 
BEGIN
	SELECT 
		 s.database_name AS DatabaseName
		,CASE s.type 
			WHEN 'D' THEN 'FULL' 
			WHEN 'I' THEN 'DIFF' 
			WHEN 'L' THEN 'LOG' 
		 END AS BakupType
		,DATEDIFF(SECOND, backup_start_date, backup_finish_date) AS Duration_seg
		,backup_start_date
		,backup_finish_date
		,CASE 
			WHEN s.type IN ('D','I') THEN 'RESTORE DATABASE ' + QUOTENAME(s.database_name) + ' FROM DISK = N' + '''' + CASE ISNULL(@UNC, '') WHEN '' THEN '\\' + CONVERT(VARCHAR(100), @@SERVERNAME) + '\' + REPLACE(m.physical_device_name,':','$') WHEN 'N' THEN m.physical_device_name ELSE @UNC + '\' + REPLACE(m.physical_device_name,':','$') END + '''' + ' WITH NORECOVERY, STATS = 10' + CASE ISNULL(@OPTIMIZATION, 'N') WHEN 'N' THEN '' ELSE ', MAXTRANSFERSIZE = 2097152, BUFFERCOUNT = 50, BLOCKSIZE = 8192' END + ';'
			ELSE 'RESTORE LOG ' + QUOTENAME(s.database_name) + ' FROM  DISK = N''' + CASE ISNULL(@UNC, '') WHEN '' THEN '\\' + CONVERT(VARCHAR(100), @@SERVERNAME) + '\' + REPLACE(m.physical_device_name,':','$') WHEN 'N' THEN m.physical_device_name ELSE @UNC + '\' + REPLACE(m.physical_device_name,':','$') END + ''' WITH NORECOVERY, STATS = 10' + CASE ISNULL(@OPTIMIZATION, 'N') WHEN 'N' THEN '' ELSE ', MAXTRANSFERSIZE = 2097152, BUFFERCOUNT = 50, BLOCKSIZE = 8192' END + ';'
		 END AS CommandRestore
	FROM msdb.dbo.backupset AS s
	INNER JOIN msdb.dbo.backupmediafamily AS m ON s.media_set_id = m.media_set_id
	WHERE 1 = 1
		AND backup_start_date  >= DATEADD(HOUR, @RETENCAO, GETDATE())
		AND s.database_name NOT IN ('master', 'model', 'msdb')
		AND (s.database_name = @DATABASE OR @DATABASE IS NULL)
		AND (s.type = @TYPE OR @TYPE IS NULL)
	ORDER BY s.database_name, backup_start_date ASC
	OPTION (RECOMPILE)
END

GO

--Gerar comandos de RESTORE com otimizacao de todas as databases na ultima semana
EXEC stp_geraCommandRestore 
	 @DATABASE = NULL
	,@RETENCAO = -168
	,@UNC = 'N'
	,@OPTIMIZATION = 'Y'

GO

--Gerar comandos de RESTORE sem otimizacao somente da database [Northwind] nas ultimas 24 horas
EXEC stp_geraCommandRestore 
	 @DATABASE = 'Northwind'
	,@RETENCAO = -24
	,@UNC = 'N'
	,@OPTIMIZATION = 'N'

GO

--Gerar comandos de RESTORE de backups de LOG com otimizacao somente da database [CustomersData] nas ultimas 6 horas
EXEC stp_geraCommandRestore 
	 @DATABASE = 'CustomersData'
	,@RETENCAO = -6
	,@UNC = 'N'
	,@OPTIMIZATION = 'Y'
	,@TYPE = 'L'					-- Informa os tipos de backups que serao considerados, Ex. 'D' para FULL, 'I' para DIFF, 'L' para LOG ou NULL para considerar todos

GO

--Gerar comandos de RESTORE de todos os backups de diretório UNC padrao com otimizacao somente da database [Northwind] nas ultimas 2 horas
EXEC stp_geraCommandRestore 
	 @DATABASE = 'Northwind'
	,@RETENCAO = -2
	,@UNC = NULL					-- Especifique o nome do servidor que sera considerado para o diretório UNC ou NULL para coletar o valor do @@SERVERNAME, ou N para desconsiderar esse parametro
	,@OPTIMIZATION = 'Y'
	,@TYPE = NULL

GO

--Gerar comandos de RESTORE de todos os backups de diretório UNC especifico com otimizacao somente da database [Northwind] nas ultimas 2 horas
EXEC stp_geraCommandRestore 
	 @DATABASE = 'Northwind'
	,@RETENCAO = -2
	,@UNC = '\\SERVERNAME_UNC'			-- Especifique o nome do servidor que sera considerado para o diretório UNC ou NULL para coletar o valor do @@SERVERNAME, ou N para desconsiderar esse parametro
	,@OPTIMIZATION = 'Y'
	,@TYPE = NULL