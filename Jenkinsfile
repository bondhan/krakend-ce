def getEnvFromBranchName(branchName) {
    if (branchName == 'master' || branchName == "main") {
        return 'production'
    } else if(branchName == 'develop') {
        return 'develop'
    } else {
        return 'develop'
    }
}

def getImgTagFromBranchName(branchName) {
    if (branchName == 'master' || branchName == "main") {
        return 'latest'
    } else if(branchName == 'develop') {
        return 'develop'
    } else {
        return 'develop'
    }
}

pipeline {
  options {
    disableConcurrentBuilds()
    timestamps()
  }
  agent {
    kubernetes {
      yamlFile 'jenkins-pod.yml'
    }
  }
  parameters {
    choice(
      name: 'CI_GIT_TYPE',
      choices: ['', 'branch', 'commit', 'tag'],
      description: 'Which Source?'
    )
    string(
      name: 'CI_GIT_SOURCE',
      defaultValue: '',
      description: 'Input value?'
    )
  }
  environment {
    KRAKEND_REPO = 'krakend-ce'
    DOCKER_CREDENTIALS = credentials('docker_registry_login')
    SINBAD_ENV = "${env.BRANCH_NAME}"
    UTILS_BRANCH = getEnvFromBranchName("${env.BRANCH_NAME}")
    IMAGE_TAG = getImgTagFromBranchName("${env.BRANCH_NAME}")
  }
  stages {
    stage('Checkout') {
        steps {
            script {
                if(params.CI_GIT_TYPE != '' || params.CI_GIT_SOURCE != '') {
                    if(params.CI_GIT_TYPE == 'branch' || params.CI_GIT_TYPE == ''){
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "refs/remotes/origin/${params.CI_GIT_SOURCE}"]],
                            doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                            extensions: scm.extensions,
                            userRemoteConfigs: scm.userRemoteConfigs
                        ])
                        env.GIT_MESSAGE = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        env.GIT_AUTHOR = sh(returnStdout: true, script: "git --no-pager show -s --format='%an' ${env.GIT_COMMIT}").trim()
                        env.GIT_TIME = sh(returnStdout: true, script: "git show -s --format=%cD ${env.GIT_COMMIT}").trim()
                    } else if(params.CI_GIT_TYPE == 'commit') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "${params.CI_GIT_SOURCE}"]],
                            doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                            extensions: scm.extensions,
                            userRemoteConfigs: scm.userRemoteConfigs
                        ])
                        env.GIT_MESSAGE = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.GIT_COMMIT = "${params.CI_GIT_SOURCE}"
                        env.GIT_AUTHOR = sh(returnStdout: true, script: "git --no-pager show -s --format='%an' ${params.CI_GIT_SOURCE}").trim()
                        env.GIT_TIME = sh(returnStdout: true, script: "git show -s --format=%cD ${params.CI_GIT_SOURCE}").trim()
                    } else if(params.CI_GIT_TYPE == 'tag') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "refs/tags/${params.CI_GIT_SOURCE}"]],
                            doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                            extensions: scm.extensions,
                            userRemoteConfigs: scm.userRemoteConfigs
                        ])
                        env.GIT_MESSAGE = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        env.GIT_AUTHOR = sh(returnStdout: true, script: "git --no-pager show -s --format='%an' ${env.GIT_COMMIT}").trim()
                        env.GIT_TIME = sh(returnStdout: true, script: "git show -s --format=%cD ${env.GIT_COMMIT}").trim()
                    }
                } else {
                        env.GIT_MESSAGE = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        env.GIT_AUTHOR = sh(returnStdout: true, script: "git --no-pager show -s --format='%an' ${env.GIT_COMMIT}").trim()
                        env.GIT_TIME = sh(returnStdout: true, script: "git show -s --format=%cD ${env.GIT_COMMIT}").trim()
                }

                sh "echo GIT_MESSAGE=${env.GIT_MESSAGE}"
                sh "echo GIT_COMMIT=${env.GIT_COMMIT}"
                sh "echo GIT_AUTHOR=${env.GIT_AUTHOR}"
                sh "echo GIT_TIME=${env.GIT_TIME}"
            }
        }
    }
    stage('Docker login') {
        steps {
            container('docker') {
                script {
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin dcr.bondhan.local"
                }
            }
        }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'apk add make'
          sh 'make docker'
        }
      }
    }
    stage('Tag, push image for develop branch') {
      when {
        branch 'develop'
      }
      steps {
        container('docker') {
          sh "docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:{$IMAGE_TAG}"
          sh "docker push dcr.bondhan.local/krakend:develop"
        }
      }
    }
    stage('Tag, push image for master branch') {
      when {
        branch 'master'
      }
      steps {
        container('docker') {
          sh "docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:{$IMAGE_TAG}"
          sh "docker push dcr.bondhan.local/krakend:develop"
        }
      }
    }
  }
}
