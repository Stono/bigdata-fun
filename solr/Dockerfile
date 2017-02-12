FROM karlstoney/jvm:latest

ENV SOLR_VERSION=6.4.1
ENV SOLR_HOME=/opt/solr
ENV SOLR_DIST=http://mirrors.ukfast.co.uk/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz

RUN curl --silent -fSL "$SOLR_DIST" -o /tmp/solr.tar.gz && \
    tar -xf /tmp/solr.tar.gz -C /opt/ && \
    rm -f /tmp/solr.tar.gz && \
    mv /opt/solr-* $SOLR_HOME 

RUN groupadd solr && \
    useradd -r -g solr solr && \
    chown solr:solr -R $SOLR_HOME

RUN yum -y -q install lsof
    
# Open port 8081 for the HTTP listen
WORKDIR /opt/solr

VOLUME /data
EXPOSE 8983

COPY run.sh /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]
