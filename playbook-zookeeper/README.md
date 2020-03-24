# zookeeper

*Fully Distributed* installation of zookeeper on GCP IaaS.


- [x] Apache Zookeeper (zk): java8

### How to Start

- check .gcp.env and .env files. And change w/ your values.
- create machines `./create-machines.sh` (either gshell or from your local), 
    - and check logs `cat /var/log/syslog | grep =====` till you see _end_ line.
- ssh to machines, 
    - switch to `sudo -u hadoop -i` user, then setup passwordless ssh `./configure-ssh.sh`. follow the further steps on screen.
    - then on related nodes, `./configure-zookeeper.sh`. follow the further steps on screen.

#### Notes

- Check `http://master-PUBLIC-IP:`
    - run `start-zk.sh` to start ZK
    - or, `bin/zkCli.sh -server IP:2181` to enter zk-shell
    - or, `/data-1/logs`
    - or, `jps` to see java apps (QuorumPeerMain, ..)
    - or, `netstat -a -t --numeric-ports -p` for binding exceptions
    - or, `sudo ss -atpu` sshd listening and connected status
    - or, `cat $ZOOKEEPER_HOME/nohup.out | tail &`

