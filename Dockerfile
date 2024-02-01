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

# Expose the SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
