pipeline {
    agent any

    // Global options (safe and compatible)
    options {
        timestamps()                    // show timestamps in logs
        ansiColor('xterm')              // enable colored console output
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'
                sh '''
                    echo "Compiling source code..."
                    sleep 2
                    echo "Build completed!"
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                    echo "All tests passed ‚úÖ"
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh '''
                    echo "Deploy successful! Ì∫Ä"
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully Ìæâ'
        }
        failure {
            echo 'Pipeline failed ‚ùå'
        }
    }
}

