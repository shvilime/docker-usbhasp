#!/bin/bash

NAME=$(grep name env | cut -d '=' -f2)

docker container stop $(docker container ls -q --filter name=${NAME})