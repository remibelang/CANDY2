pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('token-1')   // Your SonarQube token in Jenkins
        DOCKER_IMAGE = "sample-java-app"       // Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/remibelang/CANDY2.git', credentialsId: 'github-token'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=candy2 -Dsonar.projectName="CANDY2"'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build & Run') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE .
                    docker stop $DOCKER_IMAGE || true
                    docker rm $DOCKER_IMAGE || true
                    docker run -d --name $DOCKER_IMAGE -p 8080:8080 $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        always { cleanWs() }
        success { echo "Pipeline completed successfully!" }
        failure { echo "Pipeline failed!" }
    }
}

