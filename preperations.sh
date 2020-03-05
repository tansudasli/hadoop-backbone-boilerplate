#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

export PROJECT_ID=hadoop-sandbox-270208     # must be unique - gcp level



# ----------- preperations ---------
echo "create gcp account and install gcp cli on local"
echo "check active gcp account"

gcloud projects create ${PROJECT_ID} \
                       --name 'hadoop-cluster'

gcloud alpha billing projects link ${PROJECT_ID} \
                       --billing-account 00F27E-4EE4CA-3797DD
