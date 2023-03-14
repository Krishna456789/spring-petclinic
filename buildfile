pipeline {
    agent any
    stages {
        stage('vcs') {
            steps {
                git url: 'https://github.com/Krishna456789/spring-petclinic.git',
                    branch: 'build'
            }
        }
        stage('build'){
            steps {
                sh './mvnw package'
            }
        }
    }
}