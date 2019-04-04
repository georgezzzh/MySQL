## SQL中的函数的定义

1. 定义一个简单的函数

   ```sql
   set global log_bin_trust_function_creators=TRUE;
   
   CREATE FUNCTION  simpleFun() 
   RETURNS VARCHAR(20) 
   return "hello";
   # 调用函数
   select simpleFun();
   ```
2. 定义一个复杂的查询函数

      ```sql
      use university;
      # 如果函数存在,就删除掉，MySQL中函数不能重复定义
      drop function if exists deleteById;
      
      delimiter //
      create function deleteById(id varchar(5))
      returns varchar(20)
      begin
      delete from advisor where i_ID=id;
      return (select count(i_ID) from advisor);
      end
      //
      # 最后一行delimiter不要写了，写了会报错
      select deleteById('22222');
      
      
      ```

      * delimiter 后面跟上一个符号用来声明一段函数，不会遇到";"就结束,这个符号在函数结尾再出现一次
        用函数的时候,`select functionName(var);`即可

3. 在函数中声明变量使用while循环

   ```sql
   use university;
   
   drop function if exists my_sum;
   
   delimiter //
   create function my_sum(x int) returns int
   begin
   	set @i=1;
       set @sum=0;
       while @i<=x do
   		set @sum=@sum+@i;
           set @i=@i+1;
   	end while;
       return @sum;
       end
       //
   select my_sum(10);
   
   
   ```

   * 用`set @varName=initParam;`来声明变量；

4. 使用if流程判断语句

   ```sql
   use university;
   
   drop function if exists func;
   delimiter //
   create function func()
   	returns varchar(20)
   begin
   	if hour(now())>=11 
   		then return 'night';
   	else
   		return 'morning';
       end if;
   end
   //
   select func();    
   
   ```

   * 函数体中的hour()和now()是SQL中固有的函数

5.  用declare定义变量

   ```sql
   use university;
   
   drop function if exists dept_count;
    
   delimiter //
   create function dept_count(dept_name varchar(20))
   returns integer
   begin
   	declare d_count integer;
       select count(*) into d_count
       from instructor
       where instructor.dept_name=dept_name;
       return d_count;
   end
   //
   # select ..into...是从一张表选择数据插入到另一张表中
   # declare声明变量，可以不初始化
   select dept_count("Comp. Sci.")
   
   ```

   * declare在过程之前定义，set可以在任意地方定义

## SQL过程

1. ### out参数

```sql
use university;
drop procedure if exists myproc;
delimiter //
create procedure myproc(out s int) 
	begin
       select count(*) into s from student;
	end
//

call myproc(@s);
select @s;
```

* 调用procedure用`call procedureName(@param);`
* 参数out标识输出到变量中
* 选择输出 `select @Param;`

2. ### in param

   ```sql
   use university;
   drop procedure if exists in_param;
   
   delimiter //
   	create procedure in_param(IN p_in int) 
   		begin
           select p_in;
           set p_in=2;
           select p_in;
           end;
   //
   set @p_in=1;
   call in_param(@p_in);
   select @p_in;
   ```

   * 参数前面的*IN* ,标识需要输入参数,procedure()中参数是输入参数的实参，但是过程段的作用结果不影响外部。

3. ### out

   ```sql
   use university;
   drop procedure if exists out_param;
   
   delimiter //
   create procedure out_param(out p_out int)
   	begin
   		select p_out;
           set p_out=2;
           select p_out;
   	end;
   //
   set @p_out=1;
   call out_param(@p_out);
   select @p_out;
   
   ```

   * 使用out参数，过程作用后会修改输入参数，不管输入的擦书，默认为Null

4. 使用inout参数

   ```sql
   use university;
   drop procedure if exists inout_param;
   delimiter //
   create procedure
   inout_param(inout p_inout int)
   	begin
   		select p_inout;
           set p_inout=2;
           select p_inout;
   	end;
   //
   set @p_inout=1;
   call inout_param(@p_inout);
   select @p_inout;
   ```

###  in, out, inout  三者的区别

* in类型：内部运算变化不影响外部；
* out类型：内部运算变化影响外部变化并且传参到储存过程时默认初始化参数为null；
* inout类型：与out类型相比不同是默认初始化参数不为null，传的是什么就是什么。
* 如果某个变量既要是作为输入参数也要作为输出参数，用*inout* 类型