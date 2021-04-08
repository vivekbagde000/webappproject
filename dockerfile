From tomcat:latest
COPY LoginWebApp2/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war
#RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
#COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
#COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
WORKDIR /usr/local/tomcat/
VOLUME /usr/local/tomcat/webapps
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
