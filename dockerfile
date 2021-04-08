From tomcat:latest
RUN rm -rf /usr/local/tomcat/webapps/*
COPY ./target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war
#WORKDIR /usr/local/tomcat/
#VOLUME /usr/local/tomcat/webapps
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
