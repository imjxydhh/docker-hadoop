FROM z907738103/bigdata:base
MAINTAINER Ivan Ermilov <ivan.s.ermilov@gmail.com>

ENV HBASE_VERSION 2.3.1
ENV HBASE_URL https://mirrors.bfsu.edu.cn/apache/hbase/2.3.1/hbase-2.3.1-bin.tar.gz

RUN set -x \
    && curl -fSL "$HBASE_URL" -o /tmp/hbase.tar.gz \
    && tar -xvf /tmp/hbase.tar.gz -C /opt/ \
    && rm /tmp/hbase.tar.gz*

RUN ln -s /opt/hbase-$HBASE_VERSION/conf /etc/hbase
RUN mkdir /opt/hbase-$HBASE_VERSION/logs

RUN mkdir -p /hadoop-data

ENV HBASE_PREFIX=/opt/hbase-$HBASE_VERSION
ENV HBASE_HOME="$HBASE_PREFIX"
ENV HBASE_CONF_DIR=/etc/hbase

ENV USER=root
ENV PATH $HBASE_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
