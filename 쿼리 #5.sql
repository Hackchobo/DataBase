SELECT 
	A.rental_id, A.rental_date, IFNULL (A.return_date, '반납안했음') AS return_date
	, A.customer_id
	, B.first_name, B.last_name
FROM rental A
INNER JOIN customer B 
ON A.customer_id = B.customer_id
WHERE return_date IS NOT null
ORDER BY rental_date DESC;

DESC rental;


SELECT B.customer_id, B.first_name, B.last_name
FROM customer B;