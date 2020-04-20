#!/bin/bash

VERSION=0.3

docker run --rm -d --privileged --net host --name usbhasp shvilime/usbhasp:${VERSION}