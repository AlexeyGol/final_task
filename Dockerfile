FROM openjdk
COPY app/target/${JARNAME} /petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/petclinic.jar"]