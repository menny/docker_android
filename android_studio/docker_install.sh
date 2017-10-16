#!/bin/sh
if [ "" == "$1" ]
then
    echo "Please provide the container name to setup as the first argument."
    docker ps
    exit 1
fi

if [ "" == "$2" ]
then
    echo "Please provide the path to the clone folder (for example '/root/StudioProjects/AnySoftKeyboard'."
    exit 1
fi

if pgrep -x "Docker" > /dev/null
then
    echo "Docker ready."
else
    echo "Please start Docker and run this again."
    exit 1
fi

docker exec -it ${1} bash -c "cd ${2} && ./gradlew :app:assembleDebug"
docker cp ${1}:${2}/app/build/outputs/apk/debug/app-debug.apk ${TMPDIR}/app-debug.apk
adb install -r ${TMPDIR}/app-debug.apk
