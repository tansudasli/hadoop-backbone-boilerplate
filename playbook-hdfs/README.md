# hdfs

*Fully Distributed* installation of hadoop ecosystem on GCP IaaS.

- [x] Apache Hadoop (hdfs): java8


### How to Start

<br>on Local or on gloud-shell<br>

1. `cd hadoop-backbone-boilerplate/playbook-hdfs`
    - Edit `.env` and update
2. Run `./02-create-machines.sh` to create machines. Uses `cloud-init.yaml` file

<br>on allMachines<br>

3. ssh to instances on GCP, 
    - then `sudo -u hadoop -i` to switch to hadoop user, 
        - then `cd ~/hadoop-backbone-boilerplate/playbook-hdfs` folder
        - run `./checks.sh` to check results of step 4, then
        - run `./02a-ssh-passwordless.sh` to create hostname & IP match, public keys, and _.ssh_ folder for *all machines*.
            1. then in name-node, copy .ssh/id_rsa.pub content into clipboard, and 
            2. ssh to secondary-name-node *manually* and _add_ this into `nano .ssh/authorized_keys` content
            3. then conect w/ `ssh hadoop@secondary-name-node` from name-node
        - Repeat last 2 and 3 steps to all machines...

<br>

After this, master can _ssh to other machines_ w/o password! Use `hadoop-backbone-boilerplate/tests/check-ssh.sh`

<br>on nameNode<br>

4. run `./configure-hadoop.sh` to configure _HDFS_ in distributed mode. 
    - Distributes conf files to other workers automatically
    - Formats HDFS on nameNode for the first time usage

<br>on nameNode<br>

5. run `$HADOOP_HOME/sbin/start-dfs.sh` to start HDFS

6. Check `http://master-PUBLIC-IP:9870`
    - or, `$HADOOP_HOME/logs`
    - or, `jps` to see java apps (namenode, secondarynamenode, datanode)
    - or, `netstat -a -t --numeric-ports -p` for binding exceptions
    - or, `sudo ss -atpu` sshd listening and connected status
