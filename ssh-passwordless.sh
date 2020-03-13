
# switch to hadoop user!

# todo: ls -la ~/.ssh

# create ssh-keys
ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
chmod 0600 /home/hadoop/.ssh/authorized_keys

# send to other servers
# - then in nameNode, copy .ssh/id_rsa.pub content into clipboard, and 
# - ssh to machine-2 manually and add this into .ssh/authorized_keys content
# - then conect w/ `ssh hadoop@machine-2` from machine-1 to machine-2
# - do this to all machines where necessary