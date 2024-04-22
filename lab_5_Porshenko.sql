use master

IF DB_ID(N'TaskTracker') is not null drop DATABASE TaskTracker

CREATE DATABASE TaskTracker
ON (
    NAME = TaskTrackerDat,
    FILENAME = '/var/opt/mssql/data/TaskTrackerDat.mdf',
    SIZE = 10,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5%
)
LOG ON (
    NAME = TaskTrackerLog,
    FILENAME = '/var/opt/mssql/data/TaskTrackerLog.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB
)
GO

USE TaskTracker

CREATE TABLE [User]
(
    email varchar(255),
    username varchar(64),
    password varchar(128),
    register_date date
)

USE TaskTracker

ALTER DATABASE TaskTracker
ADD FILEGROUP TestGroup;

ALTER DATABASE TaskTracker
ADD FILE
(
    NAME = testFile1,
    FILENAME = '/var/opt/mssql/data/testFile1.ldf'
),
(
    NAME = testFile2,
    FILENAME = '/var/opt/mssql/data/testFile2.ldf'
)
TO FILEGROUP TestGroup;


ALTER DATABASE TaskTracker
MODIFY FILEGROUP TestGroup DEFAULT;

CREATE TABLE [User2]
(
    email varchar(255),
    username varchar(64),
    password varchar(128),
    register_date date
)

GO

-- saving table to history before dropping
ALTER DATABASE TaskTracker
ADD FILEGROUP HISTORY;
ALTER DATABASE TaskTracker
ADD FILE
(
    NAME = historyData,
    FILENAME = '/var/opt/mssql/data/historyData.mdf'
)
TO FILEGROUP HISTORY;

CREATE TABLE UserHistory
(
    email varchar(255),
    username varchar(64),
    password varchar(128),
    register_date date
)

SELECT * INTO UserHistory ON HISTORY FROM User2
-- end saving

DROP TABLE User2;

ALTER DATABASE TaskTracker
MODIFY FILEGROUP [PRIMARY] DEFAULT;
ALTER DATABASE TaskTracker
REMOVE FILE testFile1;
ALTER DATABASE TaskTracker
REMOVE FILE testFile2;

ALTER DATABASE TaskTracker
REMOVE FILEGROUP TestGroup

GO

CREATE SCHEMA TestSchema
-- CREATE TABLE [User]
-- (
--     email varchar(255),
--     username varchar(64),
--     password varchar(128),
--     register_date date
-- )
ALTER SCHEMA TestSchema TRANSFER dbo.[User]

GO

DROP TABLE TestSchema.[User]
DROP SCHEMA TestSchema;
