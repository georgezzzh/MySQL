/*
3.1题目
表的说明
department是院系的表
instructor表是，所有教师信息
teaches表是，教师的教的课程的信息
student，是学生的基本信息表
take,是学生选课的表

*/
-- 1.选择title 在comp.sci department that have 3 credits;
SELECT title FROM course WHERE credits=3 AND dept_name='Comp. Sci.';
-- 2.找Einstein老师教的学生的ID，使结果不重复
SELECT distinct student.id
FROM (student join takes using(ID))
    join (instructor join teaches using(ID))
    using(course_id,sec_id,semester,year)
WHERE instructor.name='Einstein';
/*
使用join连接，连接列名和类型都相等的列，如果使用using则根据using设定的进行连接
否则natural join则全部的列名和类型相等的都要连接
*/
--3.选择教师中工资最高的任意一个
SELECT max(salary) from instructor;
--4.找出工资最高的所有教师(可能不止一位教师具有相同的工资)
SELECT * FROM instructor WHERE salary=(Select max(salary) FROM instructor);
--5.找出2019年秋季开设的每个课程段的选课人数
SELECT course_id,sec_id,count(ID)
from section natural join takes 
where semester='Fall'
and year=2009
group by course_id,sec_id;
/*
使用count(ID)时要用group by()分组
*/
--6选择最大的选课人数，2019年秋季
Select max(enrollment)
from
(select count(ID) as enrollment
from section natural join takes
where semester='Fall'
and year=2009
group by course_id,sec_id) oldCol;
--需要将子查询更改一个伪名，否则会报错Every derived table must have its own alias
--7 找出在2009年秋季拥有最多选课人数的课程段
WITH sec_enrollment as(
    SELECT course_id,sec_id,count(ID) as enrollment
    FROM section natural join takes
    WHERE semester='Fall'
    AND year=2009
    group by course_id,sec_id)
SELECT course_id,sec_id 
FROM sec_enrollment
WHERE enrollment=(SELECT MAX(enrollment) FROM sec_enrollment)
/*
这个可以用1.6的解法来做，但是要先根据group by聚类查出各个课程的数量，再从其中选出最大的值
答案用的WITH...AS子句，就是将一个查询语句重新命一个名，方便以后用查询的结果来继续查询。
这样就不用多层嵌套了，而且如果遇到同时调用好几次的情况，还能优化性能。
*/
--3.3.使用大学模式，给Comp. Sci.系的每位教师涨10%的工资
UPDATE instructor SET salary=salary*1.1 
WHERE dept_name='Comp. Sci.';
-- 3.3.b 删除所有course中的课程没出现在section中的
DELETE　FROM course WHERE course_id 
not in (SELECT course_id FROM SECTIon);
--3.3.c 把每个在tot_cred属性超出100的学生插入到教师表中，工资为10000
INSERT INTO instructor
SELECT ID,name,dept_name,10000
FROM student WHERE tot_cred>100;
--3.4
create table person(
    driver_id varchar(8),
    name varchar(15),
    address varchar(20),
    primary key(driver_id) 
);
create table car(
    licence varchar(8),
    model varchar(20),
    year numeric(4,0),
    primary key(licence)
);
create table accident(
    report_number varchar(8),
    date varchar(10),
    location varchar(20),
    primary key(report_number)
);
create table owner(
    driver_id varchar(8),
    licence varchar(8),
    primary key(driver_id,licence)
);
create table particated(
    report_number varchar(8),
    licence varchar(8),
    driver_id varchar(8),
    damage_amout numeric(5,0),
    primary key(report_number,licence),
    foreign key(driver_id) references person(driver_id)
    on delete set null
);
---
insert into person
values('10000','Tony','London');
insert into person
values('10001','Allen','Beijing');
insert into person
values('10002','jack','New York');
insert into person
values('10003','lucy','tokyo');
insert into person
values('10004','Tom','Beijing');
insert into person
values('10005','John Smith','Beijing');

insert into car
values('20000','Tesla',2009);
insert into car
values('20001','Toyota',2009);
insert into car
values('20002','Toyota',2003);
insert into car
values('20003','Mazda',2009);
insert into car
values('20004','Mazda',2007);

insert into accident
values('30000','2009-10-1','Beijing');
insert into accident
values('30001','2008-10-1','Beijing');
insert into accident
values('30002','2009-10-4','New York');
insert into accident
values('30003','2009-12-1','tokyo');
insert into accident
values('30004','2009-1-3','London');

insert into owner
values('10001','20000');
insert into owner
values('10000','20001');
insert into owner
values('10002','20002');
insert into owner
values('10003','20003');
insert into owner
values('10004','20004');

insert into particated
values('30000','20000','10001',3);
insert into particated
values('30001','20001','10002',2);
insert into particated
values('30002','20002','10003',3);
insert into particated
values('30003','20003','10004',200);
insert into particated
values('30004','20004','10005',100);

--
--1.选择2009年的所有事故
select * from accident where (date between '2009-0-0' and '2009-12-31');
--3.往accent插入一行

insert into accident values ('30010','2016-6-6','Los Angles');

insert into particated
select '30010',c.licence,o.driver_id,300
from car c,owner o,person p
where p.name='jack' and p.driver_id=o.driver_id and o.licence=c.licence;
/*from的时候可以用别名*/
/*
注意主键和外键不要同时选择同一个字段，否则不能删除外键的父级字段，也不能设置on delete set null;
*/
