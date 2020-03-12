#!/bin/sh

# switch to hadoop user
sudo -u hadoop -i

# if cloud-init finished, then check
x=$(cat /var/log/syslog | grep ===== | wc -l)
if [ $x -eq 5]
then
   echo "CHECK"

   sudo cat /etc/passwd | grep hadoop
   java -version &&  ssh -V &&  pdsh -V && gcloud version
   ls / | grep tar.gz

   echo $JAVA_HOME && echo $HADOOP_HOME

   ls -l | grep hadoop

   df -h | grep hdfs
else
   echo "TRY AGAIN"
fi

