# hadoop-sandbox

Distributed installation of hadoop ecosystem on GCP IaaS.

- [ ] Apache Hadoop (hdfs only)
    - requires java8
- [ ] Apache Hbase 
    - requires java8, hdfs, Zookeeper
- [ ] Apache Zookeeper (central)
    - requires java8
- [ ] Apache Kafka
    - requires java8, Zookeeper


## High Level Architecture - POC
   
![Image](doc/hadoop-ecosystem-architecture.png)

### How to Start

Create a GCP account and billing account etc..., Then

1. Configure your _local_ for gcloud CLI or use _gshell_, after cloning the git-reporitory.
    - for local, run `gcloud auth list` to check active gcp account. And `gcloud auth login` if necessary
2. Run `./preparations.sh` to create project, and to link billing account on GCP
3. Run `./create-machines.sh` to create machines, and installations w/ `cloud-init.yaml` file on GCP
4. Run `./configure-hadoop.sh` to configure HDFS
5. `sudo -u hadoop -i` to switch hadoop user
6. Check `http://IP:9870` 
