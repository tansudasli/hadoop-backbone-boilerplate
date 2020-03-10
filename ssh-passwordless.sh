
# switch to hadoop user!
sudo -u hadoop -i 


# create ssh-keys
ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
chmod 0600 /home/hadoop/.ssh/authorized_keys

# send to other servers