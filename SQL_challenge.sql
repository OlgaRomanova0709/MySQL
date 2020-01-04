use sakila;
#1a
select first_name,last_name from actor;
#1b
select concat(first_name," ",last_name) as 'Actor Name' from actor;
#2a
select *  from actor where first_name="Joe";
#2b
select *  from actor where last_name like '%GEN%';
#2c
select last_name,first_name from actor where last_name like '%LI%';
#2d
select country_id,country from country where country in ('Afghanistan', 'Bangladesh', 'China');
#3a
alter table actor add column description blob;
#3b
alter table actor drop column description;
#4a
select last_name,count(*) as 'how many actors have that last name' from actor group by last_name;
#4b
select last_name,count(*) as 'how many actors have that last name'  from actor group by last_name having count(*)>1;
#4c
update actor set first_name='HARPO' where last_name='WILLIAMS' and first_name='GROUCHO';
select first_name, last_name from actor where last_name='WILLIAMS' ;
#4d
update actor set first_name='GROUCHO' where last_name='WILLIAMS' and first_name='HARPO';
select first_name,last_name from actor where last_name='WILLIAMS' ;
#5a
select  * from information_schema.columns
where table_name='address';

show create table address;
CREATE TABLE address(
   address_id  smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   address varchar(50) NOT NULL,
   address2 varchar(50) DEFAULT NULL,
   district varchar(20) NOT NULL,
   city_id smallint(5) unsigned NOT NULL,
   postal_code varchar(10) DEFAULT NULL,
   phone varchar(20) NOT NULL,
   location geometry NOT NULL,
   last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (address_id),
   KEY idx_fk_city_id (city_id),
   SPATIAL KEY idx_location (location),
   CONSTRAINT fk_address_city
   FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#6a
select staff.first_name, staff.last_name,address.address 
from staff 
join address on staff.address_id=address.address_id;
#6b
select staff.first_name, staff.last_name,sum(payment.amount)
from staff
join payment on staff.staff_id=payment.staff_id
where payment.payment_date  like '2005-08-%'
group by payment.staff_id; 
#6c
select film.title, count(film_actor.actor_id)
from film
inner join film_actor on film.film_id=film_actor.film_id
group by film_actor.film_id;
#6d
select film.title, count(inventory.inventory_id) as 'Copies of the film'
from film
join inventory on film.film_id=inventory.film_id
where film.title="Hunchback Impossible"
group by inventory.film_id;
#6e
select customer.first_name, customer.last_name, sum(payment.amount)
from customer
join payment on customer.customer_id=payment.customer_id
group by payment.customer_id
order by customer.last_name;
#7a
select title from film
where (title like 'K%' or title like 'Q%') and  language_id in
	(select language_id from language
    where name='English'
    );
#7b
select first_name, last_name from actor
where actor_id in
	(select actor_id from film_actor
    where film_id in
		(select film_id from film
        where title='Alone Trip'
        )
	);
#7c 
select first_name,last_name,email from customer
join address using (address_id)
join city using (city_id)
join country using (country_id)
where country.country='Canada';
#7d
select title from film
where film_id in
	(select film_id from film_category
    where category_id in
		(select category_id from category
        where name='Family'
        )
	);
#7e
select title,count(title) from film


inner join inventory using (film_id)
inner join rental using (inventory_id)
group by title
order by count(title) desc;
#7f
select address.address as 'store adress',sum(amount) as 'business in dollars' from payment
join rental using (rental_id)
join inventory using (inventory_id)
join store using (store_id)
join address using (address_id)
group by store.store_id;
#7g
select store.store_id,city.city,country.country from store
join address using (address_id)
join city using (city_id)
join country using (country_id)
group by store.store_id;
#7h

select category.name as 'genres' ,sum(amount) as 'gross revenue' from payment
join rental using (rental_id)
join inventory using (inventory_id)
join film_category using (film_id)
join category using (category_id)
group by category.name
order by sum(amount) desc limit 5;

#8a
create view top_five_genres as
select category.name as 'genres' ,sum(amount) as 'gross revenue' from payment
join rental using (rental_id)
join inventory using (inventory_id)
join film_category using (film_id)
join category using (category_id)
group by category.name
order by sum(amount) desc limit 5;

#8b
select  * from top_five_genres;
#8c
drop view top_five_genres;
