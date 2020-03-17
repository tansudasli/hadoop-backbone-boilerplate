#!/bin/bash

source .env

echo "ssh from masters to workers"

cat ~/.ssh/authorized_keys
sudo cat /etc/hosts
ssh hadoop@${HADOOP_INSTANCE_NAMES[1]}