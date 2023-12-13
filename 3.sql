--2
CREATE DATABASE "ApressFinancial"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
	LC_COLLATE = 'Russian_Russia.1251'
	LC_CTYPE = 'Russian_Russia.1251'
	tablespace = pg_default
	CONNECTION LIMIT = 1
    IS_TEMPLATE = False;
	
--3
CREATE SCHEMA IF NOT EXISTS "TransactionDetails"
AUTHORIZATION postgres;