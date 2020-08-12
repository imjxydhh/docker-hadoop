#!/bin/bash

$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
