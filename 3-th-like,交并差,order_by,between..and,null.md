## 字符串操作 like

* 百分号`%`匹配任意一个字符
* 下划线`_`匹配任意一个字符  


例子：
1. 模式"intro%",匹配以"intro"开头的字符串
2. 模式"%Comp%",匹配任何包含"Comp"作为一个字串
3. 模式"_ _ _",匹配任何包含三个字符的字符串(实际中下划线不需要空格)
4. 模式"_ _ _%",匹配任何至少为三个字符的字符串   

```sql
    select name from instructor where name like "%in%";
```
## order by排序
1. 将所有信息按照name属性升序        
    ```sql
    select * from instructor
    order by dept_name;
    ```

2. 用降序方式desc

    ```sql
    select * from instructor
    order by dept_name desc;
    ```

3. 多个排序条件混用

    ```sql
    #按照工资降序排序，如果工资相同则按照名字升序排序
    select * from instructor
    order by salary desc,name;
    ```
## between...and
1. 选择所有工资在70000-90000之间的教师

        select *
        from instructor
        where salary between 70000 and 90000;

### 多个属性用元组来比较

```sql
#选择所有Biology系老师所讲授的课程
select name,course_id
from instructor,teaches
where (instructor.ID,dept_name)=(teaches.ID,'Biology');
```

## MySQL中的交，并，差

### 1. 并 (union)

* 交与直接用select子句的不同在于，union结果不会保留重复项。

    ```sql
    #选择在2009年秋季和2010年春季开设的课的course_id
    (select course_id from section where semester='Fall' and year=2009)
    union
    (select course_id from section where semester='Spring' and year=2010)
    ```



### 2.交

* MySql中没有提供intersect关键字，用自然连接来实现
    ```sql
    #选出两个中的关系中的重复项
    select course_id from(
    (select course_id from section where semester='Fall' and year=2009) as T
    natural join
    (select course_id from section where semester='Spring' and year=2010) as G
    );
    #要注意的是，MySQL必须要给两个表提供别名
    ```

### 3.差

* MySql实现差运算用左连接
    ```sql
    MySQL中没有except操作符
    select * from
    (select course_id from section where semester='Fall' and year=2009) as S
    left join
    (select course_id from section where semester='Spring' and year=2010) as T
    on S.course_id=T.course_id
    where T.course_id is null;
    # S.course_id为Null即,在S表中不存在，T表存在，左连接以左边为基准，来匹配右边的选择,on连接返回左边匹配的所有的项目
    ```

## mysql中的null

* 判读null时用`is null`来判断

  ```sql
  #选择所有成绩为null的信息
  select * from takes where grade is null;
  #选择所有不为空的
  select * from takes where grade is not null;
  ```
