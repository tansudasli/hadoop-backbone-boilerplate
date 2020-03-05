#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

export PROJECT_ID=hadoop-sandbox-270208     # must be unique - gcp level



# ----------- preperations ---------
echo "create gcp account and install gcp cli on local"
echo "check active gcp account"

gcloud projects create ${PROJECT_ID} \
                       --name 'hadoop-cluster'
