--2
insert into "ShareDetails".shareprices
(shareid, price, pricedate)
values
	(1, 2.155, '2023-08-01 10:10:00'),
	(1, 2.2125, '2023-08-01 10:12:00'),
	(1, 2.4175, '2023-08-01 10:16:00'),
	(1, 2.21, '2023-08-01 11:22:00'),
	(1, 2.17, '2023-08-01 14:54:00'),
	(1, 2.34125, '2023-08-01 16:10:00'),
	(2, 41.10, '2023-08-01 10:10:00'),
	(2, 43.22, '2023-08-02 10:10:00'),
	(2, 45.20, '2023-08-03 10:10:00');
	
insert into "ShareDetails".shares
(sharedesc, sharetickerid, currentprice)
values ('FAT-BELLY.COM', 'FBC', 45.2000);

select * from "ShareDetails".v_shareprices;

--3
create view "CustomerDetails".v_custtrans
as
select
	c.accountnumber,
	c.customerfirstname,
	c.customerotherinitials,
	tt.transactiondescription,
	t.dateentered,
	t.amount,
	t.referencedetails
from "CustomerDetails".customers as c
join "TransactionDetails".transactions as t
	on t.customerid = c.customerid
join "TransactionDetails".transactiontypes as tt
	on tt.transactiontypesid = t.transactiontype
order by c.accountnumber asc, t.dateentered desc;

select * from "CustomerDetails".v_custtrans;

--4
update "CustomerDetails".customers
set customerlastname = 'Brust'
where customerlastname = 'Brusten';

insert into "CustomerDetails".financialproducts
(productid, productname)
values
	(1, 'Regular Savings'),
	(2, 'Bonds Account'),
	(3, 'Share Account'),
	(4, 'Life Insurance');

insert into "CustomerDetails".customersproducts
(customerid, financialproductid, amounttocollect, 
frequency, lastcollected, lastcollection, renewable)
values
(1, 1, 200, 1, '31.08.2021', '31.08.2035', false),
(1, 2, 50, 1, '24.08.2023', '24 March 2025', false),
(2, 4, 150, 3, '20.08.2021', '20.08.2025', true),
(3, 3, 500, 0, '24.08.2021', '24.08.2025', true);

drop view if exists "CustomerDetails".v_custfinproducts;

create view "CustomerDetails".v_custfinproducts
as select
c.customerfirstname || ' ' || c.customerlastname as customername,
c.accountnumber, fp.productname, cp.amounttocollect,
cp.frequency, cp.lastcollected
from "CustomerDetails".customers as c
join "CustomerDetails".customersproducts as cp
	on cp.customerid = c.customerid
join "CustomerDetails".financialproducts as fp
	on fp.productid = cp.financialproductid;

select * from "CustomerDetails".v_custfinproducts;
--25 ms
alter table "CustomerDetails".customers
alter column CustomerFirstName type varchar(100);

create view "CustomerDetails".v_custtrans
as
select
	c.accountnumber,
	c.customerfirstname,
	c.customerotherinitials,
	tt.transactiondescription,
	t.dateentered,
	t.amount,
	t.referencedetails
from "CustomerDetails".customers as c
join "TransactionDetails".transactions as t
	on t.customerid = c.customerid
join "TransactionDetails".transactiontypes as tt
	on tt.transactiontypesid = t.transactiontype
order by c.accountnumber asc, t.dateentered desc;

select * from "CustomerDetails".v_custtrans;

--5
drop view if exists "CustomerDetails".v_custfinproducts;

create materialized view "CustomerDetails".v_custfinproducts
as select
c.customerfirstname || ' ' || c.customerlastname as customername,
c.accountnumber, fp.productname, cp.amounttocollect,
cp.frequency, cp.lastcollected
from "CustomerDetails".customers as c
join "CustomerDetails".customersproducts as cp
	on cp.customerid = c.customerid
join "CustomerDetails".financialproducts as fp
	on fp.productid = cp.financialproductid;

select * from "CustomerDetails".v_custfinproducts;
--29ms lol

select *  from "CustomerDetails".customers;

update "CustomerDetails".customers
set customerlastname = 'Brusten'
where customerlastname = 'Brust';

refresh materialized view "CustomerDetails".v_custfinproducts;
select * from "CustomerDetails".v_custfinproducts;