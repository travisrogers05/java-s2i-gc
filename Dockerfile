FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.2-7
USER root
COPY java-default-options /opt/run-java/java-default-options
RUN chmod +x /opt/run-java/java-default-options
USER 185