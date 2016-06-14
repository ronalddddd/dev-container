FROM ubuntu:14.04
MAINTAINER Ronald Ng "https://github.com/ronalddddd"

ARG SSH_PASSWORD
ENV SSH_PASSWORD ${SSH_PASSWORD:-happymeal}

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo "root:$SSH_PASSWORD" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install node.js
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN wget -qO- https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install --yes nodejs

RUN mkdir /projects

EXPOSE 22 80 443
CMD ["/usr/sbin/sshd", "-D"]

