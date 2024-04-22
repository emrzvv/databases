use TaskTracker

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

-- 1
if object_id('GetAllTasksWithPhotos', 'P') is not null
drop procedure GetAllTasksWithPhotos

create procedure GetAllTasksWithPhotos
    @TaskWithPhotosCursor cursor varying output
as
    set @TaskWithPhotosCursor = cursor scroll static for
    select id, name, description_photo from Task where description_photo is not null
    open @TaskWithPhotosCursor


declare @CurrentCursor CURSOR
exec GetAllTasksWithPhotos @TaskWithPhotosCursor = @CurrentCursor OUTPUT

declare @id int, @name varchar(128), @description_photo varchar(255)

while (@@fetch_status = 0)
begin
    print cast(@id as varchar(10)) + ' ' + @name + ' ' + @description_photo + char(10) + '--------'
    fetch next from @CurrentCursor into @id, @name, @description_photo
end

print 'while ended!'
fetch first from @CurrentCursor into @id, @name, @description_photo
print cast(@id as varchar) + ' ' + @name + ' ' + @description_photo + char(10) + '--------'
close @CurrentCursor
deallocate @CurrentCursor

-- 2
if object_id('GetTasksWithEndDatetime', 'P') is not null
drop procedure GetTasksWithEndDatetime

if object_id('GetEndDatetime', 'F') is not null
drop function GetEndDatetime

create function GetEndDatetime (@currentDatetime datetime, @estimatedHours int)
returns datetime
as
begin
    declare @endDatetime datetime
    set @endDatetime = dateadd(HOUR, @estimatedHours, @currentDatetime)
    return @endDatetime
end

create procedure GetTasksWithEndDatetime
    @TaskWithEndDatetimeCursor cursor varying output
as
    set @TaskWithEndDatetimeCursor = cursor scroll static for
    select id, name, estimated_time, creation_datetime, dbo.GetEndDatetime(creation_datetime, estimated_time) from Task where estimated_time is not null
    open @TaskWithEndDatetimeCursor


declare @CurrentCursor CURSOR
exec GetTasksWithEndDatetime @TaskWithEndDatetimeCursor = @CurrentCursor OUTPUT


declare @id int, @name varchar(128), @estimated_time int, @start_datetime datetime, @end_datetime datetime

while (@@fetch_status = 0)
begin
    print cast(@id as varchar) + ' ' + @name + ' estimated: ' + cast(@estimated_time as varchar) + '; dates: ' + cast(@start_datetime as varchar) + ' -> ' + cast(@end_datetime as varchar) + char(10) + '--------'
    fetch next from @CurrentCursor into @id, @name, @estimated_time, @start_datetime, @end_datetime
end

fetch first from @CurrentCursor into @id, @name, @estimated_time, @start_datetime, @end_datetime
close @CurrentCursor
deallocate @CurrentCursor

-- 3

if object_id('PrintMessages', 'P') is not null
drop procedure PrintMessages

if object_id('CheckTLD', 'FN') is not null
drop function CheckTLD

create function CheckTLD (@tld varchar(10), @url varchar(255))
returns int
as
    begin
        if(@url like '%' + @tld + '%')
            return 1
        return 0
    end

create procedure PrintMessages
    @cursor cursor varying output
as
    declare @currentCursor cursor
    declare @id int, @name varchar(128), @description_photo varchar(255)
    exec GetAllTasksWithPhotos @TaskWithPhotosCursor = @currentCursor output
    while (@@fetch_status = 0)
    begin
        if (dbo.CheckTLD('com', @description_photo) = 1)
            print '"' + @description_photo + '" contains .com' + char(10)
        else
            print '"' + @description_photo + '" does not contain .com' + char(10)

        fetch next from @currentCursor into @id, @name, @description_photo
    end
    fetch first from @currentCursor into @id, @name, @description_photo

declare @cc cursor
exec PrintMessages @cursor = @cc

close @cc
deallocate @cc

-- 4

if object_id('GetEndDatetime2', 'FN') is not null
drop function GetEndDatetime2

create function dbo.GetEndDatetime2 (@currentDatetime datetime, @estimatedHours int)
returns datetime
as
begin
    declare @endDatetime datetime
    set @endDatetime = dateadd(HOUR, @estimatedHours, @currentDatetime)
    return @endDatetime
end

create function dbo.GetTasksWithEndDatetimeT()
returns table
as
return (
    select id, name, estimated_time, creation_datetime, dbo.GetEndDatetime2(creation_datetime, estimated_time) as EndDatetime
    from Task
    where estimated_time is not null
    )

create procedure dbo.GetTasksWithEndDatetimeP
    @TaskWithEndDatetimeCursor cursor varying output
as
    begin
        set @TaskWithEndDatetimeCursor = cursor scroll static for
        select id, name, estimated_time, creation_datetime, EndDatetime from dbo.GetTasksWithEndDatetimeT()
        open @TaskWithEndDatetimeCursor
    end


declare @CurrentCursor CURSOR
exec dbo.GetTasksWithEndDatetimeP @TaskWithEndDatetimeCursor = @CurrentCursor OUTPUT


declare @id int, @name varchar(128), @estimated_time int, @start_datetime datetime, @end_datetime datetime

while (@@fetch_status = 0)
begin
    print cast(@id as varchar) + ' ' + @name + ' estimated: ' + cast(@estimated_time as varchar) + '; dates: ' + cast(@start_datetime as varchar) + ' -> ' + cast(@end_datetime as varchar) + char(10) + '--------'
    fetch next from @CurrentCursor into @id, @name, @estimated_time, @start_datetime, @end_datetime
end

fetch first from @CurrentCursor into @id, @name, @estimated_time, @start_datetime, @end_datetime
close @CurrentCursor
deallocate @CurrentCursor