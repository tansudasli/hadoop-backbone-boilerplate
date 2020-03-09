#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

export PROJECT_ID=hadoop-sandbox-270208     # must be unique - gcp level

export REGION=europe-west4
export ZONE=(europe-west4-a) #(europe-west4-a europe-west4-b europe-west4-c)
export INSTANCE_NAME=(machine-1 machine-2 machine-3)

# device-ids will be in linux = sdb sdc sdd ....
# todo: so check cloud-init.yaml file for disk format/mount steps!
export HADOOP_ECOSYSTEM=(hdfs hbase zookeeper)
export DEVICE_IDs=(sdb sdc sdd)                # lsbk in linux-shell shows the device names


# export INGESTION_BUCKET_NAME=
# export AIRFLOW_BUCKET_NAME=.....         # get from gcs buckets and update

# ----------- create static-IPs ---------
echo "create machines on 1 region, for 3 zones and N additional-disks => streched distributed, low latency b/w zones"

# creates static-regional IPs, then assigns to compute-engines
for i in ${!ZONE[@]}
do
gcloud compute addresses create ${INSTANCE_NAME[i]} \
   --project=${PROJECT_ID} \
   --region ${REGION}
done

# ----------- create machines and assign static-IPs ---------
# deletes data disk! keep in mind 
# creates compute engine w/ N additional-disk in N zone
for i in ${!ZONE[@]}
do
   x="gcloud beta compute --project=${PROJECT_ID} instances create machine-${i+1}"
   x=$x" --zone=${ZONE[i]}"
   x=$x" --address $(gcloud compute addresses describe ${INSTANCE_NAME[i]} --project=${PROJECT_ID} --region=${REGION} --format='get(address)')"
   x=$x" --machine-type=custom-12-79872"
   x=$x" --subnet=default"
   x=$x" --network-tier=PREMIUM"
   x=$x" --maintenance-policy=MIGRATE"
   x=$x" --service-account=762922822926-compute@developer.gserviceaccount.com"
   x=$x" --scopes=https://www.googleapis.com/auth/cloud-platform"
   x=$x" --tags=hadoop, name-node"
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
   x=$x" --metadata-from-file user-data=./cloud-init.yaml"
   echo $x | sh

done



# gcloud compute addresses describe machine-1 --region=europe-west4 --format='get(address)'

# todo: format attached disks
# todo: create static-regional IP addresses, and assign 
# todo: hadoop-stack configurations

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

gcloud compute --project=hadoop-sandbox-270208 firewall-rules create hadoop-allow-management \
    --description="hadoop management ports" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:9870 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=name-node





# then connect w/ ssh
# gcloud compute --project $PROJECT_ID ssh --zone $ZONE_NAME $INSTANCE_NAME

