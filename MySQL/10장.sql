use sqldb;
drop procedure if exists userProc1;

delimiter //
create procedure userProc(in username varchar(10))
begin 
	select * from usertbl where name = userName;
end //
delimiter ;

call userProc('조관우');

drop procedure if exists userProc2;

delimiter //
create procedure userProc2(
	in userbirth int,
	in userheight int)
begin 
	select * from usertbl
		where birthyear > userbirth and height > userheight;
end //
delimiter ;

call userProc2(1970,178);

drop procedure if exists userProc3;

delimiter //
create procedure userProc3(
	in txtvalue char(10),
	out outvalue int)
begin 
	insert into testtbl values(null,txtvalue);
    select max(id) into outvalue from testtbl;
end //
delimiter ;

create table if not exists testtbl(
	id int auto_increment primary key,
    txt char(10)
    );
    
call userProc3('테스트값', @myvalue);
select @myvalue;

select * from testtbl;

drop procedure if exists ifelseProc;

delimiter //
create PROCEDURE ifelseProc(
	in username varchar(10)
    )
begin 
	declare bYear int;
    select birthYear into bYear from usertbl
		where name = userName;
	if (bYear >= 1980) then
		select '아직 젊군요';
	else
		select '그래도 아직 젊어요!';
	end if;
end //
delimiter ;

call ifelseProc('조용필');

# 십이간지 띠 호출
delimiter //
create procedure caseProc(in username varchar(10))
begin 
	declare byear int;
    declare tti varchar(10);
    
    select birthyear into byear from usertbl
		where name = username;
	
    case 
		when (byear%12 = 0) then set tti = '원숭이';
        when (byear%12 = 1) then set tti = '닭';
        when (byear%12 = 2) then set tti = '개';
        when (byear%12 = 3) then set tti = '돼지';
        when (byear%12 = 4) then set tti = '쥐';
        when (byear%12 = 5) then set tti = '소';
        when (byear%12 = 6) then set tti = '호랑이';
        when (byear%12 = 7) then set tti = '토끼';
        when (byear%12 = 8) then set tti = '용';
        when (byear%12 = 9) then set tti = '뱀';
        when (byear%12 = 10) then set tti = '말';
        else set tti = '양';
	end case;
    select tti;
end //
delimiter ;

call caseproc('김범수');

drop table if exists gugutbl;
create table gugutbl (txt varchar(100));
drop procedure if exists whileproc;

delimiter //
create procedure whileproc()
begin
	declare i int;
    declare j int;
    declare result varchar(100);
    
    set i = 1;
    set j = 1;
    
    while(i<=9) do
    
		while (j<=9) do
			if (j=1) then
				set result = concat(i, '*', j,'=',i*j);
            else 
				set result = concat(result, ', ', i, '*', j,'=',i*j);
			end if;
			set j = j + 1;
		end while;
        
        insert into gugutbl values(result);
        set i = i + 1 ;
        set j = 1;
        set result = '';
        
	end while;
    
	select * from gugutbl;
end //
delimiter ;

call whileproc();

drop procedure if exists errorProc;

delimiter //
create procedure errorproc()
begin
	declare i int;
    declare temp int;
    declare sum int;
    
    # 오류 처리(306쪽)의 경우, 설명이 좀 잘못됨
    declare exit handler for 1264
    BEGIN
		select concat('오버플로 직전의 합계: ', temp);
        select concat('1+2+3+...',i, '= 오버플로');
    end;
    
    set i = 1;
    set sum = 0;
    
    while (True) do
		set temp  = sum; # 오버플로 직전의 합계를 저장
		set sum = temp + i; 
        set i = i + 1;
	end while;

end //
delimiter ;

call errorproc();

# PROCEDURE 대문자로 쳐야 함
# 저장된 procedure 이름 및 내용
select routine_name, routine_definition 
	from information_schema.routines
	where routine_schema = 'sqldb' and routine_type = 'PROCEDURE';

# 프로시저의 파라미터 확인
select parameter_mode, parameter_name, dtd_identifier
	from information_schema.parameters
    where specific_name = 'userproc3';

show create procedure sqldb.userproc3;

# 테이블 이름을 파라미터로 전달하는 방법
drop procedure if exists nameProc;
delimiter //
create procedure nameproc(
in tblname varchar(20)
)
begin
	select * from tblname;
end //
delimiter ;

# error: tbl 이름을 파라미터로 전달할 수 없음
call nameproc ('userTBL');

drop procedure if exists nameProc;

delimiter //
create procedure nameProc(
	in tblname varchar(20))
begin
	# 주의: from 다음에 한 칸 띄어야 함
	set @querytxt = concat('select * from ', tblname);
	prepare myquery from @querytxt;
	execute myquery;
	DEALLOCATE PREPARE myquery;
end//
delimiter ;

call nameproc ('userTBL');

### 스토어드 함수 ###

# 스토어드 함수 사용
set global log_bin_trust_function_creators = 1;

use sqldb;

delimiter //
create FUNCTION userfunc(value1 int, value2 int)
	returns int
begin
	return value1 + value2;
end //
delimiter ;

select userfunc(100,200) as '100+200';

desc usertbl;

delimiter //
create function getAge(byear int)
	returns INT
begin
	declare age int;
    set age = year(curdate()) - byear;
    return age;
end //
delimiter ; 

select name, getAge(birthyear) as 'age' from usertbl;

# 함수 내용 확인
show create function getAge;
# 삭제
drop function getAge;

### cursor ### 
# 대상 행을 넘어가면서 처리
# 파이썬에서 for _, row in df.iterrows()와 유사한듯

use sqldb;
drop procedure if exists cursorProc;

delimiter //
create procedure cursorProc()
begin 
	declare userHeight int;
    declare cnt int default 0;
    declare totalHeight int default 0;
    
    declare endofRow boolean default false;
    
    declare userCursor cursor for
		select height from usertbl;
	
    declare continue handler 
		for not found set endofRow = True;
        
	open userCursor;
    
    cursor_loop: LOOP
			fetch usercursor into userHeight;
            
            if endofRow then
				leave cursor_loop;
			end if;
            
			set cnt = cnt + 1;
            set totalHeight = totalHeight + userHeight;
    END LOOP cursor_loop;
    
    select totalHeight/cnt;
    close usercursor;
end //
delimiter ;

call cursorproc();

# grade 열 추가
alter table usertbl add grade varchar(5);
		
drop procedure if exists gradeproc;

delimiter //
create procedure gradeproc()
begin
	declare id varchar(10);
    declare spend bigint;
    declare grade varchar(5);
    # endofrow 선언
    declare endofrow boolean default false;
    
    # 커서 선언
    declare c cursor for
		select u.userid, sum(b.price*b.amount) 
			from buytbl b 
				right outer join usertbl u
				on u.userid=b.userid
			group by u.userid;
        
	# 커서 종료를 위한 endofrow 
    declare continue handler 
		for not found set endofrow = True;
	
    # 커서 오픈
    open c;
    
    # 루프
    c_loop: loop
			fetch c into id, spend;
            
            # 루프 탈출
            if endofrow then
				leave c_loop;
			end if;
            
			if spend >= 1500 
				then set grade = 'A';
            elseif spend >= 1000 
				then set grade = 'B';
            elseif spend >= 1 then
				set grade = 'C';
			else set grade = 'F';
            end if;
            
            update usertbl set grade = grade where userid = id;
		
    end loop c_loop;
    
    # 커서 종료
    close c;
end //
delimiter ;

call gradeproc();
select * from usertbl;

### 트리거 ###
create database if not exists testdb;
use testdb;

create table if not exists testtbl (id int, txt varchar(10));
insert into testtbl values(1,'레드벨벳');
insert into testtbl values(2,'잇지');
insert into testtbl values(3,'블랙핑크');

drop trigger if exists testTrg;
delimiter //
create trigger testtrg
	after delete
    on testtbl
    for each row
begin
	set @msg = '가수 그룹이 삭제됨';
end //
delimiter ;

set @msg = '';
insert into testtbl values(4,'마마무');
select @msg;
update testtbl set txt = '블핑' where id = 3;
select @msg;
delete from testtbl where id = 4;
select @msg;

### 실습5 ###
use sqldb;
drop table buytbl;

CREATE TABLE backtbl
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr	  CHAR(2) NOT NULL, 
  mobile1	CHAR(3), 
  mobile2   CHAR(8), 
  height    SMALLINT,  
  mDate    DATE,
  modType  CHAR(2), -- 변경된 타입. '수정' 또는 '삭제'
  modDate  DATE, -- 변경된 날짜
  modUser  VARCHAR(256) -- 변경한 사용자
);

drop trigger if exists backtbl;
delimiter //
create trigger back_tri
	after delete
    on usertbl
    for each row
begin
	insert into backtbl values(OLD.userID, OLD.name, OLD.birthYear, 
        OLD.addr, OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate, 
        'DELETE', CURDATE(), CURRENT_USER() );
end //
delimiter ;

update usertbl set addr='몽고' where userid = 'JKW';
delete from usertbl where height > 177;

select * from backtbl;

# 단, TRUNCATE에는 delete 트리거가 작동하지 않음

drop trigger if exists back_tri;

# 데이터 수정 시 경고 메세지 날리는 트리거
delimiter //
create trigger back_tri
	after insert
    on usertbl
    for each row
begin
	# 사용자 오류 강제 발생. 이 경우 사용자의 시도는 롤백됨
	signal SQLSTATE '45000' 
		set MESSAGE_TEXT = 'ALERT';
end //
delimiter ; 

INSERT INTO userTbl VALUES('ABC', '에비씨', 1977, '서울', '011', '1111111', 181, '2019-12-25');
drop trigger back_tri;

### before trigger ###
use sqldb;

delimiter //
create trigger tri
	before insert
    on usertbl
    for each row
begin
	if new.birthyear < 1900 then
		set new.birthyear = 0;
	elseif new.birthyear > year(curdate()) then
		set new.birthyear = year(curdate());
	end if;
end //
delimiter ;

INSERT INTO userTbl VALUES
  ('AAA', '에이', 1877, '서울', '011', '1112222', 181, '2022-12-25');
INSERT INTO userTbl VALUES
  ('BBB', '비이', 2977, '경기', '011', '1113333', 171, '2019-3-25');
select * from usertbl;

SHOW TRIGGERS FROM sqlDB;

DROP TRIGGER tri;

### 중첩 트리거 ###
drop database if exists triggerdb;
create database if not exists triggerdb;

USE triggerDB;
CREATE TABLE orderTbl -- 구매 테이블
	(orderNo INT AUTO_INCREMENT PRIMARY KEY, -- 구매 일련번호
          userID VARCHAR(5), -- 구매한 회원아이디
	 prodName VARCHAR(5), -- 구매한 물건
	 orderamount INT );  -- 구매한 개수
CREATE TABLE prodTbl -- 물품 테이블
	( prodName VARCHAR(5), -- 물건 이름
	  account INT ); -- 남은 물건수량
CREATE TABLE deliverTbl -- 배송 테이블
	( deliverNo  INT AUTO_INCREMENT PRIMARY KEY, -- 배송 일련번호
	  prodName VARCHAR(5), -- 배송할 물건		  
	  account INT UNIQUE); -- 배송할 물건개수

INSERT INTO prodTbl VALUES('사과', 100);
INSERT INTO prodTbl VALUES('배', 100);
INSERT INTO prodTbl VALUES('귤', 100);

# 주문이 들어오면 배송 사항을 업데이트하는 트리거
delimiter //
create trigger prodtrg
	after update
    on prodtbl
    for each row
begin
	declare orderamount int;
    set orderamount = old.account - new.account ;
	insert into delivertbl values(null, new.prodname, orderamount);
end //
delimiter ;

# 주문이 들어오면 재고를 업데이트하는 트리거
delimiter //
create trigger ordertrg
	after insert
    on ordertbl
    for each row
begin
	update prodtbl set account = account - new.orderamount 
		where prodname = new.prodname;
end //
delimiter ;

insert into ordertbl values (null, 'JOHN','배',5);

SELECT * FROM orderTbl;
SELECT * FROM prodTbl;
SELECT * FROM deliverTbl;
	
