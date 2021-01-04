### MySQL的递归查询

举个递归查询的简单例子。

**关系preq**

关系preq表示课程号，和它的前置课程。例如要想修数据结构，先要修C语言程序设计。那么数据结构的前置课程就是C语言程序设计。

| course_id | prereq_id |
| --------- | --------- |
|BIO-301|BIO-101|
|BIO-399|BIO-101|
|CS-190|CS-101|
|CS-315|CS-101|
|CS-319|CS-101|
|CS-347|CS-101|
|EE-181|PHY-101|

任何递归视图都必须被定义为两个子查询的并，一个非递归的**基查询**，和一个使用递归视图的递归查询。

#### 递归查询代码

```sql
with recursive rec_prereq(course_id,prereq_id) as
(
		# 基查询
		select course_id,prereq_id from prereq
	union
		# 递归查询
		select rec_prereq.course_id,prereq.prereq_id
		from rec_prereq,prereq
		where prereq.course_id = rec_prereq.prereq_id
)
select * from rec_prereq;
```

递归查询理解：首先计算基查询， 把所有结果元组添加到视图关系rec_prereq(初始时为空)中，然后用当前视图关系的内容计算递归查询, 并把所有结果元组加回到视图关系中。 持续重复上述步骤直到没有新的元组添加到视图关系中为止。
#### 如果要查询某一个课程的所有前置课程

查询804的所有前置课程
```sql
with recursive rec_prereq(course_id,prereq_id) as
(
		# 基查询，基查询的结果放入到rec_prereq中
		select course_id,prereq_id from prereq where course_id=804
	union
		# 递归查询，每次递归查询把结果放入到rec_prereq中
		select rec_prereq.course_id,prereq.prereq_id
		from rec_prereq,prereq
		where prereq.course_id = rec_prereq.prereq_id
		# where子句, rec_prereq是暂时查出符合条件的内容，prereq是整张表
)
select * from rec_prereq;
```

