//or mvn clean package >> mvn test
pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME="alexego/final_task:final_task_${BUILD_TIMESTAMP}"
    }
    tools {
        maven "mvn 3.8.6"
        // terraform "Terraform 20622 darwin (amd64)"
    }

    // // should be replaced with AWS roles?
    // environment {
    //     #env variables to access aws
    //     AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    // }
    
    stages {     
        // stage('Build Jar'){
        //     options {
        //         timeout(time: 5, unit: "MINUTES")
        //     }
        //     steps {
        //         echo "########### Building JAR FILE ###########"
        //         // sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml package'
        //         //to speed up:
        //         sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml -Dmaven.test.skip=true package'
        //         sh 'ls -lah ./app/target'

        //     }
        // }

        // stage("Create Docker image"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Creating Docker image###########"
        //         //
        //         sh 'ls -lah'
        //         //tag with dockerhub repository
        //         echo 'Build image and tag Docker Image with my Dockerhub repository'
        //         sh "docker build -t ${DOCKER_IMAGE_NAME} --build-arg JARNAME='spring-petclinic-2.7.0-SNAPSHOT.jar' ."
        //         sh 'docker image ls -a'
        //         sh 'docker ps'
        //     }
        // }
       
        // stage("Push Docker image"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Pushing Docker image to the registry###########"
        //         withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        //             echo 'Login to the Dockerhub'
        //             sh('echo $dockerHubPassword | docker login -u $dockerHubUser --password-stdin')
        //             sh "docker info"
        //             sh 'docker push ${DOCKER_IMAGE_NAME}'
        //             echo 'https://hub.docker.com/repository/registry-1.docker.io/alexego/final_task/tags?page=1&ordering=last_updated'
        //         }
        //     }  
        // }
        
        stage("Environment - dev server"){
            // //role instead of environment?
            // environment {
            //     AWS_ACCESS_KEY_ID = credentials('aws_access_key_for_jenkins')
            //     AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key_for_jenkins')
            //     TF_VAR_my_ip = "185.220.94.81/32"
            // }
            steps {
               script {
                    dir('terraform') {
                        //tf needs access to s3 in the role
                        sh 'terraform -v'
                        sh 'terraform init'
                        sh 'terraform state list -no-color '
                        sh 'terraform plan -target=module.dev_server -no-color '
                        sh 'terraform apply -target=module.dev_server -auto-approve -no-color'
                        // sh 'terraform destroy -target=module.dev_server -auto-approve -no-color'
                        // sleep 60
                        def DEV_IP = sh(
                            script: "terraform output Dev_server_public_ip",
                            returnStdout: true
                            )
                        def DEV_IP = DEV_IP.trim()
                    }
               }
               sh 'printenv'
            }
        }
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
        always {
            // cleanWs()
            sh 'docker image prune -af'
        }
        failure {
            echo 'Build failed. Notifying on Telegram'
            //TG notification
        }
        success {
            echo 'Build succeeded'
        }
    }
}