pipeline {
  agent any

  stages {
    stage('Lint') {
      steps {
        sh 'tidy ./sample_workload/*.html'
        sh 'hadolint ./sample_workload/Dockerfile*'
      }
    }
    stage('Build') {
      steps {
        echo 'BUILD'
      }
    }
    stage('Deploy') {
      steps {
        echo 'DEPLOY'
      }
    }
  }
}