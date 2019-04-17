use miniprogram;
# 存储过程返回结果集
drop procedure if exists procedure_set;
delimiter //
create procedure procedure_set()
	begin 
    select * from deal;
    end
//

call procedure_set();