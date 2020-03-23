
source .env

echo "....."
#
#

# contains related env variables !

# design arch. topology - fully distributed
export HMASTER_NODE=${INSTANCE_NAMES[9]}
export BACKUP_HMASTERS=(${INSTANCE_NAMES[10]})
export REGION_SERVERS=(${INSTANCE_NAMES[11]} ${INSTANCE_NAMES[12]})
export HBASE_PATH=(/data-1)

# STEP: backup
echo "backup conf. files touched"
cp ${HBASE_HOME}/conf/hbase-env.sh ${HBASE_HOME}/conf/hbase-env-backup.sh
cp ${HBASE_HOME}/conf/hbase-site.xml ${HBASE_HOME}/conf/hbase-site-backup.xml


# STEP: configuration
echo export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) >> ${HBASE_HOME}/conf/hbase-env.sh
# echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
echo export HBASE_LOG_DIR=${HBASE_PATH}/logs >> ${HBASE_HOME}/conf/hbase-env.sh


# cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOL
# <configuration>
#     <property>
#         <name>fs.defaultFS</name>
#         <value>hdfs://${NAME_NODE}:9000</value>
#     </property>
# </configuration>
# EOL

cat > ${HBASE_HOME}/conf/hbase-site.xml <<EOL
<configuration>

<!--master-->
    <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>

    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://name-node:9000/hbase</value>
    </property>

    <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>${HBASE_HOME}/root/zookeeper</value>
    </property>

<!--
    <property>
        <name>hbase.unsafe.stream.capability.enforce</name>
        <value>true</value>
    </property>
-->

<!--secondaryMaster-->


<!--worker-->

</configuration>
EOL

# put only regionServers' machines
cat > ${HBASE_HOME}/conf/regionservers <<EOL
${REGION_SERVERS[0]}
${REGION_SERVERS[1]}
EOL

# put only backup masters' machines
cat > ${HBASE_HOME}/conf/backup-masters <<EOL
${BACKUP_HMASTERS[0]}
EOL

# STEP: distribute
for i in $(seq 10 1 3) 
do

  scp ${HBASE_HOME}/conf/* hadoop@${INSTANCE_NAMES[i]}:${HBASE_HOME}/conf/
done


echo "start hbase, run ${HBASE_HOME}/bin/start-hbase.sh"