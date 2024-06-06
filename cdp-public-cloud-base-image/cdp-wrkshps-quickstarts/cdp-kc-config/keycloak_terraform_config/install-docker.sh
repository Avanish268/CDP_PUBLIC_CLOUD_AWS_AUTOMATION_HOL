#!/bin/bash
sudo su - root
yum -y update
yum -y install epel-release
yum -y install ansible
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker
systemctl enable docker
docker run -d -p 80:8080 --name=keycloak -e KEYCLOACK_USER=admin -e KEYCLOACK_PASSWORD=admin jboss/keycloak
docker exec keycloak /opt/jboss/keycloak/bin/add-user-keycloak.sh -u admin -p Cloudera123
docker restart keycloak
sleep 10
docker exec keycloak /opt/jboss/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE --server http://localhost:8080/auth --realm master --user admin --password Cloudera123
docker cp /tmp/cloudera-wshps.png keycloak:/opt/jboss/keycloak/themes/keycloak/login/resources/img/keycloak-bg.png
docker cp /tmp/cloudera-newco-wshps.png keycloak:/opt/jboss/keycloak/themes/keycloak/login/resources/img/keycloak-logo-text.png

