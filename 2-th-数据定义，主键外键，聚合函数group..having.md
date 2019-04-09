## SQL数据定义

###  1.  基本类型

* char(n):固定长度的字符串，即使给定的字符串小于n，末尾补空格
* varchar(n):长度可变的字符串，用户指定最大长度
* int：整数类型
* smallint：小整数类型
* numeric(p,d)：定点数，精度由用户指定，这个数有p位数字，其中d个数在小数点右边
* real，double precision：浮点数与双精度数
* float(n)：精度至少为n位的浮点数

### 2.完整性约束

* primary key(Aj1,Aj2.....Ajm)：primary key标识属性Aj1,Aj2....Ajm构成关系的主码，主码必须非空且唯一
* *foreign key(Ak1,Ak2....Akn) references t_other(Aj1,Aj2....Ajn)*:属性(Ak1,Ak2...Akn)必须对应关系t_other中某元组在主码属性上的取值
* not null：一个属性上的not null约束表明在该属性上不允许空值

## 查询结果去重

```sql
SELECT DISTINCT dept_name FROM instructor;
```
sql查询默认不去重，去重需要指定DISTINCT关键词

### sql允许在where子句中使用逻辑连词and,or,not

逻辑连词的运算对象可以包含比较运算符   `=、<、<=、>、>=、<>(不等于)、!=`

## 更改某一个记录中的值
    UPDATE t SET r='newvalue' WHERE r1='r1Value'
    //例如
    UPDATE department SET building='Einstein' WHERE dept_name='Physics';
## 指定主键
    primary key (ID)
## 指定外键
    foreign  key (dept_name)  references  department(dept_name)
    //在instructor中的表的外键dept_name
    //设置删除信息自动解除外键
    on delete set null;   
## 更名运算
1. 重命名结果关系中属性
    SELECT avg(salary) as average_salary from instructor;

2. 重命名关系

    可以将一个长的关系名替换成短的
    ```sql
    select T.name,S.course_id
    from instructor as T,teaches as S
    where T.ID=S.ID;
    ```

3. 重命名为了比较同一个关系中的元组 

    为了把一个关系和它自身做笛卡尔集

    ```sql
    #选择所有教师的姓名，他们的工资至少比Biology系的最低工资要高
    select distinct T.name
    from insturctor as T,instructor as S
    where T.salary>S.salary and S.dept_name='Biology';
    ```
## 聚合函数

### 1. 基本聚集

* 平均值，avg

* 最小值，min

* 最大值，max

* 总和，sum

* 计数，count
    ```sql
    #用法实例
    SELECT avg(salary) from instructor;
    ```
    sum和avg输入必须时数字集，其他运算符可以作用在非数字数据类型的集合上。

    * 计算除去重复元素的个数

    ```sql
    select count(distinct ID) from teaches;
    # 除去重复元素
    ```

### 2. 分组聚集


1. group by   
  ```sql
#选择每个系的平均工资
SELECT dept_name,avg(salary) from
instructor GROUP BY dept_name; 
  ```

  *group by的注意事项：任何没有出现在group by子句中的属性如果出现在select子句中的话，它只能出现在聚集函数内部，否则这样的查询就是错误的。*
  ```sql
#例如其中的ID,salary都是出现在聚集函数内部，而dept_name因为是group by子句中的选项，可以出现在select子句中
select dept_name, count(ID), avg(salary) from instructor group by   dept_name;
  ```

### 3. having子句

有时候，对分组限定条件比对元组限定条件更有用，having条件并不针对单个元组，而是针对group by子句构成的分组。

```sql
#选择平均工资大于72000的那些分组
select dept_name,avg(salary)
from instructor
group by dept_name
having avg(salary)>72000;
```

*注意事项：having子句中的属性和select子句中的属性有同样的要求，即要么出现在group by子句中，要么就必须出现在聚合函数中。*

