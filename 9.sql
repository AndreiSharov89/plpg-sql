--1
create or replace function "TransactionDetails".fn_intcalc(
	Amount decimal (18,5),
	FromDate date,
	ToDate date,
	InterestRate decimal(6,3)=10)
returns decimal(18,5)
security invoker
as $$
	declare
		IntCalculated decimal(18,5);
	begin
		IntCalculated := Amount*(InterestRate/100)*
			(extract(day from ToDate::timestamp-FromDate::timestamp)/365.00);
		return coalesce(IntCalculated,0);
	end;
$$ language plpgsql;

select "TransactionDetails".fn_intcalc (2000, '2023-03-01', '2023-03-10', 10);

--2
create or replace function "TransactionDetails".fn_returntransactions (
	CustID bigint)
returns table (
	transactionid bigint,
	customerid bigint,
	transactiondescription varchar(30),
	dateentered timestamp(0),
	amount money)
security invoker
as $$
select
	t.transactionid as transactionid,
	t.customerid as customerid,
	tt.transactiondescription as transactiondescription,
	t.dateentered as dateentered,
	t.amount as amount
from "TransactionDetails".transactions t
join "TransactionDetails".transactiontypes tt
	on tt.transactiontypesid = t.transactiontype
where t.customerid = CustID;
$$ language sql;

insert into "TransactionDetails".transactions
	(customerid, transactiontype, dateentered, amount,
	relatedproductid)
values
	(1, 1, '2023-08-01', 100.00, 1),
	(1, 1, '2023-08-03', 75.76, 1),
	(1, 2, '2023-08-05', 35.20, 1),
	(1, 2, '2023-08-06', 20.00, 1);
	
insert into "TransactionDetails".Transactiontypes
	(transactiondescription, credittype, affectcashbalance)
values
	('proc+', true, true),
	('proc-', false, true);
	
select * from "TransactionDetails".fn_returntransactions(1);

select
	c.customerfirstname,
	c.customerlastname,
	trans.transactionid,
	trans.transactiondescription,
	trans.dateentered,
	trans.amount
from "CustomerDetails".customers as c
join "TransactionDetails".fn_returntransactions(c.customerid) as trans
	on c.customerid = trans.customerId;

--3
create procedure "CustomerDetails".spu_inscustomer(
	FirstName varchar(50),
	LastName varchar(50),
	CustTitle int,
	CustInitials varchar(10),
	AddressId int,
	AccountNumber varchar(15),
	AccountTypeId int
)
language plpgsql
as $$
begin
	insert into "CustomerDetails".customers (
		customertitleid,
		customerfirstname,
		customerotherinitials,
		customerlastname,
		addressid,
		accountnumber,
		accounttypeid,
		clearebalance,
		unclearebalance)
	values (
		custtitle,
		firstname,
		custinitials,
		lastname,
		addressid,
		accountnumber,
		accounttypeid,
		0,
		0);
end; $$

call "CustomerDetails".spu_inscustomer('Henry', 'Williams', 1, NULL, 431, '22067531', 1);
select * from "CustomerDetails".customers;

call "CustomerDetails".spu_inscustomer(
	CustTitle := 1,
	FirstName := 'Julie',
	CustInitials := 'A',
	LastName := 'Dewson',
	AddressId := 643,
	AccountNumber := 'SS865',
	AccountTypeId := 7);

--4
create or replace function "CustomerDetails".fn_instransactions()
returns trigger
as $$
begin
	update "CustomerDetails".customers
	set clearebalance = c.clearebalance + (
		select
			case
				when tt.credittype = false then (i.amount *-1)::money
				else (i.amount)::money
			end
		from new as i 
		join "TransactionDetails".transactiontypes as tt
			on tt.transactiontypesid = i.transactiontype
		where tt.affectcashbalance = true)
	from "CustomerDetails".customers as c
	join new as i
		on i.customerid = c.customerid;
	return null;
end;
$$ language plpgsql;

create or replace trigger tg_instransactions
	after insert on "TransactionDetails".transactions
	referencing new table as new
	for each row execute function "CustomerDetails".fn_instransactions();
	
select clearebalance from "CustomerDetails".customers where customerid = 1;

insert into "TransactionDetails".transactions
(customerid, transactiontype, amount, relatedproductid, dateentered)
values (1, 2, 200, 1, current_date);

insert into "TransactionDetails".transactions
(customerid, transactiontype, amount, relatedproductid, dateentered)
values (1, 3, 200, 1, current_date);

create or replace function "CustomerDetails".fn_instransactions()
returns trigger
as $$
begin
	update "CustomerDetails".customers
	set clearebalance = c.clearebalance + coalesce((
		select
			case
				when tt.credittype = false then (i.amount *-1)::money
				else (i.amount)::money
			end
		from new as i 
		join "TransactionDetails".transactiontypes as tt
			on tt.transactiontypesid = i.transactiontype
		where tt.affectcashbalance = true),0::money)
	from "CustomerDetails".customers as c
	join new as i
		on i.customerid = c.customerid;
	return null;
end;
$$ language plpgsql;

