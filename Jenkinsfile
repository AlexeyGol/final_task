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

        stage('Build Jar'){
            options {
                timeout(time: 10, unit: "MINUTES")
            }
            steps {
                echo "########### Building JAR FILE ###########"
                // sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml clean package'
                //to speed up:
                sh 'mvn -f /var/jenkins/workspace/final_task_learn/app/pom.xml -Dmaven.test.skip=true clean package'
                sh 'ls -lah ./app/target'

            }
        }

        stage("Create Docker image"){
            //Plugin - Build Timestamp for versioning
            steps {
                echo "###########Creating Docker image###########"
                //
                sh 'ls -lah'
                //tag with dockerhub repository
                echo 'Build image and tag Docker Image with my Dockerhub repository'
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
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
                    // sh('echo $dockerHubPassword | docker login -u $dockerHubUser --password-stdin')
                    // sh "docker info"
                    sh 'docker push ${DOCKER_IMAGE_NAME}'
                    echo 'https://hub.docker.com/repository/registry-1.docker.io/alexego/final_task/tags?page=1&ordering=last_updated'
                }
            }  
        }
        
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
                        sh 'unset DEV_IP'
                        // sh 'printenv'
                        DEV_IP = sh(
                            script: "terraform output Dev_server_public_ip",
                            returnStdout: true
                            ).trim()
                        // sh 'printenv'
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

                    sshagent(['ec2-ssh-username-with-pk']) {
                        def dev_commands = "docker run -d -p 8080:8080 ${DOCKER_IMAGE_NAME}"
                        withDockerRegistry(credentialsId: 'dockerHub', toolName: 'Docker') {
                            sh "ssh -o StrictHostKeyChecking=no $dev_server '${dev_commands}'"
                        }
                    }
                }
            }
        }
                    // withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-username-with-pk', keyFileVariable: 'PEM', usernameVariable: 'EC2_USR'), usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'DH_PWD', usernameVariable: 'DH_USR')]) {
                    // }
        
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
