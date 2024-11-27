# ./Dockerfile
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root
RUN apt-get update 
RUN apt-get install openssh-server sudo -y

# change port and allow root login
RUN echo "Port 10123" >> /etc/ssh/sshd_config
RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

# init conda env
RUN conda init

# random arbitrary port
EXPOSE 10123

CMD ["/usr/sbin/sshd", "-D", "-e"]