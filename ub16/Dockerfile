FROM ubuntu:16.04

ENV TOMCAT_PACKATE_NAME apache-tomcat-7.0.72.tar.gz
ENV SOS_PACKAGE_NAME 52n-sos-4.3.7.war
# Tomcat admin user password
ENV ADMIN_PASS tomcat7

# ssl files path
ENV CERTS_FOLDER /certs
# RSA Private key filename
ENV RSA_KEY_FILENAME server.key
# certificate filename
ENV CERT_FILENAME server.crt
# certificate chain filename
ENV CERT_CHAIN_FILENAME cert-chain.crt

# add openjdk repo
RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common
RUN add-apt-repository -y  ppa:openjdk-r/ppa

RUN apt-get update && apt-get install -y openssh-server \
                                         openjdk-7-jdk \
                                         supervisor \
                                         wget \
                                         ca-certificates \
                                         sudo \
                                         ssh \
                                         unzip \
                                         vim \
                                         postgresql-client \
                                         supervisor \
                                         net-tools \
                                         gcc \
                                         make \
                                         libssl-dev \
                                         libapr1-dev

# set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
# tomcat main folder in vm
ENV CATALINA_HOME /tomcat

COPY tomcat/${TOMCAT_PACKATE_NAME} /tmp/tomcat.tar.gz
RUN tar zxf /tmp/tomcat.tar.gz && \
    mv apache-tomcat* ${CATALINA_HOME} && \
    rm /tmp/tomcat.tar.gz

# compile and install tomcat-native apr lib for ssl
RUN cd /${CATALINA_HOME}/bin && \
    tar xzvf tomcat-native.tar.gz && \
    cd tomcat-native-*-src/native && \
    ./configure --prefix=/apr && \
    make && \
    make install && \
    rm -rf /${CATALINA_HOME}/bin/tomcat-native-*-src

# create setenv.sh to include apr lib folder
RUN echo '#!/bin/sh' >> ${CATALINA_HOME}/bin/setenv.sh
RUN echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/apr/lib'" >> ${CATALINA_HOME}/bin/setenv.sh

# create folder for ssl files
RUN mkdir -p ${CERTS_FOLDER}
COPY certs/* ${CERTS_FOLDER}/
RUN chmod -R 400 ${CERTS_FOLDER}

# prepare server.xml
RUN rm -f ${CATALINA_HOME}/conf/server.xml
COPY tomcat/server.xml ${CATALINA_HOME}/conf/server.xml
RUN sed -i 's!<CERTS_FOLDER>!'${CERTS_FOLDER}'!g' ${CATALINA_HOME}/conf/server.xml
RUN sed -i 's!<CERT_FILENAME>!'${CERT_FILENAME}'!g' ${CATALINA_HOME}/conf/server.xml
RUN sed -i 's!<RSA_KEY_FILENAME>!'${RSA_KEY_FILENAME}'!g' ${CATALINA_HOME}/conf/server.xml
RUN sed -i 's!<CERT_CHAIN_FILENAME>!'${CERT_CHAIN_FILENAME}'!g' ${CATALINA_HOME}/conf/server.xml

# set Tomcat admin password
RUN sed -i -r 's/<\/tomcat-users>//' ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '<role rolename="manager-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '<role rolename="manager-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '<role rolename="manager-jmx"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '<role rolename="admin-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '<role rolename="admin-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo "<user username=\"admin\" password=\"${ADMIN_PASS}\" roles=\"manager-gui,manager-script,manager-jmx,admin-gui, admin-script\"/>" >> ${CATALINA_HOME}/conf/tomcat-users.xml
RUN echo '</tomcat-users>' >> ${CATALINA_HOME}/conf/tomcat-users.xml

COPY 52n-sos/${SOS_PACKAGE_NAME} /tmp/sos.war
RUN unzip -d /tomcat/webapps/sos/ /tmp/sos.war && \
	rm /tmp/sos.war

# Setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/

EXPOSE 8080 8443 22

# Add VOLUMES for inspection
VOLUME  ["/tomcat/logs", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]
