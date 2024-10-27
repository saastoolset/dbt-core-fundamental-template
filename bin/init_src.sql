--create schema
create schema raw;
create schema jaffle_shop;
create schema stripe;


-- create table as SELECT
create table jaffle_shop.customers as 
select * from dev_seeds.customers;

create table jaffle_shop.orders as  
select * from dev_seeds.orders;

create table stripe.payments as  
select * from dev_seeds.payments;
