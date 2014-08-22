FROM ubuntu:14.04
MAINTAINER Kyle Mathews "mathews.kyle@gmail.com"

RUN apt-get update; apt-get install -y python-software-properties software-properties-common; apt-add-repository ppa:ansible/ansible;
RUN apt-get update
RUN apt-get install ansible -y
ADD . /opt/config
WORKDIR /opt/config
RUN echo "localhost	ansible_connection=local" >> ~/.ansible_hosts
RUN ansible-playbook dev.yml -i ~/.ansible_hosts -v
