FROM bde2020/spark-base:2.4.6

RUN mkdir /opt/spark-2.4.6-bin-without-hadoop-scala-2.12/appjars

COPY *.jar /opt/spark-2.4.6-bin-without-hadoop-scala-2.12/appjars/

ENV SPARK_SUBMIT_ARGS=""

ADD spark-submit.sh /spark-submit.sh
RUN chmod a+x /spark-submit.sh


CMD ["/spark-submit.sh"]
