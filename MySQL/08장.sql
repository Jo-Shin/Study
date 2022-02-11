### 8장 1교시 ###

DROP DATABASE IF EXISTS ShopDB;
DROP DATABASE IF EXISTS ModelDB;
DROP DATABASE IF EXISTS sqldb;
DROP DATABASE IF EXISTS tabledb;

CREATE DATABASE tabledb;

CREATE TABLE `tabledb`.`buytbl` (
  `num` INT NOT NULL AUTO_INCREMENT,
  `userid` CHAR(8) NOT NULL,
  `prodName` CHAR(6) NOT NULL,
  `groupName` CHAR(4) NULL,
  `price` INT NOT NULL,
  `amount` SMALLINT NOT NULL,
  PRIMARY KEY (`num`),
  FOREIGN KEY (userid) REFERENCES usertbl(userID)  
);

### 8장 2교시 ###
DROP DATABASE IF EXISTS tabledb;
CREATE DATABASE tabledb;

USE tabledb;
drop table if exists buytbl, usertbl;

create table usertbl
	(
	userid char(8) not null primary key,
	name varchar(10) not null,
	birthyear int not null,
    addr char(2) not null,
    mobile1 char(3) null, # 없어도 되면 null 표기 권장 (설정마다 달라서 명시 권고)
    mobile2 char(8) null,
    height smallint null,
    mdate date null
    );
    
create table buytbl 
	(
    num int not null primary key auto_increment,
    userid char(8) not null,
    prodname char(6) not null,
    groupname char(4) null,
    price int not null,
    amount smallint not null,
    foreign key(userid) references usertbl(userid)
    );
    
INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');

INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
# 오류: FK 값이 PK 값에 존재하지 않으면 안됨
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1);

-- 추가 입력 
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
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

### 8장 3교시_제약조건 ###

### 8장 4교시 ###

### 압축 테이블 ###
create DATABASE if not exists compressDB;
use compressdb;

create table normaltbl(emp_no int, first_name varchar(14));
# 압축 테이블: 시스템 내부적으로 압축해서 용량이 작음
create table compresstbl(emp_no int, first_name varchar(14)) row_format=compressed;

insert into normaltbl 
	select emp_no, first_name from employees.employees;
insert into compresstbl 
	select emp_no, first_name from employees.employees;

show table status from compressdb;
drop database if exists compressdb;
    
## 임시 테이블 ##
use employees;
create temporary table if not exists temptbl (id int, name char(5));

# 기존 테이블과 이름이 같을 경우, 임시 테이블 우선으로 코드가 적용됨 
create temporary table if not exists employees (id int, name char(5));
describe temptbl;
describe employees;

insert into temptbl values (1, 'This');
insert into employees values (2, 'MySQL');
select * from temptbl;
select * from employees;

### 실습5 ###
use tabledb;
drop table if exists buytbl, usertbl;

CREATE TABLE usertbl 
( userID  CHAR(8), 
  name    VARCHAR(10),
  birthYear   INT,  
  addr	  CHAR(2), 
  mobile1	CHAR(3), 
  mobile2   CHAR(8), 
  height    SMALLINT, 
  mDate    DATE 
);
CREATE TABLE buytbl 
(  num int AUTO_INCREMENT PRIMARY KEY,
   userid  CHAR(8),
   prodName CHAR(6),
   groupName CHAR(4),
   price     INT ,
   amount   SMALLINT
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', NULL, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1871, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL,'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL,'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL,'BBK', '모니터', '전자', 200,  5);

# 기본키 제약 부여
alter table usertbl
	add constraint pk_usertbl_userid
	PRIMARY KEY (userid);

desc usertbl;

# 외래키의 값 중 하나가 참조하는 기본키에 없어서 오류가 뜸 (BBK)
alter table buytbl
	add constraint fk_usertbl_buytbl
    foreign key (userid)
    REFERENCES usertbl(userid);

delete from buytbl WHERE userid='BBK';
alter table buytbl
	add constraint fk_usertbl_buytbl
    foreign key(userid)
    REFERENCES usertbl(userid);

# 외래키와 참조하는 기본키 문제로 오류
INSERT INTO buytbl VALUES(NULL,'BBK', '모니터', '전자', 200,  5);

# 외래키를 off한후 데이터를 일단 넣어줄 수 있음
SET foreign_key_checks = 0;
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
SET foreign_key_checks = 1;

# 오류: 제약조건에 맞지 않는 데이터가 있음
alter table usertbl
	add constraint ck_birthyear
    check ((birthyear >= 1900 and birthyear <= 2023) and (birthyear is not null));

# 제약조건에 맞지 않는 데이터 수정
update usertbl set birthyear=1979 where userid='KBS';
update usertbl set birthyear=1971 where userid='KKH';

alter table usertbl
	add constraint ck_birthyear
    check ((birthyear >= 1900 and birthyear <= 2023) and (birthyear is not null));

# 오류: 제약조건에 맞지 않음
INSERT INTO usertbl VALUES('TKV', '태권뷔', 2999, '우주', NULL  , NULL , 186, '2023-12-12');

INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');

# 바비킴의 아이디 변경 요청, 하지만 외래키-기본키 문제로 오류
update usertbl set userid='VVK' where userid='BBK';

set foreign_key_checks = 0;
update usertbl set userid='VVK' where userid='BBK';
set foreign_key_checks = 1;

# 12건 중 8건 밖에 출력되지 않음
select b.userid, u.name, b.prodname, u.addr, concat(u.mobile1,u.mobile1) as 'mobile'
	from buytbl b
		inner join usertbl u
			on u.userid = b.userid;

# buytbl의 'BBK'가 usertbl에 없기 때문이다.
select userid from buytbl
 where userid not in (select userid from usertbl);
 
select b.userid, u.name, b.prodname, u.addr, concat(u.mobile1,u.mobile1) as 'mobile'
	from buytbl b
		left outer join usertbl u
			on u.userid = b.userid
	order by b.userid;

# 원상복귀 
set foreign_key_checks = 0;
update usertbl set userid='BBK' where userid='VVK';
set foreign_key_checks = 1;

# 재시도: 정상적으로 모두 출력
select b.userid, u.name, b.prodname, u.addr, concat(u.mobile1,u.mobile1) as 'mobile'
	from buytbl b
		inner join usertbl u
			on u.userid = b.userid;

# on update cascade
alter table buytbl
	drop FOREIGN KEY fk_usertbl_buytbl;

alter table buytbl
	add constraint fk_usertbl_buytbl
		foreign key (userid)
        references usertbl (userid)
        on update cascade;

# 부모 테이블에서 업데이트되면 자식테이블도 업데이트됨
update usertbl set userid = 'VVK' where userid ='BBK';
select b.userid, u.name, b.prodname, u.addr, concat(u.mobile1,u.mobile1) as 'mobile'
	from buytbl b
		inner join usertbl u
			on u.userid = b.userid;

alter table buytbl
	drop FOREIGN KEY fk_usertbl_buytbl;

alter table buytbl
	add constraint fk_usertbl_buytbl
		foreign key (userid)
        REFERENCES usertbl (userid)
        on update CASCADE
        on delete cascade;

delete from usertbl where userid = 'VVK';
select * from buytbl where userid='VVK';

# check 제약 조건이 설정된 열은 제약조건을 무시하고 삭제
alter table usertbl
	drop column birthyear;
    
### 기본키 제약 조건 ###

# create할 때 기본키 제약조건 부여_1
use tabledb;
drop table if exists buytbl, usertbl;
create table usertbl
	(userid char(8) not null primary key,
    name varchar(10) not null,
    birthyear int not null
	);

# create할 때 기본키 제약조건 부여_2
drop table if exists buytbl, usertbl;
create table usertbl
	(userid char(8) not null,
    name varchar(10) not null,
    birthyear int not null,
    CONSTRAINT pk_usertbl_userid PRIMARY KEY (userid)
	);
show keys from usertbl;

# alter로 기본키 제약조건 부여
drop table if exists buytbl, usertbl;
create table usertbl
	(userid char(8) not null,
    name varchar(10) not null,
    birthyear int not null
	);
alter table usertbl
	add constraint pk_usertbl_userid 
	primary key (userid); # 여러 열을 묶어서 기본키 설정 가능: primary key (userid, name)

## 외래 키 제약조건 ##
DROP TABLE IF EXISTS buytbl, usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL 
);

CREATE TABLE buytbl 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   FOREIGN KEY(userID) REFERENCES usertbl(userID)
);

DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   CONSTRAINT FK_usertbl_buytbl FOREIGN KEY(userID) REFERENCES usertbl(userID)
);

DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL 
);
ALTER TABLE buytbl
    ADD CONSTRAINT FK_usertbl_buytbl 
    FOREIGN KEY (userID) 
    REFERENCES usertbl(userID)
    on update cascade
    on delete cascade;

SHOW INDEX FROM buytbl ;

## unique 제약 조건 ##
USE tabledb;
DROP TABLE IF EXISTS buytbl, usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL  UNIQUE
);
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY,
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL ,  
  CONSTRAINT AK_email  UNIQUE (email)
);

## check 제약 조건 ##
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  CHAR(8) PRIMARY KEY,
  name    VARCHAR(10) , 
  birthYear  INT CHECK  (birthYear >= 1900 AND birthYear <= 2023),
  mobile1	char(3) NULL, 
  CONSTRAINT CK_name CHECK ( name IS NOT NULL)  
);

-- 휴대폰 국번 체크
ALTER TABLE usertbl
	ADD CONSTRAINT CK_mobile1
	CHECK  (mobile1 IN ('010','011','016','017','018','019')) ;

## default 정의 ##
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  	CHAR(8) NOT NULL PRIMARY KEY,  
  name    	VARCHAR(10) NOT NULL, 
  birthYear	INT NOT NULL DEFAULT -1,
  addr	  	CHAR(2) NOT NULL DEFAULT '서울',
  mobile1	CHAR(3) NULL, 
  mobile2	CHAR(8) NULL, 
  height	SMALLINT NULL DEFAULT 170, 
  mDate    	DATE NULL
);

DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  	CHAR(8) NOT NULL PRIMARY KEY,  
  name    	VARCHAR(10) NOT NULL, 
  birthYear	INT NOT NULL,
  addr	  	CHAR(2) NOT NULL,
  mobile1	CHAR(3) NULL, 
  mobile2	CHAR(8) NULL, 
  height	SMALLINT NULL, 
  mDate    	DATE NULL
);
ALTER TABLE usertbl
	ALTER COLUMN birthYear SET DEFAULT -1;
ALTER TABLE usertbl
	ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE usertbl
	ALTER COLUMN height SET DEFAULT 170;
    
## 테이블 수정_alter ##

# 추가
alter table usertbl
	add homepage 
		varchar(30)
        default '-'
        null;

# 삭제
alter table usertbl
	drop column homepage;
    
# 변경
alter table usertbl
	change column name uname varchar(20) null;

# 제약조건 삭제 / 단, 자식 테이블의 외래키 먼저 삭제해야 함. 
alter table usertbl
	drop primary key;
alter table buytbl
	drop foreign key buytbl_ibfk_1;
    
### View ###
# view 요약: 원본 테이블과 연동된 하나의 가상 테이블. 뷰를 통해 원본 테이블을 업데이트 하는 등이 가능한 경우도 있으나, 권장하지 않음
USE sqldb;
create view v_userbuytbl
	as select u.userid as 'USER_UD', U.NAME AS 'USER NAME', B.PRODNAME AS 'PRODUCT NAME', U.ADDR,
    CONCAT(U.MOBILE1, U.MOBILE2) AS 'MOBILE PHONE'
              FROM usertbl u
				inner join buytbl b
					on u.userid = b.userid;
select `user id`, `user name` from v_userbuytbl; # 열 이름에 공백이 있는 경우 ``사용해야함

alter view v_userbuytbl
	as select u.userid as 'USER_ID', U.NAME AS 'USER_NAME', B.PRODNAME AS 'PRODUCT_NAME', U.ADDR,
    CONCAT(U.MOBILE1, U.MOBILE2) AS 'MOBILE_PHONE'
              FROM usertbl u
				inner join buytbl b
					on u.userid = b.userid;
                    
drop view v_userbuytbl;

# create or replace: 이미 존재시 대체
create or replace view v_usertbl
	as select userid, name, addr from usertbl;

describe v_usertbl;

# 소스코드 내용 보여줌
show create view v_usertbl;

select * from v_usertbl;
update v_usertbl set addr='부산' where userid='JKW'; # 값 변경 가능

select * from usertbl; # 뷰로 업데이트 시 업데이트는 원본 테이블에도 반영됨

# ERROR: 원본 테이블에 not null column이 있어서 입력 안됨
insert into v_usertbl(userid, name, addr) values('KBM','김병민','충북');

create view v_sum
	as
		SELECT userid, sum(price*amount) as 'total'
			from buytbl group by userid;
            
select * from v_sum;

# is_updatetable: NO (집계함수를 사용해, 뷰를 통해 테이블 업데이트 불가능함)
select * from information_schema.views
	where table_schema = 'sqldb' and table_name = 'v_sum';

CREATE VIEW v_height177
AS
	SELECT * FROM usertbl WHERE height >= 177 ;

SELECT * FROM v_height177 ;

DELETE FROM v_height177 WHERE height < 177 ;

INSERT INTO v_height177 VALUES('KBM', '김병만', 1977 , '경기', '010', '5555555', 158, '2023-01-01') ;

SELECT * FROM v_height177; # 키가 177이상이 아니라 뷰에 김병만 안보임

alter view v_height177
	as
		select * from usertbl
        where height >= 177
        with check option;

# 입력이 안됨
INSERT INTO v_height177 VALUES('WDT', '서장훈', 2006 , '서울', '010', '3333333', 155, '2023-3-3') ;

INSERT INTO v_height177 VALUES('WDT', '서장훈', 2006 , '서울', '010', '3333333', 188, '2023-3-3') ;
select * from v_height177;

create view v_userbuytbl
	as
		SELECT u.userid, u.name, b.prodname, u.addr, concat(u.mobile1, u.mobile2) as 'mobile'
			from usertbl u
				inner join buytbl b
					on u.userid = b.userid;
# 두개 이상의 테이블로 만든 뷰라 안됨
INSERT INTO v_userbuytbl VALUES('PKL','박경리','운동화','경기','00000000000','2023-2-2');

# 뷰가 있어도 관련 테이블은 삭제됨
drop table if exists buytbl, usertbl;

# 테이블이 삭제되 조회가 안됨
select * from v_userbuytbl;

# references invalid table
check table v_userbuytbl;

### 테이블스페이스 ###
# 테이블이 저장되는 물리적 공간
# DB는 테이블이 저장되는 논리적 공간임
# C:\ProgramData\MySQL\MySQL Server 8.0\Data 에서 테이블스페이스 (숨김)파일 확인 가능, 확장명은 ibd

show variables like 'innodb_data_file_path';
show variables like 'innodb_file_per_table';

# 테이블스페이스와 그에 해당하는 데이터 파일 생성
create TABLESPACE ts_a add datafile 'ts_a.ibd';
create TABLESPACE ts_b add datafile 'ts_b.ibd';
create TABLESPACE ts_c add datafile 'ts_c.ibd';

use sqldb;
create table table_a (id int) tablespace ts_a;
create table table_b (id int);
alter table table_b
	tablespace ts_b;

create table table_c (select * from employees.salaries);
alter table table_c tablespace ts_c;
