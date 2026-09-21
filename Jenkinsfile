pipeline {

    agent any

    environment {
        APP_NAME = "jenkinsops"
        BUILD_VERSION = "${BUILD_NUMBER}"
    }

    options {

        timestamps()

        timeout(
            time: 20,
            unit: 'MINUTES'
        )

        disableConcurrentBuilds()

        buildDiscarder(
            logRotator(
                numToKeepStr: '10'
            )
        )
    }

    stages {

        stage('Checkout') {

            steps {

                echo "================================="
                echo "CHECKOUT SOURCE CODE"
                echo "================================="

                checkout scm
            }
        }


        stage('Environment Information') {

            steps {

                echo "================================="
                echo "BUILD INFORMATION"
                echo "================================="

                echo "Application : ${APP_NAME}"
                echo "Build       : ${BUILD_NUMBER}"
                echo "Job         : ${JOB_NAME}"
                echo "Workspace   : ${WORKSPACE}"
            }
        }


        stage('Validate Repository') {

            steps {

                echo "================================="
                echo "VALIDATING REPOSITORY"
                echo "================================="

                sh '''
                    echo "Checking project structure..."

                    test -f app/index.html
                    test -f Dockerfile
                    test -f Jenkinsfile

                    echo "Repository validation successful."
                '''
            }
        }


        stage('Application Test') {

            steps {

                echo "================================="
                echo "RUNNING APPLICATION TESTS"
                echo "================================="

                sh '''
                    chmod +x tests/test_app.sh

                    ./tests/test_app.sh
                '''
            }
        }


        stage('Build Docker Image') {

            steps {

                echo "================================="
                echo "BUILDING DOCKER IMAGE"
                echo "================================="

                sh """
                    docker build \
                    -t ${APP_NAME}:${BUILD_VERSION} \
                    -t ${APP_NAME}:latest \
                    .
                """
            }
        }


        stage('Docker Image Verification') {

            steps {

                echo "================================="
                echo "VERIFYING DOCKER IMAGE"
                echo "================================="

                sh """
                    docker images ${APP_NAME}
                """
            }
        }
    }


    post {

        success {

            echo """
=========================================
        JENKINSOPS BUILD SUCCESS
=========================================

Application : ${APP_NAME}
Build       : ${BUILD_NUMBER}
Status      : SUCCESS

=========================================
"""
        }


        failure {

            echo """
=========================================
        JENKINSOPS BUILD FAILED
=========================================

Application : ${APP_NAME}
Build       : ${BUILD_NUMBER}
Status      : FAILED

Check Jenkins console output.

=========================================
"""
        }


        always {

            echo "Pipeline execution completed."

        }
    }
}
