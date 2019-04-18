## 触发器

触发事件的操作和触发器中的SQL语句是一个事务操作，具有原子性，要么全部执行，要么全部不执行。

### MySQL查看触发器的命令

` select * from information_schema.triggers where trigger_name='tri_before_update_user';`

### MySQL删除触发器的命令

`drop trigger tri_before_update_user;`

*创建基本表 user和user_history表*

```sql
use course_exercise;
drop table if exists user;
# 创建表user
create table user(
id int auto_increment,
account varchar(255),
name varchar(255),
address varchar(255),
primary key(id)
);
# 创建表user_history
drop table if exists user_history;
create table user_history(
id int auto_increment,
user_id int not null,
operatetype varchar(255) not null,
operatetime datetime not null,
primary key(id)
);
```

创建触发器*tri_after_insert_user*

```sql
# 创建表插入的触发器tri_insert_user
# 在插入之后执行
drop trigger if exists tri_after_insert_user;
delimiter //
create trigger tri_after_insert_user after insert on `user`
for each row
begin
	# 把记录插入到user_history中
	insert into user_history(user_id,operatetype,operatetime)
		values(new.id,'add a user',now());
end
//
```

### 在触发器中用函数

* MySQL中触发器不能仅根据某一列来触发，只能根据行来触发。
*  类似的功能，一般是在触发器中判断一下这一列的值是否有变量。比如在 update触发器中`if new.col = old.col`则代表这一列没有更新
* 在mysql中可以用*concat()*函数来拼接字符串
* before也可以获取new行的数据

```sql
use course_exercise;
# 创建更新触发器tri_after_update_user
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
    # 如果只是改变了ID之外的内容，则记录相关的内容
	if new.name!=old.name && new.id=old.id then
		insert into user_history(user_id,operatetype,operatetime)
			value(new.id,concat('update a user,id is:',new.id,",new name is:",new.name,",old name is:",old.name),now());
	end if;
end
//
```
