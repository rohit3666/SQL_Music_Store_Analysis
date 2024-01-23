-- Who is the senior most employee based on job title?
select title,levels from employee
order by levels desc
limit 1
--  Which countries have the most Invoices?
select billing_country,count(*) as Total_invoice from invoice
group by billing_country
order by Total_invoice desc
limit 1
-- What are top 3 values of total invoice?
select total from invoice 
order by total desc
limit 3
-- Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals --
select billing_city,sum(total) as Total_invoice from invoice
group by billing_city
order by Total_invoice desc
limit 1
-- :Who is the best customer? The customer who has spent the most money will be declared the best customer.
-- :Write a query that returns the person who has spent the most money--
SELECT customer_id,first_name,last_name,sum(Total) as Total_spend FROM customer
join invoice using (customer_id)
group by customer_id,first_name,last_name
order by Total_spend desc
limit 1
# Medium#
-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A
select distinct(email),first_name,Last_name from customer c
join invoice i on
c.customer_id=i.customer_id
join invoice_line l on l.invoice_id=i.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
)
order by email;
-- Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands
Select artist.artist_id,artist.name,count(artist.artist_id) as No_of_songs from track
join album on
album.album_id=track.album_id
join artist on
artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id,artist.name
order by No_of_songs desc
limit 10
-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first.
 SELECT name,milliseconds  FROM music_data.track
where milliseconds>(select avg(milliseconds) as avg_track_length from track)
order by milliseconds desc
## hard##
-- Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
with best_selling_artist as (
select artist.artist_id as artist_id,artist.name as artist_name,
sum(invoice_line.quantity *invoice_line.unit_price) as total_sales
from invoice_line
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by artist_id,artist_name
order by total_sales desc
limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by c.customer_id,c.first_name,c.last_name,bsa.artist_name
order by amount_spent desc