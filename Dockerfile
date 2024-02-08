# Use OpenJDK 11 base image from Docker Hub
FROM openjdk:11-jdk-buster

# Install vim, net-tools, and openssh-server
RUN apt-get update && apt-get install -y \
    vim \
    net-tools \
    openssh-server

# Configure SSH (optional steps)
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Copy the entrypoint.sh script and give execute permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN adduser --disabled-password --gecos "" hadoop && \
    su hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys && chmod 0700 ~/.ssh"

RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
RUN mkdir /hadoop && \
    tar -xvzf hadoop-3.3.6.tar.gz -C /hadoop && \
    cd /hadoop && \
    mv hadoop-3.3.6/* . && \
    rmdir hadoop-3.3.6

ENV HADOOP_HOME=/hadoop \
    HADOOP_INSTALL=/hadoop \
    HADOOP_MAPRED_HOME=/hadoop \
    HADOOP_COMMON_HOME=/hadoop \
    HADOOP_HDFS_HOME=/hadoop \
    HADOOP_YARN_HOME=/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop/lib/native \
    PATH=$PATH:/hadoop/sbin:/hadoop/bin \
    HADOOP_OPTS="-Djava.library.path=/hadoop/lib/native" \
    YARN_RESOURCEMANAGER_USER=hadoop \
    YARN_NODEMANAGER_USER=hadoop \
    HDFS_NAMENODE_USER=hadoop \
    HDFS_DATANODE_USER=hadoop \
    HDFS_SECONDARYNAMENODE_USER=hadoop \
    JAVA_HOME=/usr/local/openjdk-11

RUN mkdir -p /hadoop/logs && \
    chown -R hadoop:hadoop /hadoop/logs && \
    chmod -R 755 /hadoop/logs

RUN mkdir -p ~/hadoopdata/hdfs/namenode && mkdir -p ~/hadoopdata/hdfs/datanode

# Expose the SSH port
EXPOSE 22

# Use the entrypoint script to start services
ENTRYPOINT /entrypoint.sh

