--create schema
create schema raw;
create schema jaffle_shop;
create schema stripe;


-- create table as SELECT
create table jaffle_shop.customers as 
select * from jaffle_shop_seeds.customers;

create table jaffle_shop.orders as  
select * from jaffle_shop_seeds.orders;

create table stripe.payments as  
select * from jaffle_shop_seeds.payments;
