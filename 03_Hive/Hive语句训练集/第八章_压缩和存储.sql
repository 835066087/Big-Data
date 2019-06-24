# 第八章_压缩和存储
# 8.1 Hadoop源码编译支持Snappy压缩（详参Hive文档）
# 8.2 Hadoop压缩配置
# 8.3 开启Map输出阶段压缩
# 开启map输出阶段压缩可以减少job中map和Reduce task间数据传输量。
set hive.exec.compress.intermediate=true;
set mapreduce.map.output.compress=true;
set mapreduce.map.output.compress.codec=org.apache.hadoop.io.compress.SnappyCodec;

# 8.4 开启Reduce输出阶段压缩
set hive.exec.compress.output=true;
set mapreduce.output.fileoutputformat.compress=true;
set mapreduce.output.fileoutputformat.compress.codec =org.apache.hadoop.io.compress.SnappyCodec;
set mapreduce.output.fileoutputformat.compress.type=BLOCK;

# 8.5 文件存储格式
# Hive支持的存储数据的格式主要有：TEXTFILE 、SEQUENCEFILE、ORC、PARQUET
# 8.5.1 列式存储和行式存储


