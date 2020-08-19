export SPARK_DIST_CLASSPATH=$($HADOOP_PREFIX/bin/hadoop classpath):$HADOOP_HOME/lib/native
set -x
if [ $FAST_SUBMIT == 0 ]
then
	$SPARK_HOME/bin/spark-submit ${SPARK_SUBMIT_FLAGS}
else	
	$SPARK_HOME/bin/spark-submit \
        --class ${SPARK_APPLICATION_MAIN_CLASS} \
        --master yarn \
	--deploy-mode cluster \
	${SPARK_SUBMIT_ARGS} ${SPARK_APPLICATION_JARPATH} ${SPARK_APPLICATION_ARGS}
fi
set +x
