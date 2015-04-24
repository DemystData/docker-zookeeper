FROM ubuntu:14.04
MAINTAINER Chris Baron <cbaron@demystdata.com>
    
RUN apt-get update
RUN apt-get dist-upgrade -y 
    
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update
RUN apt-get install oracle-java8-installer curl -y
RUN update-java-alternatives -s java-8-oracle
RUN apt-get install oracle-java8-set-default
    
RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt
ADD zoo.cfg.template /opt/zookeeper-3.4.6/conf/
ADD zookeeper-env.sh /opt/zookeeper-3.4.6/conf/
ADD start.sh /opt/zookeeper-3.4.6/
    
EXPOSE 2181 2888 3888
WORKDIR /opt/zookeeper-3.4.6
    
VOLUME ["/data"]
ENTRYPOINT ["/opt/zookeeper-3.4.6/start.sh"]
