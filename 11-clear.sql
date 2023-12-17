/*
======================
 ПРАКТИЧЕСКОЕ ЗАДАНИЕ
======================
Дана таблица-источник, из которой мы периодически получаем данные.
Есть наша рабочая таблица, куда мы складываем данные из таблицы-источника.
Форматы таблиц имеют разную структуру, но схожий смысл.
За данные в источнике отвечает другой отдел, который периодически добавляет/ изменяет/ удаляет оттуда данные.

Подготовка к заданию:
1. Необходимо создать на сервере базу данных с любым названием. В этой БД мы создадим 2 таблицы: источник и
нашу рабочую таблицу.
2. Необходимо создать и заполнить таблицы, используя скрипты ниже:
*/
--1
CREATE DATABASE db11
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = my_tablespace2
    CONNECTION LIMIT = 1
    IS_TEMPLATE = False;


--2
CREATE SCHEMA istochnik;  

CREATE SCHEMA nashabaza;

CREATE TABLE istochnik.tablesource (
lineid bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
npokazatelid bigint NOT NULL, -- номер показателя
vperiodtype varchar(1) NOT NULL, -- период отчетности
dtstartdate date NOT NULL, -- дата начала отчетного периода
dtenddate date NOT NULL, -- дата конца отчетного периода
vterritoryid varchar(10) NOT NULL, -- ID территории в формате (ID региона _ ID отделения)
nvalue decimal(32,4) NOT NULL -- значение показателя
)

INSERT INTO istochnik.tablesource
(npokazatelid,vperiodtype,dtstartdate,dtenddate,vterritoryid,nvalue)
VALUES
(2588,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4789',45.64),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4889',88.34),
(3600,'m',CAST('2023-06-01' as date),CAST('2023-07-31' as date),'55_4889',81.51),
(3600,'q',CAST('2023-01-01' as date),CAST('2023-03-31' as date),'55_4889',64.42),
(4719,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4889',47.33),
(8543,'m',CAST('2023-05-01' as date),CAST('2023-07-31' as date),'42_1550',20.24),
(8543,'m',CAST('2023-08-01' as date),CAST('2023-09-30' as date),'42_1550',03.15),
(8543,'m',CAST('2023-07-01' as date),CAST('2023-08-31' as date),'55_4789',86.06),
(4719,'q',CAST('2023-06-01' as date),CAST('2023-09-30' as date),'55_4789',69.97),
(3600,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4789',42.88),
(3600,'m',CAST('2023-05-01' as date),CAST('2023-03-31' as date),'55_4789',25.79),
(2588,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'16_8647',08.60),
(2589,'q',CAST('2023-03-01' as date),CAST('2023-06-30' as date),'55_4789',81.51),
(2589,'q',CAST('2023-03-01' as date),CAST('2023-06-30' as date),'55_4789',64.42),
(2589,'q',CAST('2023-03-01' as date),CAST('2023-06-30' as date),'16_8647',47.33),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4789',20.24),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'16_8647',03.15),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'16_8647',86.06),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'16_8647',69.87),
(2589,'m',CAST('2023-05-01' as date),CAST('2023-06-30' as date),'55_4789',41.98);

CREATE TABLE nashabaza.ourtable (
propid bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
ncanonid int NOT NULL, -- номер показателя
dtreportdate date NOT NULL, -- дата конца отчетного периода
nterotdelenie int NOT NULL, -- ID региона
nterpodrazdel int NOT NULL, -- ID отделения
vprocent decimal(6,4) NOT NULL -- Значение показателя
);

truncate table nashabaza.ourtable;
INSERT INTO nashabaza.ourtable
(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
VALUES
(2588,CAST('2023-06-30' as date),55,4789,45.64),
(2589,CAST('2023-06-30' as date),55,4889,88.34),
(3600,CAST('2023-07-31' as date),55,4889,81.51),
(4719,CAST('2023-06-30' as date),55,4889,47.33),
(8543,CAST('2023-07-31' as date),42,1550,20.24),
(8543,CAST('2023-08-31' as date),55,4789,83.06),
(3600,CAST('2023-06-30' as date),55,4789,42.88),
(3600,CAST('2023-03-31' as date),55,4789,25.79),
(2588,CAST('2023-06-30' as date),16,8647,08.60),
(2589,CAST('2023-06-30' as date),55,4789,20.24),
(2589,CAST('2023-06-30' as date),16,8647,03.15),
(2589,CAST('2023-06-30' as date),16,8647,86.06),
(2589,CAST('2023-06-30' as date),16,8647,69.87),
(2589,CAST('2023-06-30' as date),55,4789,41.98);



--3
/*
3. Внимательно изучите комментарии к столбцам таблиц и обратите внимание на типы данных и названия столбцов.
*/
/*
I wish before start:
	* Have time-layer on both tables sync. As I understand, source table is
	filled with data to test tasks, meaning not all data in result table are currently
	sync-ed.
	* Have any idea of meanin of column "vperiodtype". 
		Should I check period lenght?
		Should I check that "dtenddate" greather then "dtstartdate"?
		I'd use additional source table under my schema for pre-processing.
	
*/
/*
Задача 1.
Необходимо разработать функцию, которая проверяет, появились ли данные за новую дату в
таблице-источнике. Если новые данные появились, то мы их перегружаем к себе и выводим надпись "Данные изменены".
Если у нас уже присутствуют данные за последнюю дату в таблице-источнике, то пишем сообщение
"Данные на последнюю дату отчета синхронизированы" в вызывающую программу.*/

--task1
DROP FUNCTION task1();
create function task1()
returns text
as
$$
declare 
	ist date := (select max(dtenddate) from istochnik.tablesource)::date;
	nasha date := (select max(dtreportdate) from nashabaza.ourtable)::date;
	f_output text;
begin
if ist > nasha then
	insert into 
		nashabaza.ourtable
			(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
		select 
		npokazatelid::int,
		dtenddate,
		SPLIT_PART(vterritoryid, '_', 1)::int,
		SPLIT_PART(vterritoryid, '_', 2)::int,
		nvalue::decimal(6,4)
		from istochnik.tablesource
		where dtenddate > nasha;
	f_output := 'Данные изменены';
	return f_output;
else 
	f_output := 'Данные на последнюю дату отчета синхронизированы';
	return f_output;
end if;
end;
$$ language plpgsql;

--call
select count(*) from nashabaza.ourtable;
select task1();
select count(*) from nashabaza.ourtable;
--reset table
truncate table nashabaza.ourtable restart identity;
INSERT INTO nashabaza.ourtable
(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
VALUES
(2588,CAST('2023-06-30' as date),55,4789,45.64),
(2589,CAST('2023-06-30' as date),55,4889,88.34),
(3600,CAST('2023-07-31' as date),55,4889,81.51),
(4719,CAST('2023-06-30' as date),55,4889,47.33),
(8543,CAST('2023-07-31' as date),42,1550,20.24),
(8543,CAST('2023-08-31' as date),55,4789,83.06),
(3600,CAST('2023-06-30' as date),55,4789,42.88),
(3600,CAST('2023-03-31' as date),55,4789,25.79),
(2588,CAST('2023-06-30' as date),16,8647,08.60),
(2589,CAST('2023-06-30' as date),55,4789,20.24),
(2589,CAST('2023-06-30' as date),16,8647,03.15),
(2589,CAST('2023-06-30' as date),16,8647,86.06),
(2589,CAST('2023-06-30' as date),16,8647,69.87),
(2589,CAST('2023-06-30' as date),55,4789,41.98);
select * from nashabaza.ourtable;
select count(*) from nashabaza.ourtable;

/*
Задача 2.
Доработайте функцию следующим образом:
Функция должна сверять контрольную сумму значений всех показателей за последнюю дату в источнике и сверять
с контрольной суммой значений всех показателей за ту же дату в нашей таблице.
При различии в контрольных суммах - перезаписывать данные за последнюю дату.
При совпадении - выводить сообщение "Данные на последнюю дату отчета синхронизированы".
Обратите внимание на то, что сравнивать с NULL нельзя.
*/
/*
merge into nashabaza.ourtable_test2 as t
using (select 
		npokazatelid::int as ncanonid,
		dtenddate as dtreportdate,
		SPLIT_PART(vterritoryid, '_', 1)::int as nterotdelenie,
		SPLIT_PART(vterritoryid, '_', 2)::int as nterpodrazdel,
		nvalue::decimal(6,4) as vprocent
		from istochnik.tablesource_test2) as s
on (t.ncanonid = s.ncanonid, t.nterotdelenie = s.nterotdelenie, t.nterpodrazdel = s.nterpodrazdel)
when matched
	then update set vprocent = s.vprocent
when not matched
	then insert (ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
		values (s.ncanonid, s.dtreportdate, s.nterotdelenie, s.nterpodrazdel, s.vprocent)
;*/

--Since Merge returns "non unique source rows"
--And also non unique target rows btw
--We will check and merge all rows on date
DROP FUNCTION task2();
create function task2()
returns text
as
$$
declare 
	ist date := (select max(dtenddate) from istochnik.tablesource)::date;
	nasha date := (select max(dtreportdate) from nashabaza.ourtable)::date;
	target text := (select md5(array_agg(f.*)::text)
						from(select
							npokazatelid::int as ncanonid,
							dtenddate as dtreportdate,
							SPLIT_PART(vterritoryid, '_', 1)::int as nterotdelenie,
							SPLIT_PART(vterritoryid, '_', 2)::int as nterpodrazdel,
							nvalue::decimal(6,4) as vprocent
							from istochnik.tablesource where dtenddate = ist) f
				   );
	src text := (select md5(array_agg(f.*)::text)
						from(select
							ncanonid,
							dtreportdate,
							nterotdelenie,
							nterpodrazdel,
							vprocent
							from nashabaza.ourtable where dtreportdate = nasha) f
				 );
	f_output text;
begin
if ist > nasha then
	insert into 
		nashabaza.ourtable
			(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
		select 
		npokazatelid::int,
		dtenddate,
		SPLIT_PART(vterritoryid, '_', 1)::int,
		SPLIT_PART(vterritoryid, '_', 2)::int,
		nvalue::decimal(6,4)
		from istochnik.tablesource
		where dtenddate > nasha;
	f_output := 'Данные изменены';
	return f_output;
elsif (ist = nasha and target = src) then
	f_output := 'Данные на последнюю дату отчета синхронизированы';
	return f_output;
else 
	delete from nashabaza.ourtable where dtreportdate = ist;
	INSERT INTO nashabaza.ourtable
	(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
	select 
	npokazatelid::int as ncanonid,
	dtenddate as dtreportdate,
	SPLIT_PART(vterritoryid, '_', 1)::int as nterotdelenie,
	SPLIT_PART(vterritoryid, '_', 2)::int as nterpodrazdel,
	nvalue::decimal(6,4) as vprocent
	from istochnik.tablesource
	where dtenddate = ist;
	f_output := 'Данные изменены';
	return f_output;
end if;
end;
$$ language plpgsql;

select * from nashabaza.ourtable;
select task2();
select * from nashabaza.ourtable;
select task2();
select * from nashabaza.ourtable;
select task2();

DROP FUNCTION task3(date);
create function task3(in_date date default NULL)
returns text
as
$$
declare 
	ist date;
	nasha date;
	target text;
	src text;
	f_output text;

begin
if in_date is NULL then
			ist := (select max(dtenddate) from istochnik.tablesource)::date;
			nasha := (select max(dtreportdate) from nashabaza.ourtable)::date;
	else	ist := in_date;
			nasha := in_date;
end if;
target := (select md5(array_agg(f.*)::text)
						from(select
							npokazatelid::int as ncanonid,
							dtenddate as dtreportdate,
							SPLIT_PART(vterritoryid, '_', 1)::int as nterotdelenie,
							SPLIT_PART(vterritoryid, '_', 2)::int as nterpodrazdel,
							nvalue::decimal(6,4) as vprocent
							from istochnik.tablesource where dtenddate = ist) f
				   );
src := (select md5(array_agg(f.*)::text)
						from(select
							ncanonid,
							dtreportdate,
							nterotdelenie,
							nterpodrazdel,
							vprocent
							from nashabaza.ourtable where dtreportdate = nasha) f
				 );
if ist > nasha then
	insert into 
		nashabaza.ourtable
			(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
		select 
		npokazatelid::int,
		dtenddate,
		SPLIT_PART(vterritoryid, '_', 1)::int,
		SPLIT_PART(vterritoryid, '_', 2)::int,
		nvalue::decimal(6,4)
		from istochnik.tablesource
		where dtenddate > nasha;
	f_output := 'Данные изменены';
	return f_output;
elsif (ist = nasha and target = src) then
	f_output := 'Данные на последнюю дату отчета синхронизированы';
	return f_output;
else 
	delete from nashabaza.ourtable where dtreportdate = ist;
	INSERT INTO nashabaza.ourtable
	(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
	select 
	npokazatelid::int as ncanonid,
	dtenddate as dtreportdate,
	SPLIT_PART(vterritoryid, '_', 1)::int as nterotdelenie,
	SPLIT_PART(vterritoryid, '_', 2)::int as nterpodrazdel,
	nvalue::decimal(6,4) as vprocent
	from istochnik.tablesource
	where dtenddate = ist;
	f_output := 'Данные изменены';
	return f_output;
end if;
end;
$$ language plpgsql;

truncate table nashabaza.ourtable;
INSERT INTO nashabaza.ourtable
(ncanonid,dtreportdate,nterotdelenie,nterpodrazdel,vprocent)
values
(2588,CAST('2023-06-30' as date),55,4789,45.64),
(2589,CAST('2023-06-30' as date),55,4889,88.34),
(3600,CAST('2023-07-31' as date),55,4889,81.51),
(4719,CAST('2023-06-30' as date),55,4889,47.33),
(8543,CAST('2023-07-31' as date),42,1550,20.24),
(8543,CAST('2023-08-31' as date),55,4789,83.06),
(3600,CAST('2023-06-30' as date),55,4789,42.88),
(3600,CAST('2023-03-31' as date),55,4789,25.79),
(2588,CAST('2023-06-30' as date),16,8647,08.60),
(2589,CAST('2023-06-30' as date),55,4789,20.24),
(2589,CAST('2023-06-30' as date),16,8647,03.15),
(2589,CAST('2023-06-30' as date),16,8647,86.06),
(2589,CAST('2023-06-30' as date),16,8647,69.87),
(2589,CAST('2023-06-30' as date),55,4789,41.98);

select * from nashabaza.ourtable;
select * from istochnik.tablesource;
select task3();
select * from nashabaza.ourtable;
select * from nashabaza.ourtable where dtreportdate = '2023-08-31';
select task3('2023-08-31');
select * from nashabaza.ourtable where dtreportdate = '2023-08-31';
select * from nashabaza.ourtable where dtreportdate = '2023-07-31';
select task3('2023-07-31');
select * from nashabaza.ourtable where dtreportdate = '2023-07-31';
