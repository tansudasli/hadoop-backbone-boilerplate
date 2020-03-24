#!/usr/bin/env bash

source .gcp.env

echo "First, create a gcp account and install gcp cli on your local, unless you use gclod shell"
echo "Then, check active gcp account"
echo "Then, edit .gcp.env file"
echo "Then, run this script to create a project on gcp"
echo "Then, run create-firewall-rule "

gcloud projects create ${PROJECT_ID} --name ${PROJECT_NAME}

gcloud alpha billing projects link ${PROJECT_ID} --billing-account ${BILLING_ACCOUNT}
