## 函数的删除与查看

函数是定义在一个数据库中的，例如定义在miniprogram或者university数据库中。

### 显示某个自定义的函数

```
show function status like 'money';
# 显示匹配'money'函数的状态，会匹配全部数据库中所有匹配money的函数
# 如果不加like 'money'，会显示非常多的函数，不容易观察
```

### 删除某个自定义的函数

```
use miniprogram;
drop function money;
# 删除miniprogram数据库中的money函数
```

### JDBC调用自定义的函数

SQL的函数定义**money()**函数

```sql
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
```

Java中调用函数的例子

```java
    public void call_sql_function(){
        # 调用自定义的money()函数
        String sql="select deal_id,money(amount,expense)as money from deal";
        # 和调用系统函数差不多
        SqlRowSet rw= jdbcTemplate.queryForRowSet(sql);
        while(rw.next()){
            String deal_id=rw.getString("deal_id");
            double amount=rw.getDouble("money");
            System.out.println("deal id:"+deal_id+"\tamount:"+amount);
        }
    }
```

## jdbc调用存储过程

```java
public void call_sql_procedure() throws Exception{
    DataSource ds=jdbcTemplate.getDataSource();
    Connection connection=ds.getConnection();
    // 存储过程有一个参数
    CallableStatement cs=connection.prepareCall("{call count_items(?)}");
    //输入一个参数，返回输入的参数+统计的deal里的内容
    //设置存储过程的输入参数
    cs.setInt(1,100);
    //设置存储过程的输出参数
    cs.registerOutParameter(1, MysqlType.FIELD_TYPE_INT24);
    cs.execute();
    //获取存储过程out返回的参数
    int num=cs.getInt(1);
    System.out.println("procedure return: "+num);
    connection.close();
}
```

## jdbc调用带有返回集的存储过程

定义带有返回集的存储过程

```sql
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
```



```java
public void getSqlProcedureSet(){
    try{
        DataSource ds=jdbcTemplate.getDataSource();
        Connection connection=ds.getConnection();
        CallableStatement cs=connection.prepareCall("{call procedure_set()}");
        cs.execute();
        // 获取结果集
        ResultSet set=cs.getResultSet();
        while (set.next()){
            System.out.println(set.getInt("deal_id"));
        }
    }catch (Exception e){
        e.printStackTrace();
    }
}
```