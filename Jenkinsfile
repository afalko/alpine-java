pipeline {
    agent any
    stages {
        stage('Build and Test') {
            steps {
                sh "docker build -t afalko/alpine-java:${BUILD_ID} ."
            }
        }
        stage('Publish') {
	    environment { 
                DOCKER_PASSWORD = credentials('DOCKER_PASSWORD') 
            }
            when {
                expression {
                    BRANCH_NAME == "master"
                }
            }
            steps {
                sh "echo ${DOCKER_PASSWORD} | docker login -u afalko --password-stdin"
                sh "docker push afalko/alpine-java:${BUILD_ID}"
                // Push to GCR for vulnerability analysis
                withCredentials([file(credentialsId: 'gcr-push', variable: 'KEYFILE')]) {
                    sh "docker login -u _json_key --password-stdin https://gcr.io < ${KEYFILE}"
                }
                sh "docker tag afalko/alpine-java:${BUILD_ID} gcr.io/eternal-autumn-215306/alpine-java:${BUILD_ID}"
                sh "docker push gcr.io/eternal-autumn-215306/alpine-java:${BUILD_ID}"
            }
        }
        stage('Update Docker Images') {
            when {
                expression {
                    BRANCH_NAME == "master"
                }
            }
	    environment {
		git_api_url = 'https://api.github.com'
		git_api_token = credentials('DOCKERFILE_IMAGE_UPDATE_TOKEN')
		image_map_store = 'docker-tag-store-df17-demo'
	    }
            steps {
                sh "docker run --rm -e git_api_token -e git_api_url \
			salesforce/dockerfile-image-update -o afalko \
			parent afalko/alpine-java ${BUILD_ID} ${image_map_store}"
            }
        }
    }
}
