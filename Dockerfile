# Inspired by https://github.com/znly/docker-druid
FROM ubuntu:14.04
MAINTAINER mhworth <matt@carta.healthcare>

# Java config
ENV DRUID_VERSION   0.10.1
#ENV JAVA_HOME       /opt/jre1.8.0_40
#ENV PATH            $PATH:/opt/jre1.8.0_40/bin

# Druid env variable
ENV DRUID_XMX           '-'
ENV DRUID_XMS           '-'
ENV DRUID_NEWSIZE       '-'
ENV DRUID_MAXNEWSIZE    '-'
ENV DRUID_HOSTNAME      '-'
ENV DRUID_LOGLEVEL      '-'

# Java 8
RUN apt-get update \
      && apt-get install -y software-properties-common \
      && apt-add-repository -y ppa:webupd8team/java \
      && apt-get purge --auto-remove -y software-properties-common \
      && apt-get update \
      && echo oracle-java-8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
      && apt-get install -y oracle-java8-installer oracle-java8-set-default \
                            mysql-server \
                            supervisor \
                            git \
                            curl \
                            wget \
                            tar \
      && apt-get clean \
      && rm -rf /var/cache/oracle-jdk8-installer \
      && rm -rf /var/lib/apt/lists/*

RUN wget -q --no-check-certificate --no-cookies -O - \ 
    http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
    && ln -s /opt/druid-$DRUID_VERSION /opt/druid

COPY conf /opt/druid-$DRUID_VERSION/conf 
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid

ENTRYPOINT ["/docker-entrypoint.sh"]
