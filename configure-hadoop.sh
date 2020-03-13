# run on compute engine

# todo: check => ${HADOOP_HOME}/bin/hadoop version
# todo: check ls ${HADOOP_HOME}/etc/hadoop/ | grep backup

export WORKER_NODES=(machine-2 machine-3)

# set some env values
echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
# echo export HADOOP_LOG_DIR=/hdfs/logs >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

# backup conf files
cp ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env-backup.sh
cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/workers ${HADOOP_HOME}/etc/hadoop/workers-backup

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
            <name>dfs.namenode.name.dir</name>
            <value>${HADOOP_HOME}/data/nameNode</value>
    </property>

    <property>
            <name>dfs.datanode.data.dir</name>
            <value>${HADOOP_HOME}/data/dataNode</value>
    </property>

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
        <value>2</value>
    </property>
</configuration>
EOL

# creates as new file
# only dataNodes' machines
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOL
${WORKER_NODES[0]}
${WORKER_NODES[1]}
EOL

# distribute conf files to workers
for i in ${!WORKER_NODES[@]}
do

  scp ${HADOOP_HOME}/etc/hadoop/* hadoop@${WORKER_NODES[i]}:${HADOOP_HOME}/etc/hadoop/
done


# format for the first time
${HADOOP_HOME}/bin/hdfs namenode -format