FROM centos:centos7

# add mysql user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -m -r -g mysql mysql
RUN yum -y update; yum clean all
RUN yum -y erase mysql mysql-server
RUN yum -y install mysql-server mysql bash-completion psmisc net-tools epel-release; yum clean all

COPY initmysql.sh /initmysql.sh
RUN chmod 755 /initmysql.sh
ENTRYPOINT ["/initmysql.sh"]
EXPOSE 3306
CMD ["/bin/bash"]
