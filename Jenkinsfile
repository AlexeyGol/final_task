pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile_jenkins_agent'
            dir 'build_image'
            // label 'put agent name here!'
            args '-v /tmp:/tmp'
            args '-v /.m2:/.m2'
        }
    }
    // // should be replaced with AWS roles?
    // environment {
    //     #env variables to access aws
    //     AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    // }
    
    stages {
        stage("Env settings"){
            steps {
                // sh 'git clone -n https://github.com/takari/maven-wrapper.git'
                sh 'unset MAVEN_CONFIG'
            }
        }
        stage("Test code") {
            options {
                timeout(time: 20, unit: "MINUTES")
            }
            steps {
                sh 'pwd'
                sh 'mvn -N io.takari:maven:wrapper'
                sh 'mvn test -f ./app/pom.xml -X'
            }
       }
       stage("Test"){
            steps {
                echo "This is a test second stage"
                echo "$BUILD_TAG"
                sh 'mvn package -f ./app/pom.xml -Dmaven.test.skip=true'
                sh 'ls -lah ./app/target'
            }
       }
    }
}

// good_practice
// post {
    // always {
    //     cleanWs()
    // }
    // failure {
    //     echo 'Build failed. Notifying on Telegram'
    //     //TG notification
    // }
// }


 