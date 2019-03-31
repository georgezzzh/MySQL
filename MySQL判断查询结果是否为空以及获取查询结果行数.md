## MySQL判断查询结果是否为空以及获取查询结果行数

```java
ResultSet res；
res.last();
final int N=res.getRow();
res.beforeFirst();
//当查询结果是空的时候，N=0；
```

