# 第九章_企业级调优
# 9.1 Fetch抓取
# Fetch抓取是指，Hive中对某些情况的查询可以不必使用MapReduce计算。
# 例如：SELECT * FROM employees;
# 在这种情况下，Hive可以简单地读取employee对应的存储目录下的文件
# 然后输出查询结果到控制台。
set hive.fetch.task.conversion=more;
select * from emp;
select ename from emp;
select ename from emp limit 3;

# 9.2 本地模式
# Hive可以通过本地模式在单台机器上处理所有的任务。
# 对于小数据集，执行时间可以明显被缩短。
set hive.exec.mode.local.auto=true;
set hive.exec.mode.local.auto.inputbytes.max=50000000;
set hive.exec.mode.local.auto.input.files.max=10;

# 9.3 表的优化
# 9.3.1 小表、大表 Join
# 最好小表在左边，大表在右，新版Hive没有明显区别了

# 9.3.2 大表 Join 大表
# （1）空Key过滤
# 1）配置mapred-site.xml以启用历史服务器
# <property>
# <name>mapreduce.jobhistory.address</name>
# <value>hadoop102:10020</value>
# </property>
# <property>
#     <name>mapreduce.jobhistory.webapp.address</name>
#     <value>hadoop102:19888</value>
# </property>
# sbin/mr-jobhistory-daemon.sh start historyserver

insert overwrite table jointable select n.* from (select * from nullidtable where id is not null ) n  left join ori o on n.id = o.id;

#（2）空Key转换
set mapreduce.job.reduces = 5;
insert overwrite table jointable
select n.* from nullidtable n full join ori o on 
case when n.id is null then concat('hive', rand()) else n.id end = o.id;

# 9.3.3 MapJoin(小表join大表)
set hive.auto.convert.join = true;
set hive.mapjoin.smalltable.filesize=25000000;

# 9.3.4 Group By
set hive.map.aggr = true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.groupby.skewindata = true;

# 9.3.5 Count(Distinct) 去重统计
set mapreduce.job.reduces = 5;
select count(id) from (select id from bigtable group by id) a;

# 9.3.6 笛卡尔积

# 9.3.7 行列过滤

# 9.3.8 动态分区调整（Dynamic Partition）
hive.exec.dynamic.partition=true
hive.exec.dynamic.partition.mode=nonstrict
insert into table dept_partition partition(location) select deptno, dname, loc from dept;

# 9.3.9 分桶
# 9.3.10 分区

# 9.4 合理设置 Map 及 Reduce 数
# 9.4.1 复杂文件增加 Map 数
computeSliteSize(Math.max(minSize,Math.min(maxSize,blocksize)))=blocksize=128M
# maxSize最大值低于blocksize即可增加map个数

# 9.4.2 小文件进行合并
set hive.input.format= org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
SET hive.merge.mapfiles = true;
SET hive.merge.mapredfiles = true;
SET hive.merge.size.per.task = 268435456;
SET hive.merge.smallfiles.avgsize = 16777216;

# 9.4.3 合理设置Reduce数
set mapreduce.job.reduces = 15;
# 详细算法见MR理论文件

# 9.5 并行执行
set hive.exec.parallel=true;

# 9.6 严格模式
<property>
    <name>hive.mapred.mode</name>
    <value>strict</value>
    <description>
      The mode in which the Hive operations are being performed. 
      In strict mode, some risky queries are not allowed to run. They include:
        Cartesian Product.
        No partition being picked up for a query.
        Comparing bigints and strings.
        Comparing bigints and doubles.
        Orderby without limit.
</description>
</property>

# 9.7 JVM重用
# mapred-site.xml
<property>
  <name>mapreduce.job.jvm.numtasks</name>
  <value>10</value>
  <description>How many tasks to run per jvm. If set to -1, there is
  no limit. 
  </description>
</property>

# 9.8 推测执行（Speculative Execution）
# mapred-site.xml
<property>
  <name>mapreduce.map.speculative</name>
  <value>true</value>
  <description>If true, then multiple instances of some map tasks 
               may be executed in parallel.</description>
</property>

<property>
  <name>mapreduce.reduce.speculative</name>
  <value>true</value>
  <description>If true, then multiple instances of some reduce tasks 
               may be executed in parallel.</description>
</property>

# 9.9 执行计划(Explain)
explain extended select * from emp;
