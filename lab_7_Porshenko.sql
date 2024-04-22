use TaskTracker

drop table if exists [User]
drop table if exists Task
drop table if exists TaskGroup

create table TaskGroup(
    id int primary key identity(1, 1),
    name varchar(128) not null,
    description varchar(max),
    creation_datetime datetime
)

create table Task(
    id int primary key identity(1, 1),
    group_id int foreign key references TaskGroup(id) on delete cascade,
    name varchar(128) not null,
    description_text varchar(max),
    description_photo varchar(255), -- URL
    estimated_time int,
    creation_datetime datetime not null
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
    (1, 'Task 1', 'Description for Task 1', 'http://photo1.com', 10, GETDATE()),
    (1, 'Task 2', 'Description for Task 2', 'http://photo2.com', 15, GETDATE()),
    (2, 'Task 3', 'Description for Task 3', 'http://photo3.com', 20, GETDATE()),
    (2, 'Task 4', 'Description for Task 4', 'http://photo4.com', 8, GETDATE()),
    (3, 'Task 5', 'Description for Task 5', 'http://photo5.com', 12, GETDATE()),
    (3, 'Task 6', 'Description for Task 6', 'http://photo6.com', 18, GETDATE()),
    (4, 'Task 7', 'Description for Task 7', 'http://photo7.com', 25, GETDATE()),
    (4, 'Task 8', 'Description for Task 8', 'http://photo8.com', 14, GETDATE()),
    (5, 'Task 9', 'Description for Task 9', 'http://photo9.com', 16, GETDATE()),
    (5, 'Task 10', 'Description for Task 10', 'http://photo10.com', 22, GETDATE()),
    (1, 'Task 11', 'Description for Task 11', 'http://photo11.com', 10, GETDATE()),
    (2, 'Task 12', 'Description for Task 12', 'http://photo12.com', 15, GETDATE()),
    (3, 'Task 13', 'Description for Task 13', 'http://photo13.com', 20, GETDATE()),
    (4, 'Task 14', 'Description for Task 14', 'http://photo14.com', 8, GETDATE()),
    (5, 'Task 15', 'Description for Task 15', 'http://photo15.com', 12, GETDATE());

-- 1
drop view if exists TaskGroupView

create view TaskGroupView as
    select id, name, description from TaskGroup

select * from TaskGroupView

-- 2
drop view if exists GroupsTasksMappingView

create view GroupsTasksMappingView as
    select tg.id as GroupId, t.id as TaskId, tg.name as GroupName, t.name as TaskName from TaskGroup tg
    left join Task t on tg.id = t.group_id

select * from GroupsTasksMappingView

-- 3
drop index if exists TaskIndex on Task

create index TaskIndex on
    Task(name)
    include(description_text, creation_datetime)

select name, description_text, creation_datetime
from Task
where name = 'Task 3'

select name, description_text, creation_datetime, other_field --  не так эффективен
from Task
where name = 'Task 3'

-- 4

drop view if exists TaskGroupView
drop index if exists TaskGroupViewIdClusteredIndex
drop index if exists TaskGroupViewNameIndex

create view TaskGroupView as
    select id, name, description from TaskGroup

create unique clustered index TaskGroupViewIdClusteredIndex
    on TaskGroupView(id)

create index TaskGroupViewNameIndex
    on TaskGroupView(name)
