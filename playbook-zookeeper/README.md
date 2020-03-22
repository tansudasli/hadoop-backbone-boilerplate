# zookeeper

*Fully Distributed* installation of zookeeper on GCP IaaS.

- [x] Apache Zookeeper (zk): java8


### How to Start

<br>on Local or on gloud-shell<br>

1. `cd hadoop-backbone-boilerplate/playbook-zookeeper`
    - Edit `.env` and update
2. Run `./create-machines.sh` to create machines. Uses `cloud-init.yaml` file

<br>on allMachines<br>

3. ssh to instances on GCP, 
    - then `sudo -u hadoop -i` to switch to hadoop user, 
        - then `cd ~/hadoop-backbone-boilerplate/playbook-zookeeper` folder
        - run `./configure-ssh.sh` to create hostname & IP match, public keys, and _.ssh_ folder for *all machines*.
            1. then in znode1, copy .ssh/id_rsa.pub content into clipboard, and 
            2. ssh to znode2 *manually* and _add_ this into `nano .ssh/authorized_keys` content
            3. then conect w/ `ssh hadoop@znode2` from znode1
        - Repeat last 2 and 3 steps to all machines...

<br>

After this, master can _ssh to other machines_ w/o password!

4. run `./configure-zookeeper.sh` to configure _ZK_ in distributed mode. 
5. run `$ZOOKEEPER_HOME/start-zk.sh` to start ZK
    - changes to zk home, 
    - then run java cmd

6. Check `http://master-PUBLIC-IP:9870`
    - or, `/data-1/logs`
    - or, `jps` to see java apps (QuorumPeerMain, ..)
    - or, `netstat -a -t --numeric-ports -p` for binding exceptions
    - or, `sudo ss -atpu` sshd listening and connected status
