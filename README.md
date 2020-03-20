# hadoop-sandbox

*Fully Distributed* installation of hadoop ecosystem on GCP IaaS.

- [x] Apache Hadoop (hdfs): java8
- [ ] Apache Hadoop (yarn, mapreduce)
- [ ] Apache Zookeeper: java8
- [ ] Apache Hbase: java8, hdfs, Zookeeper
- [ ] Apache Spark: java8, Zookeeper ???
- [ ] Apache Kafka: java8, Zookeeper


## High Level Architecture
   
![Image](doc/hadoop-ecosystem-architecture.png)

### How to Start

Generally,
- choose what you need (hdfs, hdfs + hbase etc..)
- design inrastructure arch. on .env files in related folders (or combine yourself or add new ecosystem product)
- create machines on GCP, and establish passwordless ssh from master to workers
- and start 


#### More about production-readiness 

- [x] More optimized and parametric scripts (env files etc.)
- [ ] Use less static-IPs (just for masters etc.)
- [ ] Dynamic machine-Types regarding to purposes (diff. CPU and RAM configs)
- [ ] Dynamic port management (open for only masters)
- [x] Nodes should be dedicated to hdfs, hbase, spark etc... So it becomes *fully distributed*
- [ ] JVM optimizations
- [x] Better disk architecture (local ssd disks etc.)
- [ ] Backup to network attached disks (hdfs full image ..)
- [ ] More hadoop security (kerberos etc.)
- [ ] More network layer security (diff. subnets etc.)
- [ ] Add rsync to crontab to sync conf files

and consider _free_ cloudera distribution, for better hadoop management
and ansible for on-premise configuration management and provisioning