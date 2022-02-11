### 인덱스 ###

use sqldb;
CREATE TABLE  tbl1
	(	a INT PRIMARY KEY,
		b INT,
		c INT
	);
    
# 인덱스 정보 호출
# PRIMARY: cluster형 인덱스 의미
# non_unique: 중복 허용 여부
show index from tbl1;

create table tbl2(
a int primary key,
b int unique,
c int unique,
d int);

# unique열은 보조 인덱스로, null값 허용
show index from tbl2;

CREATE TABLE  tbl3
	(	a INT UNIQUE,
		b INT UNIQUE,
		c INT UNIQUE,
		d INT
	);
SHOW INDEX FROM tbl3;

CREATE TABLE  tbl4
	(	a INT UNIQUE NOT NULL,
		b INT UNIQUE ,
		c INT UNIQUE,
		d INT
	);
# unique하고 not null한 열은 cluster 유형의 인덱스임
SHOW INDEX FROM tbl4;

CREATE TABLE  tbl5
	(	a INT UNIQUE NOT NULL,
		b INT UNIQUE ,
		c INT UNIQUE,
		d INT PRIMARY KEY
	);
# 그러나, 기본키가 설정되는 경우 not null unique열은 cluster index가 아님
SHOW INDEX FROM tbl5;

CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  char(8) NOT NULL PRIMARY KEY, 
  name    varchar(10) NOT NULL,
  birthYear   int NOT NULL,
  addr	  nchar(2) NOT NULL 
 );
INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울');
SELECT * FROM usertbl; # 기본키 기준으로 자동 정렬됨

ALTER TABLE usertbl DROP PRIMARY KEY ;
ALTER TABLE usertbl 
	ADD CONSTRAINT pk_name PRIMARY KEY(name);
SELECT * FROM usertbl;