#!/bin/sh
if pgrep -x "Docker" > /dev/null
then
    echo "Docker ready."
else
    echo "Please start Docker and run this again."
    exit 1
fi

if [ "Darwin" == "`uname`" ]
then
    if pgrep -x "Xquartz" > /dev/null
    then
        echo "Quartz ready."
    else
        echo "Starting Quartz..."
        if [ open -a XQuartz ]
        then
            echo "Done."
            sleep 3
        else
             echo "Failed to start XQuartz. Install via 'brew cask install xquartz'"
             exit 1
        fi
    fi
else
    echo "At this moment, this script only supports macOS."
    exit 1
fi

export ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
Echo 
/opt/X11/bin/xhost + $ip
sleep 1

BASE_RUN_COMMAND="docker run -d --privileged --network=host -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix"

case $1 in
    -n|--new)
    ${BASE_RUN_COMMAND} menny/android_studio:1.8.1
    exit 0
    ;;
    -w|--warm)
    if [ "" == "$2" ]; then
        echo "Please provide an image to run. Pick one:"
        docker images
        exit 1
    else
        ${BASE_RUN_COMMAND} $2
        exit 0
    fi
    ;;
    -s|--start)
    if [ "" == "$2" ]; then
        echo "Please provide a container to start. Pick one:"
        docker ps --all
        exit 1
    else
        docker start $2
        exit 0
    fi
    ;;
    *)    # unknown option
    echo ""
    echo "You have not provided an action."
    echo ""
    echo "Create a new container based on 'menny/android_studio:1.8.1' image:"
    echo "     $0 -n"
    echo "Create a new container based on [image name]:"
    echo "     $0 -w [image name]"
    echo "Start a previously used container:"
    echo "     $0 -s [container name]"
    exit 1
    ;;
esac
done
