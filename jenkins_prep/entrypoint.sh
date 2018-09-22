#!/bin/bash
cp -R /prerequisite_tmp/jobs /var/lib/jenkins/jobs/
# cp /prerequisite_tmp/credentials.xml /var/lib/jenkins/credentials.xml
cp /prerequisite_tmp/jenkins.security.QueueItemAuthenticatorConfiguration.xml /var/lib/jenkins/jenkins.security.QueueItemAuthenticatorConfiguration.xml
cp /prerequisite_tmp/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml /var/lib/jenkins/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml
dumb-init -- /usr/libexec/s2i/run