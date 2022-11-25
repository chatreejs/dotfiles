pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -f docker/Dockerfile . -t chatreejs/dotfiles:ubuntu'
      }
    }

    stage('Clear dangling image') {
      steps {
        sh 'docker container prune -f && docker image prune -f'
      }
    }

  }
}