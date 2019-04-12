FROM ubuntu:18.04
# Hadoop Version
ARG HADOOP_VERSION=3.2.0
# install
RUN apt-get update && \
    apt-get install -y ssh rsync vim openjdk-8-jdk-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# env vars
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_COMMON_HOME /opt/hadoop
ENV HADOOP_HDFS_HOME /opt/hadoop
ENV HADOOP_MAPRED_HOME /opt/hadoop
ENV HADOOP_YARN_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop
ENV YARN_CONF_DIR /opt/hadoop/etc/hadoop
# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
RUN \
  wget http://apache.mirrors.tds.net/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
  tar -xzf hadoop-$HADOOP_VERSION.tar.gz && \
  mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
  echo "export JAVA_HOME=$JAVA_HOME" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
  echo "PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin" >> ~/.bashrc
# rm tar.gz
RUN rm -rf /hadoop-$HADOOP_VERSION.tar.gz
# create data
VOLUME /hdfs/volume1
# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088 10020 
# Datanode ports
EXPOSE 9867 9866 9865 9864 
# Other ports
EXPOSE 22 2122 49707