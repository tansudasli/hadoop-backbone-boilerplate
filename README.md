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

Create gcp account and billing account etc.. manually, Then

1. Configure your _local_ or use _gshell_, after cloning the git-reporitory.
    - for local, `gcloud auth list` check active gcp account. `gcloud auth login` if necessary
2. Run `./preparations.sh` to create project, link billing account on GCP
3. Run `./create-machines.sh` to create machines on GCP
4. Run `./configure-hadoop.sh` to configure HDFS
