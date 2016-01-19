FROM finalist/apiman-wildfly:1.2.0.Final

MAINTAINER Ton Swieb <ton@finalist.nl>

#Install required python packages, the Pythion installation manager and install required python dependencies
USER root
RUN yum -y install python epel-release 
RUN yum -y install python-pip && yum clean all 
RUN pip install requests
USER jboss

#Set the local URL to use for accessing JBoss Apiman via REST DSL for provisioning
ENV BASE_URL http://127.0.0.1:8080

ARG ADMIN_PASSWORD=admin123!

#Copy the content required for provisioning
COPY content /opt/jboss/provision/

#Execute the provision script
RUN /opt/jboss/provision/provision.sh

# Enable the management console for development purposes.
# Disable in production by commenting the line below!
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-c", "standalone-apiman.xml","-bmanagement","0.0.0.0"]

# Reset the command because we are now using entrypoint so we can easily append additional parameters without rewriting the whole CMD
CMD []
