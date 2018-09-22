#!/bin/bash
# Build & Tag the jenkins to proper gcr
docker build -t jenkins.docker.base .
docker tag jenkins.docker.base <DOCKER_REGISTRY>/jenkins.docker.base:latest
