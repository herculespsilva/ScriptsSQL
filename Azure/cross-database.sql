USE [master]
GO

--------------------------------------------------------------------------------------------------------------
--Stand Alone SQL Server 2019
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CustomersData')
BEGIN
	CREATE DATABASE CustomersData
END

USE CustomersData
GO

DROP TABLE IF EXISTS dbo.Customers

CREATE TABLE dbo.Customers (
	CustomersID INT IDENTITY (1, 1) NOT NULL,
	Name VARCHAR (40) NOT NULL ,
	Address VARCHAR (60) NULL ,
	City VARCHAR (50) NULL ,
	Region VARCHAR (30) NULL ,
	PostalCode VARCHAR (10) NULL ,
	Phone VARCHAR (24) NULL,

	CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED (CustomersID)
)

GO

--entrada de dados (Total de 10 linhas)
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Roanna U. Bell','283-4505 Adipiscing St.','Ribeirão Preto','São Paulo','19770-781','(98)81910-2521');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Slade Reilly','9003 Dictum Rd.','Parauapebas','Pará','66490-419','(87)56648-1370');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Steel D. Porter','940-4233 Convallis Street','Ribeirão Preto','São Paulo','12473-483','(97)21103-2706');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Holmes Mckee','P.O. Box 282, 7869 Sit Rd.','Santa Luzia','Minas Gerais','37033227','(19)38022-9247');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Brody A. Mcguire','Ap #121-8653 Cras Av.','Camaçari','Bahia','46453-236','(99)54389-6116');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Madison B. Hoffman','Ap #354-6530 Quisque St.','Santa Inês','Maranhão','65228-313','(43)43943-6604');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Elaine B. Summers','478-7077 Sit Road','Diadema','São Paulo','19605-607','(44)86134-1051');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Xandra Q. Mcintosh','1209 Ligula Ave','Camaragibe','Pernambuco','50495-178','(41)32326-0733');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Akeem Graves','Ap #905-4585 Ut Avenue','Carapicuíba','São Paulo','18343-742','(62)35326-8860');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Wesley Dillard','P.O. Box 836, 304 Nibh St.','Niterói','Rio de Janeiro','23145-301','(95)36619-4902');

--SELECT * FROM dbo.Customers

GO

USE [master]
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'OrdersData')
BEGIN
	CREATE DATABASE OrdersData
END

GO

USE OrdersData
GO

DROP TABLE IF EXISTS dbo.Orders

CREATE TABLE dbo.Orders (
	OrderID INT IDENTITY(1,1) NOT NULL,
	CustomersID INT NULL,
	OrderDate DATE NOT NULL,
	Value NUMERIC(18, 2) NOT NULL,
	
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED (OrderID)
)

GO

INSERT INTO dbo.Orders (CustomersID, OrderDate, Value) 
VALUES( 
	 (ABS(CHECKSUM(NEWID())) % 10) + 1 --CustomersID
	,ISNULL(CONVERT(DATE, GETDATE() - (CHECKSUM(NEWID()) / 1000000)), GETDATE() - 10) --OrderDate
	,ISNULL(ABS(CONVERT(NUMERIC(18,2), (CHECKSUM(NEWID()) / 10000000.5))), 0) --Value
);
GO 1000


--SELECT * FROM dbo.Orders 


--------------------------------------------------------------------------------------------------------------
--CROSS DATABASE ON-PREMISSE
--------------------------------------------------------------------------------------------------------------

SELECT 
	name AS databases
FROM sys.databases 
WHERE name IN ('CustomersData','OrdersData')

--customers who bought the most in descending order
SELECT TOP 10
	 a.Name
	,SUM(b.value) AS Amount
FROM [CustomersData].[dbo].[Customers] AS a
INNER JOIN [OrdersData].[dbo].[Orders] AS b
	ON a.CustomersID = b.CustomersID
GROUP BY a.Name
ORDER BY Amount DESC








--------------------------------------------------------------------------------------------------------------
--AZURE SQL DATABASE
--------------------------------------------------------------------------------------------------------------

--Criando os Azure SQL DB
CREATE DATABASE CustomersData (EDITION='Standard', Service_Objective='S0');
CREATE DATABASE OrdersData (EDITION='Standard', Service_Objective='S0');

--------------------------------------------------------------------------------------------------------------
--Acesse o banco de dados [CustomersData] em uma nova sessão
--------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.Customers

CREATE TABLE dbo.Customers (
	CustomersID INT IDENTITY (1, 1) NOT NULL,
	Name VARCHAR (40) NOT NULL ,
	Address VARCHAR (60) NULL ,
	City VARCHAR (50) NULL ,
	Region VARCHAR (30) NULL ,
	PostalCode VARCHAR (10) NULL ,
	Phone VARCHAR (24) NULL,

	CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED (CustomersID)
)

GO

--entrada de dados (Total de 10 linhas)
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Roanna U. Bell','283-4505 Adipiscing St.','Ribeirão Preto','São Paulo','19770-781','(98)81910-2521');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Slade Reilly','9003 Dictum Rd.','Parauapebas','Pará','66490-419','(87)56648-1370');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Steel D. Porter','940-4233 Convallis Street','Ribeirão Preto','São Paulo','12473-483','(97)21103-2706');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Holmes Mckee','P.O. Box 282, 7869 Sit Rd.','Santa Luzia','Minas Gerais','37033227','(19)38022-9247');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Brody A. Mcguire','Ap #121-8653 Cras Av.','Camaçari','Bahia','46453-236','(99)54389-6116');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Madison B. Hoffman','Ap #354-6530 Quisque St.','Santa Inês','Maranhão','65228-313','(43)43943-6604');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Elaine B. Summers','478-7077 Sit Road','Diadema','São Paulo','19605-607','(44)86134-1051');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Xandra Q. Mcintosh','1209 Ligula Ave','Camaragibe','Pernambuco','50495-178','(41)32326-0733');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Akeem Graves','Ap #905-4585 Ut Avenue','Carapicuíba','São Paulo','18343-742','(62)35326-8860');
INSERT INTO dbo.Customers([Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES('Wesley Dillard','P.O. Box 836, 304 Nibh St.','Niterói','Rio de Janeiro','23145-301','(95)36619-4902');

--------------------------------------------------------------------------------------------------------------
--Acesse o banco de dados [OrdersData] em uma nova sessão
--------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Orders

CREATE TABLE dbo.Orders (
	OrderID INT IDENTITY(1,1) NOT NULL,
	CustomersID INT NULL,
	OrderDate DATE NOT NULL,
	Value NUMERIC(18, 2) NOT NULL,
	
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED (OrderID)
)

GO

INSERT INTO dbo.Orders (CustomersID, OrderDate, Value) 
VALUES( 
	 (ABS(CHECKSUM(NEWID())) % 10) + 1 --CustomersID
	,ISNULL(CONVERT(DATE, GETDATE() - (CHECKSUM(NEWID()) / 1000000)), GETDATE() - 10) --OrderDate
	,ISNULL(ABS(CONVERT(NUMERIC(18,2), (CHECKSUM(NEWID()) / 10000000.5))), 0) --Value
);
GO 1000

--------------------------------------------------------------------------------------------------------------
--Em uma nova sessão tente executar a seguinte consulta
--------------------------------------------------------------------------------------------------------------

--clientes que mais compraram em ordem decrescente
SELECT TOP 10
	 a.Name
	,SUM(b.value) AS Amount
FROM [CustomersData].[dbo].[Customers] AS a
INNER JOIN [OrdersData].[dbo].[Orders] AS b
	ON a.CustomersID = b.CustomersID
GROUP BY a.Name
ORDER BY Amount DESC

/*     << ERRO >>
Msg 40515, Level 15, State 1, Line 16
Reference to database and/or server name in 'CustomersData.dbo.Customers' 
is not supported in this version of SQL Server.
*/

SELECT 
	name AS databases
FROM sys.databases 
WHERE name IN ('CustomersData','OrdersData')

--------------------------------------------------------------------------------------------------------------
--Configuração do SQL Database elastic query
--------------------------------------------------------------------------------------------------------------

--Executar no banco de dados [master]
CREATE LOGIN [RemoteLogger] WITH PASSWORD='DataSide123!';

--Necessário acessar o banco de dados de destino [OrdersData]
CREATE USER [RemoteLogger] FOR LOGIN [RemoteLogger];
GRANT SELECT ON [Orders] TO [RemoteLogger];  

--Criando master key no banco de dados de origem [CustomersData]
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Credentials123!'

--Criando credential no banco de dados de origem [CustomersData]
CREATE DATABASE SCOPED CREDENTIAL AppCredential WITH IDENTITY = 'RemoteLogger', SECRET='DataSide123!';
--IDENTITY: Usuário criado no banco de dados de destino, a partir do RemoteLogger SQL Login.
--SECRET: Senha atribuida ao SQL login RemoteLogger

--Criando o external data source para o servidor de destino [OrdersData]
CREATE EXTERNAL DATA SOURCE RemoteDatabase
WITH(
TYPE=RDBMS,
	LOCATION='srvssdp001.database.windows.net', -- Altere o nome do servidor
	DATABASE_NAME='OrdersData',
	CREDENTIAL= AppCredential
);
--          <<Explicação dos parâmetros>>
--TYPE: Quando o external data source for para Azure SQL DB é necessario especificar RDBMS, 
--  	um Sistema de Gerenciamento de Banco de Dados Relacional.
--LOCATION: Permitirá que a fonte de dados externa saiba onde procurar (Necessario informar 
--		o FQDN ou o nome do servidor lógico).
--DATABASE_NAME: Banco de dados que será apontado na fonte de dados externa.
--CREDENTIAL: Necessário mapear a Credencial correta, criada anteriormente como 
--		DATABASE SCOPE CREDENTIAL.

--Criando uma external table no banco de dados [CustomersData]
CREATE EXTERNAL TABLE dbo.Orders (
	OrderID INT NOT NULL,
	CustomersID INT NULL,
	OrderDate DATE NOT NULL,
	Value NUMERIC(18, 2) NOT NULL,
)
WITH (
	DATA_SOURCE  = RemoteDatabase
);
--DATA_SOURCE: Referência da fonte de dados externa criada (external data source) para permitir que o banco de dados saiba onde procurar os dados da tabela

--Executar a query no banco de dados [CustomersData] 
--(Tabela externa [Orders])
SELECT TOP 10
	 a.Name
	,SUM(b.value) AS Amount
FROM [dbo].[Customers] AS a
INNER JOIN [dbo].[Orders] AS b
	ON a.CustomersID = b.CustomersID
GROUP BY a.Name
ORDER BY Amount DESC