pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile_jenkins_agent'
            dir 'build_image'
            // label 'put agent name here!'
            args '-v /tmp:/tmp'
            args '-v /root/.m2:/root/.m2'
        }
    }
    // // should be replaced with AWS roles?
    // environment {
    //     #env variables to access aws
    //     AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    // }
    
    stages {
        stage("Build") {
            options {
                timeout(time: 20, unit: "MINUTES")
            }
            steps {
            sh 'pwd'
            sh 'mvn -N io.takari:maven:wrapper'
            sh 'chmod +x ./app/mvnw'
            sh './app/mvn package -f ./app/pom.xml -X'
            }
       }
       stage("Second stage"){
            steps {
                echo "This is a test second stage"
                echo "$BUILD_TAG"
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


 