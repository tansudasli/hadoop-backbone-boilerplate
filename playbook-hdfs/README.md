# hdfs

*Fully Distributed* installation of hdfs on GCP IaaS.

- [x] Apache Hadoop (hdfs): java8


### How to Start

- check .gcp.env and .env files. And change w/ your values.
- create machines `./create-machines.sh` (either gshell or from your local), 
    - and check logs `cat /var/log/syslog | grep =====` till you see _end_ line.
- ssh to machines, 
    - switch to `sudo -u hadoop -i` user, then setup passwordless ssh `./configure-ssh.sh`. follow the further steps on screen.
    - then on related nodes, `./configure-hadoop.sh`. follow the further steps on screen.

#### Notes

- Check `http://master-PUBLIC-IP:9870`
    - run `sbin/start-dfs.sh` to start HDFS
    - run `sbin/stop-dfs.sh` to stop HDFS
    - or, `/data-1/logs`
    - or, `jps` to see java apps (namenode, secondarynamenode, datanode)
    - or, `netstat -a -t --numeric-ports -p` for used ports
    - or, `sudo ss -atpu` sshd listening and connected status
