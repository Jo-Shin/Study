## 7장 실습2 ##

create database moviedb;
use moviedb;
create table movietbl 
	(movie_id int,
	movie_title varchar(30),
	movie_director varchar(20),
	movie_star varchar(20),
	movie_script longtext,
	movie_film longblob) default charset=utf8mb4;
    
insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨',
load_file('C:/MySQL/movies/Schindler.txt'),
load_file('C:/MySQL/movies/Schindler.mp4'));

# 용량 제한, 폴더의 보안 문제로 인해 파일이 업로드 되지 않음
select * from movietbl;

show variables like 'max_allowed_packet';
show variables like 'secure_file_priv';

# cmd 통해 재설정 후 pc 다시시작 후 재개
use moviedb;
truncate movietbl;
insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨',
load_file('C:/MySQL/movies/Schindler.txt'),
load_file('C:/MySQL/movies/Schindler.mp4'));

insert into movietbl values(1, '쉰들러 리스트', '스필버그', '리암니슨',
load_file('C:/MySQL/movies/Schindler.txt'),
load_file('C:/MySQL/movies/Schindler.mp4'));

insert into movietbl values(2, '쇼생크 탈출', '프랭크 다라본트', '팀 로빈스',
load_file('C:/MySQL/movies/Shawshank.txt'),
load_file('C:/MySQL/movies/Shawshank.mp4'));

insert into movietbl 
values(3, '라스트 모히칸', '마이클 만', '다니엘 데이 루이스',
load_file('C:/MySQL/movies/Mohican.txt'),
load_file('C:/MySQL/movies/Mohican.mp4'));

# 텍스트 파일 export
select movie_script from movietbl where movie_id=1
	into outfile 'C:/MySQL/movies/Schindler_out.txt' 
	lines terminated by '\\n';
    
# 동영상 파일 export
select movie_film from movietbl where movie_id=1
	into dumpfile 'C:/MySQL/movies/Schindler_out.mp4' ;
    
## 7장 실습3 ##
USE sqldb;
CREATE TABLE pivotTest
   (  uName CHAR(3),
      season CHAR(2),
      amount INT );
INSERT  INTO  pivotTest VALUES
	('김범수' , '겨울',  10) , ('윤종신' , '여름',  15) , ('김범수' , '가을',  25) , ('김범수' , '봄',    3) ,
	('김범수' , '봄',    37) , ('윤종신' , '겨울',  40) , ('김범수' , '여름',  14) ,('김범수' , '겨울',  22) ,
	('윤종신' , '여름',  64) ;
    
select * from pivottest;

select uname,
	sum(if(season='봄', amount, 0)) as '봄',
    sum(if(season='여름', amount, 0)) as '여름',
    sum(if(season='가을', amount, 0)) as '가을',
    sum(if(season='겨울', amount, 0)) as '겨울',
    sum(amount) as '합계' from pivottest group by uname;
    
## JSON ##
use sqldb;

# table -> json file, json_object(key:column of tbl)
select json_object('name',name,'height',height) as 'JSON 값'
	FROM USERTBL
    where height>=180;

set @json = 
'{"usertbl":
		[
		{"name": "임재범", "height": 182},
		{"name": "이승기", "height": 182},
		{"name": "성시경", "height": 186}
		]
}';
select json_valid(@json);
SELECT JSON_SEARCH(@json, 'one', '성시경') ; # one: 검색결과 최초만 출력, all: 모두 출력
select json_extract(@json, '$.usertbl[2].name'); # index를 통해 검색
select json_insert(@json, '$.usertbl[0].mDate', '2009-09-09'); # 새로운 key & value 삽입
select json_replace(@json, '$.usertbl[0].name','홍길동'); # replace
select json_remove(@json, '$.usertbl[0]'); # 행 삭제

## INNER JOIN ##
use sqldb;
select * 
	from buytbl 
	inner join usertbl
		on buytbl.userid = usertbl.userid # buytbl: 자식, usertbl: 부모
	where buytbl.userid = 'JYP';

select * 
	from buytbl 
	inner join usertbl
		on buytbl.userid = usertbl.userid
	order by num;

# error: userid는 두 tbl 모두에 있음
select userid, name, prodname, concat(mobile1, mobile2) as '연락처'
	from buytbl
    inner join usertbl
		on buytbl.userid = usertbl.userid
	order by num;
# 해결    
select buytbl.userid, name, prodname, concat(mobile1, mobile2) as '연락처'
	from buytbl
    inner join usertbl
		on buytbl.userid = usertbl.userid
	order by num;
    
# 별칭 ```Table Alias```
select b.userid, u.name, b.prodname, concat(u.mobile1, u.mobile2) as '연락처'
	from buytbl b
		inner join usertbl u
			on b.userid = u.userid
	order by num;

select distinct u.userid, u.name, u.addr
from usertbl u
	inner join buytbl b
		on b.userid = u.userid
	order by u.userid;

# 구매 이력이 한번이라도 있는 회원들 호출
select distinct u.userid, u.name, u.addr
from usertbl u
	inner join buytbl b
		on b.userid = u.userid
	order by u.userid;
    
## 실습4 ##
USE sqldb;
CREATE TABLE stdtbl 
( stdName    VARCHAR(10) NOT NULL PRIMARY KEY,
  addr	  CHAR(4) NOT NULL
);
CREATE TABLE clubtbl 
( clubName    VARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo    CHAR(4) NOT NULL
);
CREATE TABLE stdclubtbl
(  num int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
   stdName    VARCHAR(10) NOT NULL,
   clubName    VARCHAR(10) NOT NULL,
FOREIGN KEY(stdName) REFERENCES stdtbl(stdName),
FOREIGN KEY(clubName) REFERENCES clubtbl(clubName)
);
INSERT INTO stdtbl
	VALUES ('김범수','경남'), ('성시경','서울'), ('조용필','경기'),
    ('은지원','경북'),('바비킴','서울');
INSERT INTO clubtbl 
	VALUES ('수영','101호'), ('바둑','102호'),
    ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubtbl 
	VALUES (NULL, '김범수','바둑'), (NULL,'김범수','축구'), (NULL,'조용필','축구'), 
	(NULL,'은지원','축구'), (NULL,'은지원','봉사'), (NULL,'바비킴','봉사');

select s.stdname, s.addr, sc.clubname, c.roomno
	from stdtbl s
		inner join stdclubtbl sc
			on s.stdname = sc.stdname
		inner join clubtbl c
			on sc.clubname = c.clubname
	order by s.stdname;
    
select sc.clubname, s.stdname
	from stdclubtbl sc
		inner join stdtbl s
			on s.stdname = sc.stdname
	order by sc.clubname;
    
## OUTER JOIN ##
use sqldb;
select u.userid, u.name, b.prodname, u.addr, concat(u.mobile1, u.mobile2) as 'mobile'
	from usertbl u
		left outer join buytbl b
			on u.userid = b.userid
	order by u.userid;
    
# 구매이력이 없는 회원
select u.userid, u.name, b.prodname, u.addr, concat(u.mobile1, u.mobile2) as 'mobile'
	from usertbl u
		left outer join buytbl b
			on u.userid = b.userid
	where b.prodname is null
	order by u.userid;
    
## 실습5 ##

# 모든 학생의 동아리 정보
select s.stdname, s.addr, sc.clubname, c.roomno
	from stdtbl s
		left outer join stdclubtbl sc
			on s.stdname = sc.stdname
		left outer join clubtbl c
			on sc.clubname = c.clubname
	order by s.stdname ;

# 모든 동아리의 회원 정보
select c.clubname, c.roomno, sc.stdname, s.addr
	from clubtbl c
		left outer join stdclubtbl sc
			on sc.clubname = c.clubname
		left outer join stdtbl s
			on sc.stdname = s.stdname
	order by c.clubname;
    
# 모든 동아리의 회원 정보2
select c.clubname, c.roomno, sc.stdname, s.addr
	from stdtbl s
		left outer join stdclubtbl sc
			on s.stdname = sc.stdname
		right outer join clubtbl c
			on c.clubname  = sc.clubname;

# union: 결과 합침
select s.stdname, s.addr, sc.clubname, c.roomno
	from stdtbl s
		left outer join stdclubtbl sc
			on s.stdname = sc.stdname
		left outer join clubtbl c
			on sc.clubname = c.clubname
union
select c.clubname, c.roomno, sc.stdname, s.addr
	from clubtbl c
		left outer join stdclubtbl sc
			on sc.clubname = c.clubname
		left outer join stdtbl s
			on sc.stdname = s.stdname;
            
## 	CROSS JOIN: 무의미 ##
use sqldb;
select * from buytbl
	cross join usertbl;
    
## SELF JOIN_실습 6 ##
USE sqldb;
CREATE TABLE empTbl (emp CHAR(3), manager CHAR(3), empTel VARCHAR(8));

INSERT INTO empTbl VALUES('나사장',NULL,'0000');
INSERT INTO empTbl VALUES('김재무','나사장','2222');
INSERT INTO empTbl VALUES('김부장','김재무','2222-1');
INSERT INTO empTbl VALUES('이부장','김재무','2222-2');
INSERT INTO empTbl VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTbl VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTbl VALUES('이영업','나사장','1111');
INSERT INTO empTbl VALUES('한과장','이영업','1111-1');
INSERT INTO empTbl VALUES('최정보','나사장','3333');
INSERT INTO empTbl VALUES('윤차장','최정보','3333-1');
INSERT INTO empTbl VALUES('이주임','윤차장','3333-1-1');

select a.emp as '부하직원', b.emp as '직속상관', b.emptel as '직속상관연락처'
	from emptbl a
		inner join emptbl b
			on a.manager = b.emp
	where a.emp = '우대리';

## UNION, IN, NOT IN ##
select stdname, addr from stdtbl
	union all
select clubname, roomno from clubtbl;

select name, concat(mobile1, mobile2) as 'mobile' 
	from usertbl
	where name not in (select name from usertbl where mobile1 is NULL);

select name, concat(mobile1, mobile2) as 'mobile' 
	from usertbl
	where name in (select name from usertbl where mobile1 is NULL);
    
## SQL 프로그래밍 ##

# if ~ else
DROP PROCEDURE if exists ifProc;

DELIMITER $$
create procedure ifProc()
begin 
declare var1 int;
set var1  = 100;

if var1 = 100  then
	select '100입니다.';
else 
	select '100이 아닙니다.';
end if;
end $$
DELIMITER ;

call ifproc();

# case
DELIMITER $$
create procedure caseProc()
begin 
	declare point int;
    declare credit char(1);
    set point = 77;
    
    case
		when point >= 90 then
			set credit = 'A';
		when point >= 80 then
			set credit = 'B';
		when point >= 70 then
			set credit = 'C';
		when point >= 60 then
			set credit = 'D';
		else 
			set credit = 'F';
	end case;
    select point, credit;
end $$
DELIMITER ;
call caseproc();

## 실습 7 ##

# sqldb 초기화
DROP DATABASE IF EXISTS sqldb; -- 만약 sqldb가 존재하면 우선 삭제한다.
CREATE DATABASE sqldb;

USE sqldb;
CREATE TABLE usertbl -- 회원 테이블
( userID   CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  name     VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr    CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1 CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2 CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height     SMALLINT,  -- 키
  mDate     DATE  -- 회원 가입일
);
CREATE TABLE buytbl -- 회원 구매 테이블(Buy Table의 약자)
(  num  INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID   CHAR(8) NOT NULL, -- 아이디(FK)
   prodName  CHAR(6) NOT NULL, --  물품명
   groupName  CHAR(4)  , -- 분류
   price      INT  NOT NULL, -- 단가
   amount     SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES usertbl(userID)
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

use sqldb;
select u.userid, u.name, sum(b.price*b.amount) as 'spend',
		case 
			when sum(b.price*b.amount) >= 1500 then 'A'
			when sum(b.price*b.amount) >= 1000 then 'B'
			when sum(b.price*b.amount) >= 1 then 'C'
			else 'F'
		end as '고객등급'
	from buytbl b
		right outer join usertbl u
			on b.userid = u.userid
    group by userid
    order by spend desc;
    
## while

# 7의 배수 제외하고, 합계가 1000이 넘을때 그만 더하기
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE	i INT;
    declare hap int;
    set i = 1;
    set hap = 0;
    
    myWhile: 
    while(i<=100) do
		if (i%7=0) then
			set i = i+1;
            iterate myWhile; # continue
		end if;
        
        set hap = hap + i;
        
        if (hap>1000) then
			leave myWhile; # break
		end if;
        
        set i = i+1;
    end while;
    
    select hap;
end $$
delimiter ;

call whileProc();

# 3과 8의 배수 더하기
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE	i INT;
    declare hap int;
    set i = 1;
    set hap = 0;
    
    myWhile: 
    while(i<=1000) do
		if (i%3=0 or i%8=0) then
			set hap = hap + i;
			set i = i+1;
            iterate myWhile; # continue
		end if;
        
        set i = i+1;
    end while;
    
    select hap;
end $$
delimiter ;

call whileProc2();

## 오류 처리
delimiter $$
create procedure errorproc()
BEGIN
	declare continue handler for SQLEXCEPTION
    BEGIN
		show errors; # 에러문 출력
        select '오류 발생' as 'msg';
        rollback; # 오류 발생 시 작업을 롤백, commit은 오류 발생시 작업을 확정시킴
    end;
    insert into usertbl values('LSG', '이상구',1988, '서울',NULL, NULL, 170, current_date());
end $$
delimiter ;

call errorproc;

## 동적 SQL
use sqldb;
CREATE table mytable(id int AUTO_INCREMENT PRIMARY key, mdate datetime);
set @curDate = current_timestamp();

PREPARE myquery from 'insert into mytable values(null, ?)';
EXECUTE myquery using @curdate;
deallocate prepare myquery; # 마치 f.close()

select * from mytable;
        
    
