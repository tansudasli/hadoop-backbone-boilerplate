
source .env

# contains zk specific env variables !

echo "run on znode only"
#
#


# hadoop arch. topology - fully distributed
# export NAME_NODE=${INSTANCE_NAMES[0]}
# export SECONDARY_NAME_NODE=${INSTANCE_NAMES[1]}
# export WORKER_NODES=(${INSTANCE_NAMES[2]} ${INSTANCE_NAMES[3]})

export ZK_PATH=(/data-1)

echo "configurations of ZK"

echo "servername's format is critical. must be 6 char, and last one must be uniquenumber"
hostname=`hostname`
serverNumber=${hostname:5:1}
echo "serverNumber="$serverNumber

# creates as new file
cat > ${ZOOKEEPER_HOME}/conf/zoo.cfg <<EOL
tickTime=2000
dataDir=${ZK_PATH[0]}/zookeeper
dataLogDir=${ZK_PATH[0]}/logs
clientPort=2181
maxClientCnxns=60
initLimit=5
syncLimit=2
server.1=znode1:2888:3888
server.2=znode2:2888:3888
server.3=znode3:2888:3888
server.4=znode4:2888:3888
server.5=znode5:2888:3888
EOL

# create data dir, for myid file before start scripts.!
mkdir ${ZK_PATH[0]}/zookeeper

# todo: every server must have a different number
cat > ${ZK_PATH[0]}/zookeeper/myid <<EOL
$serverNumber
EOL

cat > ${ZOOKEEPER_HOME}/start-zk.sh <<EOL
cd ${ZOOKEEPER_HOME}
java -cp zookeeper.jar:lib/*:conf org.apache.zookeeper.server.quorum.QuorumPeerMain ./conf/zoo.cfg
EOL

echo "for cluster mode, inside $ZOOKEEPER_HOME folder, run java -cp zookeeper.jar:lib/*:conf org.apache.zookeeper.server.quorum.QuorumPeerMain ./conf/zoo.cfg"
echo "then check client connection w/ -> bin/zkCli.sh -server IP:2181 to enter zk-shell"