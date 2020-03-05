#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

export PROJECT_ID=hadoop-sandbox-270208     # must be unique - gcp level

export REGION=europe-west4
export ZONE=(europe-west4-a) #(europe-west4-a europe-west4-b europe-west4-c)
export INSTANCE_NAME=(machine-1 machine-2 machine-3)

# export INGESTION_BUCKET_NAME=
# export AIRFLOW_BUCKET_NAME=.....         # get from gcs buckets and update

# ----------- create machines ---------
echo "create machines on 1 region, for 3 zones and N additional-disks => streched distributed, low latency b/w zones"

# deletes data disk! keep in mind 
# creates compute engine w/ N additional-disk in N zone
for i in ${!ZONE[@]}
do
   x="gcloud beta compute --project=hadoop-sandbox-270208 instances create machine-${i+1}"
   x=$x" --zone=${ZONE[i]}"
   x=$x"  --machine-type=custom-12-79872"
   x=$x" --subnet=default"
   x=$x" --network-tier=PREMIUM"
   x=$x" --maintenance-policy=MIGRATE"
   x=$x" --service-account=762922822926-compute@developer.gserviceaccount.com"
   x=$x" --scopes=https://www.googleapis.com/auth/cloud-platform"
   x=$x" --tags=hadoop"
   x=$x" --image=ubuntu-1910-eoan-v20200211"
   x=$x" --image-project=ubuntu-os-cloud"
   x=$x" --boot-disk-size=500GB"
   x=$x" --boot-disk-type=pd-ssd"
   x=$x" --boot-disk-device-name=machine-${i+1}"
   for j in ${!HADOOP_ECOSYSTEM[@]} 
   do 
      x=$x" --create-disk=mode=rw,auto-delete=yes,size=500,type=projects/hadoop-sandbox-270208/zones/${ZONE[i]}/diskTypes/pd-ssd,name=${HADOOP_ECOSYSTEM[j]}-disk,device-name=${HADOOP_ECOSYSTEM[j]}" 
   done
   x=$x" --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any"
   x=$x" --metadata-from-file user-data=./cloud-config.yaml"
   echo $x | sh

done

# todo: startup-script vs cloud-init
# todo: format attached disks
# todo: configurations

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







# then connect w/ ssh
# gcloud compute --project $PROJECT_ID ssh --zone $ZONE_NAME $INSTANCE_NAME

