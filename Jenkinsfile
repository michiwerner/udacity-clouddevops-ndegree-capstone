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
          script {
            sh "docker tag sample_workload:latest \$(aws ecr describe-repositories --repository-names 'devops-capstone-sample-workload' --query 'repositories[0].repositoryUri' | sed -e 's/\"//g'):latest"
            sh "docker tag sample_workload:${BUILD_NUMBER} \$(aws ecr describe-repositories --repository-names 'devops-capstone-sample-workload' --query 'repositories[0].repositoryUri' | sed -e 's/\"//g'):${BUILD_NUMBER}"
            def dockerLogin = ecrLogin()
            sh "${dockerLogin}"
            sh "docker push \$(aws ecr describe-repositories --repository-names 'devops-capstone-sample-workload' --query 'repositories[0].repositoryUri' | sed -e 's/\"//g')"
            sh "aws eks update-kubeconfig --name devops-capstone-eks-cluster"
            sh "cat deployment.tpl.yml | sed -e \"s%IMAGE%\$(aws ecr describe-repositories --repository-names 'devops-capstone-sample-workload' --query 'repositories[0].repositoryUri' | sed -e 's/\"//g'):${BUILD_NUMBER}%g\" | kubectl apply -f -"
          }
        }
      }
    }
  }
}