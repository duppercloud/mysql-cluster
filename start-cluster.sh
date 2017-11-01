#!/bin/bash

MANAGER="${MANAGER:-1}"
NODES="${NODES:-2}"
MYSQL="${MYSQL:-1}"

# Add manager entries in config file
for (( i=1; i<=$MANAGER; i++ ))
do
    read -rd '' manager<<EOM
[ndb_mgmd]
NodeId=$i
HostName=$i.localhost
PortNumber=1186

EOM

    echo "$manager" >> /var/lib/mysql-cluster/config.ini

done

echo "==========================================================="
cat /var/lib/mysql-cluster/config.ini
echo "==========================================================="

# Add node entries in config file
for (( i=1; i<=$NODES; i++ ))
do
    read -rd '' node<<EOM
[ndbd]
HostName=$i.localhost

EOM

    echo "$node" >> /var/lib/mysql-cluster/config.ini

done

echo "==========================================================="
cat /var/lib/mysql-cluster/config.ini
echo "==========================================================="

# Add mysql entries in config file
for (( i=1; i<=$MYSQL; i++ ))
do
    read -rd '' mysql<<EOM
[mysqld]
HostName=$i.localhost

EOM

    echo "$mysql" >> /var/lib/mysql-cluster/config.ini

done


echo "==========================================================="
cat /var/lib/mysql-cluster/config.ini
echo "==========================================================="

/opt/mysql/server-5.6/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --nodaemon --verbose --reload --initial --ndb-nodeid=$INSTANCE --bind-addr=$BINDADDR
