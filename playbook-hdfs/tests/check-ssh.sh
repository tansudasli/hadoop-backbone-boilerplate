#!/bin/bash

source .env

echo "ssh from masters to workers"

cat ~/.ssh/authorized_keys
sudo cat /etc/hosts
ssh hadoop@${INSTANCE_NAMES[1]}