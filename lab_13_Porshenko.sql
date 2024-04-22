use TaskTracker

if db_id (N'Users1') is not null
    drop database Users1

if db_id (N'Users2') is not null
    drop database Users2

create database Users1
    on ( name = Users_dat1, filename = '/var/opt/mssql/data/Users_dat1.mdf',
            size = 10, maxsize = unlimited, filegrowth = 5% )
    log on ( name = Users_log1, filename = '/var/opt/mssql/data/Users_log1.ldf',
            size = 5MB, maxsize = 25MB, filegrowth = 5MB )


create database Users2
    on ( name = Users_dat2, filename = '/var/opt/mssql/data/Users_dat2.mdf',
            size = 10, maxsize = unlimited, filegrowth = 5% )
    log on ( name = Users_log1, filename = '/var/opt/mssql/data/Users_log2.ldf',
            size = 5MB, maxsize = 25MB, filegrowth = 5MB )

use Users1

drop table if exists Users

create table Users(
  id int primary key check (id < 6),
  email nvarchar(255) unique not null check (email LIKE '%_@__%.__%'),
  username nvarchar(64) unique not null,
  password varchar(128) not null,
  register_date date not null default GETDATE()
)

insert into Users (id, email, username, password, register_date)
values
(1, N'user1@example.com', N'user1', 'hashed_password1', GETDATE()),
(2, N'user2@example.com', N'user2', 'hashed_password2', GETDATE()),
(3, N'user3@example.com', N'user3', 'hashed_password3', GETDATE());

use Users2

drop table if exists Users

create table Users(
  id int primary key check (id >= 6),
  email nvarchar(255) unique not null check (email LIKE '%_@__%.__%'),
  username nvarchar(64) unique not null,
  password varchar(128) not null,
  register_date date not null default GETDATE()
)

insert into Users (id, email, username, password, register_date)
values
(6, N'user6@example.com', N'user6', 'hashed_password6', GETDATE()),
(7, N'user7@example.com', N'user7', 'hashed_password7', GETDATE()),
(8, N'user8@example.com', N'user8', 'hashed_password8', GETDATE());

drop view if exists Userview

create view Userview as
    select * from Users1.dbo.Users
    union all
    select * from Users2.dbo.Users

select * from Userview

create trigger update_trigger
    on dbo.Userview
    instead of update
as
    begin
        if update(id)
            begin
                raiserror (N'[error]: нельзя обновлять id', 16, 1)
            end
        else
            begin
                update dbo.Userview set
                    email = inserted.email,
                    username = inserted.username,
                    password = inserted.password,
                    register_date = inserted.register_date
                from inserted where inserted.id = dbo.Userview.id
        end
    end

update dbo.Userview
set id = 111 where id = 1

insert into dbo.Userview (id, email, username, password, register_date)
  values
(4, N'user4@example.com', N'user4', 'hashed_password4', GETDATE()),
(5, N'user5@example.com', N'user5', 'hashed_password5', GETDATE()),
(9, N'user9@example.com', N'user9', 'hashed_password9', GETDATE()),
(10, N'user10@example.com', N'user10', 'hashed_password10', GETDATE());

select * from Users1.dbo.Users

select * from Users2.dbo.Users

select * from Userview
