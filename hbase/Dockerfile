FROM karlstoney/jvm:latest 

RUN yum -y -q install gettext

# Setup environment
ENV HBASE_MANAGES_ZK true
ENV PATH $PATH:/opt/hbase/bin
ENV HBASE_HEAPSIZE 2048
ENV HBASE_CONF_DISTRIBUTED true
ENV HBASE_MANAGES_ZK false
ENV HBASE_HOME /opt/hbase
ENV PATH $HBASE_HOME/bin/:$PATH

# Get HBase 
ENV HBASE_VERSION 1.3.0
ENV HBASE_DIST http://mirrors.ukfast.co.uk/sites/ftp.apache.org/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz   

RUN curl --silent -fSL "$HBASE_DIST" -o /tmp/hbase.tar.gz && \
    tar -xf /tmp/hbase.tar.gz -C /opt/ && \
    rm -f /tmp/hbase.tar.gz && \
    mv /opt/hbase-* $HBASE_HOME 

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
COPY config/hbase-site.xml /opt/hbase/conf/hbase-site.template

COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
