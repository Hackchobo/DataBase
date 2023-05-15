SET autocommit = 0; -- 오토커밋을 끈다.

SELECT @@autocommit;
INSERT INTO person
(person_id, fname, lname,birth_date, eye_color)
VALUES
(4, '테스트', '김', '2023-05-15', 'BR');

SELECT * FROM person;

ROLLBACK; -- 롤백이다.

COMMIT; -- 맘에 드니까 저장을 한다.

