pipeline {
    agent any 1

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
           defaultValue: false)
    }

   // Stage Block
   stages {// stage blocks
      stage("Build docker image") {
         steps {
            script {
               echo "Bulding docker image"
               def buildArgs = """\
-f Dockerfile \
."""
                docker.build(
                   "${params.Image_Name}:${params.Image_Tag}",
                   buildArgs)
            }
         }
      }
   }

   stage("Push to Dockerhub") {
      when { 
         expression { 
            params.PushImage == 'true' }
      }
     steps {
       script {
         echo "Pushing the image to docker hub"
         def localImage = "${params.Image_Name}:${params.Image_Tag}"
      
         // pcheajra is my username in the DockerHub
         // You can use your username
         def repositoryName = "drfatalis/${localImage}"
      
         // Create a tag that going to push into DockerHub
         sh "docker tag ${localImage} ${repositoryName} "
         docker.withRegistry("", "DockerHubCredentials") {
           def image = docker.image("${repositoryName}");
           image.push()
         }
       }
    }
   }
}