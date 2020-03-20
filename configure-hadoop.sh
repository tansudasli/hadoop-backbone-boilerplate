
source .env

# contains hadoop specific env variables !

echo "run on nameNode only"
#backups hadoop conf. files. then add new lines
#then, formats hdfs namenode for the first time


# hadoop arch. topology - fully distributed
export NAME_NODE=${HADOOP_INSTANCE_NAMES[0]}
export SECONDARY_NAME_NODE=${HADOOP_INSTANCE_NAMES[1]}
export WORKER_NODES=(${HADOOP_INSTANCE_NAMES[2]} ${HADOOP_INSTANCE_NAMES[3]})
export HDFS_PATH=(/data-1)


echo "backup conf. files touched"
cp ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env-backup.sh
cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/workers ${HADOOP_HOME}/etc/hadoop/workers-backup

echo "configurations of HDFS"

echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_LOG_DIR=${HDFS_PATH}/logs >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh


# creates as new file
# public-IP creates bindingException error
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://${NAME_NODE}:9000</value>
    </property>
</configuration>
EOL

# creates as new file
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml <<EOL
<configuration>

<!--master-->
    <property>
            <name>dfs.namenode.name.dir</name>
            <value>${HDFS_PATH[0]}/name</value>
    </property>

    <property>
            <name>dfs.namenode.edits.dir</name>
            <value>${HDFS_PATH[0]}/logs</value>
    </property>

    <property>
            <name>dfs.namenode.secondary.http-address</name>
            <value>${SECONDARY_NAME_NODE}:9880</value>
    </property>

    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>

<!--secondaryMaster-->
    <property>
            <name>dfs.namenode.checkpoint.dir</name>
            <value>${HDFS_PATH[0]}/secondaryName</value>
    </property>

<!--worker-->
    <property>
            <name>dfs.datanode.data.dir</name>
            <value>${HDFS_PATH[0]}/data</value>
    </property>
</configuration>
EOL

# creates as new file
# put only dataNodes' machines
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOL
${WORKER_NODES[0]}
${WORKER_NODES[1]}
EOL

echo "distribute conf. files to all except master"
# todo: can be replaced w/ rsync
for i in $(seq 1 1 $((${#HADOOP_INSTANCE_NAMES[@]}-1))) 
do

  scp ${HADOOP_HOME}/etc/hadoop/* hadoop@${HADOOP_INSTANCE_NAMES[i]}:${HADOOP_HOME}/etc/hadoop/
done


echo "format HDFS for the first time"
${HADOOP_HOME}/bin/hdfs namenode -format