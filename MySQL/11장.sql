### Full text index ###

show VARIABLES like 'innodb_ft_min_token_size';

CREATE DATABASE IF NOT EXISTS FulltextDB;
USE FulltextDB;
DROP TABLE IF EXISTS FulltextTbl;
CREATE TABLE FulltextTbl ( 
	id int AUTO_INCREMENT PRIMARY KEY, 	-- 고유 번호
	title VARCHAR(15) NOT NULL, 		-- 영화 제목
	description VARCHAR(1000)  		-- 영화 내용 요약
);

INSERT INTO FulltextTbl VALUES
(NULL, '광해, 왕이 된 남자','왕위를 둘러싼 권력 다툼과 당쟁으로 혼란이 극에 달한 광해군 8년'),
(NULL, '간첩','남한 내에 고장간첩 5만 명이 암약하고 있으며 특히 권력 핵심부에도 침투해있다.'),
(NULL, '남자가 사랑할 때', '대책 없는 한 남자이야기. 형 집에 얹혀 살며 조카한테 무시당하는 남자'), 
(NULL, '레지던트 이블 5','인류 구원의 마지막 퍼즐, 이 여자가 모든 것을 끝낸다.'),
(NULL, '파괴자들','사랑은 모든 것을 파괴한다! 한 여자를 구하기 위한, 두 남자의 잔인한 액션 본능!'),
(NULL, '킹콩을 들다',' 역도에 목숨을 건 시골소녀들이 만드는 기적 같은 신화.'),
(NULL, '테드','지상최대 황금찾기 프로젝트! 500년 전 사라진 황금도시를 찾아라!'),
(NULL, '타이타닉','비극 속에 침몰한 세기의 사랑, 스크린에 되살아날 영원한 감동'),
(NULL, '8월의 크리스마스','시한부 인생 사진사와 여자 주차 단속원과의 미묘한 사랑'),
(NULL, '늑대와 춤을','늑대와 친해져 모닥불 아래서 함께 춤을 추는 전쟁 영웅 이야기'),
(NULL, '국가대표','동계올림픽 유치를 위해 정식 종목인 스키점프 국가대표팀이 급조된다.'),
(NULL, '쇼생크 탈출','그는 누명을 쓰고 쇼생크 감옥에 감금된다. 그리고 역사적인 탈출.'),
(NULL, '인생은 아름다워','귀도는 삼촌의 호텔에서 웨이터로 일하면서 또 다시 도라를 만난다.'),
(NULL, '사운드 오브 뮤직','수녀 지망생 마리아는 명문 트랩가의 가정교사로 들어간다'),
(NULL, '매트릭스',' 2199년.인공 두뇌를 가진 컴퓨터가 지배하는 세계.');

# index가 없어서, full scan
select * from fulltexttbl where description like "%남자%";

# full text index 생성
create fulltext index idx_description on fulltexttbl(description);
show index from fulltexttbl;

# full text index를 통해 검색
select * from fulltexttbl; 

select * from fulltexttbl 
	where match(description) against('남자*' in boolean mode);
-- 결과 --
-- 대책 없는 한 남자이야기. 형 집에 얹혀 살며 조카한테 무시당하는 남자
-- 사랑은 모든 것을 파괴한다! 한 여자를 구하기 위한, 두 남자의 잔인한 액션 본능!
-- 남자의, 남자가, 남자, 남자이야기 등을 검색 (*은 임의의 문자 0개 이상을 의미)

select * from fulltexttbl 
	where match(description) against('남자' in boolean mode);
-- 결과 --
-- 대책 없는 한 남자이야기. 형 집에 얹혀 살며 조카한테 무시당하는 남자
-- 남자를 검색

# match 정도를 점수로 표기 가능함
# 공백으로 연결하면 or로 연결됨. 즉, '남자*' or '여자*'
select *, match(description) against('남자* 여자*' in boolean mode) as 'score'
	from fulltexttbl where match(description) against('남자* 여자*' in boolean mode);

# +word: word가 필수로 있어야 함    
select * from fulltexttbl
	where match(description) against('+남자* +여자*' in boolean mode);

# -word: word 제외
select * from fulltexttbl
	where match(description) against('남자* -여자*' in boolean mode);

# full text index의 word들 확인
set global innodb_ft_aux_table = 'fulltextdb/fulltexttbl';
select word, doc_count, doc_id, position 
	from information_schema.innodb_ft_index_table;
    
drop index idx_description on fulltexttbl;
create table user_stopword (value varchar(30));

insert into user_stopword values('그는'),('그리고'),('극에');

# 시스템 변수에 중지 단어용 테이블을 추가
set global innodb_ft_server_stopword_table = 'fulltextdb/user_stopword';
show global VARIABLES like 'innodb_ft_server_stopword_table';

create fulltext index idx_description on fulltexttbl(description);

select word, doc_count, doc_id, position
	from information_schema.innodb_ft_index_table;

### 파티션 ### 
CREATE DATABASE IF NOT EXISTS partDB;
USE partDB;
DROP TABLE IF EXISTS partTBL;
CREATE TABLE partTBL (
  userID  CHAR(8) NOT NULL, -- Primary Key로 지정하면 안됨
  name  VARCHAR(10) NOT NULL,
  birthYear INT  NOT NULL,
  addr CHAR(2) NOT NULL )
PARTITION BY range(birthyear)(
PARTITION part1 values less than (1971),
PARTITION part2 values less than (1979),
PARTITION part3 values less than maxvalue
);

insert into parttbl(
select userid, name, birthyear, addr from sqldb.usertbl);

# 파티션의 순서대로 조회됨
select * from parttbl;

select table_schema, table_name, partition_name, partition_ordinal_position, table_rows
	from information_schema.partitions
	where table_name = 'parttbl';

select * from parttbl where birthyear <= 1965;
explain select * from parttbl where birthyear <= 1965;

alter table parttbl
	reorganize partition part3 into
    (
    partition part3 values less than (1986),
	partition part4 values less than maxvalue
    );
optimize table parttbl;

alter table parttbl
	reorganize partition part1, part2 into(
    partition part12 values less than (1979)
    );
optimize table parttbl;

alter table parttbl drop partition part12;
optimize table parttbl;

# partition도 삭제하면 데이터도 함께 삭제
select * from parttbl;

# 리스트 파티션
drop table parttbl;

CREATE TABLE partTBL (
  userID  CHAR(8) NOT NULL, -- Primary Key로 지정하면 안됨
  name  VARCHAR(10) NOT NULL,
  birthYear INT  NOT NULL,
  addr CHAR(2) NOT NULL )
  PARTITION BY list columns(addr)(
  PARTITION part1 values in ('서울','경기'),
  partition part2 values in ('충북','충남'),
  partition part3 values in ('경북','경남'),
  partition part4 values in ('전북','전남'),
  partition part5 values in ('강원','제주')
  );
  
  insert into parttbl (
  select userid, name, birthyear, addr from sqldb.usertbl
  );
  
  select * from parttbl;
