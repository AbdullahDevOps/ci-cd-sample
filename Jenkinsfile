pipeline {
  agent any

  environment {
    IMAGE_NAME     = "demo/web"
    IMAGE_TAG      = "build-${env.BUILD_NUMBER}"
    CONTAINER_NAME = "ci_web"
    HOST_PORT      = "8090"
    CONTAINER_PORT = "80"
  }

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Checking out source..."
        checkout scm
      }
    }

    stage('Build') {
      steps {
        echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}"
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
      post {
        success {
          sh 'docker images | head -n 10'
        }
      }
    }

    stage('Test') {
      steps {
        echo "Running test container..."
        sh """
          docker rm -f ${CONTAINER_NAME}-test || true
          docker run -d --name ${CONTAINER_NAME}-test -p 0:${CONTAINER_PORT} ${IMAGE_NAME}:${IMAGE_TAG}
          TEST_PORT="\$(docker inspect ${CONTAINER_NAME}-test --format='{{ (index (index .NetworkSettings.Ports \"${CONTAINER_PORT}/tcp\") 0).HostPort }}')"
          echo "Ephemeral port: \$TEST_PORT"
          sleep 2
          curl -fsSL http://localhost:\$TEST_PORT | grep -q "Hello from Jenkins CI/CD!"
        """
      }
      post {
        always {
          sh 'docker rm -f ${CONTAINER_NAME}-test || true'
        }
      }
    }

    stage('Deploy') {
      steps {
        echo "Deploying live container..."
        sh """
          docker rm -f ${CONTAINER_NAME} || true
          docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE_NAME}:${IMAGE_TAG}
          sleep 2
          curl -fsSL http://localhost:${HOST_PORT} | grep -q "Hello from Jenkins CI/CD!"
        """
      }
    }
  }

  post {
    success {
      echo "SUCCESS: App running at http://34.245.144.236:${HOST_PORT}"
    }
    failure {
      echo "FAILED: check logs below"
      sh 'docker ps -a || true'
    }
    always {
      echo "Build ${env.BUILD_NUMBER} finished."
    }
  }
}
