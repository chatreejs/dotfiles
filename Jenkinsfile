pipeline {
  agent any

  environment {
    IMAGE_URL_WITH_TAG = "chatreejs/dotfiles:ubuntu"
  }

  stages {
    stage('Build') {
      steps {
        sh 'docker build -f Dockerfile . -t chatreejs/dotfiles:ubuntu'
      }
    }

    stage('Clear dangling image') {
      steps {
        sh 'docker container prune -f && docker image prune -f'
      }
    }

    stage('Push to registry') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credential', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'docker login -u $USERNAME -p $PASSWORD'
          sh 'docker push $IMAGE_URL_WITH_TAG'
        }
      }
    }
  }
  
  post {
    success {
      discordSend description: "Duration: ${currentBuild.durationString}", link: env.BUILD_URL, result: currentBuild.currentResult, title: "${JOB_NAME} - # ${BUILD_NUMBER}", footer: "${currentBuild.getBuildCauses()[0].shortDescription}",webhookURL: 'https://discord.com/api/webhooks/1038846192844541973/zWWNg0uc-FZYGf3ffwo9kc-gtYHRjjCiZIz6U_DNhxcOcShnx5AyyKtKfhH08uUj9f3r'
    }
    failure {
      discordSend description: "Duration: ${currentBuild.durationString}", link: env.BUILD_URL, result: currentBuild.currentResult, title: "${JOB_NAME} - # ${BUILD_NUMBER}", footer: "${currentBuild.getBuildCauses()[0].shortDescription}",webhookURL: 'https://discord.com/api/webhooks/1038846192844541973/zWWNg0uc-FZYGf3ffwo9kc-gtYHRjjCiZIz6U_DNhxcOcShnx5AyyKtKfhH08uUj9f3r'
    }
  }

}
