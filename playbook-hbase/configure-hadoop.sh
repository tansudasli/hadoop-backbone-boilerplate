
source .env

echo "run on nameNode only"

# todo: design fully distributed arch. here
# contains internal env variables !
HADOOP_HOME=/home/hadoop/hadoop-3.2.1

NAME_NODE=${INSTANCE_NAMES[0]}
SECONDARY_NAME_NODE=${INSTANCE_NAMES[1]}
WORKER_NODES=(${INSTANCE_NAMES[2]} ${INSTANCE_NAMES[3]})
HDFS_PATH=(/data-1)

# STEP: backup
echo "backup conf. files"
cp ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env-backup.sh
cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/workers ${HADOOP_HOME}/etc/hadoop/workers-backup

# STEP: configuration
echo "configurations of HDFS"

echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_LOG_DIR=${HDFS_PATH}/logs >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh


cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://${NAME_NODE}:9000</value>
    </property>
</configuration>
EOL

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

# put only dataNodes' machines
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOL
${WORKER_NODES[0]}
${WORKER_NODES[1]}
EOL

# STEP: distribute
echo "distribute conf. files to all except master"

for i in $(seq 1 1 3) 
do

  scp ${HADOOP_HOME}/etc/hadoop/* hadoop@${INSTANCE_NAMES[i]}:${HADOOP_HOME}/etc/hadoop/
done

# STEP: format
echo "format HDFS for the first time"
${HADOOP_HOME}/bin/hdfs namenode -format

echo "HADOOP_HOME=$HADOOP_HOME"
echo "Run $HADOOP_HOME/sbin/start-dfs.sh to start hdfs."