#!/bin/bash

dupper stack create mysql-cluster
eval $(dupper stack env mysql-cluster)
dupper rm mysql nodes manager
docker build --tag mysql -f Dockerfile-mysql .
docker build --tag manager -f Dockerfile-manager .
docker build --tag nodes -f Dockerfile-ndb .
docker rmi $(docker images -q -f dangling=true)
dupper dup nodes 
dupper dup mysql 
dupper dup -e MANAGER=2 -e NODES=2 -e MYSQL=5 manager
dupper scale manager=2 nodes=2 mysql=2
 
set -o noglob 
dupper -D connect manager:1186@manager manager:1186@nodes manager:1186@mysql nodes:*@manager nodes:*@mysql nodes:*@nodes

