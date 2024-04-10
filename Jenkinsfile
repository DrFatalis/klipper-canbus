node {
    def app

    stage("Clone repo"){

        checkout scm
    }

    stage("Build image"){

        app = docker.build("drfatalis/klipper-canbus")
    }

    stage("Test image"){

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage ("Push image to docker.io") {

        docker.withRegistry("https://registry.hub.docker.com", 'docker-hub-credentials'){
            app.push("${end.BUILD_NUMBER}")
            app.push("latest");
        }
    }
}