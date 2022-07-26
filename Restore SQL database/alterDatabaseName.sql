SELECT
	 @@SERVERNAME AS SQLServer
	,name
	,state_desc
	,create_date
FROM sys.databases 
WHERE name LIKE 'AdventureWorksLT%'

GO

--SQL Database em seu estado atual
ALTER DATABASE [AdventureWorksLT] MODIFY NAME = [AdventureWorksLT_OLD];

--SQL Database restaurada no horario especificado
ALTER DATABASE [AdventureWorksLT_restore] MODIFY NAME = [AdventureWorksLT];
