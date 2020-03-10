# run on compute engine
# todo:  check => $HADOOP_HOME/bin/hadoop version

# set some env values
echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
# echo export HADOOP_LOG_DIR=/hdfs/logs >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

# backup conf files
# todo: check ls ${HADOOP_HOME}/etc/hadoop/ | grep backup
 cp ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env-backup.sh
 cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site-backup.xml
 cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site-backup.xml

# add hostname and IPs
index=1
for i in `gcloud compute addresses list | grep '\n' | awk '{$1=""; print $2}'`
do
  echo ${i} machine-${index} | sudo tee -a /etc/hosts
  let index=${index}+1
done

# creates as new file
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$(gcloud compute instances describe $(curl -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/name) --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone=europe-west4-a):9000</value>
    </property>
</configuration>
EOL

# creates as new file
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml <<EOL
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOL


# format for the first time
${HADOOP_HOME}/bin/hdfs namenode -format