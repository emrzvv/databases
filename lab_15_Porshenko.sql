use master;

if DB_ID('tracker1') is not null drop database tracker1
if DB_ID('tracker2') is not null drop database tracker2

create database tracker1 on (
    name = tracker1_dat,
    filename = '/var/opt/mssql/data/tracker1_dat.mdf',
    size = 20,
    maxsize = 50
)
log on (
    name = tracker1_log,
    filename = '/var/opt/mssql/data/tracker1_log.ldf',
    size = 5,
    maxsize = 25,
    filegrowth = 5
);

create database tracker2 on (
    name = tracker2_dat,
    filename = '/var/opt/mssql/data/tracker2_dat.mdf',
    size = 20,
    maxsize = 50
)
log on (
    name = tracker2_log,
    filename = '/var/opt/mssql/data/tracker2_log.ldf',
    size = 5,
    maxsize = 25,
    filegrowth = 5
);

use tracker1

create table TaskGroup(
    id int primary key,
    name varchar(128) not null unique,
    description varchar(max),
    creation_datetime datetime default GETDATE()
)

use tracker2

create table Task(
    id int primary key,
    group_id int foreign key references TaskGroup(id),
    name varchar(128) not null,
    description_text varchar(max),
    description_photo varchar(255), -- URL
    estimated_time int,
    creation_datetime datetime not null default GETDATE(),
    is_done bit default 0 not null
)

drop view if exists GroupsTasksMappingView

create view GroupsTasksMappingView as
    select tg.id as GroupId, tg.name as GroupName, tg.description as GroupDescription,
           t.id as TaskId, t.name as TaskName, t.description_text as TaskDescription, t.estimated_time, t.creation_datetime from TaskGroup tg
    left join Task t on tg.id = t.group_id

select * from GroupsTasksMappingView

drop trigger if exists InsertTaskGroup

create trigger InsertTaskGroup on TaskGroup instead of insert as
    begin
        if exists(
           select * from tracker1.dbo.TaskGroup tg
           join inserted i on tg.name = i.name) or exists(
                                                        select * from tracker1.dbo.TaskGroup tg
                                                                 join inserted i on tg.id = i.id)
            begin
                raiserror(N'[error]: Запрещена вставка неуникальных имён или id групп', 16, 1)
            end
        else
            begin
                insert into tracker1.dbo.TaskGroup(id, name, description, creation_datetime)
                select id, name, description, creation_datetime from inserted
            end
    end

drop trigger if exists DeleteTaskGroup

create trigger DeleteTaskGroup on TaskGroup instead of delete as
    begin
        delete t from tracker2.dbo.Task t join deleted d on d.id = t.group_id
        delete tg from tracker1.dbo.TaskGroup tg join deleted d on d.id = tg.id
    end

drop trigger if exists UpdateTaskGroup

create trigger UpdateTaskGroup on TaskGroup instead of update as
    begin
        if update(id)
            begin
                raiserror(N'[error]: Обновление id запрещено', 16, 1)
            end
        else
            if update(name) and exists(select * from tracker1.dbo.TaskGroup tg where tg.name = name)
                begin
                   raiserror(N'[error]: Имя группы должно быть уникальным', 16, 1)
                end
            else
                begin
                    update tracker1.dbo.TaskGroup
                    set
                        name = inserted.name,
                        description = inserted.description,
                        creation_datetime = inserted.creation_datetime
                    from inserted i where i.id = tracker1.dbo.TaskGroup.id
                end
    end

use tracker2

drop trigger if exists InsertTask

create trigger InsertTask on Task instead of insert as
    begin
        if exists(
            select i.group_id from inserted i
                              where i.group_id not in (select tg.id from tracker1.dbo.TaskGroup tg))
            begin
                raiserror(N'[error]: Группы с таким id не существует', 16, 1)
            end
        else
            begin
                insert into tracker2.dbo.Task(id, group_id, name, description_text, estimated_time, creation_datetime, is_done)
                select id, group_id, name, description_text, estimated_time, creation_datetime, is_done from inserted
            end
    end

drop trigger if exists DeleteTask

create trigger DeleteTask on Task instead of delete as
    begin
        delete t from tracker2.dbo.Task t join deleted d on d.id = t.id
    end

drop trigger if exists UpdateTask

create trigger UpdateTask on Task instead of update as
    begin
        if update(id)
            begin
                raiserror(N'[error]: Обновление id запрещено', 16, 1)
            end
        else
            if update(group_id) and exists(
                                        select i.group_id from inserted i
                                        where i.group_id not in (select tg.id from tracker1.dbo.TaskGroup tg))
                begin
                   raiserror(N'[error]: Группы с таким id не существует', 16, 1)
                end
            else
                begin
                    if update(estimated_time) and estimated_time < 0
                        begin
                            raiserror(N'[error]: Оценочное время не может быть меньше 0', 16, 1)
                        end
                    else
                        begin
                            update tracker2.dbo.Task
                            set
                                group_id = inserted.group_id,
                                name = inserted.name,
                                description_text = inserted.description_text,
                                description_photo = inserted.description_photo,
                                estimated_time = inserted.estimated_time,
                                creation_datetime = inserted.creation_datetime,
                                is_done = inserted.is_done
                            from inserted
                        end
                end
    end

use tracker1
insert into TaskGroup (id, name, description) values (1, 'Group1', 'Description1');
insert into TaskGroup (id, name, description) values (2, 'Group1', 'Description2');

insert into TaskGroup (id, name, description) values (1, 'Group1', 'Description1');
insert into TaskGroup (id, name, description) values (1, 'Group2', 'Description2');

DELETE FROM TaskGroup where id = 1;
update TaskGroup set id = 100 where name = 'Group1';

use tracker2
insert into Task (id, group_id, name, description_text, estimated_time) values (1, 100, 'Task1', 'Description1', 10);
delete from Task where id = 1;
update Task set id = 100 where name = 'Task1';
update Task set estimated_time = -5 where name = 'Task1';