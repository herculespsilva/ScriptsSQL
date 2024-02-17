-- Criação do banco de dados 
--------------------------------------------------------------------------------------------------------------------------------
USE [master]
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'db_clientes')
BEGIN
	ALTER DATABASE [db_clientes] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [db_clientes]
END

GO

CREATE DATABASE [db_clientes]

GO

USE [db_clientes]
GO

DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS cliente;

CREATE TABLE cliente (
	id_cliente INT IDENTITY(1,1),
	nome VARCHAR(50),
	sobrenome VARCHAR(50),
	sexo CHAR(1),
	cpf CHAR(14),
	dt_nascimento DATE,
	email VARCHAR(100),

	CONSTRAINT PK_cliente PRIMARY KEY (id_cliente),
	CONSTRAINT CK_cliente_sexo CHECK (sexo = 'M' OR sexo = 'F' ),
	CONSTRAINT UQ_cliente_CPF UNIQUE (cpf)
);

CREATE TABLE pedido (
	id_pedido INT IDENTITY(1,1),
	valor NUMERIC(12,2),
	[data] DATETIME CONSTRAINT DF_pedido_data DEFAULT GETDATE(),
	id_cliente INT,

	CONSTRAINT PK_pedido PRIMARY KEY (id_pedido),
	CONSTRAINT FK_pedido_cliente_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

GO

-- Inserir dados com nomes, sobrenomes, datas de nascimento e e-mails fictícios com domínios aleatórios
INSERT INTO cliente (nome, sobrenome, sexo, cpf, dt_nascimento, email)
VALUES
    ('Hércules', 'Pereira', 'M', '123.456.789-09', '1998-01-06', 'hercules.pereira@outlook.com'),
    ('João', 'Silva', 'M', '234.567.890-12', '1985-05-15', 'joao.silva@gmail.com'),
    ('Maria', 'Santos', 'F', '345.678.901-23', '1988-09-20', 'maria.santos@hotmail.com'),
    ('Pedro', 'Ferreira', 'M', '456.789.012-34', '1992-03-10', 'pedro.ferreira@outlook.com'),
    ('Ana', 'Ribeiro', 'F', '567.890.123-45', '1987-11-25', 'ana.ribeiro@gmail.com'),
    ('Lara', 'Martins', 'F', '678.901.234-56', '1995-07-08', 'lara.martins@hotmail.com'),
    ('Rafael', 'Almeida', 'M', '789.012.345-67', '1993-02-18', 'rafael.almeida@outlook.com'),
    ('Carolina', 'Gomes', 'F', '890.123.456-78', '1986-06-30', 'carolina.gomes@gmail.com'),
    ('Fernando', 'Pereira', 'M', '901.234.567-89', '1998-12-03', 'fernando.pereira@hotmail.com'),
    ('Julia', 'Rodrigues', 'F', '012.345.678-90', '1989-04-14', 'julia.rodrigues@outlook.com'),
    ('Gabriel', 'Lima', 'M', '123.456.789-10', '1994-10-22', 'gabriel.lima@gmail.com'),
    ('Sophia', 'Cruz', 'F', '234.567.890-23', '1991-08-05', 'sophia.cruz@hotmail.com'),
    ('Arthur', 'Vieira', 'M', '345.678.901-45', '1984-09-17', 'arthur.vieira@outlook.com'),
    ('Isabella', 'Carvalho', 'F', '456.789.012-67', '1996-01-28', 'isabella.carvalho@gmail.com'),
    ('Enzo', 'Nascimento', 'M', '567.890.123-89', '1997-06-09', 'enzo.nascimento@hotmail.com'),
    ('Valentina', 'Pinto', 'F', '678.901.234-01', '1983-12-11', 'valentina.pinto@outlook.com'),
    ('Daniel', 'Machado', 'M', '789.012.345-12', '1982-02-26', 'daniel.machado@gmail.com'),
    ('Mariana', 'Sousa', 'F', '890.123.456-23', '1999-04-19', 'mariana.sousa@hotmail.com'),
    ('Luiz', 'Rocha', 'M', '901.234.567-34', '1980-07-31', 'luiz.rocha@outlook.com'),
    ('Giovanna', 'Barbosa', 'F', '012.345.678-45', '1981-11-07', 'giovanna.barbosa@gmail.com'),
    ('Lucas', 'Pereira', 'M', '123.456.789-56', '1992-03-10', 'lucas.pereira@hotmail.com'),
    ('Ana', 'Santos', 'F', '234.567.890-67', '1987-11-25', 'ana.santos@outlook.com'),
    ('Paulo', 'Ferreira', 'M', '345.678.901-78', '1994-10-22', 'paulo.ferreira@gmail.com'),
    ('Isabela', 'Martins', 'F', '456.789.012-89', '1991-08-05', 'isabela.martins@hotmail.com'),
    ('Rafael', 'Oliveira', 'M', '567.890.123-90', '1984-09-17', 'rafael.oliveira@outlook.com'),
    ('Sophia', 'Pereira', 'F', '678.901.234-02', '1996-01-28', 'sophia.pereira@gmail.com'),
    ('Mateus', 'Rodrigues', 'M', '789.012.345-08', '1997-06-09', 'mateus.rodrigues@hotmail.com'),
    ('Larissa', 'Costa', 'F', '890.123.456-01', '1983-12-11', 'larissa.costa@outlook.com'),
    ('Fernando', 'Gomes', 'M', '901.234.567-32', '1982-02-26', 'fernando.gomes@gmail.com'),
    ('Luiza', 'Almeida', 'F', '012.345.678-40', '1999-04-19', 'luiza.almeida@hotmail.com'),
    ('Henrique', 'Ribeiro', 'M', '123.456.789-67', '1986-06-30', 'henrique.ribeiro@outlook.com'),
    ('Thiago', 'Machado', 'M', '234.567.890-78', '1998-12-03', 'thiago.machado@hotmail.com'),
    ('Manuela', 'Cunha', 'F', '345.678.901-89', '1989-04-14', 'manuela.cunha@outlook.com'),
    ('Eduardo', 'Lima', 'M', '456.789.012-01', '1980-07-31', 'eduardo.lima@gmail.com'),
    ('Gabriela', 'Fernandes', 'F', '567.890.123-12', '1999-04-19', 'gabriela.fernandes@hotmail.com'),
    ('Daniel', 'Pinto', 'M', '678.901.234-23', '1992-03-10', 'daniel.pinto@outlook.com'),
    ('Lívia', 'Ramos', 'F', '789.012.345-34', '1994-10-22', 'livia.ramos@gmail.com'),
    ('Marcos', 'Correia', 'M', '890.123.456-45', '1991-08-05', 'marcos.correia@hotmail.com'),
    ('Carolina', 'Vieira', 'F', '901.234.567-56', '1984-09-17', 'carolina.vieira@outlook.com'),
    ('Ricardo', 'Oliveira', 'M', '012.345.678-67', '1996-01-28', 'ricardo.oliveira@gmail.com'),
    ('Amanda', 'Martins', 'F', '123.456.789-78', '1997-06-09', 'amanda.martins@hotmail.com'),
    ('José', 'Santos', 'M', '234.567.890-89', '1983-12-11', 'jose.santos@outlook.com'),
    ('Fernanda', 'Costa', 'F', '345.678.901-90', '1982-02-26', 'fernanda.costa@gmail.com'),
    ('Roberto', 'Gomes', 'M', '456.789.012-10', '1999-04-19', 'roberto.gomes@hotmail.com'),
    ('Laura', 'Almeida', 'F', '567.890.123-11', '1986-06-30', 'laura.almeida@outlook.com'),
    ('Alex', 'Ribeiro', 'M', '678.901.234-12', '1987-11-25', 'alex.ribeiro@gmail.com'),
    ('Aline', 'Nascimento', 'F', '789.012.345-13', '1994-10-22', 'aline.nascimento@hotmail.com'),
    ('Vinícius', 'Pereira', 'M', '890.123.456-14', '1991-08-05', 'vinicius.pereira@outlook.com'),
    ('Camila', 'Rodrigues', 'F', '901.234.567-15', '1984-09-17', 'camila.rodrigues@gmail.com'),
    ('Luciano', 'Silva', 'M', '012.345.678-16', '1996-01-28', 'luciano.silva@hotmail.com'),
    ('Beatriz', 'Ferreira', 'F', '123.456.789-17', '1997-06-09', 'beatriz.ferreira@outlook.com'),
    ('Raphael', 'Carvalho', 'M', '234.567.890-18', '1983-12-11', 'raphael.carvalho@gmail.com'),
    ('Renata', 'Martins', 'F', '345.678.901-19', '1982-02-26', 'renata.martins@hotmail.com'),
    ('Carlos', 'Oliveira', 'M', '456.789.012-20', '1999-04-19', 'carlos.oliveira@outlook.com'),
    ('Larissa', 'Cruz', 'F', '567.890.123-21', '1986-06-30', 'larissa.cruz@gmail.com'),
    ('Leandro', 'Sousa', 'M', '678.901.234-22', '1987-11-25', 'leandro.sousa@hotmail.com'),
    ('Tatiane', 'Rocha', 'F', '789.012.345-23', '1994-10-22', 'tatiane.rocha@outlook.com'),
    ('Felipe', 'Barbosa', 'M', '890.123.456-24', '1991-08-05', 'felipe.barbosa@gmail.com'),
    ('Nathalia', 'Pereira', 'F', '901.234.567-25', '1984-09-17', 'nathalia.pereira@hotmail.com'),
    ('Bruno', 'Silva', 'M', '012.345.678-26', '1996-01-28', 'bruno.silva@outlook.com');
GO

INSERT INTO pedido (valor, data, id_cliente)
VALUES 
	( 
		 (ABS(CHECKSUM(NEWID())) % 1000) + 1
		,(DATEADD(DAY, ((ABS(CHECKSUM(NEWID())) % 3000) + 1) * -1, GETDATE()))
		,(ABS(CHECKSUM(NEWID())) % 40) + 1
	)
GO 50000

--VALIDACAO DOS DADOS INSERIDOS
SELECT * FROM cliente	-- 60 REGISTROS
SELECT * FROM pedido	-- 50.000 MIL REGISTROS