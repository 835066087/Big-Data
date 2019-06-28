# 第六章_查询
# 6.1.1 全表查询和特定列查询
# 1.创建表
create table if not exists dept(
deptno int,
dname string,
loc int
)
row format delimited fields terminated by '\t';

create table if not exists emp(
empno int,
ename string,
job string,
mgr int,
hiredate string, 
sal double, 
comm double,
deptno int)
row format delimited fields terminated by '\t';

load data local inpath '/opt/module/datas/dept.txt' into table dept;
load data local inpath '/opt/module/datas/emp.txt' into table emp;
# 2.查询
select * from emp;
select empno, ename from emp;

# 6.1.2 列别名
select ename AS name, deptno dn from emp;

# 6.1.3 算术运算符

# 6.1.4 常用函数
select count(*) cnt from emp;
select max(sal) max_sal from emp;
select min(sal) min_sal from emp;
select sum(sal) sum_sal from emp;
select avg(sal) avg_sal from emp;

# 6.1.5 Limit语句
select * from emp limit 5;



# 6.2 Where语句
select * from emp where sal >1000;

# 6.2.1 比较运算符（Between/In/ Is Null）
select * from emp where sal between 500 and 1000;
select * from emp where comm is null;
select * from emp where sal IN (1500, 5000);

# 6.2.2 Like和RLike
select * from emp where sal LIKE '2%';
select * from emp where sal LIKE '_2%';
select * from emp where sal RLIKE '[2]';
# RLike通过Java正则表达式来指定匹配条件

# 6.2.3 逻辑运算符（And/Or/Not)
select * from emp where sal>1000 and deptno=30;
select * from emp where sal>1000 or deptno=30;
select * from emp where deptno not IN(30, 20);

# 6.3 分组
# 6.3.1 Group By
select t.deptno, avg(t.sal) avg_sal from emp t group by t.deptno;
select t.deptno, t.job, max(t.sal) max_sal from emp t group by t.deptno, t.job;

# 6.3.2 Having语句(having只用于group by分组统计语句)
select deptno, avg(sal) avg_sal from emp group by deptno having avg_sal > 2000;

# 6.4 Join语句
# 6.4.1 等值Join
select e.empno, e.ename, d.deptno, d.dname from emp e join dept d on e.deptno = d.deptno;

# 6.4.2 内连接
select e.empno, e.ename, d.deptno from emp e join dept d on e.deptno = d.deptno;

# 6.4.3 左外连接
select e.empno, e.ename, d.deptno from emp e left join dept d on e.deptno = d.deptno;

# 6.4.4 右外连接
select e.empno, e.ename, d.deptno from emp e right join dept d on e.deptno = d.deptno;

# 6.4.5 满外链接
# 将会返回所有表中符合WHERE语句条件的所有记录。如果任一表的指定字段没有符合条件的值的话，那么就使用NULL值替代。
select e.empno, e.ename, d.deptno from emp e full join dept d on e.deptno = d.deptno;

# 6.4.6 多表链接
# 注意：连接 n个表，至少需要n-1个连接条件。例如：连接三个表，至少需要两个连接条件。
create table if not exists location(
loc int,
loc_name string
)
row format delimited fields terminated by '\t';

load data local inpath '/opt/module/datas/location.txt' into table location;

SELECT e.ename, d.dname, l.loc_name
FROM   emp e 
JOIN   dept d
ON     d.deptno = e.deptno 
JOIN   location l
ON     d.loc = l.loc;

# 6.4.7 笛卡尔积
# 1.笛卡尔集会在下面条件下产生
#（1）省略连接条件
#（2）连接条件无效
#（3）所有表中的所有行互相连接 
# 错误示范如下：
select empno, dname from emp, dept;

# 6.4.8 连接谓词中不支持or
select e.empno, e.ename, d.deptno from emp e join dept d on e.deptno = d.deptno or e.ename=d.ename;

# 6.5 排序
# 6.5.1 全局排序（Order By）——只有一个Reducer
select * from emp order by sal;
select * from emp order by sal desc;

# 6.5.2 多个列排序
select ename, deptno, sal from emp order by deptno, sal;

# 6.5.3 每个MR内部排序（Sort By）
set mapreduce.job.reduces = 3;
set mapreduce.job.reduces;
select * from emp sort by deptno desc;

# 6.5.4 分区排序（Distributed By）——类似于MR中的partition
set mapreduce.job.reduces=3;
insert overwrite local directory '/opt/module/datas/distribute-result' 
	select * from emp distribute by deptno sort by empno desc;
# 1．distribute by的分区规则是根据分区字段的hash码与reduce的个数进行模除后，余数相同的分到一个区。
# 2．Hive要求DISTRIBUTE BY语句要写在SORT BY语句之前

# 6.5.5 Cluster By
# 当distribute by和sorts by字段相同时，可以使用cluster by方式。
# 排序只能是升序排序，不能指定排序规则为ASC或者DESC。
select * from emp cluster by deptno;
select * from emp distribute by deptno sort by deptno;

# 6.6 分桶及抽样查询
# 6.6.1 分桶表数据存储
# 分区针对的是数据的存储路径；分桶针对的是数据文件。
set hive.enforce.bucketing=true;
set mapreduce.job.reduces=-1;

insert into table stu_buck
select id, name from stu;

# 6.6.2 分桶抽样查询
select * from stu_buck tablesample(bucket 1 out of 4 on id);