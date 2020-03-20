#!/usr/bin/env bash

source .gcp.env

echo "First, create a gcp account and install gcp cli on your local"
echo "Then, check active gcp account"
echo "Then, edit .env file"
echo "Then, run this script to create a project on gcp"

gcloud projects create ${PROJECT_ID} --name ${PROJECT_NAME}

gcloud alpha billing projects link ${PROJECT_ID} --billing-account ${BILLING_ACCOUNT}
