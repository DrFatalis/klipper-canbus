/* Declarative Pipeline */
pipeline {
   agent any

   options {
      buildDiscarder(logRotator(numToKeepStr: '30'))
      timestamps()
   }

   parameters {
      string(
         name: "Branch_Name", 
         defaultValue: 'main', 
         description: '')
         string(
            name: "Image_Name", 
            defaultValue: 'klipper-canbus', 
            description: '')
         string(
            name: "Image_Tag", 
            defaultValue: 'latest', 
            description: 'Image tag')
        booleanParam(
           name: "PushImage", 
           defaultValue: true)
    }

   environment {
        DOCKERHUB_CREDENTIALS=credentials('DockerHubCredentials')
   }

   // Stage Block
   stages {
      stage("Build docker image") {
         steps {
            script {
               echo "Bulding docker image"
               def buildArgs = "--no-cache . -f Dockerfile"
               docker.build(
                     "${params.Image_Name}:${params.Image_Tag}",
                     buildArgs)
            }
         }
      }

      stage("Push to Dockerhub") {
         when { 
            expression { 
               params.PushImage }
         }
         steps {
            script {
               echo "Pushing the image to docker hub"
               def localImage = "${params.Image_Name}:${params.Image_Tag}"
            
               def repositoryName = "drfatalis/${localImage}"
            
               // Create a tag that going to push into DockerHub
               sh "docker tag ${localImage} ${repositoryName} "
               sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
               def image = docker.image("${repositoryName}");
               image.push()
               /*docker.withRegistry("https://registry.hub.docker.com", "DockerHubCredentials") {
                  def image = docker.image("${repositoryName}");
                  image.push()
               }*/
            }
         }
      }

      stage("Cleaning unused image") {
         steps {
            script {
               echo "Pruning unused images"
               sh "docker image prune -af"
            }
         }
      }
   }
}