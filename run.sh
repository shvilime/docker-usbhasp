#!/bin/bash

VERSION=$(grep version env | cut -d '=' -f2)
NAME=$(grep name env | cut -d '=' -f2)
ACCOUNT=$(grep account env | cut -d '=' -f2)

docker run --rm -d --privileged --net host --name ${NAME} ${ACCOUNT}/${NAME}:${VERSION}