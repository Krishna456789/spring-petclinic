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
                -Dsonar.login=072696b6757624106c293ba7eb9cbdef8d920a95 \
                -Dsonar.host.url=https://sonarcloud.io \
                -Dsonar.organization=Krishna456789 \
                -Dsonar.projectKey=krishna456789_sonarqube'
            }
        }
        
    }
}