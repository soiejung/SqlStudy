-- 8.DML.sql
/* 
- DML : Data Manupulation Language
            데이터 조작 언어
	   (select(DQL)/insert/update/delete 모두 다 DML)
	   - 이미 존재하는 table에 데이터 저장, 수정, 삭제, 검색 
	   - commit과 rollback(트랜젝션)이 적용되는 명령어
	   	insert/update/delete에만 적용
	   

1. insert sql문법
	1-1. 모든 칼럼에 데이터 저장시 
		insert into table명 values(데이터값1, ...)

	1-2.  특정 칼럼에만 데이터 저장시,
		명확하게 칼럼명 기술해야 할 경우 
		insert into table명 (칼럼명1, ...) values(칼럼과매핑될데이터1...)


2. update -> 특정 조건에 맞는 행을 찾아서 수정 
	2-1. 모든 table(다수의 row)의 데이터 한번에 수정
		- where조건문 없는 문장
		- update table명 set 칼럼명=수정데이타; -- job이라는 컬럼을 만들고 : 회사원, 연봉 컬럼에 모두 100만원을 올려주는 경우 

	2-2. 특정 row값만 수정하는 방법
		- where조건문으로 처리하는 문장
		- update table명 set 칼럼명=수정데이타[, 컬럼명2=수정데이터2,..] where 조건sql;
		
		
3. delete		
	- 존재하는 데이터 삭제

*/

use fisa;

-- *** insert ****
-- 1. 칼럼명 기술없이 데이터 입력
-- table 자체가 생성시에 컬럼 순으로 데이터 값들도 설정해서 저장
drop table if exists emp01;
drop table if exists emp02;

-- 데이터 구조만 복제해서 새로 생성
-- empno, ename, deptno emp 테이블을 가지고오는데 구조만 

CREATE TABLE emp01 SELECT empno, ename, deptno FROM emp WHERE 1=0;
CREATE TABLE emp02 SELECT empno, ename, deptno FROM emp WHERE 1=0;
SELECT * FROM emp01;
DESC emp01;

SHOW tables;


-- 2. 칼럼명 기술후 데이터 입력 
-- 저장하고자 하는 데이터의 순서를 컬럼명 명시하면서 변경 가능
INSERT INTO emp01 VALUES (1, '김연지', 10);
SELECT * FROM emp01;
INSERT INTO emp01 VALUES (NULL, '김연지', 10);

INSERT INTO emp01 (ename, deptno) VALUES ('김연지', 12);
SELECT * FROM emp01;

desc emp01;
-- null을 허용하는 컬럼에 값 미저장시 특정 컬럼만 명시해서 값 저장 가능
-- DEFALUT 값이 정해진 컬럼을 명시해서 값을 넣지 않으면 DEFAULT 값이 들어갑니다 
/* 제약조건 없는 table에 사원명과 부서번호만 저장시도 : 정상 저장
 * mysql의 empno라는 int타입의 컬럼값이 검색시 0으로 적용되어 있음
 * oracle db의 경우 널 / mysql은 타입에 맞는 즉 정수타입의 기본값으로 자동 저장  
 */

INSERT INTO emp01 (ename) VALUES ('김연지');
SELECT * FROM emp01;
-- ORACLE은 DEFAULT로 NULL이 들어갑니다 
INSERT INTO emp01 (empno, ename) VALUES (DEFAULT, '김연지');
SELECT * FROM emp01;

INSERT INTO emp01 (empno, ename) VALUES ('ONE', '김연지'); -- 숫자자료형 자리에 '1'은 넣을 수 있어도 'ONE'은 넣을 수 없다 : 무결성 보장 위해서 
SELECT * FROM emp01;


select * from emp01;

-- 0으로 검색하는 현 sql문장은 사번이 0인 사람은 없기 때문에 가치없는 문장
select * from emp01 where empno=0;

insert into emp01 (empno, ename, deptno ) values (5, '재석2', 70);
select * from emp01;


-- 3. 하나의 table에 한번에 데이터 insert하기 
-- , 구분자로 () 표현을 적용해서 저장
drop table if exists emp01;
drop table if exists emp02;
create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;
select * from emp01;
select * from emp02;


insert into emp01 (empno, ename, deptno ) values (1, '김연지', 10), (5, '재석2', 70);
select * from emp01;

insert into emp01 values (1, '김연지', 10), (5, '재석2', 70);
select * from emp01;

insert into emp01 (ename, deptno) values ('김연지', 10), ('재석2', 70);
select * from emp01;

-- 4. 데이터만 삭제 - rollback으로 복구 불가능한 데이터 삭제 명령어
truncate table emp01; -- 명령어 실행하자마자 테이블에서 내용이 날아가버림(commit과 동시 실행)
truncate table emp02;

rollback;  -- 의미 없음
select * from emp01;



-- *** update ***
-- 1. 테이블의 모든 행 변경 UPDATE 테이블명 SET 컬럼명=값
drop table emp01;
create table emp01 as select * from emp;
select deptno from emp01;

-- deptno값을 모두 50으로 변경
UPDATE emp01 SET deptno=50;
select * from emp01;

select deptno from emp01;
rollback;

UPDATE emp01 SET sal=sal+100;
select * from emp01;

-- 10번 부서 번호를 50으로 변경
drop table emp01;
create table emp01 as select * from emp;
select deptno from emp01;

#      테이블      변경할 컬럼=변경할 값     조건이 되는 컬럼=기존의 값 
UPDATE emp01 SET deptno=50 WHERE deptno=10;
select * from emp01;

UPDATE emp01 SET job='점원' WHERE deptno=50;
select * from emp01;
 
USE fisa;

-- 2. ? emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
desc emp01;
drop table if exists emp01;

create table emp01 as select empno, sal, hiredate, ename from emp;
desc emp01;
select * from emp01;

-- UPDATE 테이블명 SET 변경할컬럼=변경할값 WHERE 조건을탐색할컬럼=기존값;
UPDATE emp01 SET sal= sal*1.1;
UPDATE emp01 SET sal= sal + (sal*0.1);
select sal from emp01;




-- ? 3. emp01의 모든 사원의 입사일을 오늘로 바꿔주세요
select now(), sleep(2), now(); -- 명령문이 실행될 때 한번만 시간을 기록합니다 
select sysdate(), sleep(2), sysdate(); -- 함수가 실행되는 순간의 시간을 기록합니다 

select now();
select * from emp01;
UPDATE emp01 SET hiredate=now(); -- date와 datetime은 호환되는 자료형 
desc emp01;


select * from emp01;
commit;



-- ? 4. 급여가 3000이상(where sal >= 3000)인 사원의 급여만 10%인상
select sal from emp01;
SELECT * FROM emp01 WHERE sal>=3000;

UPDATE emp01 SET sal=sal*1.1 WHERE sal>=3000; 




select * from emp01;
commit;


-- 5. ?emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500원씩 삭감 
-- insert/update/delete 문장에 한해서만 commit과 rollback 영향을 받음
select sal from emp01;

UPDATE emp01 SET sal=sal-500 WHERE sal>=1000; 

select * from emp01;
commit;

SELECT *
  FROM emp05;
-- 6. ? emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
-- 서브쿼리 사용
drop table emp01;
create table emp01 as select * from emp;
select * from emp01;

select * from dept;
select deptno from dept where loc='DALLAS';
-- emp와 dept를 서브쿼리를 통해 연결해서 emp의 부서원정보는 모두 조회되되, 
-- loc이 같이 출력되도록 쿼리문을 작성해주세요
select * from emp01, dept where emp01.deptno = dept.deptno;
select * from emp01, dept where emp01.deptno = dept.deptno AND loc='DALLAS';
select sal from emp01;

UPDATE emp01 SET sal=sal+1000 WHERE deptno=(
			select deptno 
            from dept 
            where loc='DALLAS'
			);
            
select * from emp;
select * from emp01;
commit;


-- 7. ? emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
-- 두개 이상의 칼럼값 동시 수정
select deptno, job from emp01 where ename='SMITH';

UPDATE emp01 SET deptno=30, job='MANAGER' WHERE ename='SMITH'; 
select deptno, job from emp01 where ename='SMITH';

UPDATE emp01 SET job='CLERK', deptno=20 WHERE ename='SMITH'; 

select deptno, job from emp01 where ename='SMITH';
commit;


-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
select * from emp01;
DELETE from emp01;
select * from emp01;

select * from emp01;


-- 9. 특정 row 삭제(where 조건식 기준)
-- deptno가 30번 부서의 모든 사원들 삭제
DROP TABLE IF EXISTS emp01;
create TABLE EMP01 SELECT * FROM emp;
select * from emp01;

delete from emp01 where deptno=30;
select * from emp01;

rollback;

-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
-- DROP, AVG, MEDIAN, MODE, 영향없음(카테고리), 0
USE fisa;
DROP TABLE IF EXISTS emp01;
create TABLE EMP01 SELECT * FROM emp;
select sal, comm from emp01;

select sal, comm from emp01 WHERE comm = NULL; -- NULL은 값이 없음 : 값이 없음을 비교하는 것은 논리적으로 맞지 않음 
select sal, comm from emp01 WHERE comm IN (NULL); 

select sal, comm from emp01 WHERE comm IS NULL; 

delete FROM emp01 WHERE comm IS NULL OR comm = 0; -- null과 0을 같은 입장으로 놓고 처리를 해야 한다면 그 점도 고려필요
select * from emp01;
rollback;

-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제
DROP TABLE IF EXISTS emp01;
create TABLE EMP01 SELECT * FROM emp;
select sal, comm from emp01;
select * from emp01;

select sal, comm from emp01 WHERE comm IS NOT NULL; 

select sal, comm from emp01 WHERE NOT comm IS NULL; 

DELETE FROM emp01 WHERE NOT comm IS NULL; 


select * from emp01;
rollback;


-- 12. emp01 table에서 부서명이 RESEARCH 부서(dept table의 dname)에 소속된 사원 삭제 
-- 서브쿼리 활용
DROP TABLE IF EXISTS emp01;
create TABLE EMP01 SELECT * FROM emp;
select * from emp01;

SELECT deptno, dname FROM dept WHERE dname = 'RESEARCH';
DELETE FROM emp01 WHERE fisa.emp01.deptno = (
		SELECT deptno 
        FROM dept 
        WHERE dname = 'RESEARCH'
);

select * from dept;
select deptno from dept where dname='RESEARCH';


select * from emp01;
rollback;

SELECT COUNT(*) FROM mywork.box_office;

-- 13. table 전체 내용 삭제
select * from emp01;

DELETE FROM emp01;

select * from emp01;

rollback;
select * from emp01;

DROP TABLE emp01;

select * from emp01;

-- 같은 값을 가진 행이 있음? 행을 변경, 없음? 행을 삽입 (딕셔너리의 키 처럼) 

/* INSERT와 UPDATE를 동시에 처리 
조건을 확인해 이미 대상 테이블에 값이 있으면 수정하고 없으면 입력하는 방법입니다.
INSERT INTO 테이블명 (칼럼1, 칼럼2, ...)
VALUES 절(또는 SELECT 문)
    ON DUPLICATE KEY UPDATE 칼럼 = 값1, 값2, ... ;

ON DUPLICATE KEY UPDATE 구문을 추가하면 충돌이 발생하는 로우에서는 신규로 값을 입력하는 것이 아니라 기존에 저장된 값을 변경합니다.
*/ 
DESC people;
ALTER TABLE people DROP PRIMARY KEY; 
DESC people;
SELECT * FROM people;
INSERT INTO people (name, age) VALUES ('김연지', 25) 
ON DUPLICATE KEY UPDATE 
  name = '중복값', 
  age = age + 1;

SELECT * FROM people;

ALTER TABLE people ADD CONSTRAINT PRIMARY KEY (name); -- NOT NULL, UNIQUE

DESC people;

DELETE FROM people; 

SELECT * FROM people;

DESC people;

ALTER TABLE people ADD CONSTRAINT PRIMARY KEY (name); 

DESC people;

-- 아래 구문은 4번 정도 반복해보세요
INSERT INTO people (name, age) VALUES ('김연재', 25) 
ON DUPLICATE KEY UPDATE  -- ON DUPLICATE KEY가 의미하는 것은 실제로 UNIQUE가 걸려있는 COLUMN에서의 DUPLICATE를 의미합니다 
  name = '중복값', 
  age = age + 1;
  
SELECT * FROM people;