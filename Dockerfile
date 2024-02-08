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

RUN adduser hadoop
RUN su - hadoop && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
  && chmod 0600 ~/.ssh/authorized_keys && chmod 0700 ~/.ssh && ssh hadoop@localhost -y
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && mkdir /hadoop \
  && tar -xvzf hadoop-3.3.6.tar.gz -C /hadoop && cd /hadoop && mv hadoop-3.3.6 hadoop



# Expose the SSH port
EXPOSE 22

# Use the entrypoint script to start services
ENTRYPOINT ["/entrypoint.sh"]
