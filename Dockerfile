FROM ubuntu:14.04

ENV SOS_VERSION 4.3.7

# Apt setup -----------------------------------------------------------------------------------------------------------#
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
	  wget \
	  sudo \
	  ssh \
	  unzip \
	  vim \
	  software-properties-common \
	  openjdk-7-jre \
	  tomcat7 \
	  postgresql-client \
	  supervisor

# Setup supervisor ----------------------------------------------------------------------------------------------------#
COPY supervisord.conf /etc/supervisor/conf.d/

# Deploy sos.war ---------------------------------------------------------------------------------#
COPY sos/$SOS_VERSION/sos.war /tmp/
RUN unzip -d /var/lib/tomcat7/webapps/sos/ /tmp/sos.war && \
	rm /tmp/sos.war
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7/webapps/sos

EXPOSE 8080

# Add VOLUMES for inspection, data storage, and backup ----------------------------------------------------------------#
VOLUME  ["/var/log/tomcat7", "/var/log/supervisor"]

# Initialize
RUN mkdir -p /usr/share/tomcat7-sos
COPY startup.sh /usr/share/tomcat7-sos/startup.sh
RUN chmod +x /usr/share/tomcat7-sos/startup.sh

CMD ["/usr/share/tomcat7-sos/startup.sh"]
