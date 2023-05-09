CREATE TABLE my_dual(
	col CHAR(1) NOT null
);

INSERT INTO my_dual
SET col = 'y';

SELECT *FOR my_dual;

SELECT * 'haha' as col2, NOW()
FROM my_dual;
-- Single Line Comment
/*
  Multi Lint Comments
  
*/

SELECT 1+1+3*3, CONCAT('aa','bb'),PI(),ABS(-10),CEIL(10.111);
-- SELECT NOW() FROM DUAL; 오라클 기준
SELECT NOW();

SELECT *, 'haha' FROM DUAL;

/*
	char(255) - 고정길이
	varchar(65535) - 가변길이
	text - 많은 데이터를 적을 수있다.
	mediumtext 
	longtext
	blob - 추천안함(장점은 관리면에서는 좋다.)

*/
SHOW CHARACTER SET;

/*
	tinyint 
	부호가 있는 -> 음수값을 저장 (-128 ~ 127)
	부호가 없는  -> 양수값을 저장 (0 ~ 255)
*/