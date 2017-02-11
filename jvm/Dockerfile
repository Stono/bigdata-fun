FROM centos:7
MAINTAINER Karl Stoney <me@karlstoney.com> 

VOLUME /data

ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
ENV JAVA_OPTS "-Xms2g -Xmx4g -XX:MaxPermSize=2048m"
ENV TERM xterm-256color

# Get dependencies
RUN yum -y -q install curl wget java-1.8.0-openjdk-headless

CMD ["/bin/true"]
