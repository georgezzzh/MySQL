use course_exercise;
# 创建更新触发器tri_after_update_user
# MySQL中触发器不能仅根据某一列来触发，只能根据行来触发。
# 类似的功能，一般是在触发器中判断一下这一列的值是否有变量。比如在 update触发器中
#if new.col = old.col 则代表这一列没有更新

# 创建一个before触发的触发器
drop trigger if exists tri_before_update_user;
delimiter //
create trigger tri_before_update_user after update on user
for each row
begin
	# 如果ID不同就记录 
	if new.id!=old.id then
	insert into user_history(user_id,operatetype,operatetime)
		values(new.id,concat('update a user,old id is:',old.id,',new id:',new.id),now());
	end if;
    # 如果只是改变了ID之外的内容，则记录
	if new.name!=old.name && new.id=old.id then
		insert into user_history(user_id,operatetype,operatetime)
			value(new.id,concat('update a user,id is:',new.id,",new name is:",new.name,",old name is:",old.name),now());
	end if;
end
//

