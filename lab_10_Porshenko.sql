use TaskTracker

drop table if exists TaskGroup
drop table if exists Task

create table TaskGroup(
    id int primary key identity(1, 1),
    name varchar(128) not null,
    description varchar(max),
    creation_datetime datetime default GETDATE()
)

create table Task(
    id int primary key identity(1, 1),
    group_id int foreign key references TaskGroup(id) on delete cascade,
    name varchar(128) not null,
    description_text varchar(max),
    description_photo varchar(255), -- URL
    estimated_time int,
    creation_datetime datetime not null default GETDATE(),
    is_done bit default 0 not null
)


INSERT INTO TaskGroup (name, description, creation_datetime)
VALUES
    ('Group 1', 'Description for Group 1', GETDATE()),
    ('Group 2', 'Description for Group 2', GETDATE()),
    ('Group 3', 'Description for Group 3', GETDATE()),
    ('Group 4', 'Description for Group 4', GETDATE()),
    ('Group 5', 'Description for Group 5', GETDATE());

INSERT INTO Task (group_id, name, description_text, description_photo, estimated_time, creation_datetime)
VALUES
    (1, 'Task 1', 'Description for Task 1', 'http://photo1.com', null, GETDATE()),
    (1, 'Task 2', 'Description for Task 2', 'http://photo2.com', 15, GETDATE()),
    (2, 'Task 3', 'Description for Task 3', null, 20, GETDATE()),
    (2, 'Task 4', 'Description for Task 4', null, 8, GETDATE()),
    (3, 'Task 5', 'Description for Task 5', 'http://photo5.su', 12, GETDATE()),
    (3, 'Task 6', 'Description for Task 6', 'http://photo6.ru', 18, GETDATE()),
    (4, 'Task 7', 'Description for Task 7', 'http://photo7.com', 25, GETDATE()),
    (4, 'Task 8', 'Description for Task 8', 'http://photo8.com', 14, GETDATE()),
    (5, 'Task 9', 'Description for Task 9', 'http://photo9.com', 16, GETDATE()),
    (5, 'Task 10', 'Description for Task 10', null, 22, GETDATE()),
    (1, 'Task 11', 'Description for Task 11', 'http://photo11.com', 10, GETDATE()),
    (2, 'Task 12', 'Description for Task 12', 'http://photo12.com', 15, GETDATE()),
    (3, 'Task 13', 'Description for Task 13', null, 20, GETDATE()),
    (4, 'Task 14', 'Description for Task 14', 'http://photo14.com', 8, GETDATE()),
    (5, 'Task 15', 'Description for Task 15', 'http://photo15.com', 12, GETDATE());


SET transaction isolation level read uncommitted

SET transaction isolation level read committed

SET transaction isolation level repeatable read

SET transaction isolation level serializable

-- dirty read

begin transaction
select * from Task
update Task
set description_text = 'lab11234 description' where name = 'Task 1'
waitfor delay '00:00:15'
rollback

select * from Task
select resource_type, resource_description, request_mode from sys.dm_tran_locks

-- non-repeatable read
begin transaction
select * from Task
update Task
set description_text = 'lab102220 description' where name = 'Task 1'
select * from Task
select resource_type, resource_description, request_mode from sys.dm_tran_locks
commit transaction

-- fantom read
begin transaction
insert into Task(group_id, name, description_text, description_photo, estimated_time, creation_datetime)
values
    (1, 'Task fantom read', 'fantom read', 'http://photo1.com', 1, GETDATE())
select resource_type, resource_description, request_mode from sys.dm_tran_locks
commit transaction