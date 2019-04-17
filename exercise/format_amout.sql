# 通过将amount和expense的值结合给出最后返回的值
# 用sql中的函数来完成格式转换功能
set global log_bin_trust_function_creators=TRUE;
use miniprogram;

drop function if exists money; 
delimiter //
create function money(amount int,expense boolean)
returns int
begin
	set @num=0;
	if(expense) then
		set @num=-amount;
	else
		set @num=amount;
	end if;
	return @num;
end
//
# select money(10,false) as num;
select deal_id,money(amount,expense) from deal;
