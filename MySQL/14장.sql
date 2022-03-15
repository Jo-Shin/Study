## 실습 1

create database gisdb;

use gisdb;
create table streamtbl(
mapnumber char(10),
streamname char(10),
stream geometry
);

INSERT INTO StreamTbl VALUES ( '330000001' ,  '한류천', 
	ST_GeomFromText('LINESTRING (-10 30, -50 70, 50 70)'));
INSERT INTO StreamTbl VALUES ( '330000001' ,  '안양천', 
	ST_GeomFromText('LINESTRING (-50 -70, 30 -10, 70 -10)'));
INSERT INTO StreamTbl VALUES ('330000002' ,  '일산천', 
	ST_GeomFromText('LINESTRING (-70 50, -30 -30, 30 -60)'));
    
create table buildingtbl(
mapnumber char(10),
buildingname char(20),
building geometry
);

INSERT INTO BuildingTbl VALUES ('330000005' ,  '하나은행', 
	ST_GeomFromText('POLYGON ((-10 50, 10 30, -10 10, -30 30, -10 50))'));
INSERT INTO BuildingTbl VALUES ( '330000001' ,  '우리빌딩', 
	ST_GeomFromText('POLYGON ((-50 -70, -40 -70, -40 -80, -50 -80, -50 -70))'));
INSERT INTO BuildingTbl VALUES ( '330000002' ,  '디티오피스텔', 
	ST_GeomFromText('POLYGON ((40 0, 60 0, 60 -20, 40 -20, 40 0))'));
    
select * from streamtbl;

select * from buildingtbl;

## 실습2
# 객체의 길이
select * from streamtbl where st_length(stream) > 140;

# 객체의 넓이
select buildingname, st_area(building) from buildingtbl
	where st_area(building) < 500;
    
select * from streamtbl
union all
select * from buildingtbl;

# 안양천과 겹치는 건물
select streamname, buildingname, stream, building
from streamtbl s, buildingtbl b
where st_intersects(s.stream, b.building) = 1 and streamname = '안양천';

select st_buffer(stream, 5) from streamtbl;

## 실습 3
drop database if exists kinghotdb;
create database kinghotdb;

USE KingHotDB;
-- [왕매워 짬뽕] 체인점 테이블 (총 매출액 포함)
CREATE TABLE Restaurant
(restID int auto_increment PRIMARY KEY,  -- 체이점 ID
 restName varchar(50),	        -- 체인점 이름
 restAddr varchar(50),	        -- 체인점 주소
 restPhone varchar(15),	        -- 체인점 전화번호
 totSales  BIGINT,		        -- 총 매출액			
 restLocation geometry ) ;	        -- 체인점 위치

-- [왕매워 짬뽕] 1호점~9호점 입력
INSERT INTO Restaurant VALUES
 (NULL, '왕매워 짬뽕 1호점', '서울 강서구 방화동', '02-111-1111', 1000, ST_GeomFromText('POINT(-80 -30)')),
 (NULL, '왕매워 짬뽕 2호점', '서울 은평구 증산동', '02-222-2222', 2000, ST_GeomFromText('POINT(-50 70)')),
 (NULL, '왕매워 짬뽕 3호점', '서울 중랑구 면목동', '02-333-3333', 9000, ST_GeomFromText('POINT(70 50)')),
 (NULL, '왕매워 짬뽕 4호점', '서울 광진구 구의동', '02-444-4444', 250, ST_GeomFromText('POINT(80 -10)')),
 (NULL, '왕매워 짬뽕 5호점', '서울 서대문구 북가좌동', '02-555-5555', 1200, ST_GeomFromText('POINT(-10 50)')),
 (NULL, '왕매워 짬뽕 6호점', '서울 강남구 논현동', '02-666-6666', 4000, ST_GeomFromText('POINT(40 -30)')),
 (NULL, '왕매워 짬뽕 7호점', '서울 서초구 서초동', '02-777-7777', 1000, ST_GeomFromText('POINT(30 -70)')),
 (NULL, '왕매워 짬뽕 8호점', '서울 영등포구 당산동', '02-888-8888', 200, ST_GeomFromText('POINT(-40 -50)')),
 (NULL, '왕매워 짬뽕 9호점', '서울 송파구 가락동', '02-999-9999', 600, ST_GeomFromText('POINT(60 -50)'));

SELECT restName, ST_Buffer(restLocation, 3) as '체인점' FROM Restaurant;

-- 지역 관리자 테이블
CREATE TABLE Manager
 (ManagerID int auto_increment PRIMARY KEY,   -- 지역관리자 id
  ManagerName varchar(5),	              -- 지역관리자 이름
  MobilePhone varchar(15),	              -- 지역관리자 전화번호
  Email varchar(40),                      -- 지역관리자 이메일
  AreaName varchar(15),                 -- 담당지역명
  Area geometry SRID 0) ;                       -- 담당지역 폴리곤

INSERT INTO Manager VALUES
 (NULL, '존밴이', '011-123-4567', 'johnbann@kinghot.com',  '서울 동/북부지역',
   ST_GeomFromText('POLYGON((-90 0, -90 90, 90 90, 90 -90, 0 -90, 0  0, -90 0))')) ,
 (NULL, '당탕이', '019-321-7654', 'dangtang@kinghot.com', '서울 서부지역',
   ST_GeomFromText('POLYGON((-90 -90, -90 90, 0 90, 0 -90, -90 -90))'));

SELECT ManagerName, Area as '당탕이' FROM Manager WHERE ManagerName = '당탕이';
SELECT ManagerName, Area as '존밴이' FROM Manager WHERE ManagerName = '존밴이';

-- 서울시의 도로 테이블
CREATE TABLE Road
 (RoadID int auto_increment PRIMARY KEY,  -- 도로 ID
  RoadName varchar(20),           -- 도로 이름
  RoadLine geometry );              -- 도로 선

INSERT INTO Road VALUES
 (NULL, '강변북로',
   ST_GeomFromText('LINESTRING(-70 -70 , -50 -20 , 30 30,  50 70)'));

# 담당 면적
select managername, areaname, st_area(area) as '면적' from manager;

# 담당자별 체인점의 이름과 주소
select managername, restname, restaddr, areaname
from Restaurant, manager
where st_contains(Area, restLocation) = 1
order by managername;

# 1호점과 가까운 지점
select B.restname, B.restaddr, round(st_distance(A.restLocation, B.restLocation), 1) as 'distance'
from restaurant A, restaurant B
where A.restname like '%1호점' 
order by st_distance(A.restLocation, B.restLocation);

# 두 관리자의 지역을 모두 합쳐서 출력
select area into @eastnorthseoul from manager where areaname = '서울 동/북부지역';
select area into @westseoul from manager where areaname = '서울 서부지역';
select st_union(@eastnorthseoul, @westseoul) as '모든 관리지역을 합친 범위';

select area into @eastnorthseoul from manager where managername = '존밴이';
select area into @westseoul from manager where managername = '당탕이';
select st_intersection(@eastnorthseoul, @westseoul) into  @crossarea;

# 중복지역이 포함하는 지점
select restname 
from restaurant 
where st_contains(@crossarea, restlocation)=1;

select st_buffer(RoadLine, 30) into @roadbuffer from road;
select restname from restaurant where st_contains(@roadbuffer, restlocation)=1;

select st_buffer(RoadLine, 30) from road;
select RoadLine as '강변북로' from road;
select st_buffer(restlocation,5) from restaurant where st_contains(@roadbuffer, restlocation)=1;