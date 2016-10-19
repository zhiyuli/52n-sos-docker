FROM ubuntu:16.04

ENV TOMCAT_PACKATE_NAME apache-tomcat-7.0.72.tar.gz
ENV SOS_PACKAGE_NAME 52n-sos-4.3.7.war
# Tomcat admin user password
ENV ADMIN_PASS tomcat7

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
                                         net-tools

# tomcat main folder in vm
ENV CATALINA_HOME /tomcat

COPY tomcat/${TOMCAT_PACKATE_NAME} /tmp/tomcat.tar.gz
RUN tar zxf /tmp/tomcat.tar.gz && \
    mv apache-tomcat* ${CATALINA_HOME} && \
    rm /tmp/tomcat.tar.gz

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

EXPOSE 8080

# Add VOLUMES for inspection
VOLUME  ["/tomcat/logs", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]
