# 第四章 DDL数据定义
# 4.1 创建数据库
[COMMENT database_comment]
[LOCATION hdfs_path]
[WITH DBPROPERTIES (property_name=property_value, ...)];
# 1.默认
create database db_hive;
# 2.判断是否存在
create database if not exists db_hive;
# 3.指定位置
create database db_hive2 location '/db_hive2.db';

# 4.2 查询数据库
# 1.显示数据库
show databases;
# 2.查看数据库详情
desc database extended db_hive;
# 3.切换当前数据库
use db_hive;

# 4.3修改数据库
# 用户可以使用ALTER DATABASE命令为某个数据库的DBPROPERTIES设置键-值对属性值，来描述这个数据库的属性信息。
# 数据库的其他元数据信息都是不可更改的，包括数据库名和数据库所在的目录位置。
alter database db_hive set dbproperties('createtime'='20170830');

# 4.4 删除数据库
# 1.删除空数据库
drop database db_hive2;
# 2.删除不空数据库
drop database db_hive cascade;

# 4.5创建表
# 1.建表语法
CREATE [EXTERNAL] TABLE [IF NOT EXISTS] table_name;
[(col_name data_type [COMMENT col_comment], ...)] 
[COMMENT table_comment] 
[PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)] 
[CLUSTERED BY (col_name, col_name, ...) 
[SORTED BY (col_name [ASC|DESC], ...)] INTO num_buckets BUCKETS] 
[ROW FORMAT row_format] 
[STORED AS file_format] 
[LOCATION hdfs_path]
[TBLPROPERTIES (property_name=property_value, ...)]
[AS select_statement]
# 2.管理表（内部表）
# 3.外部表
# 因为表是外部表，所以Hive并非认为其完全拥有这份数据。
# 删除该表并不会删除掉这份数据，不过描述表的元数据信息会被删除掉。
# 创建外部表-上传数据到HDFS/创建外部表
dfs -mkdir /student;
dfs -mkdir /student;
create external table stu_external(
id int, 
name string) 
row format delimited fields terminated by '\t' 
location '/student';
# 4.内部表与外部表的相互转化
alter table student2 set tblproperties('EXTERNAL'='TRUE');
alter table student2 set tblproperties('EXTERNAL'='FALSE');

# 4.6分区表
create table dept_partition(
deptno int, dname string, loc string
)
partitioned by (month string)
row format delimited fields terminated by '\t';

load data local inpath '/opt/module/datas/dept.txt' into table default.dept_partition partition(month='201709');
load data local inpath '/opt/module/datas/dept.txt' into table default.dept_partition partition(month='201708');
load data local inpath '/opt/module/datas/dept.txt' into table default.dept_partition partition(month='201707');

# 单分区查询
select * from dept_partition where month='201709';
# 多分区查询
select * from dept_partition where month='201709'
              union
              select * from dept_partition where month='201708'
              union
              select * from dept_partition where month='201707';
# 增加分区
alter table dept_partition add partition(month='201706') ;
# 删除分区
alter table dept_partition drop partition (month='201704');
# 创建二级分区
create table dept_partition2(
               deptno int, dname string, loc string
               )
               partitioned by (month string, day string)
               row format delimited fields terminated by '\t';

load data local inpath '/opt/module/datas/dept.txt' into table default.dept_partition2 partition(month='201709', day='13');

select * from dept_partition2 where month='201709' and day='13';
# 在现有数据情况下添加分区（3总方式）
# （1）创建文件夹后load到分区
dfs -mkdir -p /user/hive/warehouse/dept_partition2/month=201709/day=10;
load data local inpath '/opt/module/datas/dept.txt' into table dept_partition2 partition(month='201709',day='10');
# （2）上传数据后添加分区
dfs -mkdir -p /user/hive/warehouse/dept_partition2/month=201709/day=11;
alter table dept_partition2 add partition(month='201709', day='11');

# 4.7修改表
# 重命名表
ALTER TABLE table_name RENAME TO new_table_name;
# 添加列
alter table dept_partition add columns(deptdesc string);
# 更新列
alter table dept_partition change column deptdesc desc int;
# 替换列
alter table dept_partition replace columns(deptno string, dname string, loc string);
# 删除表 
drop table dept_partition;


















