pipeline {
  agent any

  options {
    timestamps()
    // If you don't have the AnsiColor plugin, delete the next line.
    ansiColor('xterm')
  }

  environment {
    // change these to your values
    DOCKERHUB_REPO = 'ci-cd-sample'                 // repo name on Docker Hub
    // If your Docker Hub username is same as GitHub, set it here:
    DOCKERHUB_USER = 'skabdullahus'               // Docker Hub username
    IMAGE_NAME     = "${env.DOCKERHUB_USER}/${env.DOCKERHUB_REPO}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'git log -1 --oneline || true'
      }
    }

    stage('Build') {
      steps {
        echo 'Building app (sample placeholder)…'
        sh '''
          echo "Build steps go here (npm/mvn/gradle/etc)."
          sleep 1
        '''
      }
    }

    stage('Test') {
      steps {
        echo 'Running tests (sample placeholder)…'
        sh 'echo "All tests passed ✅"'
      }
    }

    stage('Compute Image Tag') {
      steps {
        script {
          // Prefer short git SHA; fallback to build number
          env.IMAGE_TAG = sh(
            script: 'git rev-parse --short=12 HEAD 2>/dev/null || echo ' + env.BUILD_NUMBER,
            returnStdout: true
          ).trim()
          echo "Image tag: ${env.IMAGE_TAG}"
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        // Requires a Jenkins credential: kind "Username with password", ID "dockerhub"
        
	withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                  usernameVariable: 'DH_USER',
                                  passwordVariable: 'DH_PASS')]) {
  	sh '''
       	 echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin

     	docker build -t "$IMAGE_NAME:$IMAGE_TAG" .
    	docker tag "$IMAGE_NAME:$IMAGE_TAG" "$IMAGE_NAME:latest"

    	docker push "$IMAGE_NAME:$IMAGE_TAG"
    	docker push "$IMAGE_NAME:latest"

    	docker logout || true
      '''

	   }
      }
    }

    stage('(Optional) Smoke Run') {
      when { expression { return false } } // flip to true to test-run locally
      steps {
        sh """
          docker rm -f sample-app || true
          docker run -d --name sample-app -p 8081:80 ${IMAGE_NAME}:${IMAGE_TAG}
          sleep 3
          docker ps --filter name=sample-app
        """
      }
    }
  }

  post {
    always {
      echo "Build URL: ${env.BUILD_URL}"
    }
    success {
      echo "Pushed: ${IMAGE_NAME}:${IMAGE_TAG} and :latest ✅"
    }
    failure {
      echo "Pipeline failed ❌ — check console log."
    }
  }
}

