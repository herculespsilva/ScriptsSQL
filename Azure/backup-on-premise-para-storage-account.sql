USE [CustomersData]
GO

--SELECT * FROM sys.key_encryptions
--DROP MASTER KEY;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Senh@Forte';

IF EXISTS (SELECT * FROM sys.database_credentials WHERE name = 'https://storssdpacc001.blob.core.windows.net/backup')
BEGIN
	DROP DATABASE SCOPED CREDENTIAL [https://storssdpacc001.blob.core.windows.net/backup];
END

CREATE DATABASE SCOPED CREDENTIAL [https://storssdpacc001.blob.core.windows.net/backup]
WITH IDENTITY = 'Shared Access Signature',
SECRET = 'sv=2021-12-02&sr=c&sig=qZKrdTy1ZlcnOjk5jX9OetDXUdZDzxAkSWpB7ZyjREY%3D' --SAS token

BACKUP DATABASE [CustomersData]
TO URL = 'https://storssdpacc001.blob.core.windows.net/backup/backup_FULL_CustomersData.bak'
WITH STATS = 10, COMPRESSION, CHECKSUM
