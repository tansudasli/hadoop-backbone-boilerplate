#!/usr/bin/env bash

export ZONE=(europe-west4-a europe-west4-b europe-west4-c)

for i in ${!ZONE[@]}
do
    echo ${ZONE[i]}
done