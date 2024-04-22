USE TaskTracker


DROP TABLE IF EXISTS [User]
DROP TABLE IF EXISTS TaskGroup
DROP TABLE IF EXISTS Task

DROP SEQUENCE IF EXISTS task_id_sequence

-- 1, 2
CREATE TABLE [User](
    user_id INT PRIMARY KEY IDENTITY(1, 1),
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email LIKE '%_@__%.__%'),
    username VARCHAR(64) UNIQUE NOT NULL,
    password VARCHAR(128) NOT NULL,
    register_date DATE DEFAULT '2023-10-31'
)

INSERT INTO [User] VALUES
    ('abacaba@mail.ru', 'some_user', '12345', '2023-10-25'),
    ('a@mail.ru', 'se', '12345', '2023-10-26')

SELECT IDENT_CURRENT('User') -- ограничена только таблицей
SELECT SCOPE_IDENTITY() -- ограничена сеансом
SELECT @@IDENTITY -- связана с применением триггеров и ограничена сеансом

SELECT * FROM [User]

-- 3
CREATE TABLE TaskGroup(
    group_id UNIQUEIDENTIFIER ROWGUIDCOL DEFAULT NEWID(),
    name VARCHAR(128) NOT NULL,
    description VARCHAR(MAX),
    creation_datetime DATETIME
)

INSERT INTO TaskGroup VALUES
                          (DEFAULT, 'task_group_name', 'description...', '2016-12-21 00:00:00.000')

SELECT * FROM TaskGroup

-- 4
CREATE SEQUENCE task_id_sequence
    START WITH 1
    INCREMENT BY 2
CREATE TABLE Task(
    id INT PRIMARY KEY DEFAULT NEXT VALUE FOR task_id_sequence,
    name VARCHAR(128) NOT NULL,
    description_text VARCHAR(MAX),
    description_photo VARCHAR(255), -- URL
    estimated_time INT,
    creation_datetime DATETIME NOT NULL
)

INSERT INTO Task VALUES
                     (DEFAULT, 'task1', 'descr', 'https://ya.ru/img', 2, '2016-12-21 00:00:00.000'),
                     (DEFAULT, 'task2', 'descr2', 'https://ya.ru/img', 10, '2016-12-21 00:00:00.000')

SELECT * FROM Task

-- 5
DROP TABLE IF EXISTS TaskGroup
DROP TABLE IF EXISTS [User]

CREATE TABLE [User](
    user_id INT PRIMARY KEY IDENTITY(1, 1),
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email LIKE '%_@__%.__%'),
    username VARCHAR(64) UNIQUE NOT NULL,
    password VARCHAR(128) NOT NULL,
    register_date DATE DEFAULT '2023-10-31'
)

CREATE TABLE TaskGroup(
    group_id UNIQUEIDENTIFIER ROWGUIDCOL DEFAULT NEWID(),
    creator_id INT NOT NULL FOREIGN KEY REFERENCES [User](user_id) ON DELETE CASCADE ON UPDATE SET NULL,
    name VARCHAR(128) NOT NULL,
    description VARCHAR(MAX),
    creation_datetime DATETIME
)

INSERT INTO [User] VALUES
    ('abacaba@mail.ru', 'some_user', '12345', '2023-10-25'),
    ('a@mail.ru', 'se', '12345', '2023-10-26')

INSERT INTO TaskGroup VALUES
                          (DEFAULT, 1, 'task_group_name', 'description...', '2016-12-21 00:00:00.000')

DELETE FROM [User] WHERE user_id = 1 -- ON DELETE CASCADE - удалится дочерняя запись, NO ACTION - conflict, SET NULL - error
UPDATE [User] SET user_id = 3 WHERE user_id = 1 -- ON UPDATE CASCADE - обновится fk, NO ACTION - error, SET NULL - error при объявлении, SET DEFAULT - error при объявлении

DROP TABLE IF EXISTS TaskGroup
DROP TABLE IF EXISTS [User]

GO