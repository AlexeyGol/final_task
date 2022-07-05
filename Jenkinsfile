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
                        // sh 'terraform -v'
                        sh 'terraform init'
                        // sh 'terraform state list -no-color '
                        // sh 'terraform plan -target=module.dev_server -no-color '
                        sh 'terraform apply -auto-approve -no-color'
                        // sh 'terraform destroy -target=module.dev_server -auto-approve -no-color'
                        // sleep 60
                        sh 'printenv'
                        DEV_IP = sh(
                            script: "terraform output Dev_server_public_ip",
                            returnStdout: true
                            ).trim()
                        sh 'printenv'
                    }
               }
               echo "DEV_IP is : ${DEV_IP}"
            }
        }
        
        stage("Deploy to dev") {
            steps {
                script {
                    // wait for the server to boot
                    // sleep(time: 60, unit: "SECONDS")
                    // sh 'while ! mysqladmin ping -h0.0.0.0 --silent; do sleep 1; done'
                    echo 'deploy to dev server'
                    def dev_server = "ec2-user@${DEV_IP}"
                    def dev_user = 'ec2-user'
                    
                    sshagent(['ec2-ssh-username-with-pk']) {
                        sh "scp -o StrictHostKeyChecking=no \
                            /var/jenkins/workspace/final_task_learn/app/target/spring-petclinic-2.7.0-SNAPSHOT.jar \
                            ${DEV_IP}:/home/ec2-user/"
                        sh "ls -lah /home/ec2-user && java -jar /home/ec2-user/spring-petclinic-2.7.0-SNAPSHOT.jar"
                    }
                        
                    // withCredentials([
                    //     usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]){
                    //     sshagent(credentials: ['ec2-ssh-username-with-pk']){
                    //         sh "ssh -o StrictHostKeyChecking=no ${dev_server} uptime && \
                    //         echo \${dockerHubPassword} | docker login -u \${dockerHubUser} --password-stdin && \
                    //         docker image pull \${DOCKER_IMAGE_NAME} && \
                    //         docker image ls -a && \
                    //         docker container run \${DOCKER_IMAGE_NAME} && \
                    //         docker ps"
                    //         // docker image prune -af && \
                    //     }
                    // }
                            // rm /home/ec2-user/.docker/config.json


                            // sh "ssh -i $ec2_pem -o StrictHostKeyChecking=no $dev_server docker login -u $dockerHubUser -p $dockerHubPassword"
                    //     sshUserPrivateKey(credentialsId: 'ec2-ssh-username-with-pk', keyFileVariable: 'ec2_pem')
                            // sshagent(['ec2-ssh-username-with-pk']){
                        
                            // sh "ssh -o StrictHostKeyChecking=no ${dev_server} uptime"

                            // sh "ssh -i ${ec2_pem} -o StrictHostKeyChecking=no ${dev_server} uptime" //WORKING!
                            // sh "ssh -i $ec2_pem -o StrictHostKeyChecking=no $dev_server docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
                            

                            
                            
                            // sh "ssh -i ${ec2_pem} -o StrictHostKeyChecking=no ${dev_server} uptime && \
                            // pwd \
                            
                            
                            
                            
                            // sh "ssh -i ${ec2_pem} -o StrictHostKeyChecking=no ${dev_server} /bin/bash '<< EOF
                            //     pwd
                            //     uptime
                            // EOF'"
                            
                            
                            // sh "ssh -i ${ec2_pem} -o StrictHostKeyChecking=no ${dev_server} echo ${dockerHubPassword} | docker login -u ${dockerHubUser} --password-stdin"

                           
                            

                            // sh "ssh -i ${ec2_pem} ${dev_server} docker image pull ${DOCKER_IMAGE_NAME}"
                }
                        //  COMMANDS = "cd /www && git fetch"
                        // sh "sshpass -p $PASSWORD ssh -A -o StrictHostKeyChecking=no -T $USERNAME@$SERVER '$COMMANDS'"
                        
                        
                        // sh "ssh -i ${ec2_pem} ${dev_server} << 'ENDSSH'
                        //     unzip -o -d path/to/bin  path/to/bin/my-bin.zip 
                        //     rm path/to/bin/my-bin.zip 
                        //     chmod +x  path/to/bin/run.sh 
                        // ENDSSH"
                        
                        // //     ssh dev_server "w"
                        // //     ssh dev_server "cat /etc/os-release"
                        // secretFile(credentialsId: 'aws-server-key-pair', passwordVariable: 'ec2Password', usernameVariable: 'ec2User')
                                                        
                        //     // ssh env.dev_server StrictHostKeyChecking=no
                                
                        //     //         sh 'w'
                        //     //         sh 'pwd'
                        //             // // docker login
                        //             // echo 'Login to the Dockerhub'
                        //             // sh('echo $dockerHubPassword | docker login -u $dockerHubUser --password-stdin')
                        //             // // pull image from ECR
                        //             // sh 'docker image pull ${DOCKER_IMAGE_NAME}'
                        // }
                // }
                     
            //         }
            //     }
            }
        }
        // stage("Test"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Creating Docker image###########"
        //         curl http://${DEV_IP}:8080
        //     }
        // }

        // stage("Deploy to production"){
        //     steps {
        //         timeout(time:5, unit: MINUTES) {
        //             input message 'Approve deploy to production?'
        //         }
        // }        
        }
    

// good_practice
    post {
        always {
            // cleanWs()
            sh 'docker image prune -af'
            echo "https://hub.docker.com/repository/registry-1.docker.io/alexego/final_task/tags?page=1&ordering=last_updated"
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