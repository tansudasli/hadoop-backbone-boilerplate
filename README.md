# hadoop-sandbox

*Fully Distributed* installation of hadoop ecosystem on GCP IaaS.

- [x] Apache Hadoop (hdfs): java8 (playbook-hdfs)
- [ ] Apache Hadoop (yarn, mapreduce)
- [x] Apache Zookeeper: java8 (playbook-zookeeper)
- [x] Apache Hbase: java8, hdfs, Zookeeper (playbook-hbase)
- [ ] Apache Spark: java8, Zookeeper
- [ ] Apache Kafka: java8, Zookeeper

all playbooks are consistent within related tools

## High Level Architecture
   
![Image](doc/hadoop-ecosystem-architecture.png)

### How to Start

Generally,
- choose which playbook do you need (hdfs, hdfs + hbase, zookeeper etc..)
- design inrastructure arch. on .env files in related playbook folders.
    - you can also combine your own playbook (good for trainings or POCs)
- create machines on GCP, and establish passwordless ssh from master to workers
- and configure products
- then start servers

Create a GCP account and billing account etc..., Then

1. Configure your _local_ for gcloud CLI or use _gcloud-shell_ in gcp console, after cloning the git-reporitory.
    - for local, run `gcloud auth list` to check active gcp account. And `gcloud auth login` if necessary
2. `git clone https://github.com/tansudasli/hadoop-backbone-boilerplate.git`, 
    - Then `cd hadoop-backbone-boilerplate`
    - Edit `.gcp.env` and update (service account, project, region etc...)
3. Run `./create-gcp-project.sh` to create project, and to link your billing account
4. Run `./create-firewall-rule.sh` to create fw rules, so that you can reach via web consoles


#### More about production-readiness 

- [x] More optimized and parametric scripts (env files etc.)
- [ ] Use less static-IPs (just for masters etc.)
- [x] Dynamic machine-Types regarding to purposes (diff. CPU and RAM configs)
- [ ] Dynamic port management (open it only for masters)
- [x] Nodes should be dedicated to hdfs, hbase, spark etc... So it becomes *fully distributed*
- [x] Shared zookeeper (instead hbase managed ..)
- [ ] Adjust file and process limits in linux (ulimit -n, -u)
- [ ] JVM optimizations
- [x] Better disk architecture (local ssd disks etc.)
- [ ] Backup to network attached disks (hdfs full image ..)
- [ ] More hadoop security (kerberos etc.)
- [ ] More network layer security (diff. subnets etc.)
- [ ] Add rsync to crontab to sync conf files
- [ ] Better log management (esp. for zk ..)
- [ ] Central DNS management (not hostname update)
- [ ] General optimizations related to other ecosystem tools (hbase changes some hdfs parameters ...)

and also consider 
- _free_ cloudera distribution for better hadoop management,
- and ansible for on-premise configuration management and provisioning