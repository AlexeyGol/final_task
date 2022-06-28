pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile_jenkins_agent'
            dir 'build_image'
            // label 'put agent name here!'
            args '-v /tmp:/tmp'
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
                timeout(time: 5, unit: "MINUTES")
            }
            steps {
            sh "printenv"
            sh 'java --version'
            }
       }
    }
}

// good_practice
post {
    // always {
    //     cleanWs()
    // }
    // failure {
    //     echo 'Build failed. Notifying on Telegram'
    //     //TG notification
    // }
}


 