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
        stage('post build') {
            steps {
                archiveArtifacts artifacts: '**/target/spring-petclinic-3.0.0-SNAPSHOT.jar',
                                 onlyIfSuccessful: true
                junit testResults: '**/surefire-reports/TEST-*.xml'
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
        stage ('Artifactory configuration') {
            steps {
                rtServer (
                    id: "ARTIFACTORY_SERVER",
                    url: 'https://chaitanyadar.jfrog.io/artifactory',
                    credentialsId: 'JFROG-TOKEN'
                )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: 'libs-release',
                    snapshotRepo: 'libs-snapshot'
                )

                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: 'libs-release',
                    snapshotRepo: 'libs-snapshot'
                )
            }
        }
        stage('package') {
            tools {
                jdk 'jdk_17'
            }
            steps {
                rtMavenRun (
                    tool: 'MAVEN_DEFAULT',
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER"
                    
                )
                rtPublishBuildInfo (
                    serverId: "ARTIFACTORY_SERVER"
                )
                //sh "mvn ${params.MAVEN_GOAL}"
            }
        }        
        
    }
}