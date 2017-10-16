#!/bin/sh
if [ "" == "$1" ]
then
    echo "Please provide the container name to setup as the first argument."
    docker ps
fi

if [ "" == "$2" ]
then
    echo "Please provide the path to the clone folder (for example '/root/StudioProjects/AnySoftKeyboard'."
    docker ps
fi

if pgrep -x "Docker" > /dev/null
then
    echo "Docker ready."
else
    echo "Please start Docker and run this again."
    exit 1
fi

docker exec -it ${1} mkdir -p /root/.ssh
docker exec -it ${1} chmod 0700 /root/.ssh
docker cp ~/.ssh/id_rsa ${1}:/root/.ssh/
docker cp ~/.ssh/id_rsa.pub ${1}:/root/.ssh/


sdk.dir=/opt/android-sdk-linux
docker exec -it ${1} ndk.dir=/opt/android-ndk-linux >> ${2}/local.properties
docker exec -it ${1} sdk.dir=/opt/android-sdk-linux >> ${2}/local.properties