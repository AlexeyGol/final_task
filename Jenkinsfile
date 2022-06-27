pipeline {
    agent {
        docker {
              
        }
    }
    environment {
        #env variables to access aws
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    
    stages {
        stage("Build") {
            options {
                timeout(time: 5, unit: "MINUTES")
            }
            steps {
            sh "mvn -version"
            sh "mvn clean install"
            }
       }
    }
}

#good_practice
post {
    always {
        cleanWs()
    }
}


 