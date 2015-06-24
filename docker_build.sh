#!/bin/bash -x

docker build --no-cache=true --rm=true -t zenentropy/sonarqube:v1 -f ./Dockerfile.sonarqube .

exit
