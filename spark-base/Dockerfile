FROM bde2020/hadoop-base:3.1.3

ENV SPARK_URL https://downloads.apache.org/spark/spark-2.4.6/spark-2.4.6-bin-without-hadoop-scala-2.12.tgz 

RUN set -x \
    && curl -fsL "$SPARK_URL" -o /tmp/spark-2.4.6.tgz \
    && tar -xvf /tmp/spark-2.4.6.tgz -C /opt/ \
    && rm /tmp/spark-2.4.6.tgz

ENV SPARK_HOME /opt/spark-2.4.6-bin-without-hadoop-scala-2.12
ENV SPARK_MASTER "spark://spark-master:7077"
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_WEBUI_PORT 8081
ENV SPARK_LOGS $SPARK_HOME/logs
#hadoop conf dir set in base's Dockerfile
ENV YARN_CONF_DIR $HADOOP_CONF_DIR

RUN mkdir -p "$SPARK_LOGS"
