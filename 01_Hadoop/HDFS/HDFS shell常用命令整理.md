# HDFS shell常用命令整理

## 1.启动与关闭Hadoop集群

> sbin/start-dfs.sh
>
> sbin/start-yarn.sh
>
> sbin/stop-dfs.sh
>
> sbin/stop-yarn.sh

## 2.目录相关操作

>hadoop fs -ls /dir
>
>hadoop fs -mkdir -p /dir1/dir2
>
>hadoop fs -mv /file /dir1/dir2
>
>hadoop fs -rm /dir1/dir2/file
>
>hadoop fs -rmdir /dir

## 3.文件移动操作

>① 从本地上传到HDFS
>
>hadoop fs -moveFromLocal ./file /dir1/dir2
>
>hadoop fs -copyFromLocal file /dir1/dir2
>
>hadoop fs -put file /dir1/dir2
>
>②从HDFS下载到本地
>
>hadoop fs -copyToLocal file /dir1/dir2
>
>hadoop fs -get file /dir1/dir2
>
>hadoop fs -getmerge file /dir1/dir2
>
>③文件内部操作
>
>hadoop fs -cat /file
>
>hadoop fs -chmod/chown/chgrp
>
>hadoop fs -cp /file /file
>
>hadoop fs -mv /file /file