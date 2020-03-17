#!/bin/bash

source .env

echo "ssh from masters to workers"

ssh hadoop@${HADOOP_INSTANCE_NAMES[1]}