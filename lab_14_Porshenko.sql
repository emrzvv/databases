use TaskTracker

if DB_ID('part1') is not null
    drop database part1
if DB_ID('part2') is not null
    drop database part2

create database part1
on (
    name = part1_dat,
    filename = '/var/opt/mssql/data/part1_dat.mdf',
    size = 20,
    maxsize = 50
)
log on (
    name = part1_log,
    filename = '/var/opt/mssql/data/part1_log.ldf',
    size = 5,
    maxsize = 25,
    filegrowth = 5
)


create database part2
on (
    name = part2_dat,
    filename = '/var/opt/mssql/data/part2_dat.mdf',
    size = 20,
    maxsize = 50
)
log on (
    name = part2_log,
    filename = '/var/opt/mssql/data/part2_log.ldf',
    size = 5,
    maxsize = 25,
    filegrowth = 5
)

use part1

drop table if exists part1..Users

create table part1..Users
(
    id int primary key,
    email nvarchar(255) unique not null check (email LIKE '%_@__%.__%'),
)

use part2

drop table if exists part2..Users

create table part2..Users
(
    id int primary key not null,
    username nvarchar(64) unique not null,
    password varchar(128) not null,
    register_date date not null default GETDATE()
)



drop view if exists UserView

create view UserView as
    select part1.id, part1.email, part2.username, part2.password, part2.register_date
    from part1.dbo.Users as part1
         join part2.dbo.Users as part2 on part1.id = part2.id


drop trigger if exists InsertTrigger

create trigger InsertTrigger
    on UserView
    instead of insert
as
    begin
        if exists (select part1.id
                    from part1.dbo.Users as part1
                         join inserted as i on part1.id = i.id)
           or exists (select part1.email
                         from part1.dbo.Users as part1
                              join inserted as i on part1.email = i.email)
            begin
                raiserror(N'[error]: Запрещена вставка строк с одинаковыми значениями email или id', 16, 1)
            end
        else
            begin
                insert into part1.dbo.Users (id, email)
                select id, email from inserted

                insert into part2.dbo.Users (id, username, password, register_date)
                select id, name, surname, GETDATE() from inserted
            end
    end

insert UserView (id, email, username, password, register_date) 
values
    (1, 'user1@example.com', 'user1', 'hashed_password1', GETDATE()),
    (2, 'user2@example.com', 'user2', 'hashed_password2', GETDATE()),
    (3, 'user3@example.com', 'user3', 'hashed_password3', GETDATE()),
    (4, 'user4@example.com', 'user4', 'hashed_password4', GETDATE())

select * from part1.dbo.Users
select * from part2.dbo.Users
select * from UserView


drop trigger if exists DeleteTrigger

create trigger DeleteTrigger
    on UserView
    instead of delete
as
    begin
        delete u from part1.dbo.Users u join deleted on u.id = deleted.id
        delete u from part2.dbo.Users u join deleted on u.id = deleted.id
    end

delete from UserView where id = 1

select * from part1.dbo.Users
select * from part2.dbo.Users

drop trigger if exists UpdateTrigger

create trigger UpdateTrigger
    on UserView
    instead of update
as
    begin
        if update(id)
            begin
                raiserror (N'[error]: нельзя обновлять id', 16, 1)
            end
        else
            begin
                update part1.dbo.Users set
                    email = inserted.email
                from inserted WHERE inserted.id = part1.dbo.Users.id

                update part2.dbo.Users set
                    username = inserted.username,
                    password = inserted.password,
                    register_date = inserted.register_date
                from inserted where inserted.id = part2.dbo.Users.id
            end
    end

update UserView
set email = N'updated@mail.ru',
    register_date = GETDATE()
where id = 1

select * from part1.dbo.Users
select * from part2.dbo.Users
