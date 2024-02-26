# Use OpenJDK 11 base image from Docker Hub
FROM openjdk:11-jdk-buster

# Install vim, net-tools, and openssh-server
RUN apt-get update && apt-get install -y \
    vim \
    net-tools \
    openssh-server \
    python3 python3-pip \
    sudo

# Set python3 as the default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Link pip3 to pip if needed
RUN if [ -e /usr/bin/pip3 ] && [ ! -e /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip; fi

# Configure SSH (optional steps)
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Copy the entrypoint.sh script and give execute permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Creating hadoop user
RUN adduser --disabled-password --gecos "" hadoop && \
    su - hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys && chmod 0700 ~/.ssh"

# Download and setup Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    mkdir /hadoop && \
    tar -xvzf hadoop-3.3.6.tar.gz -C /hadoop && \
    cd /hadoop && \
    mv hadoop-3.3.6/* . && \
    rmdir hadoop-3.3.6

# Setting environment variables for Hadoop and Java
ENV HADOOP_HOME=/hadoop \
    HADOOP_INSTALL=/hadoop \
    HADOOP_MAPRED_HOME=/hadoop \
    HADOOP_COMMON_HOME=/hadoop \
    HADOOP_HDFS_HOME=/hadoop \
    HADOOP_YARN_HOME=/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop/lib/native \
    PATH=$PATH:/hadoop/sbin:/hadoop/bin \
    HADOOP_OPTS="-Djava.library.path=/hadoop/lib/native" \
    JAVA_HOME=/usr/local/openjdk-11 \
    YARN_RESOURCEMANAGER_USER=hadoop \
    YARN_NODEMANAGER_USER=hadoop \
    HDFS_NAMENODE_USER=hadoop \
    HDFS_DATANODE_USER=hadoop \
    HDFS_SECONDARYNAMENODE_USER=hadoop \
    HADOOP_CONF_DIR=/hadoop/etc/hadoop

# Configure environment variables specifically for the hadoop user
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /home/hadoop/.bashrc && \
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> /home/hadoop/.bashrc && \
    echo "export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop" >> /home/hadoop/.bashrc && \
    echo "export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> /home/hadoop/.bashrc

# Install Python Libraries
RUN pip install pydoop

# Creating necessary directories and setting permissions
RUN mkdir -p /hadoop/logs && \
    chown -R hadoop:hadoop /hadoop/logs && \
    chmod -R 755 /hadoop/logs && \
    mkdir -p ~/hadoopdata/hdfs/namenode && \
    mkdir -p ~/hadoopdata/hdfs/datanode

# Expose the SSH port
EXPOSE 22

# Use the entrypoint script to start services
ENTRYPOINT ["/entrypoint.sh"]
