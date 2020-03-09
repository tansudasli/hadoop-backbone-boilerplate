# run on compute engine


# adds below lines into same file
echo JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

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

# todo:  check => ./hadoop-3.2.1/bin/hadoop version

# format for the first time
${HADOOP_HOME}/bin/hdfs namenode -format