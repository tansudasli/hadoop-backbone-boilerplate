#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

export PROJECT_ID=hadoop-sandbox-270208     # must be unique - gcp level
export BILLING_ACCOUNT=00F27E-4EE4CA-3797DD

export REGION=europe-west4
export ZONE=(europe-west4-a europe-west4-b europe-west4-c)
export INSTANCE_NAME=(machine-1 machine-2 machine-3)

export INGESTION_BUCKET_NAME=datalake-hadoop-sandbox-datasets-123

# export AIRFLOW_BUCKET_NAME=.....         # get from gcs buckets and update

# ----------- create machines ---------
echo "create machines on 1 region, for 3 zones => streched distributed, low latency b/w zones"

# deletes data disk! keep in mind 
gcloud beta compute --project=$PROJECT_ID instances create $INSTANCE_NAME \
    --zone=$ZONE_NAME \
    --machine-type=n1-standard-1 \
    --subnet=default \
    --network-tier=PREMIUM \
    --maintenance-policy=MIGRATE \
    --service-account=923205623626-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=ubuntu-1904-disco-v20190605 \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=$INSTANCE_NAME \
    --create-disk=mode=rw,size=200,type=projects/sandbox-236618/zones/europe-west3-c/diskTypes/pd-ssd,name=kafka-datadisk-1,device-name=kafka-datadisk-1

# then connect w/ ssh
gcloud compute --project $PROJECT_ID ssh --zone $ZONE_NAME $INSTANCE_NAME

