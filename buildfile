pipeline{
    agent { label ('JDK_17') }
    stages{
        stage('vcs'){
            steps{
                git url: 'https://github.com/Krishna456789/spring-petclinic.git',
                    branch: 'build'
            }
        }
        stage ('MVN PACKAGE') {
            steps {
                sh './mvnw package'
            }
        }
        stage('build') {
            steps {
                sh './mvnw clean verify sonar:sonar \
                -Dsonar.login=4e69ad62dbe102f33bb2153c5de97a352cc37409 \
                -Dsonar.host.url=https://sonarcloud.io \
                -Dsonar.organization=darling456123 \
                -Dsonar.projectKey=darling456123_sonarqube'
            }
        }
        
    }
}