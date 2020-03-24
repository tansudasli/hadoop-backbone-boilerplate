# hbase

*Fully Distributed* installation of hbase on GCP IaaS.

- [x] Apache Hadoop (hdfs): java8
- [x] Apache Zookeeper (zk): java8
- [x] Apache Hbase (zk): java8, hdfs, zk

### How to Start

- check .gcp.env and .env files. And change w/ your values.
- create machines `./create-machines.sh` (either gshell or from your local), 
    - and check logs `cat /var/log/syslog | grep =====` till you see _end_ line.
- ssh to machines, 
    - switch to `sudo -u hadoop -i` user, then setup passwordless ssh `./configure-ssh.sh`. follow the further steps on screen.
    - then on related nodes, `./configure-hadoop.sh`, `./configure-zookeeper.sh` , then `./configure-hbase.sh`. follow the further steps on screen.