pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME="alexego/final_task:final_task_${BUILD_TIMESTAMP}"
    }
    tools {
        maven "mvn 3.8.6"
    }
   
    stages {     
        stage('Build Jar'){
            options {
                timeout(time: 10, unit: "MINUTES")
            }
            steps {
                echo "#####################################################################"
                echo "######################### Building JAR FILE #########################"
                echo "#####################################################################"
                // sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml clean package'
                //to speed up:
                sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml -Dmaven.test.skip=true clean package'
                sh 'ls -lah ./app/target'

            }
        }

        stage('Tests'){
            steps {
                echo "#####################################################################"
                echo "######################### Running tests #############################"
                echo "#####################################################################"
            }
        }

        

        stage("Create Docker image"){
            //Plugin - Build Timestamp for versioning
            steps {
                echo "#####################################################################"
                echo "##################### Creating Docker image #########################"
                echo "#####################################################################"                
                //tag with dockerhub repository
                echo 'Build image and tag Docker Image with my Dockerhub repository'
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
                sh 'docker image ls -a'
            }
        }
       
        stage("Push Docker image"){
            steps {
                echo "#####################################################################"
                echo "############### Pushing Docker image to the registry ################"
                echo "#####################################################################"  
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    echo 'Login to the Dockerhub'
                    sh('echo $dockerHubPassword | docker login -u $dockerHubUser --password-stdin')
                    echo 'Sending image to the Dockerhub'
                    sh 'docker push ${DOCKER_IMAGE_NAME}'
                    echo 'https://hub.docker.com/repository/registry-1.docker.io/alexego/final_task/tags?page=1&ordering=last_updated'
                }
            }  
        }
        
        stage("Environment - Terraform work"){
            steps {
                echo "#####################################################################"
                echo "####################### Preparing environment #######################"
                echo "#####################################################################"              
                script {
                    dir('terraform') {
                        //tf needs access to s3 in the role
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve -no-color'
                        // sleep 60
                        // sh 'unset DEV_IP'
                        // sh 'unset PROD_IP'
                        DEV_IP = sh(
                            script: "terraform output Dev_server_public_ip",
                            returnStdout: true
                            ).trim()
                        // sh 'printenv'
                        PROD_IP = sh(
                            script: "terraform output Prod_server_public_ip",
                            returnStdout: true
                            ).trim()
                    }
                }
            }
        }
        
        stage("Deploy to dev") {
            environment {
                DH_CREDS = credentials('dockerHub')
                // DOCKER_HOST = "ssh://ec2-user@35.178.85.162"
            }
            steps {
                echo "#####################################################################"
                echo "####################### Deploy to DEV Server ########################"
                echo "#####################################################################"  

                script {
                    // wait for the server to boot
                    // sleep(time: 60, unit: "SECONDS")
                    echo 'deploy to dev server'
                    def dev_server = "ec2-user@${DEV_IP}"
                    def dev_user = 'ec2-user'
                    // //COPY JAR FROM TARGET AND RUN ON DEV SERVER - WITHOUT DOCKER
                    // sshagent(['ec2-ssh-username-with-pk']) {
                    //     sh "scp -o StrictHostKeyChecking=no \
                    //         /var/jenkins/workspace/final_task_learn/app/target/spring-petclinic-2.7.0-SNAPSHOT.jar ${DEV_IP}:/home/ec2-user/"
                    //     sh "ssh -o StrictHostKeyChecking=no ${dev_server} java -jar /home/ec2-user/spring-petclinic-2.7.0-SNAPSHOT.jar >/dev/null 2>&1 &"
                    //     }
                        
                    // //BLOCK WITH DOCKER - public repo
                    // withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    //     sshagent(credentials: ['ec2-ssh-username-with-pk']){
                    //         def docker_login = "docker pull ${DOCKER_IMAGE_NAME} && \
                    //             docker rm -f \$(docker ps -a -q) && \
                    //             docker run -d -p 8080:8080 ${DOCKER_IMAGE_NAME}"
                    //         sh "ssh -o StrictHostKeyChecking=no ${dev_server} '${docker_login}'"
                    //         }
                    // }
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'DH_PWD', usernameVariable: 'DH_USR'), sshUserPrivateKey(credentialsId: 'ec2-ssh-username-with-pk', keyFileVariable: 'ec2pem', usernameVariable: 'EC2_USR')]){
                        def run_dev_server_script = 'bash /home/ec2-user/dev_script.sh ${DH_USR} ${DH_PWD} ${DOCKER_IMAGE_NAME}'
                        sh "scp -o StrictHostKeyChecking=no -i ${ec2pem} dev_script.sh ${dev_server}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no -i ${ec2pem} docker-compose.yaml ${dev_server}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no -i ${ec2pem} -T ${dev_server} ${run_dev_server_script}"
                    }
                }
            }
        }
        
        stage("Deploy to production"){
            steps {
                echo "#####################################################################"
                echo "####################### Deploy to PROD Server ########################"
                echo "#####################################################################"  
                script {
                    // timeout(time:5, unit: MINUTES) {
                    //     input message 'Approve deploy to production?'
                    // }
                    def prod_user = 'ec2-user'
                    def prod_server = "${prod_user}@${PROD_IP}"
                    withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'DH_PWD', usernameVariable: 'DH_USR'), sshUserPrivateKey(credentialsId: 'ec2-ssh-username-with-pk', keyFileVariable: 'ec2pem', usernameVariable: 'EC2_USR')]){
                        def run_dev_server_script = 'bash /home/ec2-user/dev_script.sh ${DH_USR} ${DH_PWD} ${DOCKER_IMAGE_NAME}'
                        sh "scp -o StrictHostKeyChecking=no -i ${ec2pem} dev_script.sh ${prod_server}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no -i ${ec2pem} docker-compose.yaml ${prod_server}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no -i ${ec2pem} -T ${prod_server} ${run_dev_server_script}"
                    }
                }
            }     
        }   
        
    
    }

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
            telegramSend 'Hello World'
            echo "DEV_IP is : ${DEV_IP}"
            echo "PROD_IP is : ${PROD_IP}"

        }
    }
}
