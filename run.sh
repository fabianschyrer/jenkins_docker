docker run -d -e CHECKOUT_PATH=jenkins-staging \
-e JENKINS_PASSWORD=welcome \
-p 8089:8080 \
<DOCKER_REGISTRY>/jenkins.docker.base:latest