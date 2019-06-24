# 第七章_函数
# 7.1 系统自带函数
show functions;
desc function extended upper;

# 7.2 自定义函数
# 1.三类UDF（user-defined function）
# （1）UDF——一进一出
# （2）UDAF（User-Defined Aggregation Function)——多进一出，类似于(count/max/min)
# （3）UDTF（User-Defined Table-Generating Functions)——一进多出，（lateral view explore()）

# 2.编程步骤
#（1）继承org.apache.hadoop.hive.ql.exec.UDF
#（2）需要实现evaluate函数；evaluate函数支持重载；
#（3）在hive的命令行窗口创建函数
# 1）添加jar
add jar /opt/module/datas/udf.jar
# 2）创建function
create [temporary] function [dbname.]function_name AS class_name;
create temporary function mylower as "com.atguigu.hive.Lower";
# drop [temporary] function [if exists] [dbname.]function_name;
select ename, mylower(ename) lowername from emp;
# UDF必须要有返回类型，可以返回null，但是返回类型不能为void;
