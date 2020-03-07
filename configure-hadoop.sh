# run on compute engine

# global env mngmt=> /etc/environment

sudo echo JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) > /hadoop-3.2.1/etc/hadoop/hadoop-env.sh


cat >> /hadoop-3.2.1/etc/hadoop/core-site.xml <<EOL
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$(gcloud compute instances describe $(curl -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/name) --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone=europe-west4-a):9000</value>
    </property>
</configuration>
EOL

cat >> /hadoop-3.2.1/etc/hadoop/hdfs-site.xml <<EOL
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOL