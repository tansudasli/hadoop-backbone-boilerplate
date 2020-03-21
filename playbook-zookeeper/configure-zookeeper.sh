
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


# creates as new file
# public-IP creates bindingException error
cat > ${ZOOKEEPER_HOME}/conf/zoo.cfg <<EOL
tickTime=2000
dataDir=${ZK_PATH}/zookeeper
clientPort=2181
EOL