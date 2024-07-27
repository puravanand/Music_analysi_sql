--Q1. Who is the senior most employee based on job title ?
--based on the levels we can identified senior employee

select *  from employee
order by levels desc
limit 1

--Q2. Which country have most invoices ?
--based on grouped and then count on billing_country
	
select count(billing_country),"billing_country" from invoice 
group by "billing_country" 
order by "billing_country" desc

--Q3. What are top 3 values of total invoice ?
select * from invoice 
order by "total" desc
limit 3

--Q4. Which city has the best customer ? We would like to throw
--a music festival in the city where we made the most money.Write
--query that returns a one city which have highest sum of invoice
--total ?
	
select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total  desc

select * from invoice_line

--Q5. Who is the best customer. The customer who spent a lot of money will be the best customer
--Write a query that returnz the person who spent the most money

select customer.customer_id,customer.first_name,customer.last_name,
sum(invoice.total) as total
from customer
join invoice 
on customer.customer_id= invoice.customer_id
group by customer.customer_id
order by total desc limit 1

--Q6.Write the query to return the first name ,last name and Genre of all rock music listener
-- return your list order by alphabatically on the basis of email staring with A
select  distinct email,first_name , last_name
from customer 
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id=genre.genre_id
	where genre.name = 'Rock'
	
)	
order by email;


--Q7. Let's invite the artist who have written the most of the songs in our dataset.Write the 
--query that written the artist name and the no. of track counts
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

--Q8.Return all the track name having song length greater than the average length
--retunr the name and milliseconds of each track.Order by song length with longest song 
--listed first

select name ,milliseconds from track 
where milliseconds >(
	select avg(milliseconds	) from track
)
order by milliseconds desc;

--Q9.Find how much amount spent by the each customer on artist. Return the artist name,
--customer name and total sales

with best_selling_artist as(
select artist.artist_id as artist_id ,artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by 1
order by 3 desc
limit 1
)

select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity)as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc


