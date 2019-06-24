# 第五章_DML数据操作
# 5.1 数据导入
# 5.1.1 数据装载（load)
load data [local] inpath '/opt/module/datas/student.txt' 
[overwrite] into table student [partition (partcol1=val1,…)];
# 有local表示从本地加载数据，否则从hdfs中加载
# 有overwrite表示覆写，如无则追加
load data local inpath '/opt/module/datas/student.txt' into table default.student;

# 5.1.2 插入数据（Insert）
insert into table  student partition(month='201709') values(1,'wangwu'),(2,’zhaoliu’);
insert overwrite table student partition(month='201708')
            select id, name from student where month='201709';
#into为追加，overwrite为覆写

# 5.1.3 查询语句中创建表并加载数据（As Select）
# 根据查询结果创建表
create table if not exists student3 as select id, name from student;

# 5.1.4 创建表时通过Location指定加载数据路径
dfs -mkdir /student;
dfs -put /opt/module/datas/student.txt /student;

create external table if not exists student5(
              id int, name string
              )
              row format delimited fields terminated by '\t'
              location '/student';
# 5.1.5 Import数据到指定的Hive中
import table student2 partition(month='201709') from '/user/hive/warehouse/export/student';

# 5.2 数据导出
# 5.2.1 Insert导出
# 查询结果格式化导出到本地
insert overwrite local directory '/opt/module/datas/export/student1'
           ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'             
           select * from student;
# 查询结果导出到HDFS
insert overwrite directory '/user/atguigu/student2'
             ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
             select * from student;
# 5.2.2 Hadoop导出到本地
dfs -get /user/hive/warehouse/student/month=201709/000000_0 /opt/module/datas/export/student3.txt;
# 5.2.3 Shell命令导出
bin/hive -e 'select * from default.student;' > /opt/module/datas/export/student4.txt;
# 5.2.4 Export导出到HDFS
export table default.student to '/user/hive/warehouse/export/student';

# 5.3 清除表数据
truncate table student;

















