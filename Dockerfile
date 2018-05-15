FROM centos:centos7
# Version
# Check for Updates:
# https://dev.mysql.com/downloads/repo/yum/
ENV YUM_REPO_URL="https://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm "
#ADD http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm ./
#RUN rpm -ivh mysql-community-release-el7-5.noarch.rpm
LABEL Version=5.6

# add mysql user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -m -r -g mysql mysql
RUN yum -y update; yum clean all
#RUN yum -y erase mysql mysql-server
RUN yum -y install bash-completion psmisc net-tools epel-release; yum clean all
#RUN yum -y install mysql-server

RUN \
        yum -y install epel-release && \
        rpm -ivh ${YUM_REPO_URL} && \
        yum-config-manager --disable mysql55-community && \
        yum-config-manager --enable mysql56-community && \
        yum-config-manager --disable mysql57-community && \
        yum-config-manager --disable mysql80-community && \
        yum clean all

RUN yum -y update && yum -y install \
        mysql-community-server

COPY install-mysql.sh /
RUN chmod 755 /install-mysql.sh
ENTRYPOINT ["/install-mysql.sh"]
EXPOSE 3306
CMD ["/bin/bash"]
