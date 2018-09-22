FROM vulcanhub/jenkins-2-centos7:v3.11

# Switch to User ROOT
USER root

# Update YUM
RUN yum update -y

# Install Telnet Client
RUN yum install -y sudo telnet

# Install libltdl7
RUN yum install -y sudo libtool-ltdl
RUN yum install -y sudo libtool-ltdl-devel

# Cleanup YUM Junk
USER root
RUN yum clean packages \
	&& yum clean headers \
	&& yum clean metadata \
	&& yum clean dbcache \
	&& yum clean plugins \
	&& yum clean expire-cache \
	&& yum --enablerepo=* clean all \
	&& package-cleanup --quiet --leaves --exclude-bin | xargs yum remove -y \
	&& sudo rm -rf /var/cache/yum \
	&& sudo rm -rf /var/cache/yum/x86_64


COPY jenkins_prep/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 777 /usr/bin/entrypoint.sh

# Download and Install Jenkins Plugins
COPY  plugins.txt /usr/local/bin/plugins.txt
RUN /usr/local/bin/install-plugins.sh /usr/local/bin/plugins.txt

# Copy Groovy Scripts
COPY /groovy/credentials.groovy /opt/openshift/configuration/init.groovy.d/credentials.groovy
COPY /groovy/executors.groovy /opt/openshift/configuration/init.groovy.d/executors.groovy

# Create Jenkins Job Directory and Copy Jenkins Jobs
RUN mkdir -p /prerequisite_tmp/jobs
RUN mkdir -p /prerequisite_tmp/jobs/0_PREREQUISITE/jobs/0-init-etl-template/
COPY /jenkins_jobs/0_PREREQUISITE/config.xml /prerequisite_tmp/jobs/0_PREREQUISITE/config.xml
COPY /jenkins_jobs/0_PREREQUISITE/jobs/0-init-etl-template/config.xml	/prerequisite_tmp/jobs/0_PREREQUISITE/jobs/0-init-etl-template/config.xml
COPY /jenkins_prep/jenkins.security.QueueItemAuthenticatorConfiguration.xml /prerequisite_tmp/jenkins.security.QueueItemAuthenticatorConfiguration.xml
COPY /jenkins_prep/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml /prerequisite_tmp/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml

RUN chmod -R 777 /var/log && chown -R 1001:0 /var/log
RUN /usr/local/bin/fix-permissions /opt/openshift && \
    /usr/local/bin/fix-permissions /opt/openshift/configuration/init.groovy.d && \
    /usr/local/bin/fix-permissions /var/lib/jenkins && \
    /usr/local/bin/fix-permissions /var/log

# Switch User Jenkins
USER 1001
ENTRYPOINT ["/usr/bin/entrypoint.sh"]