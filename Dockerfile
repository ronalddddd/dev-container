FROM ubuntu:14.04
MAINTAINER Ronald Ng "https://github.com/ronalddddd"
# adapted from https://docs.docker.com/engine/examples/running_ssh_service/

ARG SSH_PASSWORD
ENV SSH_PASSWORD ${SSH_PASSWORD:-happymeal}

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server vim curl htop tree
RUN mkdir /var/run/sshd
RUN echo "root:$SSH_PASSWORD" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile

# Force password change on login
# RUN chage -d0 root

# Enable SSH tunneling
RUN echo "PermitTunnel yes" >> /etc/ssh/sshd_config

# Install node.js
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN wget -qO- https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --yes nodejs

# Install a specific version of docker.
# This is used for controlling host docker by mounting /var/run/docker.sock:/var/run/docker.sock
# Adapted from http://stackoverflow.com/a/33575062
curl -sSL https://get.docker.com/ | sh
apt-cache showpkg docker-engine               # show version which are available
apt-get install docker-engine=1.11.2-0~trusty # re-install with specific version
apt-mark hold docker-engine                   # prevent upgrade on sys upgrade
docker version                                # check installed docker version

# Create projects folder
RUN mkdir /projects
VOLUME ["/projects"]
# Expose SSH and other common web/development ports
EXPOSE 22 80 443 3000 8080
# Change the root password and start the SSH server
CMD echo "root:$SSH_PASSWORD" | chpasswd && /usr/sbin/sshd -D
