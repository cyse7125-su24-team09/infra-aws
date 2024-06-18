pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
        }
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Fmt') {
            steps {
                sh 'terraform fmt -recursive -check'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate -json'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
