--1
CREATE UNIQUE INDEX ix_customers_customerid
    ON "CustomerDetails".customers USING btree
    (customerid ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
	
--2
create index ix_customerproducts
	on "CustomerDetails".customersproducts (CustomerId);
	
create unique index ix_transactiontypes
	on "TransactionDetails".transactiontypes
	using btree
	(transactiontypesid ASC);

create index ix_transactions_ttypes
	on "TransactionDetails".transactions
	using btree
	(TransactionType ASC);
	
--3
drop index "TransactionDetails".ix_transactiontypes;

create unique index ix_transactiontypes
	on "TransactionDetails".transactiontypes
	using btree
	(transactiontypesid ASC);


--4
create unique index ix_shareprices
	on "ShareDetails".shareprices (ShareID ASC, PriceDate ASC);
	
--create unique index ix_shareprices
--	on "ShareDetails".shareprices (ShareID ASC, PriceDate DESC);

drop index if exists "ShareDetails".ix_shareprices;
create unique index ix_shareprices
	on "ShareDetails".shareprices (ShareID ASC, PriceDate DESC);
