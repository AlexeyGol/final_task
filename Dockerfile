FROM openjdk
COPY ./app/target/spring-petclinic-2.7.0-SNAPSHOT.jar /petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/petclinic.jar"]