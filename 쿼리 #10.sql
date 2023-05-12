-- 05/11

SELECT 1 as num, 'abc' as str
UNION all
SELECT 9 , 'xyzaa'
UNION all
SELECT 1 num, 'abc';

-- 고객의 이름,성 / 배우의 이름, 성 같이 띄워주세요. union이용
SELECT 'customer' AS typ, first_name, last_name
FROM customer
UNION 
SELECT 'actor', first_name, last_name
FROM actor
ORDER BY first_name;

SELECT first_name, last_name
FROM (SELECT first_name, last_name
		FROM customer
		UNION 
		SELECT first_name, last_name
		FROM actor) A
ORDER BY A.first_name;

-- 배우, 고객 둘다 이름이(fnm) J or D로 시작하는 사람 리스트
SELECT 'customer' AS typ, first_name, last_name
FROM customer
WHERE first_name REGEXP '^J' AND last_name REGEXP 'D$'
UNION
SELECT 'actor', first_name, last_name
FROM actor
WHERE first_name REGEXP '^J' AND last_name REGEXP 'D$'
ORDER BY first_name;

SELECT A.*
FROM (SELECT 'customer' AS typ, first_name, last_name
FROM customer
UNION
SELECT 'actor', first_name, last_name
FROM actor) A
WHERE A.first_name REGEXP '^[JD]';
-- akljsfkljsflkajsfdlj

SELECT'customer' AS typ, first_name, last_name
		FROM customer
		WHERE first_name REGEXP '^J' AND last_name REGEXP '^D'
		UNION
		SELECT 'actor', first_name, last_name
		FROM actor
		WHERE first_name REGEXP '^J' AND last_name REGEXP '^D';

-- intersect
SELECT A.first_name, A.last_name
FROM (
		SELECT'customer' AS typ, first_name, last_name
		FROM customer
		WHERE first_name REGEXP '^J' AND last_name REGEXP '^D'
		UNION
		SELECT 'actor', first_name, last_name
		FROM actor
		WHERE first_name REGEXP '^J' AND last_name REGEXP '^D'
		) A
GROUP BY A.first_name, A.last_name
HAVING COUNT(1) < 2;

-- -- -- ---------------------------------------------
CREATE TABLE except_a(
id INT UNSIGNED
);

CREATE TABLE except_b(
id INT UNSIGNED
);

INSERT INto except_a
(id)
VALUES
(10),(11),(12),(10),(10);

INSERT INTo except_a
(id)
VALUES
(10),(10);

SELECT *
FROM except_a
UNION
SELECT *
FROM except_b;

-- 6.5.2
SELECT first_name,last_name
FROM actor
WHERE last_name REGEXP '^L'
UNION
SELECT first_name,last_name
FROM customer
WHERE last_name REGEXP '^L';
-- 6.5.3
SELECT first_name,last_name
FROM actor
WHERE last_name REGEXP '^L'
UNION
SELECT first_name,last_name
FROM customer
WHERE last_name REGEXP '^L'
ORDER BY last_name;


CREATE TABLE string_tbl(
	char_fld CHAR(30),
	vchar_fld VARCHAR(30),
	text_fld TEXT
);

INSERT INTO string_tbl
(char_fld,vchar_fld,text_fld)
VALUES
(
	'This is char data',
	'This is varchar data',
	'This is text data'
);

SELECT *, QUOTE(text_fld) from string_tbl; -- QUOTE 이스케이프 문자까지 찍어주는 명령어

UPDATE string_tbl
SET vchar_fld = 'This in a piece of extremely long varchar data';

UPDATE string_tbl
SET vchar_fld = 'This string didn\'t WORK, but it does now';

SELECT @@SESSION.sql_mode; 
-- @@session -> 나의 개인 공간 (저장공간) 
-- 크롬을 키면 유일한 ID를 만든다. 요청을 했는데 처음왔으니까 서버 메모리에서 세션을 만들어서 부여  
-- 5분까지는 세션유지 요청하면 다시 리셋 (예전은 쿠키) PK값으로 서버에서는 구분을 한다. Wep tokken
-- 구분할수있도록 세션이라는 것을 사용한다. 브라우저에서 완전히 껏다가 다시들어가야지 세션이 날라가서
-- 다시 로그인을 할수있음 <-> 웹토큰,JSON,JSP (껏다가 다시켜도 로그인정보가 담겨있으면)
-- pageContext, session, application, request

SET sql_mode='strict'; -- 일반적으로 strict문자이다 (30개의 문자열을 저장함 그이상은 저장 X) <->
--  ansi(30개이상의 문자열을 나타내고 다음 문자열은 잘라버린다.)

SHOW WARNINGS;

SELECT lname,fname, CONCAT(lname, ' ',fname) -- 문자열 합치기
FROM person;

SELECT lname, CHAR_LENGTH(lname) -- 문자열의 길이 LENGTH 보다 CHAR_LENGTH 을 쓰는 이유는 전부다 3byte 로 취급을 한다.
FROM person;

SELECT lname, POSITION('ur'IN lname) -- ur의 위치를 숫자로 나타내준다.
FROM person;

SELECT * FROM string_tbl;

SELECT text_fld, POSITION('n' IN text_fld), LOCATE('n', text_fld, 12)
FROM string_tbl;

SELECT '안녕' = '안녕'
		, 'abc' = 'ABC'
		, 'abc'='cba'
		, STRCMP('abc','ABCC') -- 같은지 아닌지 비교하는 것
		, STRCMP('abc','ab');
		
SELECT
	NAME,
	NAME LIKE '%y',
	NAME REGEXP '^[C]' -- 트루 펄스 판별해주는 것
FROM category;

SELECT first_name || ' ' || last_name OR 1
FROM customer;

SELECT first_name, REPLACE(first_name, 'BA', 'DA') FROM customer;

-- 성에서 PH > TH 바꾸고, NI > NA ====> STETHANAE
SELECT customer_id,first_name
, REPLACE (REPLACE(first_name, 'PH', 'TH'),'NI', 'NA') 
FROM customer
WHERE customer_id = 41;

SELECT 'goodbye world', INSERT('goodbye world',9,0,'cruel ')
, INSERT('goodbye asdf sdfsdf ssdfsdf world',POSITION('world' IN 'goodbye asdf sdfsdf ssdfsdf world'),CHAR_LENGTH('world'),'cls');

-- 영화 제목 빈칸에 NICE 추가해주세요.

SELECT title,INSERT(title,POSITION(' 'IN title),1,' NICE ')
FROM film;

SELECT title, REPLACE(title, ' ', 'NICE')
FROM film;

SELECT title, INSERT(title,LOCATE(' ',title,1),0,' NICE ')
FROM film;

SELECT email, SUBSTRING(email, 3), SUBSTRING(email, 3, 6), SUBSTR(email, 3, 3)
FROM customer;

-- 사용자 이메일 쪼개서 출력 @ 기준으로
SELECT email
,SUBSTRING(email,1,POSITION("@"IN email)-1) AS '아이디'
, SUBSTRING(email,POSITION("@"IN email)+1) AS '사이트'
FROM customer;

SELECT email
,LEFT (email,POSITION("@"IN email)-1)
,right (email, char_length(email) - POSITION("@"IN email))
FROM customer;

SELECT (38 *59) / (78 - (8*6)); -- 가능한 프론트엔드에서 하면 좋다.

SELECT MOD(51,2);

SELECT TRUNCATE(1123.3456, 3), ABS(-10), ABS(10);

SELECT NOW(), CURRENT_DATE(), CURRENT_time(), CURRENT_timestamp();

SELECT CAST('2023-05-11 16:46:30' AS DATETIME)
, CONVERT('2023-05-11 16:46:30', DATETIME);

SELECT DATE_ADD(CURRENT_DATE(),INTERVAL 5 DAY);
SELECT DATE_ADD(NOW(),INTERVAL '03:27:11' HOUR_SECOND);

SELECT * FROM employees
WHERE emp_no = 10001;

UPDATE employees
SET birth_date = DATE_ADD(birth_date, INTERVAL '2-1' YEAR_MONTH)
WHERE emp_no = 10001;

SELECT CURDATE() -- 
		, SYSDATE() -- 시스템의 연도 월 일 시분초
		, WEEKDAY(NOW()) -- 월(0),화(1),수(2),목(3),금(4),토(5),일(6) 
		, DAYNAME(NOW())
		, LAST_DAY(NOW()) -- 그달의 마지막일
		, LAST_DAY('2023-06-11')
		, DATE_SUB(NOW(), INTERVAL '2' YEAR)
		, EXTRACT(MONTH FROM NOW())
		, DATEDIFF('2023-09-20 00:00:00', NOW());
		
-- 7.5.1
SELECT 'Please find the substring in this string', SUBSTR('Please find the substring in this string', 17, 9);
-- 7.5.2
SELECT ABS(-25.76823),sign(-25.76823),ROUND (-25.76823,2); -- 반올림 필요없을때는 truncate
-- 7.5.3
SELECT EXTRACT(MONTH FROM NOW()), Month(NOW());