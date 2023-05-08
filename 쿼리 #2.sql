-- Single Line Comment
/*
  Multi Lint Comments
  
*/
SELECT NOW(); FROM DUAL;

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