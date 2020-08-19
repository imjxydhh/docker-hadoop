#!/bin/bash

export SPARK_MASTER_HOST="`hostname`"
export SPARK_DIST_CLASSPATH=$(hadoop classpath):$HADOOP_HOME/lib/native

. "${SPARK_HOME}/sbin/spark-config.sh"

. "${SPARK_HOME}/bin/load-spark-env.sh"

$SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master \
       	--host $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT \
       	--webui-port $SPARK_MASTER_WEBUI_PORT
