#!/bin/bash

NAME=usbhasp

docker container stop $(docker container ls -q --filter name=${NAME})