FROM karlstoney/jvm:latest 

# Setup environment
ENV HBASE_VERSION 1.3.0
ENV HBASE_DIST http://mirrors.ukfast.co.uk/sites/ftp.apache.org/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz   
ENV HBASE_MANAGES_ZK true
ENV USE_HDFS true
ENV PATH $PATH:/opt/hbase/bin
ENV HBASE_HEAPSIZE 2048
ENV HBASE_CONF_DISTRIBUTED true
ENV HBASE_MANAGES_ZK false
ENV HBASE_HOME /opt/hbase

# Download and install HBase
RUN cd /opt && \
	wget --quiet $HBASE_DIST && \
	tar xzf hbase-* && \
	rm -f *.tar.gz && \
	mv hbase-* hbase

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

RUN yum -y -q install gettext

# Config files
COPY config/hbase-site.xml /opt/hbase/conf/hbase-site.template

COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
