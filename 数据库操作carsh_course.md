## 创建数据库
```sql
create database myfirstdatabase;
```
## 删除数据库
```sql
drop database myfirstdatabase;
```
## 选中数据库
```sql
use myfirstdatabase;
```
## 在命令行下使用SQL文件进行数据库操作
```sql
source xxx/xxx.sql
//xxx/xxx.sql代表sql文件的绝对路径
```
## 查看某个数据库中所有表
```sql
show tables;
```
## 创建表
```sql
create table instructor
    (ID	varchar(5), 
    name  varchar(20) not null, 
    dept_name	varchar(20), 
    salary	numeric(8,2),
    primary key (ID)
    );
```
## 删除表
```sql
drop table instructor;
```

## 清空表

```sql
delete from instructor;
//不指明where，默认全部
```
## 增加表的列
    ALTER TABLE r ADD a d
r是表名，a是列名，d是列的类型   

    ALTER TABLE instructor ADD sex varchar(5);
    //增加属性sex
## 删除表的列
    ALTER TABLE r DROP a
r是表名，a是列的值   

    ALTER TABLE instructor DROP sex;



