
source .env

echo "run on all znodes"

# todo: design fully distributed arch. here
# contains internal env variables !
ZOOKEEPER_HOME=/home/hadoop/apache-zookeeper-3.6.0-bin

ZK_NODE=(${INSTANCE_NAMES[@]:0:5})
ZK_PATH=(/data-1)

# STEP: configuration
echo "configurations of ZK"

cat > ${ZOOKEEPER_HOME}/conf/zoo.cfg <<EOL
tickTime=2000
dataDir=${ZK_PATH[0]}/zookeeper
dataLogDir=${ZK_PATH[0]}/logs
clientPort=2181
maxClientCnxns=60
initLimit=5
syncLimit=2
server.1=${ZK_NODE[0]}:2888:3888
server.2=${ZK_NODE[1]}:2888:3888
server.3=${ZK_NODE[2]}:2888:3888
server.4=${ZK_NODE[3]}:2888:3888
server.5=${ZK_NODE[4]}:2888:3888
EOL

# create data dir, for myid file before start scripts.!
mkdir ${ZK_PATH[0]}/zookeeper

# todo: every server must have a different number
# so, servername's format is critical. must be 6 char, and last one must be uniquenumber
hostname=`hostname`
serverNumber=${hostname:5:1}
echo "serverNumber="$serverNumber

cat > ${ZK_PATH[0]}/zookeeper/myid <<EOL
$serverNumber
EOL

# STEP: create file to start zk easily
cat > ${ZOOKEEPER_HOME}/start-zk.sh <<EOL
cd ${ZOOKEEPER_HOME}
nohup java -cp zookeeper.jar:lib/*:conf org.apache.zookeeper.server.quorum.QuorumPeerMain ./conf/zoo.cfg &
EOL

chmod +x ${ZOOKEEPER_HOME}/start-zk.sh

echo "ZOOKEEPER_HOME=$ZOOKEEPER_HOME"
echo "for cluster mode, run ${ZOOKEEPER_HOME}/start-zk.sh on all znodes"
echo "then check client connection w/ -> ${ZOOKEEPER_HOME}/bin/zkCli.sh -server IP:2181 to enter zk-shell"