# Темы лабораторных работ
### 1. Моделирование данных с использованием модели сущность-связь
- Выбрать простейшую предметную область, соответствующую 4-5 сущностям.
- Сформировать требования к предметной
области.
- Создать модель «сущность-связь» для
предметной области с обоснованием выбора
кардинальных чисел связей.
### 2. Моделирование данных с использованием модели семантических объектов
- Создать модель семантических объектов для
предметной области, выбранной в
лабораторной работе №1.
- Обосновать выбор кардинальных чисел
атрибутов и типов объектов.
### 3. Преобразование модели «сущность-связь» в реляционную модель
- Преобразовать модель «сущность-связь»,
созданную в лабораторной работе №1, в
реляционную модель согласно процедуре
преобразования.
- Обосновать выбор типов данных, ключей,
правил обеспечения ограничений
минимальной кардинальности.
### 4. Преобразование модели семантических объектов в реляционную модель
- Преобразовать модель семантических объектов, созданную в лабораторной работе №2, в реляционную модель согласно процедуре преобразования.
- Сопоставить результаты проектирования с
использованием модели «сущность-связь» и
модели семантических объектов (лабораторные работы №№3,4).
- Обосновать различия результатов, выявить и
исправить ошибки проектирования.
### 5. Операции с базой данных, файлами, схемами
- Создать базу данных (CREATE DATABASE…,
определение настроек размеров файлов).
- Создать произвольную таблицу (CREATE TABLE…).
- Добавить файловую группу и файл данных (ALTER
DATABASE…).
- Сделать созданную файловую группу файловой
группой по умолчанию.
- (*) Создать еще одну произвольную таблицу.
- (*) Удалить созданную вручную файловую группу.
- Создать схему, переместить в нее одну из таблиц, удалить схему.
### 6. Ключи, ограничения, значения по умолчанию
- Создать таблицу с автоинкрементным первичным
ключом. Изучить функции, предназначенные для
получения сгенерированного значения IDENTITY.
- Добавить поля, для которых используются
ограничения (CHECK), значения по умолчанию
(DEFAULT), также использовать встроенные
функции для вычисления значений.
- Создать таблицу с первичным ключом на основе
глобального уникального идентификатора.
- Создать таблицу с первичным ключом на основе
последовательности.
- Создать две связанные таблицы, и протестировать
на них различные варианты действий для
ограничений ссылочной целостности (NO ACTION |
CASCADE | SET NULL | SET DEFAULT).
### 7. Представления и индексы
- Создать представление на основе одной из таблиц
задания 6.
- Создать представление на основе полей обеих
связанных таблиц задания 6.
- Создать индекс для одной из таблиц задания 6,
включив в него дополнительные неключевые поля.
- Создать индексированное представление.
### 8. Хранимые процедуры, курсоры и пользовательские функции
- Создать хранимую процедуру, производящую выборку
из некоторой таблицы и возвращающую результат
выборки в виде курсора.
- Модифицировать хранимую процедуру п.1. таким
образом, чтобы выборка осуществлялась с
формированием столбца, значение которого
формируется пользовательской функцией.
- Создать хранимую процедуру, вызывающую процедуру
п.1., осуществляющую прокрутку возвращаемого
курсора и выводящую сообщения, сформированные из
записей при выполнении условия, заданного еще одной
пользовательской функцией.
- Модифицировать хранимую процедуру п.2. таким
образом, чтобы выборка формировалась с помощью
табличной функции.
### 9. Триггеры DML
- Для одной из таблиц пункта 2 задания 7 создать
триггеры на вставку, удаление и добавление, при
выполнении заданных условий один из триггеров
должен инициировать возникновение ошибки
(RAISERROR / THROW).
- Для представления пункта 2 задания 7 создать
триггеры на вставку, удаление и добавление,
обеспечивающие возможность выполнения
операций с данными непосредственно через
представление.
### 10. Режимы выполнения транзакций
- Исследовать и проиллюстрировать на примерах
различные уровни изоляции транзакций MS SQL
Server, устанавливаемые с использованием
инструкции SET TRANSACTION ISOLATION LEVEL
- Накладываемые блокировки исследовать с
использованием sys.dm_tran_locks
### 11. -
### 12. -
### 13. Создание распределенных баз данных на основе секционированных представлений
- Создать две базы данных на одном экземпляре
СУБД SQL Server 2012.
- Создать в базах данных п.1. горизонтально
фрагментированные таблицы.
- Создать секционированные представления,
обеспечивающие работу с данными таблиц
(выборку, вставку, изменение, удаление).
### 14. Создание вертикально фрагментированных таблиц средствами СУБД SQL Server 2012
- Создать в базах данных пункта 1 задания 13
таблицы, содержащие вертикально
фрагментированные данные.
- Создать необходимые элементы базы данных
(представления, триггеры), обеспечивающие работу
с данными вертикально фрагментированных таблиц
(выборку, вставку, изменение, удаление).
### 15. Создание распределенных баз данных со связанными таблицами средствами СУБД SQL Server 2012
- Создать в базах данных пункта 1 задания 13
связанные таблицы.
- Создать необходимые элементы базы данных
(представления, триггеры), обеспечивающие работу
с данными связанных таблиц (выборку, вставку,
изменение, удаление).
