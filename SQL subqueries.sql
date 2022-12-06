use sakila;

-- Query 1: How many copies of the film Hunchback Impossible exist in the 
-- inventory system?
select count(*) as total from inventory
	where film_id = (
					select film_id 
                    from film
					where title = 'Hunchback Impossible'
				 );


-- same query using join
select title, COUNT(inventory_id)
from film f
inner join inventory i 
on f.film_id = i.film_id
where title = "Hunchback Impossible";


-- Query 2: List all films whose length is longer than the average of all the films.
select * from film
where length > (select avg(length) from film
order by length asc
);


-- Query 3: Use subqueries to display all actors who appear in the film Alone Trip.
select last_name, first_name from actor
 where actor_id in (
	select actor_id from film_actor
    where film_id in (
		select actor_id from film
        where title = 'Alone Trip')
	);
    
-- same Query using joins
select f.film_id, fa.actor_id, a.first_name, a.last_name, f.title from film as f
join film_actor as fa
using(film_id)
join actor as a
using(actor_id)
where title = 'Alone Trip';



-- Query 4: Sales have been lagging among young families, and you wish to target 
-- all family movies for a promotion. Identify all movies categorized as family films
select title from film
where film_id in (
	select film_id from film_category as fc
		where category_id in (
			select category_id from category as c
			  where name = 'Family')
				);
    

-- same query using joins
select f.title, c.name from category as c
join film_category as fa
using(category_id)
join film as f
using(film_id)
where name = 'Family';



-- Query 5: Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify 
-- the correct tables with their primary keys and foreign keys, that will help you 
-- get the relevant information.
select first_name, last_name, email from customer
where address_id in (select address_id from address
where city_id in (select city_id from city
where country_id in (select country_id from country
where country = 'Canada')
));


-- same query using joins
select c.first_name, c.last_name, c.email, co.country from customer as c
join address as a using(address_id)
join city as ci using(city_id)
join country as co using(country_id)
where country = 'Canada';


-- Query 6: Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most 
-- number of films. First you will have to find the most prolific actor and 
-- then use that actor_id to find the different films that he/she starred.

-- step 1
select customer_id, sum(amount) as sum from payment
					group by customer_id
                    order by sum(amount) desc;
                    

-- step 2			
select a.actor_id, concat(a.first_name, ' ', a.last_name) as full_name, f.title  as starred_in_films from actor as a
join film_actor as fa on fa.actor_id=a.actor_id 
join film as f on f.film_id=fa.film_id  
where a.actor_id = (select actor_id from film_actor
					group by actor_id
                    order by count(*) desc
                    limit 1);



-- QUery 7: Films rented by most profitable customer. You can use the 
-- customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments

-- step 1
select customer_id, sum(amount) as sum from payment
					group by customer_id
                    order by sum(amount) desc;
                    
-- step 2 
select customer_id, SUM(amount) as sum from payment
where customer_id in (select customer_id from customer)
group by customer_id
order by sum desc
limit 5;

-- step 3
select p.customer_id, f.film_id from film as f
join inventory as i using(film_id)
join rental as r using(inventory_id)
join payment as p using(customer_id)
where customer_id = (select customer_id from payment
							group by customer_id
							order by sum(amount) desc
                            limit 1);


-- same query using joins
select p.customer_id, sum(p.amount) as sum from film as f
join inventory as i using(film_id)
join rental as r using(inventory_id)
join payment as p using(customer_id)	
join customer as c using(customer_id)
group by customer_id
order by sum(amount) desc
limit 5;



-- Query 8: Get the client_id and the total_amount_spent of those clients 
-- who spent more than the average of the total_amount spent by each client.
select * from payment
where amount > (select avg(amount) from payment)
order by amount
limit 10;

