#!/bin/bash

echo "run w/ hadoop user"

# if cloud-init finished, then check
x=$(cat /var/log/syslog | grep ===== | wc -l)
if [ $x -eq 5 ]
then
   echo "CHECK"

   sudo cat /etc/passwd | grep hadoop
   java -version &&  ssh -V &&  pdsh -V && gcloud version
   ls / | grep t*gz

   echo "JAVA_HOME="$JAVA_HOME && echo "HADOOP_HOME="$HADOOP_HOME && echo "rcmd default="$PDSH_RCMD_TYPE

   ls -l ~ | grep hadoop-

   df -h | grep data

   cat /etc/hosts | grep machine-

   echo "if env. vars are empty, run source /etc/environment manually !"
else
   echo "WAIT and TRY AGAIN"
fi

