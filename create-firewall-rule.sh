
source .gcp.env

export RULE_NAME=hadoop-allow-management

# hdfs name-nodeIP: 9870
# hbase masterIP: 16010
# zk 0.0.0.0:8080
gcloud compute --project=${PROJECT_ID} firewall-rules create ${RULE_NAME} \
    --description="hadoop management ports" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:9870,tcp:9880,tcp:16010,tcp:16030,tcp:8080 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=hadoop
