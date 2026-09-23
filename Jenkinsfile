pipeline {

    agent any

    environment {
        APP_NAME = "jenkinsops"
        IMAGE_TAG = "${BUILD_NUMBER}"
        BUILD_TIMESTAMP = "${new Date().format('yyyy-MM-dd HH:mm:ss')}"
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
                echo "CHECKOUT"
                echo "================================="

                checkout scm
            }
        }


        stage('Build Information') {

            steps {

                echo """
=========================================
JENKINSOPS BUILD INFORMATION
=========================================

Application : ${APP_NAME}
Build       : ${BUILD_NUMBER}
Job         : ${JOB_NAME}
Workspace   : ${WORKSPACE}
Branch      : ${env.GIT_BRANCH}
Commit      : ${env.GIT_COMMIT}

=========================================
"""
            }
        }


        stage('Repository Validation') {

            steps {

                sh '''
                    echo "Checking repository..."

                    test -f app/index.html
                    test -f Dockerfile
                    test -f Jenkinsfile
                    test -f tests/test_app.sh
                    test -f scripts/security-check.sh

                    echo "Repository validation passed."
                '''
            }
        }


        stage('CI Checks') {

            parallel {

                stage('Unit Tests') {

                    steps {

                        echo "Running application tests..."

                        sh '''
                            chmod +x tests/test_app.sh

                            ./tests/test_app.sh
                        '''
                    }
                }


                stage('Security Check') {

                    steps {

                        echo "Running security check..."

                        sh '''
                            chmod +x scripts/security-check.sh

                            ./scripts/security-check.sh
                        '''
                    }
                }
            }
        }


        stage('Docker Build') {

            steps {

                echo "Building Docker image..."

                sh """
                    docker build \
                    -t ${APP_NAME}:${IMAGE_TAG} \
                    -t ${APP_NAME}:latest \
                    .
                """
            }
        }


        stage('Docker Verification') {

            steps {

                echo "Checking Docker image..."

                sh """
                    docker images ${APP_NAME}

                    docker image inspect \
                    ${APP_NAME}:${IMAGE_TAG} > docker-image-info.json
                """
            }
        }


        stage('Create Build Artifact') {

            steps {

                sh """
                    mkdir -p build-info

                    echo "Application=${APP_NAME}" \
                        > build-info/deployment.txt

                    echo "Build=${BUILD_NUMBER}" \
                        >> build-info/deployment.txt

                    echo "Commit=${GIT_COMMIT}" \
                        >> build-info/deployment.txt

                    echo "Timestamp=${BUILD_TIMESTAMP}" \
                        >> build-info/deployment.txt

                    echo "Status=CI PASSED" \
                        >> build-info/deployment.txt
                """

                archiveArtifacts(
                    artifacts: 'build-info/**,docker-image-info.json',
                    fingerprint: true
                )
            }
        }
    }


    post {

        success {

            echo """
=========================================
        CI PIPELINE SUCCESS
=========================================

Build ${BUILD_NUMBER} completed successfully.

Docker image:
${APP_NAME}:${IMAGE_TAG}

=========================================
"""
        }


        failure {

            echo """
=========================================
        CI PIPELINE FAILED
=========================================

Build ${BUILD_NUMBER} failed.

Check the failed stage in Jenkins.

=========================================
"""
        }


        always {

            echo "Pipeline execution completed."

            sh '''
                echo "Cleaning temporary files..."
                rm -rf build-info
            '''
        }
    }
}