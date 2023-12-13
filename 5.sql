--1
CREATE TABLE IF NOT EXISTS "CustomerDetails".customers
(
    customerid bigint NOT NULL,
    customertitleid integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    customerfirstname character varying(50)[] COLLATE pg_catalog."default" NOT NULL,
    customerotherinitials character varying(10)[] COLLATE pg_catalog."default",
    customerlastname character varying(50)[] COLLATE pg_catalog."default" NOT NULL,
    addressid bigint NOT NULL,
    accountnumber character(15)[] COLLATE pg_catalog."default" NOT NULL,
    accounttypeid integer NOT NULL,
    clearebalance money NOT NULL,
    unclearebalance money NOT NULL,
    dateadded date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT customers_pkey PRIMARY KEY (customerid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "CustomerDetails".customers
    OWNER to postgres;

COMMENT ON TABLE "CustomerDetails".customers
    IS 'customers in db we don''t know why in this lab';
	
--2
create table "TransactionDetails".transactions (
	transactionid bigint generated always as identity (increment 1 start 1)
		primary key not NULL,
	customerid bigint not NULL,
	transactiontype int not NULL,
	dateentered timestamp(0) not NULL,
	amount numeric(18,5) not NULL,
	referencedetails varchar(50) NULL,
	notes varchar(50) NULL,
	relatedshareid bigint NULL,
	relatedproductid bigint not NULL
);
create table "TransactionDetails".transactiontypes
(
	transactiontypesid int generated always as identity not NULL,
	transactiondescription varchar(30) not NULL,
	credittype boolean not NULL
);

--3
alter table "TransactionDetails".transactiontypes
	add affectcashbalance boolean NULL;
	
alter table "TransactionDetails".transactiontypes
	alter column affectcashbalance set not NULL;
	
alter table "TransactionDetails".transactiontypes
	add constraint PK_TransactionTypes primary key (transactiontypesid);

--4
create table "CustomerDetails".customersproducts
(
	customerfinancialproductid bigint generated always as identity not NULL,
	customerid bigint not NULL,
	financialproductid bigint not NULL,
	ammounttocollect money not NULL,
	frequency int not NULL,
	lastcollected timestamp(0) not NULL,
	lastcollection timestamp(0) not NULL,
	renewable boolean not NULL
);

create table "CustomerDetails".financialproducts
(
	productid bigint not NULL,
	productname varchar(50) not NULL
);

create schema "ShareDetails" authorization postgres;

create table "ShareDetails".shareprices
(
	sharepriceid bigint generated always as identity not NULL,
	shareid bigint not NULL,
	price numeric(18,5) not NULL,
	pricedate timestamp(0) not NULL
);

create table "ShareDetails".shares
(
	shareid bigint generated always as identity not NULL,
	sharedesc varchar(50) not NULL,
	sharetickerid varchar(50) NULL,
	currentprice numeric(18,5) not NULL
);

--5
ALTER TABLE IF EXISTS "TransactionDetails".transactions
    ADD CONSTRAINT fk_customers_transactions FOREIGN KEY (customerid)
    REFERENCES "CustomerDetails".customers (customerid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS fki_fk_customers_transactions
    ON "TransactionDetails".transactions(customerid);
	
--6
alter table "ShareDetails".shares
    add constraint unique_shareid unique (shareid);
	
alter table "TransactionDetails".transactions
	add constraint fk_transactions_shares foreign key (relatedshareid)
	references "ShareDetails".shares(shareid);
