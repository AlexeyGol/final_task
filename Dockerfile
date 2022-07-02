FROM openjdk
COPY app/target/$JARNAME $HOME/petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/petclinic.jar"]