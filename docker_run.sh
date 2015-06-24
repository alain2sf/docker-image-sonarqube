#!/bin/bash -x

docker run -it -d \
           -p 9000:9000 -p 9092:9092 \
           --add-host sonarqube.zenentropy.net:127.0.0.1 \
           --hostname sonarqube.zenentropy.net \
           --name mysonarqube \
           zenentropy/sonarqube:v1

exit
