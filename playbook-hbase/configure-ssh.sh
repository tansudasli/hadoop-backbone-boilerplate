
source ../.gcp.env
source .env

echo "ssh to remote machine, then Run configure-ssh.."
echo "then Run configure-... files"


# STEP: add hostname and internal-IPs to /etc/hosts file
echo "Add private-IPs into /etc/hosts file"

for i in `gcloud compute instances list --project=${PROJECT_ID}| awk 'NR>1 {print $4 "#" $1}'`
do
  echo ${i} | tr '#' ' '| sudo tee -a /etc/hosts

done


# STEP: create ssh-keys
echo "create ssh-keys, and update .ssh/authorized_keys"
ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
chmod 0600 /home/hadoop/.ssh/authorized_keys


echo "Run configure-ssh... in all workers, then"
echo "     in hdfs -> Manually cat /home/hadoop/.ssh/authorized_keys in master to the workers' authorized_keys!"

# send to other servers
# - then in nameNode, copy .ssh/id_rsa.pub content into clipboard, and 
# - ssh to machine-2 manually and add this into .ssh/authorized_keys content
# - then conect w/ `ssh hadoop@machine-2` from machine-1 to machine-2
# - do this to all machines where necessary