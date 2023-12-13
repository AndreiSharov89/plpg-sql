--1
create tablespace my_tablespace2
	owner postgres
	location E'D:\\Study\\plpg-my_db';

alter tablespace my_tablespace2
	owner to postgres;

--2
create database my_db_2
    owner = postgres
    encoding = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    LOCALE_PROVIDER = 'libc'
    tablespace = my_tablespace2
    connection limit = 10
    IS_TEMPLATE = False;

--3
create table my_table1 (column1 int, column2 bigint);

--4
create table my_table2
	(column1 int, column2 bigint)
	tablespace pg_default;
	
--5
alter table my_table1 set tablespace pg_default;

