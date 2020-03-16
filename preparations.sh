#!/usr/bin/env bash

echo "edit env variables w/ your valid values!"

# todo: must be unique - at gcp level
export PROJECT_ID=hadoop-sandbox-270208     


# ----------- preperations ---------
echo "First, create a gcp account and install gcp cli on your local"
echo "Then, check active gcp account"
echo "Then, run this script to create a project on gcp"

gcloud projects create ${PROJECT_ID} \
                       --name 'hadoop-cluster'

gcloud alpha billing projects link ${PROJECT_ID} \
                       --billing-account 00F27E-4EE4CA-3797DD
