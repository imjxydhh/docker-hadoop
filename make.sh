#!/bin/bash

DOCKER_NETWORK=dockerhadoop_default
ENV_FILE=hadoop.env
build_prefix=z907738103/bigdata
task=$1
shift  

build () {
 	 # docker build -t $build_prefix:base  ./base \
	 #   docker build -t $build_prefix:namenode  ./namenode \
	 #  && docker build -t $build_prefix:datanode  ./datanode \
	 #  && docker build -t $build_prefix:resourcemanager  ./resourcemanager \
	 #  && docker build -t $build_prefix:nodemanager  ./nodemanager \
	 #  && docker build -t $build_prefix:historyserver  ./historyserver \
	 #  && docker build -t $build_prefix:sparkbase ./spark-base \
	 #  && docker build -t $build_prefix:sparkmaster ./spark-master \
	 #  && docker build -t $build_prefix:sparkworker ./spark-worker \
	 #   && docker build -t $build_prefix:hbasebase ./hbase-base \
	    docker build -t $build_prefix:hbasestandalone ./hbase-standalone
}

wordcount () {
	docker build -t hadoop-wordcount ./submit \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base  hdfs dfs -mkdir -p /input/ \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base  hdfs dfs -copyFromLocal /opt/hadoop-3.1.3/README.txt /input/ \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  hadoop-wordcount \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base  hdfs dfs -cat /output/* \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base  hdfs dfs -rm -r /output \
	 && docker run --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base  hdfs dfs -rm -r /input   
}

bash () {
	docker run -it --network $DOCKER_NETWORK  --env-file $ENV_FILE  $build_prefix:base /bin/bash
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

