### 6장 1교시 ###

use employees;

# 실수
use mysql;
select * from employees;

use employees;
select * from titles;

select * from employees.titles; # database.table / use로 사전설정없이 호출 가능

select first_name from employees;
select first_name, last_name, gender from employees;

-- 주석
# 주석
/*
여러줄
주석
*/

### 실습1 ###
show databases;

use employees;

# DB내 테이블의 정보들 보여줌
show table status; 

# 복수형인거 주의
show tables; 

# table의 정보
describe employees; 

select first_name, gender from employees;

### 6장 2교시 ###
drop database if exists sqldb;
create database sqldb;

use sqldb;
create table userTBL 
(
	userID char(8) not null primary key, # # char: 고정형, 무조건 8글자 저장공간 차지
	name varchar(10) not null, # varchar: 가변형, 글자 수 대로 저장공간 차지
	birthYear int not null,
	addr char(2) not null,
	mobile1 char(3),
	mobile2 char(8),
	height smallint,
	mDate date
);

create table buyTBL
(
num int auto_increment not null primary key, # auto_increment: 자동으로 증가하면서 입력됨
userID char(8) not null,
prodName char(6) not null,
groupName char(4),
price int not null,
amount smallint not null,
foreign key(userID) references usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

select * from usertbl;
select * from buytbl;

### 6장 3교시: WHERE 조건절 ###
use sqldb;
select * from usertbl;

## and / or
select * from usertbl where name='김경호';
select userID, name from usertbl where height >= 182 and birthYear >= 1970;
select userID, name from usertbl where height >= 182 or birthYear >= 1970;

## between A and B: A 이상 B 이하
select name, height from usertbl where height >= 180 and height <= 183;
select name, height from usertbl where height between 180 and 183;

## IN: python에서의 in과 같음
select name, addr from usertbl where addr = '경남' or addr='전남' or addr='경북';
select name, addr from usertbl where addr in ('경남','전남','경북');

## Like: 정규표현식을 사용할 때 사용 문법
# %: 정규표현식 *과 같음
# _: 한 글자
select name, height from usertbl where name like '김%';
select name, height from usertbl where name like '_종신';
select name, height from usertbl where name like '_용%';

## any(some)/all과 서브쿼리
# any와 some은 같은 기능

select name, height from usertbl 
	where height > (select height from usertbl where name='김경호');
    
select height from usertbl where addr='경남'; # 173, 170

# 170보다 크거나, 173보다 크다. 즉, 170보다 크다
select name, height from usertbl 
	where height > any (select height from usertbl where addr='경남');

# 170보다 크고 173보다 크다. 즉, 173보다 크다
select name, height from usertbl 
	where height > all (select height from usertbl where addr='경남');

# '= any' 는 'in ()'과 같은 의미
select name, height from usertbl 
	where height = any (select height from usertbl where addr='경남');
select name, height from usertbl 
	where height in (select height from usertbl where addr='경남');
    
## order by: 구절의 맨 뒤에, default는 오름차순
select name, mDate from userTBL order by mDate;
select name, mDate from userTBL order by mDate desc;
select name, height from userTBL order by height desc, name asc;

## distinct: 고유값
select distinct addr from userTBL order by addr;

## limit: pandas의 head와 같은 의미
use employees;
select * from employees limit 10; # head(10)
select * from employees limit 5,10; # 6번째 행부터 10개의 행 출력

## table 복사
# 단, PK, FK 등의 제약조건은 복사 X
use sqldb;
create table buytbl2 (select * from buytbl);
select * from buytbl2;

### 6장 4교시 Group by, Having 절 ###

use sqldb;
select userid, amount from buytbl order by userid;

select userid, sum(amount) from buytbl group by userid;
select userid as '아이디', sum(amount) as '구매개수' 
	from buytbl group by userid;
    
select userID as '사용자 아이디', sum(price*amount) as '총 구매액' 
	from buytbl group by userid;

select avg(amount) as '평균 구매 개수' from buytbl;
select userid, avg(amount) as '평균 구매 개수' from buytbl group by userid;

select name, max(height), min(height) from usertbl; # 부적절
select name, height
	from usertbl
	where height = (select max(height) from usertbl) or height = (select min(height) from usertbl);
select name, height
	from usertbl
	where height in ((select max(height) from usertbl), (select min(height) from usertbl));
    
select count(*) from usertbl;
select count(mobile1) as '폰 있는 사람' from usertbl; # Null 값 제외하고 count

# where절은 group by의 조건절로서 사용할 수 없음
select userid, sum(price*amount) as payment
from buytbl
where sum(price*amount) > 1000
group by userid;

# group by의 조건절은 having을 사용
select userid, sum(price*amount) as payment from buytbl
group by userid having sum(price*amount)>1000;

# sql 순서 정리
# 전자제품(where) 중 총 매출액(group by)이 800 초과인(having) 제품과 총 매출액을 검색
select prodname, sum(price*amount) as '매출액'
from buytbl
where groupname ='전자'
group by prodname
having sum(price*amount)>800
order by prodname;

# rollup: 엑셀에서의 부분합과 같음
select num, groupname, sum(price*amount) as '매출'
from buytbl group by groupname, num
with rollup;

select num, groupname, sum(price*amount) as '매출'
from buytbl group by groupname with rollup;


# rollup 다른 예시
# 대분류로 한번 묶고, 각 집단 내에서 소분류로 다시 묶음. 그 다음 부분합 계산
select groupname as '대분류' , prodname as '소분류' , sum(price*amount) as '매출액'
from buytbl group by groupname, prodname
with rollup;

### 6장 5교시 ###
## INSERT INTO  table(col1, col2...) values(val1, val2...)

use sqldb;
CREATE table testtbl (id int, username char(3), age int);

insert into testtbl values(1, '홍길동', 25); # 열 생략 가능
insert into testtbl(id, username) values(2, '설현'); # 결측값 입력시 열 기재 
insert into testtbl(username, age, id) values('하니', 26, 3); # 순서 바꿀시 열 기재

select * from testtbl;

## auto_increment
create table testtbl2(
id int auto_increment primary key, #1부터 자동 증가
username char(3),
age int);

insert into testtbl2 values(null, '지민', 25);
insert into testtbl2 values(null, '유나', 22);
insert into testtbl2 values(null, '유경',21);

select * from testtbl2;

# auto_increment 시작값 변경
alter table testtbl2 auto_increment=100;
insert into testtbl2 values(null, '찬미', 23);
select * from testtbl2;

# auto_increment의 증가값 변경
create table testtbl3(
id int AUTO_INCREMENT primary key,
username char(3),
age int);
alter table testtbl3 auto_increment=1000;
set @@auto_increment_increment=3;
insert into testtbl3 values (null,'나연',20), (null,'정연',18), (null,'모모',19); # 여러 값 한꺼번에 넣기
select * from testtbl3;

# 다른 테이블 불러와서 입력하기(insert into ~ select)
create table testtbl4 (id int, fname varchar(50), lname varchar(50));
insert into testtbl4 select emp_no, first_name, last_name from employees.employees;
create table testtbl5 (select emp_no, first_name, last_name from employees.employees); # 테이블 정의 생략 가능

## update
update testtbl4 set lname ='없음' where fname='Kyoichi';
update sqldb.buytbl set price = price * 1.5;

## delete
use sqldb;
delete from testtbl4 where fname='Aamer';
delete from testtbl4 where fname='Aamer' limit 5; # 조건 충족 row 중 상위 5개만 삭제

## 실습 3
create table bigtbl1 (select * from employees.employees);
create table bigtbl2 (select * from employees.employees);
create table bigtbl3 (select * from employees.employees);

# 시간 소요: drop < truncate < delete 
# drop만 테이블 자체를 삭제
delete from bigtbl1;
drop table bigtbl2;
TRUNCATE table bigtbl3;

## 조건부 데이터 입력, 변경
use sqldb;
create table membertbl (select userid, name, addr from usertbl limit 3);
alter table membertbl 
	add constraint pk_membertbl primary key(userid); # pk 지정(8장)
select * from membertbl;

insert into membertbl values('BBK','비비코','미국');
insert into membertbl values('SJH','서장훈','서울');
select * from membertbl; # 첫 sql문이 오류가 나서 두번째 sql문이 실행이 안됨

# key가 중복될경우 넘어감(오류문 발생X)
insert ignore into membertbl values('BBK','비비코','미국');
insert ignore into membertbl values('SJH','서장훈','서울');
insert ignore into membertbl values('HJY','현주협','경기');
select * from membertbl;

# key가 중복될 시 update함
insert into membertbl values('BBK','비비코','미국')
	on duplicate key update name='비비코', addr='미국';
insert into membertbl values('DJM','동짜몽','일본')
	on duplicate key update name='동짜몽', addr='일본';
select * from membertbl;

## with절과 CTE
use sqldb;
with abc(userid, total)
	as (select userid, sum(price*amount) from buytbl group by userid)
select * from abc order by total desc;

# 틀린 답
with abc(userid, name, height) 
	as(select userid, name, height from usertbl GROUP BY addr having height = max(height))
select avg(height) from abc;

# 모범답안
with abc(addr, maxheight) 
	as(select addr, max(height) from usertbl GROUP BY addr)
select avg(maxheight*1.0) from abc;