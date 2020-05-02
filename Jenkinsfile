pipeline {
    agent {
            label "docker && linux"
    } 
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'
                script {              
                    withVault(configuration: [timeout: 60], vaultSecrets: [[path: 'infastructure/gitlab', secretValues: [[envVar: 'CI_BOT_TOKEN', vaultKey: 'ci-bot']]]]) {
                        sh "docker login -u ci-bot -p ${CI_BOT_TOKEN} registry.oskk.1solution.ru"
                        def customImage = docker.build("registry.oskk.1solution.ru/docker-images/onec-base:latest")
                        customImage.push()
                    }
                }          
            }
        }
    }
}



