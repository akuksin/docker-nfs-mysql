# Docker with mounted NFS for MySql

This is the Git repo of the docker image for mysql.

It based on offical centos image [centos:centos6.8] and you can mount NFS volume for mysql data in Docker container.

When containers is start and the user namespace is enabled for docker engine,The effective root inside the container is a non-root user out side the container process.
  
 
# Setup NFS driver 

`sudo systemctl stop docker-volume-netshare.service`

`sudo systemctl start docker-volume-netshare.service`

or

`sudo /usr/bin/docker-volume-netshare nfs -v 3 --verbose`
  
# Build an image

`sudo docker build -t "mysqlnfs" .`
  
# Mount NFS Docker volume

`docker volume create -d nfs --name mysqlvolume -o nfsvers=3,nolock,rw -o share=noetl.io:/vol/mysql -o port=2049`
 
# Run container

`docker run -it -v mysqlvolume:/var/lib/mysql mysqlnfs /bin/bash`
