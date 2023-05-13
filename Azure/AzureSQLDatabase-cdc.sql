--habilitar o cdc no banco de dados
EXEC sys.sp_cdc_enable_db
GO

--verificar databases com CDC habilitado
SELECT name, is_cdc_enabled FROM sys.databases WHERE is_cdc_enabled = 1

--hailitar o CDC em tabelas especificas
EXEC sys.sp_cdc_enable_table  
@source_schema = N'SalesLT',  
@source_name   = N'ProductModel',  
@role_name     = NULL,  
@filegroup_name = NULL,  
@supports_net_changes = 0 

--query auxiliar para criar comandos para habilitar cdc em varias tabelas
SELECT 
	 sh.name AS [Schema]
	,st.name
	,Command = 'EXEC sys.sp_cdc_enable_table @source_schema = N' + '''' + sh.name + '''' + ',  @source_name   = N' + '''' + st.name + '''' +',  @role_name = NULL,  @filegroup_name = NULL, @supports_net_changes = 0;'
FROM sys.tables AS st
INNER JOIN sys.schemas AS sh
	ON st.schema_id = sh.schema_id
WHERE 
	st.is_tracked_by_cdc = 0
	AND sh.name NOT IN ('cdc')

--verificar tabelas com CDC habilitado
SELECT name,type,type_desc,is_tracked_by_cdc
FROM sys.tables
WHERE is_tracked_by_cdc = 1

EXEC sys.sp_cdc_help_change_data_capture

--identificar as tabelas que relacionado ao cdc
SELECT 
	 st.name
	,st.object_id
	,st.type_desc
	,st.create_date
	,Command = 'SELECT * FROM ' + QUOTENAME(sh.name) + '.' + QUOTENAME(st.name) + ';'
FROM sys.objects AS st
INNER JOIN sys.schemas AS sh
	ON st.schema_id = sh.schema_id
WHERE 
	sh.name = 'cdc'
	AND st.type_desc = 'USER_TABLE'


INSERT INTO [SalesLT].[ProductModel] ([Name],[CatalogDescription],[rowguid],[ModifiedDate])
VALUES ('MT Fork', NULL, NEWID() ,GETDATE())

SELECT * FROM [SalesLT].[ProductModel]

UPDATE [SalesLT].[ProductModel] SET [Name] = 'Touring Tire 2' WHERE [ProductModelID] = 131

DELETE [SalesLT].[ProductModel] WHERE [ProductModelID] = 131

SELECT
	CASE [__$operation]
		WHEN 1 THEN 'DELETE'
		WHEN 2 THEN 'INSERT'
		WHEN 3 THEN 'BEFORE UPDATE'
		WHEN 4 THEN 'AFTER UPDATE'
	END AS Operation
	,*
FROM [cdc].[SalesLT_ProductModel_CT];


  
DECLARE 
	 @from_lsn binary(10)
	,@to_lsn binary(10);  

SET @from_lsn = sys.fn_cdc_get_min_lsn('SalesLT_ProductModel');  
SET @to_lsn   = sys.fn_cdc_get_max_lsn();  

SELECT * FROM cdc.fn_cdc_get_all_changes_SalesLT_ProductModel (@from_lsn, @to_lsn, N'all');  


--Desabilitando o CDC em uma tabela especifica
EXEC sys.sp_cdc_disable_table
@source_schema = N'SalesLT',  
@source_name   = N'ProductModel',  
@capture_instance = N'SalesLT_ProductModel'

--desabilitar CDC na database
EXEC sys.sp_cdc_disable_db