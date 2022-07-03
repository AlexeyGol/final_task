//or mvn clean package >> mvn test
pipeline {
    agent any
    tools {
        maven "mvn 3.8.6"
    }

    // // should be replaced with AWS roles?
    // environment {
    //     #env variables to access aws
    //     AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    // }
    
    stages {     
        stage('Build Jar'){
            options {
                timeout(time: 5, unit: "MINUTES")
            }
            steps {
                echo "########### Building JAR FILE ###########"
                // sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml package'
                //to speed up:
                sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml -Dmaven.test.skip=true package'
                sh 'ls -lah ./app/target'

            }
        }

        stage("Create Docker image"){
            //Plugin - Build Timestamp for versioning
            steps {
                echo "###########Creating Docker image###########"
                //
                sh 'ls -lah'
                sh "docker build -t final_task_petclinic:${BUILD_TIMESTAMP} --build-arg JARNAME='spring-petclinic-2.7.0-SNAPSHOT.jar' ."
                sh 'docker image ls -a'
                sh 'docker ps'
            }
        }
       
        stage("Push Docker image"){
            //Plugin - Build Timestamp for versioning
            steps {
                echo "###########Pushing Docker image to the registry###########"
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    echo 'Login to the Dockerhub'
                    sh('echo $dockerHubPassword | docker login -u $dockerHubUser --password-stdin')
                    sh "docker system info | grep -E alexeygo"
        //   sh 'docker push shanem/spring-petclinic:latest'
        //         docker tag getting-started YOUR-USER-NAME/getting-started
        //         docker push alexego/final_task
                }
            }  
        }
        

        


        // stage("Create dev server"){
        //     //role instead of environment?
        //     environment {
        //         AWS_ACCESS_KEY_ID = credentials('aws_access_key_for_jenkins')
        //         AWS_SECRET_ACCESS_KEY = ('aws_secret_access_key_for_jenkins')
        //         TF_VAR_my_ip = "185.220.94.81/32"
        //     }
        //     steps {
        //        script {
        //             dir('terraform') {
        //                 sh 'terraform init'
        //                 sh 'terraform apply --target <put module here> --auto-approve'
        //                 DEV_IP = sh(
        //                     script: "terraform output Jenkins_public_ip",
        //                     returnStdout: true
        //                 ).trim
        //             }
        //        }
        //     }
        // }
        // stage("Deploy to dev") {
        //     steps {
        //         script {
        //             // wait for the server to boot
        //             sleep(time: 60, unit: "SECONDS")
        // sh 'while ! mysqladmin ping -h0.0.0.0 --silent; do sleep 1; done'
        //             echo 'deploy to dev server'
        //             def dev_server = "ec2-user@${DEV_IP}"

        //             sshagent(['server-key-pair']) {
        //                 sh "scp -o StrictHostKeyChecking=no somefile ${DEV_IP}:/home/ec2-user/"
        //                 // pull image from ECR
        //                 // run image
                            //delete previous container
                            // docker login
                            // docker run alexego/final_task:${BUILD_TIMESTAMP}
        //             }
        //         }
        //     }
        // }
        // stage("Test"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Creating Docker image###########"
        //         curl http://${DEV_IP}:8080
        //     }
        // }
    }
    

// good_practice
    post {
        // always {
        //     cleanWs()
        // }
        failure {
            echo 'Build failed. Notifying on Telegram'
            //TG notification
        }
        success {
            echo 'Build succeeded'
        }
    }
}