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

Create a GCP account and billing account etc..., Then

<br>on Local or on gloud-shell<br>

1. Configure your _local_ for gcloud CLI or use _gcloud-shell_ in gcp console, after cloning the git-reporitory.
    - for local, run `gcloud auth list` to check active gcp account. And `gcloud auth login` if necessary
2. `git clone https://github.com/tansudasli/hadoop-sandbox.git`, then `cd hadoop-sandbox` folder
    - Edit .env file, and update variables w/ your values ( service account, project, region etc...)
3. Run `./preparations.sh` to create project, and to link billing account on GCP
4. Run `./create-machines.sh` to create machines w/ `cloud-init.yaml` file on GCP

<br>on allMachines<br>

5. ssh to instances on GCP, 
    - then `sudo -u hadoop -i` to switch to hadoop user, then `cd ~/hadoop-sandbox` folder
        - run `./checks.sh` to check results of step 4, then
        - run `./ssh-passwordless.sh` to create public keys, and _.ssh_ folder for all machines.
            1. then in name-node, copy .ssh/id_rsa.pub content into clipboard, and 
            2. ssh to secondary-name-node *manually* and _add_ this into `nano .ssh/authorized_keys` content
            3. then conect w/ `ssh hadoop@secondary-name-node` from name-node
        - Repeat last 2 and 3 steps to all machines...

<br>After this, master can ssh to other machines w/o password!

<br>on nameNode<br>

6. run `./configure-hadoop.sh` to configure _HDFS_ in distributed mode. 
    - Distributes conf files to other workers automatically
    - Formats HDFS on nameNode for the first time usage

<br>on Local<br>

7. Check `http://master-PUBLIC-IP:9870`
    - or, `$HADOOP_HOME/logs`
    - or, `jps` to see java apps (namenode, secondarynamenode, datanode)
    - or, `netstat -a -t --numeric-ports -p` for binding exceptions
    - or, `sudo ss -atpu` sshd listening and connected status

#### About Possible Errors & Other staffs

- to limit server count, check `.env` file
- to create and delete machine-x many times, you may need to clean `rm -r .ssh/` on your local *to eliminate ssh connection problems*

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