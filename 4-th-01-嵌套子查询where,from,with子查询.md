## in和not in|where子查询

* 连接词in测试元组是否是集合中的成员，集合是由select子句产生的一组值构成，not in则测试元组是否不是集合中的成员

```sql
#选择即在2010年Spring开设的课，又在2009年Fall开设的课
# 可以用in来达到union的效果
select distinct course_id from section
where semester='Fall' and year=2009 and
course_id in 
(select course_id from section where semester='Spring' and year=2010);
```

* in和not in操作符也能用于枚举集合

  ```sql
  #选择不是mozart和Einstein的老师
  select distinct name
  from instructor where name not in
  ('Mozart','Einstein');
  ```

## 集合的比较 some all

* 至少比一个大，在SQL中用*some*来描述

  ```sql
  # 从教师列表中选出名字，其中工资至少比Biology系的一个老师多
  select name from instructor
  where salary>
  some(select salary from instructor where dept_name='Biology');
  ```

* 比所有的都xxx，在SQL中用*all*来描述

  ```sql
  #选出比所有计算机系老师的工资高的教师
  select name from instructor
  where salary>
  all(select salary from instructor where dept_name='Comp. Sci.');
  ```
## from子查询

* MySQL中from子查询必须要命别名

    ```sql
    select dept_name,avg_salary
    from(
    select dept_name,avg(salary)as avg_salary
    from instructor group by dept_name
    ) as T
    where avg_salary>42000;
    #查询系平均工资大于42000的系
    ```

## with子句   |   定义临时关系

* with子句提供定义临时关系的方法，这个定义只对包含with子句的查询有效。

  ```sql
  # 选择department中最大预算的一个系
  with max_budget(value) as (select max(budget) from department)
  select budget
  from department,max_budget
  where department.budget=max_budget.value;
  ```