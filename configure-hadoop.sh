echo "run on nameNode only"
echo "backups hadoop conf. files. then add new lines"
echo "then, formats hdfs namenode"

# todo: check => ${HADOOP_HOME}/bin/hadoop version
# todo: check ls ${HADOOP_HOME}/etc/hadoop/ | grep backup

# hadoop arch. topology - streched distributed
# this can be changed to fully distributed easiliy
export INSTANCE_NAMES=(machine-1 machine-2 machine-3)
export SECONDARY_NAME_NODE=machine-2
export WORKER_NODES=(machine-2 machine-3)
export HDFS_PATH=(/hdfs)

# set some env values
# all machines(master, secindaryMaster, workers...)
echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
# echo export HADOOP_LOG_DIR=/${HDFS}/logs >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

# backup conf. files touched
cp ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env-backup.sh
cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site-backup.xml
cp ${HADOOP_HOME}/etc/hadoop/workers ${HADOOP_HOME}/etc/hadoop/workers-backup


# creates as new file
# public-IP creates bindingException error
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://${INSTANCE_NAMES[0]}:9000</value>
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
# only dataNodes' machines
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOL
${WORKER_NODES[0]}
${WORKER_NODES[1]}
EOL

# distribute conf. files to workers
for i in ${!WORKER_NODES[@]}
do

  scp ${HADOOP_HOME}/etc/hadoop/* hadoop@${WORKER_NODES[i]}:${HADOOP_HOME}/etc/hadoop/
done


# format for the first time
${HADOOP_HOME}/bin/hdfs namenode -format