
source ../.gcp.env
source .env

# sets passwordeless ssh

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


echo "Run configure-ssh... in all workers"
echo "No need pubkey copy step"
echo "then, Run configure-... files on all znodes"