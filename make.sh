#!/bin/bash

DOCKER_NETWORK=dockerhadoop_default
ENV_FILE=hadoop.env
hadoop_version="3.1.3"
spark_version="2.4.6"
hbase_version="2.3.0"
task=$1
shift  

build () {
 	  docker build -t bde2020/hadoop-base:$hadoop_version  ./base \
	   && docker build -t bde2020/hadoop-namenode:$hadoop_version  ./namenode \
	   && docker build -t bde2020/hadoop-datanode:$hadoop_version  ./datanode \
	   && docker build -t bde2020/hadoop-resourcemanager:$hadoop_version  ./resourcemanager \
	   && docker build -t bde2020/hadoop-nodemanager:$hadoop_version  ./nodemanager \
	   && docker build -t bde2020/hadoop-historyserver:$hadoop_version  ./historyserver \
	   && docker build -t bde2020/hadoop-submit:$hadoop_version  ./submit  \
	   && docker build -t bde2020/spark-base:$spark_version ./spark-base \
	   && docker build -t bde2020/spark-master:$spark_version ./spark-master \
	   && docker build -t bde2020/spark-worker:$spark_version ./spark-worker \
	   && docker build -t bde2020/hbase-base:$hbase_version ./hbase-base \
	   && docker build -t bde2020/hbase-standalone:$hbase_version ./hbase-standalone
}

wordcount () {
	docker build -t hadoop-wordcount ./submit \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version  hdfs dfs -mkdir -p /input/ \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version  hdfs dfs -copyFromLocal /opt/hadoop-3.1.3/README.txt /input/ \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  hadoop-wordcount \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version  hdfs dfs -cat /output/* \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version  hdfs dfs -rm -r /output \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version  hdfs dfs -rm -r /input   
}

bash () {
	docker run -it --network $DOCKER_NETWORK  --env-file $ENV_FILE  bde2020/hadoop-base:$hadoop_version /bin/bash
}

spark_quick_submit() {
	jarpath=$1
	classname=$2
	shift 2
	appargs=$@
	docker build -t spark-submit ./spark-submit \
	 && docker run --network $DOCKER_NETWORK  --env FAST_SUBMIT=1 --env SPARK_APPLICATION_JARPATH=$jarpath --env SPARK_APPLICATION_ARGS="$appargs" --env SPARK_APPLICATION_MAIN_CLASS=$classname --env-file $ENV_FILE  spark-submit 
}

spark_submit() {
	docker build -t spark-submit ./spark-submit \
		&& docker run --network $DOCKER_NETWORK  --env FAST_SUBMIT=0 --env SPARK_SUBMIT_FLAGS="$echo $@" --env-file $ENV_FILE spark-submit 
}

set -x
$task "$@"
set +x

