#!/bin/bash

DOCKER_NETWORK=dockerhadoop_default
ENV_FILE=hadoop.env
current_branch="3.1.3"
task=$1
shift  

build () {
 	 #docker build -t bde2020/hadoop-base:$(current_branch) ./base \
	 # && docker build -t bde2020/hadoop-namenode:$(current_branch) ./namenode \
	 # && docker build -t bde2020/hadoop-datanode:$(current_branch) ./datanode \
	 # && docker build -t bde2020/hadoop-resourcemanager:$(current_branch) ./resourcemanager \
	 # && docker build -t bde2020/hadoop-nodemanager:$(current_branch) ./nodemanager \
	 # && docker build -t bde2020/hadoop-historyserver:$(current_branch) ./historyserver \
	 # && docker build -t bde2020/hadoop-submit:$(current_branch) ./submit  \     
	 # && docker build -t bde2020/spark-base:2.4.6 ./spark-base \
	 # && docker build -t bde2020/spark-master:2.4.6 ./spark-master \
	   docker build -t bde2020/spark-worker:2.4.6 ./spark-worker
}

wordcount () {
	docker build -t hadoop-wordcount ./submit \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/ \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal /opt/hadoop-3.1.3/README.txt /input/ \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -cat /output/* \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /output \
	 && docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /input  
}

bash () {
	docker run -it --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) /bin/bash
}

spark_quick_submit() {
	jarpath=$1
	classname=$2
	shift 2
	appargs=$@
	docker build -t spark-submit ./spark-submit \
	 && docker run --network ${DOCKER_NETWORK} --env FAST_SUBMIT=1 --env SPARK_APPLICATION_JARPATH=$jarpath --env SPARK_APPLICATION_ARGS="$appargs" --env SPARK_APPLICATION_MAIN_CLASS=$classname --env-file ${ENV_FILE} spark-submit 
}

spark_submit() {
	docker build -t spark-submit ./spark-submit \
		&& docker run --network ${DOCKER_NETWORK} --env FAST_SUBMIT=0 --env SPARK_SUBMIT_FLAGS="$(echo $@)" --env-file ${ENV_FILE} spark-submit 
}

set -x
$task "$@"
set +x

