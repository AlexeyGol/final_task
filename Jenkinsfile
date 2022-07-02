//or mvn clean package >> mvn test
pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile_jenkins_agent'
            dir 'build_image'
            // label 'put agent name here!'
            args '-v /tmp:/tmp -v /usr/bin/docker:/usr/bin/docker'
            // to do not download every time
            args '-v $HOME/.m2:/root/.m2'
            //to share docker commands to the agent
            args '-v /usr/bin/docker:/usr/bin/docker'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
            //to share docker commands to the agent v2
            // args '-e DOCKER_HOST=unix:///var/run/docker.sock'
            args '--privileged'
            reuseNode true
        }
    }
    // // should be replaced with AWS roles?
    // environment {
    //     #env variables to access aws
    //     AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    // }
    
    stages {
        stage('TESTDOCKER'){
            steps {
                echo "########### TESTDOCKER ###########"
                sh 'docker run hello-world'
            }
            }
        
        // stage('Env settings'){
        //     steps {
        //         echo "########### Preparing environment ###########"
        //         // sh 'git clone -n https://github.com/takari/maven-wrapper.git'
        //         sh 'unset MAVEN_CONFIG'
        //         // sh 'chmod 777 /var/run/docker.sock'
        //         sh 'printenv'
        //         }
        //     }
        
        // stage('Test code'){
        //     options {
        //         timeout(time: 20, unit: "MINUTES")
        //     }
        //     steps {
        //         echo "########### Testing code ###########"
        //         sh 'pwd'
        //         sh 'mvn -N io.takari:maven:wrapper'
        //         //can add -X flag for debug mode
        //         sh 'mvn test -f ./app/pom.xml'
        //     }
        // }
        // stage('Package'){
        //     steps {
        //         echo "########### Package jar ###########"
        //         echo "$BUILD_TAG"
        //         sh 'mvn package -f ./app/pom.xml -Dmaven.test.skip=true'
        //         sh 'ls -lah ./app/target'
        //     }
        // } 

        // stage("Create Docker image"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Creating Docker image###########"
        //         //
        //         sh 'ls -lah'
        //         sh "docker build -t final_task_petclinic:${BUILD_TIMESTAMP} --build-arg JARNAME='spring-petclinic-2.7.0-SNAPSHOT.jar' ."
        //         sh 'docker image ls -a'
        //     }
        // }
       
        // stage("Push Docker image"){
        //     //Plugin - Build Timestamp for versioning
        //     steps {
        //         echo "###########Pushing Docker image to the registry###########"
        //         docker login 
        // withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        //   sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
        //   sh 'docker push shanem/spring-petclinic:latest'
        //         docker tag getting-started YOUR-USER-NAME/getting-started
        //         docker push alexego/final_task
        //     }
        // }

        

        


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