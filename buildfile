pipeline{
    agent { label ('JDK_17') }
    stages{
        stage('vcs'){
            steps{
                git url: 'https://github.com/Krishna456789/spring-petclinic.git'
                    branch: 'build'
            }
        }
        
    }
}