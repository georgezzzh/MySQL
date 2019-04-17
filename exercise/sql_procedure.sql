use miniprogram;
drop procedure if exists count_items;
delimiter //
create procedure count_items(inout s int)
	begin 
    set @temp=0;
    select count(*) into @temp from deal;
    set s=s+@temp;
    select s;
    end
//

set @s=2;
call count_items(@s);
select @s;