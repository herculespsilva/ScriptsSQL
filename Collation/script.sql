USE [master]
GO

IF EXISTS(SELECT name FROM sys.databASes WHERE name = 'TesteCollation')
	DROP DATABASE TesteCollation

-- CRIANDO BANCO DE DADOS ESPECIFICANDO A COLLATION
CREATE DATABASE [TesteCollation] COLLATE Latin1_General_CI_AI
GO

USE [TesteCollation]
GO

---------------------------------------------------------------------------------------------------------------------------------------------
-- CRIANDO AS TABELAS
---------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE [Clientes] (
	ClienteID INT IDENTITY (1, 1) NOT NULL ,
	Nome VARCHAR (50) NOT NULL ,
	DataNAScimento DATE NULL ,
	Endereco VARCHAR (60) NULL ,
	Cidade VARCHAR (50) NULL ,
	Estado VARCHAR (30) NULL ,
	CEP VARCHAR (15) NULL ,
	Sexo VARCHAR (15) NULL ,

	CONSTRAINT PK_Cliente PRIMARY KEY CLUSTERED (ClienteID),
	CONSTRAINT CK_DataNAScimento CHECK (DataNAScimento < DATEADD(YEAR, -18, GETDATE())),
	CONSTRAINT CK_Sexo CHECK (Sexo = 'masculino' OR Sexo = 'feminino')
)

CREATE TABLE [Pedidos] (
	PedidoID INT IDENTITY (1, 1) NOT NULL ,
	ClienteID INT ,
	DataPedido DATETIME NULL ,
	Valor MONEY NOT NULL , 
	Anotacao TEXT NULL,
	CONSTRAINT PK_Customers PRIMARY KEY  CLUSTERED (PedidoID),
	CONSTRAINT FK_Orders_Employees FOREIGN KEY (ClienteID) REFERENCES dbo.Clientes (ClienteID),
	CONSTRAINT CK_Valor CHECK (Valor > 0) , 
	CONSTRAINT CK_DataPedido CHECK (DataPedido < GETDATE())
)

GO

---------------------------------------------------------------------------------------------------------------------------------------------
-- INSERINDO REGISTROS NAS TABELAS
---------------------------------------------------------------------------------------------------------------------------------------------

SET IDENTITY_INSERT dbo.Clientes ON

INSERT INTO Clientes (ClienteID, Nome, DataNAScimento, Endereco, Cidade, Estado, CEP, Sexo)
VALUES
  (1,'Ignácia P. Wheeler','2000-01-31','P.O. Box 565, 4936 Dictum Av.','Curitiba','Santa Catarina','65775-228','feminino'),
  (2,'Elijah L. Rhodes','1998-07-07','3793 Fusce Rd.','Joinville','Maranhão','58434-181','feminino'),
  (3,'Dale A. Petersen','1970-04-10','743-6778 Libero. Ave','Belém','São Paulo','13359-081','feminino'),
  (4,'NicholAS K. russo','1988-02-20','P.O. Box 140, 5101 Tortor. Street','Jaboatão dos Guararapes','Santa Catarina','11084-132','mASculino'),
  (5,'Zêlenia N. Christensen','1975-05-07','Ap #495-9170 In Rd.','Timon','Maranhão','42715-248','feminino'),
  (6,'Jocelyn F. Clarke','1966-07-06','603-9931 Scelerisque Rd.','Blumenau','Pernambuco','96385-852','feminino'),
  (7,'Iona H. Beard','1990-08-30','410-125 Semper Road','Ipatinga','Paraíba','82469-670','feminino'),
  (8,'Neville Q. Mathis','1991-06-02','520-4542 Est. Road','Caruaru','Paraná','43919-716','feminino'),
  (9,'Lance A. Rutledge','1993-10-30','1018 Est Av.','Gravataí','Paraná','89632-232','mASculino'),
  (10,'Ían M. Maxwell','1982-04-07','Ap #268-4224 Eget, Street','Crato','Rio de Janeiro','89672-987','mASculino'),
  (11,'Rogan M. Johnston','1989-08-22','497-7692 Ullamcorper Street','Anápolis','Rio Grande do Sul','62862-576','mASculino'),
  (12,'Burke E. Christian','1999-07-15','P.O. Box 597, 7067 Et, Road','CAScavel','Rio Grande do Sul','65352-928','mASculino'),
  (13,'Rahim Q. Johnston','1983-01-03','P.O. Box 770, 1478 Nec St.','Caruaru','São Paulo','67277-916','mASculino'),
  (14,'Quinn N. Byrd','1976-09-07','Ap #598-5590 Id, Ave','Paranaguá','Ceará','25915-723','mASculino'),
  (15,'Melyssa M. Gonzales','1988-12-15','556-2784 Blandit Road','Duque de CaxiAS','Paraíba','35727739','feminino'),
  (16,'Fitzgerald L. Delaney','1976-11-04','346-5507 In, Street','Chapecó','Rio de Janeiro','42347-663','feminino'),
  (17,'Melodie Q. Fischer','1995-12-12','P.O. Box 800, 3536 Primis Rd.','Guarapuava','Pará','76711-731','feminino'),
  (18,'Alexander I. Mullins','1988-11-28','206-5603 Ipsum Street','Bragança','Goiás','65115-233','mASculino'),
  (19,'Jorden Y. Peters','1990-02-02','847-2947 Magnis Rd.','Porto Alegre','Goiás','84470-551','mASculino'),
  (20,'Porter R. Ochoa','1960-05-17','Ap #541-2042 Urna. Rd.','Maracanaú','Bahia','58542-408','mASculino')


SET IDENTITY_INSERT dbo.Clientes OFF

GO

SET IDENTITY_INSERT dbo.Pedidos ON

INSERT INTO Pedidos (PedidoID, ClienteID, DataPedido, Valor, Anotacao)
VALUES
  (1,4,'2021-08-14 10:02:43','40.29','Isso é uma anotação de pedido'),
  (2,6,'2022-01-16 15:46:22','49.74','Isso é uma anotação de pedido'),
  (3,9,'2021-01-24 15:45:10','1.09','Isso é uma anotação de pedido'),
  (4,11,'2021-03-03 05:30:10','26.62','Isso é uma anotação de pedido'),
  (5,11,'2021-09-05 19:14:57','45.09','Isso é uma anotação de pedido'),
  (6,12,'2021-02-10 22:30:21','37.48','Isso é uma anotação de pedido'),
  (7,10,'2021-04-25 17:46:50','20.04','Isso é uma anotação de pedido'),
  (8,14,'2021-02-15 16:53:41','41.78','Isso é uma anotação de pedido'),
  (9,18,'2021-07-16 20:35:18','21.47','Isso é uma anotação de pedido'),
  (10,10,'2021-01-16 04:07:34','8.69','Isso é uma anotação de pedido'),
  (11,6,'2022-01-31 05:04:45','9.70','Isso é uma anotação de pedido'),
  (12,9,'2021-08-25 14:59:53','15.20','Isso é uma anotação de pedido'),
  (13,18,'2022-01-26 12:34:30','17.66','Isso é uma anotação de pedido'),
  (14,3,'2021-01-05 20:49:14','46.74','Isso é uma anotação de pedido'),
  (15,1,'2021-07-10 08:37:34','14.19','Isso é uma anotação de pedido'),
  (16,6,'2021-01-13 21:47:54','6.75','Isso é uma anotação de pedido'),
  (17,10,'2021-12-27 04:09:49','46.53','Isso é uma anotação de pedido'),
  (18,18,'2021-11-16 00:20:17','16.14','Isso é uma anotação de pedido'),
  (19,1,'2022-03-04 18:53:56','43.80','Isso é uma anotação de pedido'),
  (20,7,'2021-12-19 05:53:41','33.61','Isso é uma anotação de pedido'),
  (21,5,'2021-05-02 22:47:12','39.99','Isso é uma anotação de pedido'),
  (22,8,'2021-05-16 18:57:08','34.44','Isso é uma anotação de pedido'),
  (23,4,'2021-08-25 04:33:59','46.44','Isso é uma anotação de pedido'),
  (24,4,'2022-02-27 17:15:43','35.40','Isso é uma anotação de pedido'),
  (25,4,'2021-10-28 07:35:27','16.82','Isso é uma anotação de pedido'),
  (26,19,'2021-02-20 23:42:10','49.73','Isso é uma anotação de pedido'),
  (27,14,'2021-03-26 20:23:15','37.95','Isso é uma anotação de pedido'),
  (28,14,'2022-02-10 23:56:22','47.13','Isso é uma anotação de pedido'),
  (29,16,'2021-05-14 13:50:30','5.00','Isso é uma anotação de pedido'),
  (30,3,'2021-10-27 14:57:47','10.48','Isso é uma anotação de pedido'),
  (31,8,'2021-08-12 06:58:29','38.20','Isso é uma anotação de pedido'),
  (32,18,'2021-05-20 06:34:03','22.83','Isso é uma anotação de pedido'),
  (33,15,'2021-10-19 17:57:58','33.75','Isso é uma anotação de pedido'),
  (34,12,'2021-02-26 04:21:54','7.86','Isso é uma anotação de pedido'),
  (35,11,'2022-03-01 07:10:13','35.76','Isso é uma anotação de pedido'),
  (36,13,'2021-05-03 08:29:59','35.92','Isso é uma anotação de pedido'),
  (37,15,'2021-11-07 08:04:02','48.69','Isso é uma anotação de pedido'),
  (38,8,'2022-02-18 02:28:36','8.99','Isso é uma anotação de pedido'),
  (39,6,'2021-12-02 19:45:32','8.13','Isso é uma anotação de pedido'),
  (40,8,'2021-09-12 13:04:52','7.36','Isso é uma anotação de pedido'),
  (41,17,'2021-08-20 06:25:36','25.19','Isso é uma anotação de pedido'),
  (42,5,'2021-05-02 02:27:40','43.81','Isso é uma anotação de pedido'),
  (43,12,'2021-08-31 13:15:42','39.94','Isso é uma anotação de pedido'),
  (44,20,'2021-02-08 19:53:40','13.77','Isso é uma anotação de pedido'),
  (45,7,'2021-06-27 21:48:56','25.17','Isso é uma anotação de pedido'),
  (46,18,'2022-02-04 10:26:57','3.75','Isso é uma anotação de pedido'),
  (47,19,'2021-09-26 07:19:06','12.79','Isso é uma anotação de pedido'),
  (48,5,'2021-04-24 14:11:17','11.28','Isso é uma anotação de pedido'),
  (49,4,'2021-01-22 04:23:30','43.97','Isso é uma anotação de pedido'),
  (50,18,'2022-03-15 09:44:00','37.68','Isso é uma anotação de pedido')


SET IDENTITY_INSERT dbo.Pedidos OFF

-- criando indice
CREATE NONCLUSTERED INDEX idx_01 ON Clientes(Nome) INCLUDE (DataNAScimento, Endereco)

-- validando os dados
SELECT * FROM Clientes

SELECT * FROM Pedidos

-- buscando cliente que tenha seu primeiro nome Zelenia
SELECT * FROM Clientes WHERE Nome LIKE 'Zelenia%'

GO

---------------------------------------------------------------------------------------------------------------------------------------------
-- ALTERANDO A COLLATE DA DATABASE (SERA RETORNADO ERRO)
---------------------------------------------------------------------------------------------------------------------------------------------

USE master
GO

ALTER DATABASE TesteCollation SET SINGLE_USER WITH ROLLBACK IMMEDIATE

ALTER DATABASE TesteCollation COLLATE SQL_Latin1_General_CP1_CI_AS

ALTER DATABASE TesteCollation SET MULTI_USER 

--Msg 5075, Level 16, State 1, Line 152
--The object 'CK_DataNascimento' is dependent on database collation. The database collation cannot be changed if a schema-bound object depends on it. Remove the dependencies on the database collation and then retry the operation.
--Msg 5075, Level 16, State 1, Line 152
--The object 'CK_Sexo' is dependent on database collation. The database collation cannot be changed if a schema-bound object depends on it. Remove the dependencies on the database collation and then retry the operation.
--Msg 5075, Level 16, State 1, Line 152
--The object 'CK_Valor' is dependent on database collation. The database collation cannot be changed if a schema-bound object depends on it. Remove the dependencies on the database collation and then retry the operation.
--Msg 5075, Level 16, State 1, Line 152
--The object 'CK_DataPedido' is dependent on database collation. The database collation cannot be changed if a schema-bound object depends on it. Remove the dependencies on the database collation and then retry the operation.
--Msg 5072, Level 16, State 1, Line 152
--ALTER DATABASE failed. The default collation of database 'TesteCollation' cannot be set to SQL_Latin1_General_CP1_CI_AS.

GO

---------------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICANDO AS CONSTRAINTS DO BANCO DE DADOS
---------------------------------------------------------------------------------------------------------------------------------------------

USE TesteCollation
GO

SELECT * FROM sys.objects WHERE name = 'CK_DataNAScimento'

SELECT * FROM sys.check_constraints

---------------------------------------------------------------------------------------------------------------------------------------------
-- APAGAR TODAS AS CONSTRAINTS DO TIPO CHECK NO BANCO DE DADOS 
---------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	 QUOTENAME(con.[name]) AS constraint_name
    ,QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.[name])  AS [table]
    ,col.[name] AS column_name
    ,con.[definition]
	,con.is_disabled AS [status]
	,'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.[name]) + ' DROP CONSTRAINT ' + QUOTENAME(con.[name]) AS [DROP_COMMAND]
	,'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.[name]) + ' ADD CONSTRAINT ' + QUOTENAME(con.[name]) + ' CHECK ' + con.[definition] AS [CREATE_COMMAND]
FROM sys.check_constraints AS con
    LEFT OUTER JOIN sys.objects AS t
        ON con.parent_object_id = t.object_id
    LEFT OUTER JOIN sys.all_columns AS col
        ON con.parent_column_id = col.column_id
        and con.parent_object_id = col.object_id
	--where con.[name] = ''
ORDER BY con.name

ALTER TABLE [dbo].[Clientes] DROP CONSTRAINT [CK_DataNascimento]
ALTER TABLE [dbo].[Pedidos] DROP CONSTRAINT [CK_DataPedido]
ALTER TABLE [dbo].[Clientes] DROP CONSTRAINT [CK_Sexo]
ALTER TABLE [dbo].[Pedidos] DROP CONSTRAINT [CK_Valor]

---------------------------------------------------------------------------------------------------------------------------------------------
-- ALTERANDO A COLLATE DA DATABASE (SERA RETORNADO SUCESSO)
---------------------------------------------------------------------------------------------------------------------------------------------

USE master
GO

ALTER DATABASE TesteCollation SET SINGLE_USER WITH ROLLBACK IMMEDIATE

ALTER DATABASE TesteCollation COLLATE SQL_Latin1_General_CP1_CI_AS

ALTER DATABASE TesteCollation SET MULTI_USER 

--CRIANDO CONSTRAINTS NOVAMENTE
USE TesteCollation
GO
ALTER TABLE [dbo].[Clientes] ADD CONSTRAINT [CK_DataNAScimento] CHECK ([DataNAScimento]<dateadd(year,(-18),getdate()))
ALTER TABLE [dbo].[Pedidos] ADD CONSTRAINT [CK_DataPedido] CHECK ([DataPedido]<getdate())
ALTER TABLE [dbo].[Clientes] ADD CONSTRAINT [CK_Sexo] CHECK ([Sexo]='masculino' OR [Sexo]='feminino')
ALTER TABLE [dbo].[Pedidos] ADD CONSTRAINT [CK_Valor] CHECK ([Valor]>(0))

---------------------------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO APOS ALTERACAO DA COLLATION
---------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM Clientes WHERE Nome LIKE 'Zelenia%'

SELECT name, collation_name FROM sys.databases WHERE name = 'TesteCollation'

---------------------------------------------------------------------------------------------------------------------------------------------
-- VALIDANDO COLUMN COLLATE
---------------------------------------------------------------------------------------------------------------------------------------------

EXEC sp_help Clientes -- Ctrl + F1

---------------------------------------------------------------------------------------------------------------------------------------------
-- ALTERANDO COLLATE DAS COLUNAS
---------------------------------------------------------------------------------------------------------------------------------------------

-- 1º Dropando as contraints CHECK associada a colunas do tipo caractere
ALTER TABLE [dbo].[Clientes] DROP CONSTRAINT [CK_Sexo]

-- 2º Dropando os índices associada a colunas do tipo caractere
DROP INDEX [idx_01] ON [dbo].[Clientes]
 
-- 3º Alterando a tabela (colunas)
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [Nome] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [Endereco] VARCHAR(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [Cidade] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [Estado] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [CEP] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Clientes] ALTER COLUMN [Sexo] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Pedidos]	 ALTER COLUMN [Anotacao] TEXT COLLATE SQL_Latin1_General_CP1_CI_AS NULL

-- 4º Recriando as constraints CHECK
ALTER TABLE [dbo].[Clientes] ADD CONSTRAINT [CK_Sexo] CHECK ([Sexo]='masculino' OR [Sexo]='feminino')

-- 5º Recriando os índices
CREATE NONCLUSTERED INDEX idx_01 ON Clientes(Nome) INCLUDE (DataNAScimento, Endereco)


---------------------------------------------------------------------------------------------------------------------------------------------
-- VALIDANDO ALTERAÇAO
---------------------------------------------------------------------------------------------------------------------------------------------

USE TesteCollation
GO

SELECT * FROM Clientes WHERE Nome LIKE 'Zelenia%'
