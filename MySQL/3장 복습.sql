use employees;

# index
select * from employees where first_name='Mary';
create index idx_employee on employees(first_name);

# view
use shopDB;
create view v_memberTBL as select memberName, memberAddress from memberTBL;
select * from v_memberTBL;

# stored procedure
delimiter //
create procedure myProc() 
	begin 
		select * from memberTBL where memberName='당탕이' ;
        select * from productTBL where productName='냉장고' ;
	end //
delimiter ;

call myProc(); 
drop procedure myProc;

# trigger
use shopDB;
insert into memberTBL values ('Figure', '연아','경기도 군포시 당정동');
select * from memberTBL;

update memberTBL set memberAddress = '서울 강남구 역삼동' where memberName='연아';
select * from memberTBL;

create table deletedMemberTBL (
memberID char(8),
memberName char(5),
memberAddress char(20),
deletedDate date
);

delimiter //
create trigger trg_deleteMemberTBL
	after delete
    on memberTBL
    for each row
begin
	insert into deletedMemberTBL values(old.memberID, old.memberName, old.memberAddress, CURDATE() );
end //
delimiter ;

select * from memberTBL;
delete from memberTBL where memberName = '연아';
delete from memberTBL where memberName = '당탕이';

select * from deletedMemberTBL;