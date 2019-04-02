#!/bin/bash

set -v
docker build --no-cache=true --rm=true -t zenentropy/sonarqube:5.1.1 -f ./Dockerfile.sonarqube .

exit
