-- 5/15

-- 가장 나중에 가입한 고객의 pk, 이름, 성 출력하시오.

SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 1;

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (
	SELECT MAX(customer_id)
	FROM customer
);

-- 도시 id, 도시명 > India(인도) 나라가 아닌 나라들의 도시id, 도시명
SELECT *
FROM country
WHERE country != 'India';


SELECT city_id, city
FROM city A
JOIN (SELECT *
	FROM country
	WHERE country != 'India'
	) B
on A.country_id = B.country_id;

SELECT city_id, city
FROM city
WHERE country_id != (
	SELECT country_id 
	FROM country 
	WHERE country = 'India'
);

-- Canada, Mexico의 도시 id, 도시명을 출력
SELECT *
FROM country
WHERE country IN('Canada','Mexico');

SELECT A.city_id, A.city
FROM city A
JOIN (SELECT *
	FROM country
	WHERE country IN('Canada','Mexico')
	) B
on A.country_id = B.country_id;

SELECT city_id, city
FROM city
WHERE country_id in
(
	SELECT country_id
	FROM country
	WHERE country IN ('Canada','Mexico')
);

-- all 연산자
SELECT * FROM payment
WHERE amount = 0;

SELECT*
FROM customer
WHERE customer_id != ALL(
SELECT customer_id
FROM payment
WHERE amount = 0);

-- United States, Maxico, Canada 에 거주하는 소비자의 렌탈 횟수보다 많이
-- 렌탈한 사람들의 고객 id, 횟수
SELECT * FROM view_test_1;

DROP VIEW view_test_1;

CREATE VIEW view_test_1 as
SELECT customer_id, COUNT(customer_id)
FROM rental
GROUP BY customer_id
HAVING COUNT(customer_id) > ALL(
	SELECT COUNT(customer_id)
	FROM rental
	WHERE customer_id IN
	(
		SELECT customer_id
		FROM customer
		WHERE address_id IN
		(
			SELECT address_id
			FROM address
			WHERE city_id IN(
				SELECT city_id
				FROM city
				WHERE country_id IN(
					SELECT country_id
					FROM country
					WHERE country IN ('United States', 'Maxico', 'Canada')
				)
			)
		)
	) 
	GROUP BY customer_id
);

-- 배우 성이 'MONROE' 인 사람이 PG 영화등급에 출연했다. 배우id, 영화id가 궁금.

SELECT A.actor_id, C.film_id
FROM actor A
INNER JOIN film_actor B
ON A.actor_id = B.actor_id
INNER JOIN film C
ON B.film_id = C.film_id
WHERE A.last_name = 'MONROE'
AND C.rating = 'PG';

SELECT * FROM actor
WHERE (first_name, last_name) IN
		(
			SELECT first_name, last_name
			FROM actor
			WHERE last_name = 'MONROE'
		);
		

-- case 문
SELECT active,
	case
		when active = 1  -- 조건문
		then '활성화' -- 조건이 true 일경우 
		ELSE '비활성화' -- 조건이 falsr 일 경우 
	END as active_str -- 끝난 조건의 출력
	, if(active = 1, '활성화', '비활성화') as active_str2
FROM customer;

-- PG,G 전체이용, NC-17 17세 이상,PG-13 13세이상,R은 청소년관람불가
SELECT rating,
	case
		when rating IN ('PG','G') then '전체이용가'
		when rating = ('NC-17') then '17세 이상'
		when rating = ('PG-13') then '13세 이상'
		ELSE '청소년 관람불가'
	END rating_str
FROM film
ORDER BY rating;

SELECT *,
	case rating when 'PG' then '전체 이용'
					when 'G' then '전체 이용'
					when 'NC-17' then '17세 이상'
					when 'PG-13' then '12세 이상'
			ELSE '청소년 관람불가'
		END rating_str
	FROM film;
	
-- first_name / last_name / num_rentals (active = 0 > 0)
SELECT A.first_name, A.last_name,
	case 
	when active = 0 then active
	ELSE COUNT(B.customer_id)
	END num_rentals,active
	FROM customer A
	INNER JOIN(SELECT customer_id
	FROM rental)B
	ON A.customer_id = B.customer_id
	GROUP BY A.customer_id;
	
-- 선생님 코드
SELECT B.first_name, B.last_name
	, case B.active when 0 then 0
		ELSE COUNT(A.customer_id)
		END num_rentals
	, B.active
	,COUNT(A.customer_id)
FROM rental A
INNER JOIN customer B
ON A.customer_id = B.customer_id
GROUP BY A.customer_id;


SELECT c.first_name, c.last_name
		, case when active = 0 then 0
				ELSE (
						SELECT COUNT(*) FROM rental r
						WHERE r.customer_id = c.customer_id
				)
		END num_rentals
FROM customer c;

-- rental 테이블에서 2005-05 ~ 08월 각 달의 렌탈 수
SELECT year(rental_date),month(rental_date), COUNT(1)
		, case when MONTH(rental_date) = 2 then 2
		END 
FROM rental
GROUP BY year(rental_date),month(rental_date);

SELECT DATE_FORMAT(rental_date, '%Y-%m') mon , COUNT(rental_date) cnt
FROM rental
WHERE DATE_FORMAT(rental_date, '%Y-%m') BETWEEN '2005-05' AND '2005-07'
GROUP BY mon;  

-- 화면단, 자바단, DB단 > MVC 패턴
-- M : Model > DB
-- V : View >프론트엔드
-- C : Controller > java

SELECT 
SUM(
	case DATE_FORMAT(rental_date, '%Y-%m') when '2005-05' then 1 ELSE 0 end
) may_rentals

, SUM(
	case DATE_FORMAT(rental_date, '%Y-%m') when '2005-06' then 1 ELSE 0 end
) june_rentals

, SUM(
	case DATE_FORMAT(rental_date, '%Y-%m') when '2005-07' then 1 ELSE 0 end
) july_rentals
FROM rental
WHERE DATE_FORMAT(rental_date, '%Y-%m') BETWEEN '2005-05' AND '2005-07'
GROUP BY rental_date;


