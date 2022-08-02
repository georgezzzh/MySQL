## SQL中的连接

## 内连接

### 1. 笛卡尔连接

```sql
select * from instructor,teaches where  instructor.course_id=teaches.course_id;
```

笛卡尔连接在*from*子句中用逗号(,)隔开，数据库会做两个关系的笛卡尔积，之后再根据where的条件来选定。

特点：简单粗暴

### 2. 等值连接

* 选择所有上课的老师
1. 分别从teaches表和instrucor表抽取，令其ID相等即可

```sql
SELECT * FROM instructor,teaches
WHERE instructor.ID=teaches.ID
```

还可以一张相同的表进行连接，自身与自身进行连接。
Products表结构
```
+---------+---------+--------------+------------+----------------------------------------------------------------+
| prod_id | vend_id | prod_name    | prod_price | prod_desc                                                      |
+---------+---------+--------------+------------+----------------------------------------------------------------+
| ANV01   |    1001 | .5 ton anvil |       5.99 | .5 ton anvil, black, complete with handy hook                  |
| ANV02   |    1001 | 1 ton anvil  |       9.99 | 1 ton anvil, black, complete with handy hook and carrying case |
| ANV03   |    1001 | 2 ton anvil  |      14.99 | 2 ton anvil, black, complete with handy hook and carrying case |
+---------+---------+--------------+------------+----------------------------------------------------------------+
```
现在有个需求是，找出prod_id='DTNTR'的相同供应商(vend_id)的其他prod_id：
现在需要Products表与自身进行连接，为了避免混淆需要起别名。
```sql
select a.prod_id, a.prod_name from products as a, products as b 
        where a.vend_id=b.vend_id and b.prod_id='DTNTR';
```
### 3. 自然连接

自然连接只考虑那些再关系模式中都出现的属性上取值相同的元组对，默认会去除重复的属性(即只保留一列相同属性的一列，这里有别于笛卡尔连接)

```sql
select * from instructor natural join teaches;
//两个关系中，选择相同属性的列
```

自然连接也可以连接多个关系

```sql
select A1,A2,....,An
from r1 natural join r2 natural join rn
where p;
```

### 4. 指明条件的自然连接 (join......using)连接

为了发扬自然连接的优点，避免不必要的相等属性带来的危险，SQL提供了一种自然连接的构造形式，允许用户指定那些列相等。

```sql
select name,title
from (instructor natural join teaches) join course using(course_id);
```

### 5.join...on连接

 on可以使列名属性名不相同

   ```sql
   select * from student join takes
   on student.ID=takes.ID;
   ```

* 内连接

## 外连接

外连接运算与连接运算类似，但是结果中创建包括空值元组的方式，保留了那些在连接中丢失的元组。外连接在于当一个表中没有某一项，而另外一张表存在，查询结果以left或者right一侧为基准。

 * 左外连接

   ```sql
   select * from student natural left join takes;
   ```

 * 右外连接

   ```sql
   select * from takes natural right join students;
   ```

 * 全外连接

   MySQL不支持全外连接，使用left join union right join

```sql
select name,dept_name,course_id from student natural left join takes
union
select name,dept_name,course_id from student natural right join takes
```

*同样，join也可以用on或者using来限定范围*
