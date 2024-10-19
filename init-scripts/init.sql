IF EXISTS (SELECT * FROM sys.databases WHERE name = 'bargerdev')
BEGIN
    DROP DATABASE bargerdev;
END

CREATE DATABASE bargerdev;
GO

USE bargerdev;
GO

CREATE TABLE [role]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [title] NVARCHAR(100) NOT NULL
);

CREATE TABLE [user]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [email] NVARCHAR(100) NOT NULL,
    [firstname] NVARCHAR(100) NOT NULL,
    [surname] NVARCHAR(100) NOT NULL,
    [patronymic] NVARCHAR(100) NOT NULL,
    [password_hash] BINARY(64) NOT NULL,
    [role] UNIQUEIDENTIFIER NOT NULL,
    [blocked] BIT NOT NULL DEFAULT(0),
    FOREIGN KEY ([role]) REFERENCES [role] ([id])
);

CREATE TABLE [image]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [title] NVARCHAR(200) NOT NULL,
    [path] NVARCHAR(200) NOT NULL,
    [create_date] DATETIME2 NOT NULL,
    [edit_date] DATETIME2 NULL
);

CREATE TABLE [external_application]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [title] NVARCHAR(100) NOT NULL,
    [integration_key] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID())
);

CREATE TABLE [database_table]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [title] NVARCHAR(100) NOT NULL,
    [system_name] NVARCHAR(100) NOT NULL
);

CREATE TABLE [database_column]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [database_table] UNIQUEIDENTIFIER NOT NULL,
    [title] NVARCHAR(100) NOT NULL,
    [system_name] NVARCHAR(100) NOT NULL,
    [data_type] INT NOT NULL,
    [default_value] NVARCHAR(100) NULL,
    [required] BIT NOT NULL DEFAULT(0),
    [indexed] BIT NOT NULL DEFAULT(0),
    [editable] BIT NOT NULL DEFAULT(0),
    FOREIGN KEY ([database_table]) REFERENCES [database_table] ([id])
);  

CREATE TABLE [database_relation]
(
    [id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
    [relation_type] INT NOT NULL,
    [source_table] UNIQUEIDENTIFIER NOT NULL,
    [target_table] UNIQUEIDENTIFIER NOT NULL,
    [source_key_column] UNIQUEIDENTIFIER NOT NULL,
    [target_key_column] UNIQUEIDENTIFIER NOT NULL,
    FOREIGN KEY ([source_table]) REFERENCES [database_table] ([id]),
    FOREIGN KEY ([target_table]) REFERENCES [database_table] ([id]),
    FOREIGN KEY ([source_key_column]) REFERENCES [database_column] ([id]),
    FOREIGN KEY ([target_key_column]) REFERENCES [database_column] ([id])
);

CREATE TABLE [database_table_role]
(
	[database_table] UNIQUEIDENTIFIER NOT NULL,
	[role] UNIQUEIDENTIFIER NOT NULL,
	FOREIGN KEY ([database_table]) REFERENCES [dbo].[database_table] ([id]),
	FOREIGN KEY ([role]) REFERENCES [dbo].[role] ([id])
);

CREATE TABLE [trigger]
(
	[id] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()) PRIMARY KEY,
	[title] NVARCHAR(100) NOT NULL,
	[database_table] UNIQUEIDENTIFIER NOT NULL,
	[event] INT NOT NULL,
	[service_end_point] NVARCHAR(200) NOT NULL,
	FOREIGN KEY ([database_table]) REFERENCES [database_table] ([id])
);