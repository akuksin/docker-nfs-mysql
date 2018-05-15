# Docker with mounted NFS for MySql

This is the Git repo of the docker image for mysql with NFS volume.

It based on offical centos image [centos:centos7] with NFS volume for mysql data in Docker container.

When containers is start and the user namespace is enabled for docker engine, the effective root inside the container is a non-root user out side the container process.


## Mount NFS docker volume (option 1)

`docker volume create --driver local --opt type=nfs --opt o=addr=noetl.io,nfsvers=3,nolock,rw --opt device=:/vol/mysql mysqlvol`

## Setup NFS driver (option 2)

https://github.com/netixx/docker-volume-netshare
https://github.com/ContainX/docker-volume-netshare/issues/149
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/Reference_Guide/s2-nfs-client-config-options.html


`sudo systemctl stop docker-volume-netshare.service`

`sudo systemctl start docker-volume-netshare.service`

or

`sudo /usr/bin/docker-volume-netshare nfs -v 3 --verbose`

and mount volume

`docker volume create --driver local --opt type=nfs --opt o=addr=noetl.io,nfsvers=3,nolock,rw --opt device=:/vol/mysql mysqlvol`

## Build an image

`sudo docker build -t "mysqlnfs" .`

## Run container

`docker run -it -v mysqlvol:/var/lib/mysql mysqlnfs`

## Get container id

`docker container ls`

output

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
a590e40cc947        mysqlnfs            "/install-mysql.sh /Ã¢   About an hour ago   Up About an hour    3306/tcp
```

## use CONTAINER ID to connect

`docker exec -it a590e40cc947 bash`

get promt

```
[root@a590e40cc947 /]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

## Other source
https://github.com/andrefernandes/docker-mysql
