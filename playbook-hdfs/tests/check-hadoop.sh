#!/bin/bash

echo "run w/ hadoop user"

${HADOOP_HOME}/bin/hadoop version
ls ${HADOOP_HOME}/etc/hadoop/ | grep backup

cat ${HADOOP_HOME}/etc/hadoop/core-site.xml

cat ${HADOOP_HOME}/etc/hadoop/workers