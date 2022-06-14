
-------------------------------------------------------------------------
-- Row Level Security (RLS) with Opt-in Opt-out
-------------------------------------------------------------------------

--apagando objetos e usuarios
DROP USER IF EXISTS app;
DROP USER IF EXISTS admin;
DROP USER IF EXISTS Sales1;
DROP USER IF EXISTS Sales2;

DROP SECURITY POLICY IF EXISTS CustomerFilter;
DROP FUNCTION IF EXISTS Security.fn_securitypredicateCutomer;
DROP SCHEMA IF EXISTS Security;
DROP TABLE IF EXISTS Flag_historico
DROP TABLE IF EXISTS Customers

--Criando usuarios no contexto da database
CREATE USER app WITHOUT LOGIN; 
CREATE USER admin WITHOUT LOGIN;  
CREATE USER sales1 WITHOUT LOGIN;  
CREATE USER sales2 WITHOUT LOGIN;  

GO

--criando tabela
CREATE TABLE Customers (
	CustomerID INT IDENTITY (1, 1) PRIMARY KEY,
	Name VARCHAR (40) NOT NULL ,
	Address VARCHAR (60) NULL ,
	City VARCHAR (50) NULL ,
	Region VARCHAR (30) NULL ,
	PostalCode VARCHAR (10) NULL ,
	Phone VARCHAR (24) NULL
)

SET IDENTITY_INSERT dbo.Customers ON

GO

--insercao de dados (Total de 10 linhas)
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(1,'Roanna U. Bell','283-4505 Adipiscing St.','Ribeirão Preto','São Paulo','19770-781','(98)81910-2521');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(2,'Slade Reilly','9003 Dictum Rd.','Parauapebas','Pará','66490-419','(87)56648-1370');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(3,'Steel D. Porter','940-4233 Convallis Street','Ribeirão Preto','SP','12473-483','(97)21103-2706');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(4,'Holmes Mckee','P.O. Box 282, 7869 Sit Rd.','Santa Luzia','MG','37033227','(19)38022-9247');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(5,'Brody A. Mcguire','Ap #121-8653 Cras Av.','Camaçari','BA','46453-236','(99)54389-6116');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(6,'Madison B. Hoffman','Ap #354-6530 Quisque St.','Santa Inês','MA','65228-313','(43)43943-6604');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(7,'Elaine B. Summers','478-7077 Sit Road','Diadema','SP','19605-607','(44)86134-1051');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(8,'Xandra Q. Mcintosh','1209 Ligula Ave','Camaragibe','Pernambuco','50495-178','(41)32326-0733');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(9,'Akeem Graves','Ap #905-4585 Ut Avenue','Carapicuíba','São Paulo','18343-742','(62)35326-8860');
INSERT INTO dbo.Customers([CustomerID],[Name],[Address],[City],[Region],[PostalCode],[Phone]) VALUES(10,'Wesley Dillard','P.O. Box 836, 304 Nibh St.','Niterói','RJ','23145-301','(95)36619-4902');

SELECT * FROM dbo.Customers

GO

--concedendo permissoes de leitura na tabela
GRANT SELECT ON dbo.Customers TO app;  
GRANT SELECT ON dbo.Customers TO admin;  
GRANT SELECT ON dbo.Customers TO Sales1; 
GRANT SELECT ON dbo.Customers TO Sales2; 

GO

ALTER TABLE Customers ADD flag BIT DEFAULT 1 NOT NULL

GO

CREATE SCHEMA Security;  

GO 

-- criação da função com valor de tabela Customer
CREATE FUNCTION Security.fn_securitypredicateCutomer(@flag int)  
    RETURNS TABLE  
WITH SCHEMABINDING
AS  -- retorna 1 quando verdadeiro
    RETURN SELECT 1 AS fn_securitypredicate_result
	WHERE @flag = 1
	OR USER_NAME() IN ('admin')
GO

-- criacao da politica de segurança (RLS) com a função, como predicado
CREATE SECURITY POLICY CustomerFilter  
ADD FILTER PREDICATE Security.fn_securitypredicateCutomer(flag)
ON dbo.Customers
WITH (STATE = ON);

GO

--concedendo permissao de leitura para todos os usuarios
GRANT SELECT ON Security.fn_securitypredicateCutomer TO app;  
GRANT SELECT ON Security.fn_securitypredicateCutomer TO admin;  
GRANT SELECT ON Security.fn_securitypredicateCutomer TO Sales1;  
GRANT SELECT ON Security.fn_securitypredicateCutomer TO Sales2;  

GO

--simulando Opt-out (Revogação da autorização de uso dos dados de determinados clientes)
UPDATE dbo.Customers SET flag = 0 WHERE CustomerID IN (1, 3, 7, 9, 10)

GO

EXECUTE AS USER = 'app';  
	SELECT 'app' AS [User], * FROM dbo.Customers;
REVERT;  
  
EXECUTE AS USER = 'admin';  
	SELECT 'admin' AS [User], * FROM dbo.Customers;
REVERT;  

EXECUTE AS USER = 'Sales1';  
	SELECT 'Sales1' AS [User], * FROM dbo.Customers;
REVERT;  

EXECUTE AS USER = 'Sales2';  
	SELECT 'Sales2' AS [User], * FROM dbo.Customers;
REVERT;  

GO

--simulando que foram revogados a autorizacao de todos os clientes
UPDATE dbo.Customers SET flag = 0

GO

EXECUTE AS USER = 'Sales1';  
	SELECT 'Sales1' AS [User], * FROM dbo.Customers;
REVERT;  

EXECUTE AS USER = 'admin';  
	SELECT 'admin' AS [User], * FROM dbo.Customers;
REVERT;  
