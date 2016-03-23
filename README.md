# Dockerfile for Android CI
My general usage (very up-to-date) Docker image for Android CI
<br>
# Common commands
Build image: `docker build -t menny/android:latest .`

Pull from Docker Hub: `docker pull menny/android:latest`

To run image: `docker run -i -t [image-id] /bin/bash` 

To stop all Docker containers: `docker stop -f $(docker ps -a -q)`

To remove all Docker containers: `docker rm -f $(docker ps -a -q)`

To remove all Docker images: `docker rmi -f $(docker images -q)`
