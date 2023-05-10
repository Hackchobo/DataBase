SELECT title
FROM film
WHERE rating = 'G' and rental_duration >= 7;


-- select from where group having order-by limit

-- 등급이 'G'면서 빌릴 수 있는 기간이 7일 이상인 레코드


-- 등급이 'G'면서 빌릴 수 있는 기간이 7일 이상인 레코드
-- 혹은 등급이 'PG-13'이면서 빌릴 수 있는  기간이 4미만인
-- 모든 레코드, 컬럼은 (제목, 등급, 빌릴수있는 기간)

SELECT title, rating ,rental_duration
FROM film
WHERE (rating = 'G' and rental_duration >=7) 
OR (rating = 'PG-13' and rental_duration < 4);

-- group by

-- group function 그룹함수
-- sum, avg, min, max, count
SELECT * FROM customer;
SELECT store_id, COUNT(*)  FROM customer
GROUP BY store_id -- 레코드를 제외시키고 싶을때
HAVING COUNT(*) < 300; -- 그룹을 제외 시키고싶을때

-- amount는 판매금액, 직원별 평균 판매금액 알고 싶다.
SELECT concat(B.first_name,' ',B.last_name) AS '네년의 이름',SUM(A.amount),Avg(A.amount)
FROM payment A
INNER JOIN staff B
ON A.staff_id = B.staff_id
GROUP BY A.staff_id;

SELECT COUNT(*), SUM(active)
, COUNT(*) - SUM(active)
, MAX(address_id)
, MIN(address_id)
,FLOOR(AVG(address_id))
FROM customer;

SELECT store_id, COUNT(*)
FROM customer
WHERE active = 1
GROUP BY store_id
HAVING COUNT(*) >= 300;



-- 3.8.1 
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name, first_name;

-- 3.8.2
SELECT actor_id, first_name, last_name
FROM actor
WHERE (last_name = 'WILLIAMS' OR last_name ='DAVIS');
-- WHERE last_name IN ('WILLIAMS','DAVIS');

-- 3.8.3
SELECT distinct customer_id
FROM rental
WHERE DATE(rental_date)  = '2005-07-05';

-- 3.8.4
SELECT c.email, r.return_date
FROM customer c
	INNER JOIN rental r 
	ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;



SELECT * FROM customer
WHERE first_name = 'STEVEN'
or create_date > '2006-01-01';

-- 이름은 STEVEN이고 , 생성 날짜는 2006년1월1일 또는 그이전

SELECT * FROM customer
WHERE first_name = 'STEVEN'
and create_date <= '2006-01-01';

-- 이름은 STEVEN이 아니지만, 생성 날짜는 2006년 1월 1일 이후

SELECT * FROM customer
WHERE first_name != 'STEVEN' -- 값은 대소문자를 구분한다.
AND create_date > '2006-01-01';

-- 이름은 STEVEN이 아니거나 성이 'YOUNG' 인 사람중에
-- 생성날짜가 2006년 1월 1일 이후인 사람들

SELECT *
FROM customer
WHERE (first_name !='STEVEN' or last_name = 'YOUNG')
AND create_date > '2006-01-01';

-- 이름은 STEVEN이 아니거나 성이 'YOUNG' 아닌 사람중에
-- 생성날짜가 2006년 1월 1일 이후인 사람들

SELECT *
FROM customer
WHERE NOT (first_name = 'STEVEN' OR last_name = 'YOUNG')
AND create_date > '2006-01-01';

-- file_id: 762 , 대여기간보다 짧은 영화만 알고 싶다.
SELECT * FROM film
WHERE rental_duration<(SELECT rental_duration
								FROM film
								where film_id =762);

SELECT 6;

SELECT rental_duration
FROM film
where film_id = 762 ;

-- '2005-06-14'일날 rental한 사람들의 이메일을 알고싶다.

SELECT distinct A.email
FROM customer A
INNER JOIN rental B 
ON A.customer_id = B.customer_id
WHERE Date(rental_date) = '2005-06-14'
ORDER BY A.email;

-- 렌탈정보, 2004,2005 년을 제외한 렌탈정보를 알고 싶다.

SELECT *
FROM rental A
WHERE YEAR(A.rental_date) NOT IN(2004,2005) ;


SELECT YEAR('2006-02-14 15:16:03');

-- 2005-06-14 ~ 16 사이의 렌탈 정보 알고싶다.

SELECT *
FROM rental
WHERE DATE(rental_date) BETWEEN '2005-06-14' AND '2005-06-16';

-- 고객 성이 'FA' 와 'FR' 사이에 속하는 사람이 알고 싶다.

SELECT *
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FR';


SELECT '김고은'  <'김고운' ;

-- 영화 등급이 'G' 혹은 'PG' 인 영화 정보 알고 싶다.

SELECT *
FROM film
WHERE rating IN ('G','PG');

-- 제목에 PET이 포함된 영화와 같은 등급을 가진 영화가 궁금하다.

SELECT *
FROM film
WHERE rating IN (
	SELECT DISTINCT rating
	FROM film
	WHERE title LIKE '%PET%'
);


-- 등급이 'PG-13', 'R', 'NC-17'이 아닌 영화 정보 알고 싶다.

SELECT *
FROM film
WHERE rating not IN ('PG-13', 'R', 'NC-17');

SELECT LEFT('abcdefg',2) , RIGHT('abcdefg',2), MID('abcdefg',2,3);

-- 문자함수 이용하여 고객 성이 'Q'로 시작하는 사람 궁금하다.

SELECT *
FROM customer
WHERE LEFT(last_name,1)='Q';

SELECT *
FROM customer
WHERE last_name LIKE 'Q%';