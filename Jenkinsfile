pipeline {
    agent {
            label "docker && linux"
    } 
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'
                script {              
                    withVault(configuration: [timeout: 60], vaultSecrets: [[path: 'cubbyhole/GITLAB', secretValues: [[envVar: 'thedemoncat', vaultKey: 'thedemoncat']]]]) {
                        sh "docker login -u ci-bot -p ${thedemoncat}"
                        def customImage = docker.build("demoncat/onec-base:latest")
                        customImage.push()
                    }
                }          
            }
        }
    }
}



