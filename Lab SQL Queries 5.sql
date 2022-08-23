-- Lab | SQL Queries 5

use sakila;

-- 1 Drop column picture from staff.
alter table staff
drop column picture;

select * from customer;
-- 2 A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select * from customer where first_name = 'TAMMY';
select * from staff;
insert into staff(store_id, first_name, last_name,address_id, username) values
(2,'TAMMY','SANDERS',79, 'Tammy');
-- store_id, address_id and username require non null values, so copy from customer table.

-- 3 Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table.
--  Hint: Check the columns in the table rental and see what information you would need to add there.
select * from rental;

-- You can query those pieces of information. For eg., you would notice that you need customer_id information as well.
-- To get that you can use the following query:

select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- customer_id = 130

-- Use similar method to get inventory_id, film_id, and staff_id.
select staff_id from sakila.staff
where first_name = 'Mike' and last_name = 'Hillyer';
-- staff_id = 1

select * from film
where title = 'Academy Dinosaur';
-- film_id = 1

select inventory_id from sakila.inventory
where film_id = 1 order by last_update desc limit 1;
-- inventory_id = 1

select * from rental;

insert into rental values
(0,curdate(),1,130,curdate(),1,0);

select * from rental order by rental_id desc limit 1;
-- checking if table was updated

-- 4 Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:


-- Check if there are any non-active users
select * from customer where active = 0;

-- Create a table backup table as suggested
drop table if exists deleted_users;
create table deleted_users(
customer_id int unique not null,
email varchar(50) default null,
date date default null
);
select * from deleted_users;

-- Insert the non active users in the table backup table
insert into deleted_users(customer_id,email)
select customer_id, email from customer where active = 0;

-- Delete the non active users from the table customer
delete from customer where active = 0;

-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails 
-- (`sakila`.`payment`, CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE)

SET FOREIGN_KEY_CHECKS=0; -- to disable them
delete from customer where active = 0;
SET FOREIGN_KEY_CHECKS=1; -- to re-enable them