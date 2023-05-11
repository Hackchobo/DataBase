-- 05/10

SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

-- KIRK.STCLAIR@sakilacustomer.org
-- 고객 중에 이메일값이 다섯째에 . 이있고 13번째 @인 사람
SELECT *
FROM customer
-- where email like '____.________@%'
WHERE email LIKE '____.%' AND mid(email, 13,1) = '@';

-- 이메일이 Q, Y로 시작하는 사람들 알고 싶어.

SELECT * FROM customer
WHERE last_name REGEXP '^[QY]';

SELECT *
FROM customer
WHERE left(last_name,1) = 'Q' OR last_name LIKE 'Y%';

-- 성이 Q,Y로 끝나는 사람들 알고 싶다.
SELECT * FROM customer
WHERE last_name REGEXP '[LY]$';

SELECT * FROM rental
WHERE return_date IS NULL;

-- 반납일이 '2005-05' ~ '2005-08'이 아닌 렌탈 정보 알고 싶다.
SELECT *
FROM rental
WHERE date(return_date) not BETWEEN '2005-05-01' and '2005-08-31'
OR return_date IS NULL;

-- 4.5.1
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE payment_id BETWEEN 101 AND 120
AND customer_id != 5 AND(amount > 8 OR DATE(payment_date) = '2005-08-23');

-- 4.5.2
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE payment_id BETWEEN 101 AND 120
AND customer_id = 5 AND not(amount > 6 OR DATE(payment_date) = '2005-06-19');

-- 4.5.3
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE amount IN('1.98','7.98','9.98');

-- 4.5.4
SELECT *
FROM customer
WHERE last_name LIKE '_A%W%';

SELECT* FROM person;

SELECT A.food, A.person_id, B.person_id,B.fname,B.lname
FROM favorite_food A
INNER JOIN person B
ON A.person_id = B.person_id;

SELECT *
FROM person A -- 얘가 기준이 된다. 얘가 나오는 것 보장이 된다.
LEFT JOIN favorite_food B
ON A.person_id = B.person_id; -- 연결시킬게 없다면 null 값을 반환한다.

-- 고객 id, 이름, 성 , address, district 값이 나오는 쿼리문 완성.
SELECT A.customer_id,A.first_name,A.last_name,B.address,B.district
FROM customer A
INNER JOIN address B
ON A.address_id = B.address_id;

SELECT A.customer_id,A.first_name,A.last_name,B.address,B.district
FROM customer A, address B
where A.address_id = B.address_id; -- no권장이다.

-- 고객 id, 이름, 성 , 도시명 나오는 쿼리문 완성.
SELECT A.customer_id,A.first_name,A.last_name,C.city
FROM customer A
INNER JOIN address B
ON A.address_id = B.address_id
INNER JOIN city C
ON B.city_id = C.city_id;

-- 'California' 값만 알고 있다. 미국 주중에 California 에 사는 소비자
-- 정보를 알고 싶다.
SELECT * 
FROM customer A
INNER JOIN address B
ON A.address_id = B.address_id
WHERE B.district = 'California';

SELECT * FROM customer
WHERE address_id IN(
	SELECT address_id FROM address
	WHERE district = 'California'
);

SELECT * FROM customer A
INNER join(
	SELECT address_id FROM address
	WHERE district = 'California'
)B
ON A.address_id = B.address_id;

-- 배우이름 CATE MCQUEEN, CUBA BIRCH
SELECT *
FROM actor
WHERE  CONCAT(first_name, ' ' , last_name) IN('CATE MCQUEEN','CUBA BIRCH');


SELECT distinct C.*
FROM film_actor A
INNER JOIN(
	SELECT * 
	from actor
	WHERE  CONCAT(first_name, ' ' , last_name) 
	IN('CATE MCQUEEN','CUBA BIRCH')
)B
ON A.actor_id = B.actor_id
INNER JOIN film C
ON A.film_id = C.film_id;
-- 내가 만든 소스 (서브쿼리 사용)
SELECT * FROM actor
WHERE (first_name, last_name) IN (('CATE', 'MCQUEEN'), ('CUBA', 'BIRCH'));

SELECT * FROM film.actor;

SELECT DISTINCT C.* FROM actor A
INNER JOIN film_actor B
ON A.actor_id = B.actor_id
INNER JOIN film C
ON B.film_id = C.film_id
WHERE (first_name, last_name) IN (('CATE', 'MCQUEEN'), ('CUBA', 'BIRCH'))
ORDER BY film_id;
-- 선생님 코드

SELECT *
FROM film F
INNER JOIN
(
	SELECT B.film_id FROM actor A
	INNER JOIN film_actor B
	ON A.actor_id = B.actor_id
	WHERE (A.first_name, A.last_name) IN (('CATE', 'MCQUEEN'), ('CUBA', 'BIRCH'))
	GROUP BY B.film_id
	HAVING COUNT(*) = 2
) S
ON S.film_id = F.film_id;

-- 선생님 코드 (중복되는 값을 찾아내서 나타내주기)

-- 5.4.1
SELECT C.first_name, C.last_name, A.address, CT.city
FROM customer C
	inner JOIN address A
	ON C.address_id = A.address_id
	INNER JOIN city CT
	ON A.city_id = CT.city_id
	WHERE A.district = 'California';

-- 5.4.2
SELECT actor_id, first_name
FROM actor
WHERE first_name = 'JOHN';

SELECT C.*
FROM film_actor A
INNER JOIN actor B
ON A.actor_id = B.actor_id
INNER JOIN film C
ON A.film_id = C.film_id
WHERE B.first_name = (SELECT first_name
FROM actor
WHERE first_name = 'JOHN');

-- 5.4.3
SELECT a1.address addr1, a2.address addr2, a1.city_id, a2.city_id
FROM address a1
INNER JOIN address a2
ON a1.city_id = a2.city_id
WHERE a1.address_id <> a2.address_id;

SELECT address FROM address
WHERE city_id IN (
	SELECT city_id FROM address
	GROUP BY city_id
	HAVING COUNT(1) > 1
);

