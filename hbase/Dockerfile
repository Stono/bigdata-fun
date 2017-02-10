FROM centos:7
MAINTAINER Karl Stoney <me@karlstoney.com> 

VOLUME /data

# Setup environment
ENV TERM xterm-256color
ENV HBASE_VERSION 1.3.0
ENV HBASE_DIST http://mirrors.ukfast.co.uk/sites/ftp.apache.org/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz   
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV PATH=$PATH:/opt/hbase/bin
ENV HBASE_MANAGES_ZK=true

# Get dependencies
RUN yum -y -q install curl wget java-1.8.0-openjdk-headless

# Download and install HBase
RUN cd /opt && \
	wget --quiet $HBASE_DIST && \
	tar xzf hbase-* && \
	rm -f *.tar.gz && \
	mv hbase-* hbase

# Supervisor
RUN yum install -y -q python-setuptools && \
	easy_install -q supervisor supervisor-stdout && \
    mkdir -p /etc/supervisord.d && \
    mkdir -p /var/log/supervisord && \
    mkdir -p /var/run 

# Ports: Rest
EXPOSE 8080

# Ports: Thrift
EXPOSE 9090
EXPOSE 9095

# Ports: Master
EXPOSE 16000 
EXPOSE 16010
EXPOSE 2181
EXPOSE 16020
EXPOSE 16030

# Config files
COPY config/hbase-site.xml /opt/hbase/conf/hbase-site.xml
COPY config/supervisord.conf /etc/supervisord.conf

# Services
COPY services/* /etc/supervisord.d/

COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
