-- 05/12
SELECT customer_id, COUNT(1) FROM rental
GROUP BY customer_id
ORDER BY COUNT(1) DESC;

-- limit(1), limist(1,1) 

SELECT * FROM rental
ORDER BY rental_id desc
LIMIT 2, 3;

-- join 이용하여 사용자 이름 찍어주세요.
SELECT  B.first_name, B.last_name, A.customer_id, COUNT(1) cnt
FROM rental A
INNER JOIN customer B
on A.customer_id = B.customer_id
GROUP BY A.customer_id
ORDER BY COUNT(1) DESC
LIMIT 1;

SELECT B.customer_id, B.first_name, B.last_name, A.cnt
from
(
	select customer_id, COUNT(1) cnt
	FROM rental 
	GROUP BY customer_id
	ORDER BY 2 DESC -- > 설렉트 구문(컬럼)에서 2번째기준으로 한다는 뜻이다.
	LIMIT 1
) A
INNER JOIN customer B
ON A.customer_id = B.customer_id;

-- 가장 적게 빌린 사람의 pk, 이름, 빌린 수
SELECT B.customer_id, B.first_name, B.last_name, A.cnt
FROM(
	select customer_id, COUNT(1) cnt
	FROM rental 
	GROUP BY customer_id
	ORDER BY COUNT(1)
	LIMIT 1
)A
INNER JOIN customer B
ON A.customer_id = B.customer_id;

SELECT customer_id, COUNT(1) vovo
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

-- 렌탈횟수가 40회이상인 사람들 pk, 이름, 성, 렌탈수
SELECT B.customer_id,B.first_name,B.last_name, COUNT(1) cnt
FROM rental A
JOIN customer B
ON A.customer_id = B.customer_id
GROUP BY B.customer_id
HAVING COUNT(1) >= 40;

SELECT B.customer_id,B.first_name,B.last_name, A.cnt
FROM(
	SELECT customer_id,COUNT(1) cnt
	FROM rental
	GROUP BY customer_id
	HAVING cnt >=40
) A
INNER JOIN customer B
ON A.customer_id = B.customer_id
ORDER BY A.cnt;

-- max, min, avg, count, sum

SELECT customer_id
, MAX(amount), MIN(amount)
, AVG(amount), SUM(amount) / COUNT(amount) -- 평균값이 sql에서 오류가 많이 난다.
FROM payment
GROUP BY customer_id;

SELECT COUNT(customer_id)
, COUNT(DISTINCT customer_id)
FROM payment;

SELECT COUNT(1)
FROM customer;

SELECT *
FROM rental
WHERE return_date IS NULL;

SELECT COUNT(*), COUNT(return_date), COUNT(1)
FROM rental
WHERE return_date IS NULL;

SELECT MAX(DATEDIFF(return_date, rental_date))
FROM rental;

-- 제일 늦게 반납한 사람 정보, pk, 이름, 성 
SELECT B.customer_id, B.first_name, B.last_name, max(DATEDIFF(return_date, rental_date))
FROM rental A
inner JOIN customer B
ON A.customer_id = B.customer_id;

SELECT B.last_name, B.first_name, B.customer_id
FROM(
	SELECT DISTINCT customer_id
	FROM rental
	WHERE DATEDIFF(return_date, rental_date) =
		(
			SELECT MAX(DATEDIFF(return_date, rental_date))
			FROM rental
		)
)A
INNER JOIN customer B
ON A.customer_id = B.customer_id
ORDER BY B.customer_id;

-- 배우의 등급별 출연 횟수
SELECT A.actor_id, B.rating, COUNT(1) cnt
FROM film_actor A
JOIN film B
ON A.film_id = B.film_id
GROUP BY A.actor_id, B.rating -- 그룹 바이를 다중 그룹으로 하면 기준이 똑같아야 된다.
ORDER BY cnt DESC; -- 이것까지 하면 한영화 배우가 어디 등급에 가장많이 출연했는지 알수있게 된다.

-- 배우의 카테고리별 출연횟수
SELECT A.category_id, COUNT(1) cnt
FROM category A
JOIN film_category B
ON A.category_id= B.category_id
GROUP BY A.category_id;

SELECT A.actor_id,D.first_name,D.last_name, B.category_id,C.name, COUNT(1) cnt
FROM film_actor A
JOIN film_category B
ON A.film_id = B.film_id
JOIN category C
ON B.category_id = C.category_id
JOIN actor D
ON A.actor_id = D.actor_id
GROUP BY A.actor_id, B.category_id;

-- 서브 쿼리 이용
SELECT C.actor_id,D.first_name,D.last_name, C.category_id, COUNT(1) cnt
FROM (SELECT A.actor_id,B.category_id, COUNT(1) cnt
		FROM film_actor A
		JOIN film_category B
		ON A.film_id = B.film_id
		GROUP BY A.actor_id,B.category_id
)C
JOIN actor D
ON C.actor_id = D.actor_id
GROUP BY C.actor_id, C.category_id;

-- 정호씨 코드
SELECT A.actor_id,B.category_id, COUNT(1) cnt
FROM film_actor A
JOIN film_category B
ON A.film_id = B.film_id
GROUP BY A.actor_id,B.category_id;

-- 연도별 렌탈 횟수 궁금쓰...
SELECT  CONCAT(year(rental_date),'년') AS `연도`,count(1) `갯수`
FROM rental 
GROUP BY year(rental_date);

-- 롤업생성
SELECT fa.actor_id, f.rating, COUNT(1) AS cnt
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY fa.actor_id,f.rating WITH ROLLUP; -- actor_id의 PK값의 rating에는 null값이 들어간다.
-- null값의 의미는 PK값의 전체 합계이다.

-- 배우의 등급('G', 'PG') 별 출연 횟수가 궁금함, 출연횟수가 9초과인 actor_id 궁금쓰
SELECT A.actor_id, B.rating, COUNT(A.actor_id) cnt
FROM film_actor A
JOIN film B
ON A.film_id = B.film_id
WHERE B.rating IN('G','PG') 
GROUP BY A.actor_id, B.rating 
HAVING COUNT(1)>9
ORDER BY COUNT(A.actor_id);
-- 선생님 코드
SELECT A.actor_id, B.rating, COUNT(A.actor_id) cnt
FROM film_actor A
JOIN film B
ON A.film_id = B.film_id
GROUP BY A.actor_id, B.rating 
HAVING B.rating IN('G','PG') and COUNT(1)>9
ORDER BY COUNT(A.actor_id);

-- 8.5.1
SELECT COUNT(1) FROM payment;
-- 8.5.2
SELECT customer_id, COUNT(1) cnt, SUM(amount)
FROM payment
GROUP BY customer_id WITH rollup;
-- 8.5.3
SELECT customer_id, COUNT(1) cnt, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING cnt>=40;