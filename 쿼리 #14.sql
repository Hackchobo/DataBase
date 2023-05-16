CREATE TABLE t_deal(
	id int UNSIGNED AUTO_INCREMENT,
	deal_date DATE NOT NULL,
	price INT UNSIGNED NOT NULL,
	PRIMARY KEY (id)
);
ALTER TABLE t_deal MODIFY price INT NOT NULL DEFAULT 0;

DROP TABLE t_deal_sub;
CREATE TABLE t_deal_sub(
	deal_id INT UNSIGNED,
	seq INT UNSIGNED,
	provider_cd CHAR(1) NOT null,
	parts_id INT UNSIGNED NOT NULL,
	quantity INT UNSIGNED NOT NULL,
	PRIMARY KEY(deal_id, seq),
	FOREIGN KEY(provider_cd) REFERENCES t_provider(cd),
	FOREIGN KEY(parts_id) REFERENCES t_parts(id),
	FOREIGN KEY(deal_id) REFERENCES t_deal(id)
);


CREATE TABLE t_provider(
	cd CHAR(1) PRIMARY KEY,
	nm VARCHAR(10) NOT NULL
);

CREATE TABLE t_parts(
	id INT UNSIGNED AUTO_INCREMENT primary KEY,
	nm VARCHAR(10) NOT NULL,
	price INT UNSIGNED NOT NULL
);

-- 공급자 테이블, 부품테이블, 데이터 입력
INSERT INTO t_provider
(cd,nm)
VALUES
('A','알파'),
('B','브라보'),
('C','찰리');

SELECT * FROM t_provider;

INSERT INTO t_parts
(nm,price)
VALUES
('모니터','200000'),
('키보드','30000'),
('마우스','10000');

SELECT * FROM t_parts;

INSERT INTO t_deal
(deal_date, price)
VALUES
('2023-10-20',0),
('2023-10-20',0),
('2023-10-22',0);

-- t_deal_sub 레코드 채우기
INSERT INTO t_deal_sub
(deal_id,seq,provider_cd,parts_id,quantity)
VALUES
(1,1,'A',1, 10),
(1,2,'B',3,10),
(1,3,'C',2,10),
(2,1,'A',1,20),
(2,2,'B',3,10), 
(3,1,'A',3,30),
(3,2,'C',2,5);

UPDATE t_deal A
INNER JOIN (
	SELECT deal_id, SUM(A.quantity * C.price) calc_price
	FROM t_deal_sub A
	INNER JOIN t_parts C
	ON A.parts_id = C.id
	GROUP BY deal_id
) B
ON A.id = B.deal_id
SET A.price = B.price;

-- select 거래정보
SELECT A.deal_id AS '전표번호',DATE_FORMAT(D.deal_date,'%m / %d') AS '날짜', B.cd AS '공급자' ,B.nm AS '공급자명',
		C.nm AS '부품명', C.price AS '단가', A.quantity AS '수량', A.quantity * C.price AS '금액'
FROM t_deal_sub A
INNER JOIN t_provider B
ON A.provider_cd = B.cd
INNER JOIN t_parts C
ON A.parts_id = C.id
INNER JOIN t_deal D
ON A.deal_id = D.id
ORDER BY D.id, B.cd;

-- 서브 쿼리 이용(선생님 코드)
SELECT B.id,B.deal_date
		,C.cd, C.nm
		,D.nm, D.price
		,A.quantity
		,D.price * A.quantity
FROM t_deal_sub A
INNER JOIN t_deal B
ON A.deal_id = B.id
INNER JOIN t_provider C
ON A.provider_cd = C.cd
INNER JOIN t_parts D
ON A.parts_id = D.id
ORDER BY B.id, C.cd;


