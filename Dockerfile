# base image
FROM openjdk:8u212-jdk-slim-stretch
# Hadoop Version
ARG HADOOP_VERSION=3.2.0
# env vars
ENV \
  HADOOP_HOME=/opt/hadoop \
  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
  HADOOP_COMMON_HOME=/opt/hadoop \
  HADOOP_HDFS_HOME=/opt/hadoop \
  HADOOP_MAPRED_HOME=/opt/hadoop \
  HADOOP_YARN_HOME=/opt/hadoop \
  HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop \
  YARN_CONF_DIR=/opt/hadoop/etc/hadoop \
  YARN_HOME=/opt/hadoop
# ssh 
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY id_rsa.pub /root/.ssh/authorized_keys
COPY ssh_config /root/.ssh/config
# install
RUN apt-get update && \
    apt-get install -y ssh wget curl && \
    apt-get clean && \
    mkdir -p /root/.ssh && \
    chmod 600 /root/.ssh/config && chown root:root /root/.ssh/config && \
    chmod 400 /root/.ssh/id_rsa && \
    wget http://apache.mirrors.tds.net/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm -rf ${HADOOP_HOME}/share/doc && \
    mkdir ${HADOOP_HOME}/logs && \
    echo "export JAVA_HOME=$JAVA_HOME" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo "PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin" >> ~/.bashrc && \
    rm -rf /hadoop-$HADOOP_VERSION.tar.gz /var/lib/apt/lists/* /tmp/* /var/tmp/*
# create data
VOLUME /hdfs/volume1
# Hdfs ports                                                                        
EXPOSE 50010 50020 50070 50075 50090 8020 9000 9870
# YARN                                          Mapred
EXPOSE 8030 8031 8032 8033 8040 8042 8088 10020 19888  
# datanode
EXPOSE 9867 9866 9865 9864 
# journal ports
EXPOSE 8485 8481 8480 
# misc ports
EXPOSE 22 2122 49707