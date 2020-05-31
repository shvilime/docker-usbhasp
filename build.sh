#!/bin/bash

VERSION=$(grep version env | cut -d '=' -f2)
NAME=$(grep name env | cut -d '=' -f2)
ACCOUNT=$(grep account env | cut -d '=' -f2)

# Delete previous image
if docker images | grep -q ${NAME}.*${VERSION}; then 
   docker rmi ${ACCOUNT}/${NAME}:${VERSION}
fi

# Build new image
sed -i "s/com.example.version=\".*\"/com.example.version=\"${VERSION}\"/g" Dockerfile
docker build -t ${ACCOUNT}/${NAME}:${VERSION} .