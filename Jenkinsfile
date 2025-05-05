pipeline {
  agent any

  environment {
    IMAGE_URL_UBUNTU = "chatreejs/dotfiles:ubuntu"
    IMAGE_URL_DEBIAN = "chatreejs/dotfiles:debian"
  }

  stages {
    stage('Build in Parallel') {
      parallel {
        stage('Build Ubuntu') {
          steps {
            sh 'docker build -f docker/Dockerfile.ubuntu . -t $IMAGE_URL_UBUNTU'
          }
        }
        stage('Build Debian') {
          steps {
            sh 'docker build -f docker/Dockerfile.debian . -t $IMAGE_URL_DEBIAN'
          }
        }
      }
    }

    stage('Push to registry') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credential', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'docker login -u $USERNAME -p $PASSWORD'
          sh 'docker push $IMAGE_URL_UBUNTU'
          sh 'docker push $IMAGE_URL_DEBIAN'
        }
      }
    }

    stage('Clear images') {
      steps {
        sh 'docker rmi $IMAGE_URL_UBUNTU'
        sh 'docker rmi $IMAGE_URL_DEBIAN'
      }
    }
  }

  post {
    success {
      discordSend description: "Duration: ${currentBuild.durationString}", link: env.BUILD_URL, result: currentBuild.currentResult, title: "${JOB_NAME} - # ${BUILD_NUMBER}", footer: "${currentBuild.getBuildCauses()[0].shortDescription}", webhookURL: "https://discord.com/api/webhooks/${DISCORD_WEBHOOK_ID}/${DISCORD_WEBHOOK_TOKEN}"
    }
    failure {
      discordSend description: "Duration: ${currentBuild.durationString}", link: env.BUILD_URL, result: currentBuild.currentResult, title: "${JOB_NAME} - # ${BUILD_NUMBER}", footer: "${currentBuild.getBuildCauses()[0].shortDescription}", webhookURL: "https://discord.com/api/webhooks/${DISCORD_WEBHOOK_ID}/${DISCORD_WEBHOOK_TOKEN}"
    }
  }
}
