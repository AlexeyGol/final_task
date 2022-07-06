FROM openjdk
COPY ./app/target/${JARNAME} /${HOME}/petclinic.jar
EXPOSE 8080
WORKDIR /${HOME}
ENTRYPOINT ["java","-jar","petclinic.jar"]