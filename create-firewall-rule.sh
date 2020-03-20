
source .gcp.env

export RULE_NAME=hadoop-allow-management

gcloud compute --project=${PROJECT_NAME} firewall-rules create ${RULE_NAME} \
    --description="hadoop management ports" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:9870,tcp:9880 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=hadoop


# firewall rules - tag based selection
# gcloud compute --project=hadoop-sandbox-270208 firewall-rules create default-allow-http \
#     --direction=INGRESS \
#     --priority=1000 \
#     --network=default \
#     --action=ALLOW \
#     --rules=tcp:80 \
#     --source-ranges=0.0.0.0/0 \
#     --target-tags=hadoop

# gcloud compute --project=hadoop-sandbox-270208 firewall-rules create default-allow-https \
#     --direction=INGRESS \
#     --priority=1000 \
#     --network=default \
#     --action=ALLOW \
#     --rules=tcp:443 \
#     --source-ranges=0.0.0.0/0 \
#     --target-tags=hadoop