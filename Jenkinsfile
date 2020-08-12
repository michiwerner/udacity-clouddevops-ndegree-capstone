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
        sh "cd ./sample_workload/ && docker build -t sample_workload:latest -t sample_workload:${BUILD_NUMBER} ."
      }
    }
    stage('Deploy') {
      steps {
        withAWS() {
          def dockerLogin = ecrLogin()
          sh "${dockerLogin}"
        }
      }
    }
  }
}