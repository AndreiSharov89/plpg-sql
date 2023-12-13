--1
INSERT INTO "ShareDetails".shares(
	sharedesc,
	sharetickerid,
	currentprice)
	VALUES ('ACME''S HOMEBAKE COOKIES INC',
			'AHCI',
			2.34125);

select * from "ShareDetails".shares;
select * from "CustomerDetails".customers;

insert into "CustomerDetails".customers
	(customertitleid, customerlastname, customerfirstname,
	 customerotherinitials, addressid, accountnumber,
	 accounttypeid, clearebalance,unclearebalance)
	 values (3, 'Lobel', 'Leonard', NULL, 145, 53431993, 1, 437.97, -10.56);

delete from "CustomerDetails".customers
where customerid = 5;

alter table "CustomerDetails".customers alter column
customerfirstname type character varying(50);
alter table "CustomerDetails".customers alter column
customerotherinitials type character varying(10);
alter table "CustomerDetails".customers alter column
customerlastname type character varying(50);
alter table "CustomerDetails".customers alter column
accountnumber type character varying(15);

insert into "CustomerDetails".customers
	(customertitleid, customerlastname, customerfirstname,
	 customerotherinitials, addressid, accountnumber,
	 accounttypeid, clearebalance,unclearebalance)
	 values (3, 'Lobel', 'Leonard', NULL, 145, 53431993, 1, 437.97, -10.56);

alter table "CustomerDetails".customers alter column
customerid
drop identity;

update "CustomerDetails".customers
set customerid =1;
select * from "CustomerDetails".customers;

alter table "CustomerDetails".customers alter column
customerid
add generated always as identity;

alter sequence "CustomerDetails".customers_customerid_seq restart with 2;

insert into "CustomerDetails".customers
	(customertitleid, customerlastname, customerfirstname,
	 customerotherinitials, addressid, accountnumber,
	 accounttypeid, clearebalance,unclearebalance)
	 values
(1, 'Brust', 'Andrew', 'J,', 133, 18176111, 1, 200, 2);

insert into "CustomerDetails".customers
	(customertitleid, customerlastname, customerfirstname,
	 customerotherinitials, addressid, accountnumber,
	 accounttypeid, clearebalance,unclearebalance)
	 values
(3, 'Lobel', 'Leonard', NULL, 145, 53431993, 1, 437.97, -10.56);
select * from "CustomerDetails".customers;

--2
alter table "CustomerDetails".customersproducts
add constraint pk_customersproducts
primary key (customerfinancialproductid);

alter table "CustomerDetails".customersproducts
add constraint ck_custprods_amtcheck
check (amounttocollect > 0::money);

alter table "CustomerDetails".customersproducts
alter column renewable
set default false;

--3
insert into "CustomerDetails".customers
	(customertitleid, customerfirstname, customerotherinitials,
	 customerlastname, addressid, accountnumber,
	 accounttypeid, clearebalance, unclearebalance)
	 values
(3, 'Bernie', 'I', 'McGee', 314, 65368765, 1, 6653.11, 0.00),
(2, 'Julie', 'A', 'Dewson', 2134, 81625422, 1, 53.32, -12.21),
(1, 'Kristy', NULL, 'Hull', 4312, 96565334, 1, 1266.00, 10.32);

insert into "ShareDetails".shares
	(sharedesc, sharetickerid, currentprice)
	 values
('FAT-BELLY.COM', 'FBC', 45.20),
('NetRadio Inc', 'NRI', 29.79),
('Texas Oil Industies', 'TOI', 0.455),
('London Bridge Club', 'LBC', 1.46);

select * from "CustomerDetails".customers;
select * from "ShareDetails".shares;

--4
select * from "CustomerDetails".customers;
select customerfirstname, customerlastname, clearebalance
from "CustomerDetails".customers;

--5
update "CustomerDetails".customers
set customerlastname = 'Brodie'
where customerid = 4;

do
$$
declare ValueToUpdate varchar(30);
begin
	ValueToUpdate := 'McGlynn';
	update "CustomerDetails".customers
	set customerlastname = ValueToUpdate,
	clearebalance = clearebalance + unclearebalance,
	unclearebalance = 0
	where customerlastname = 'Brodie';
end
$$
select * from "CustomerDetails".customers;

do
$$
declare WrongDataType varchar(30) := '4311,22';
begin
	update "CustomerDetails".customers
	set clearebalance = WrongDataType::money
	where customerid = 4;
end
$$
select * from "CustomerDetails".customers;

--6
/*
create temporary table tmp_customers
as select
	customerid,
	customerfirstname,
	customerotherinitials,
	customerlastname
from "CustomerDetails".customers
with no data;

delete from tmp_customers;
drop table tmp_customers;
*/

create temporary table tmp_customers
as select
	customerid,
	customerfirstname,
	customerotherinitials,
	customerlastname
from "CustomerDetails".customers;

select * from tmp_customers;

delete from tmp_customers
where customerid = 4;

insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');

delete from tmp_customers
where customerid is NULL;

alter table tmp_customers
alter column customerid
set not NULL;

alter table tmp_customers
alter column customerid
add generated always as identity (increment 1 start 7);

insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');

select * from tmp_customers;

delete from tmp_customers;
insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');

truncate table tmp_customers;
insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');

truncate table tmp_customers restart identity;
insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');
select * from tmp_customers;

alter table tmp_customers
alter column customerid
drop identity;

alter table tmp_customers
alter column customerid
add generated always as identity (increment 1 start 1);

truncate table tmp_customers restart identity;
insert into tmp_customers
(customerfirstname, customerotherinitials, customerlastname)
values ('Dmitrij', 'J', 'Vetrov');
select * from tmp_customers;


