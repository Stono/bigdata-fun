FROM karlstoney/jvm:latest 

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV PATH $HADOOP_PREFIX/bin/:$PATH

RUN curl --silent -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz && \
    tar -xf /tmp/hadoop.tar.gz -C /opt/ && \
    rm -f /tmp/hadoop.tar.gz*
 
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir /hadoop-data

RUN ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME 
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml

RUN yum -y -q install perl which

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
