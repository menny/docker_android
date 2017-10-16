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
/opt/X11/bin/xhost + $ip

if [ "new" == "$1" ]; then
    shift # past action
    
    BASE_RUN_COMMAND="docker run -d --privileged --network=host -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix "
    IMAGE_NAME="menny/android_studio:1.8.2-3.0.0-RC1"
    ADDITIONAL_ARGS=""
    
    while [[ $# -gt 0 ]]
    do
    key="$1"
    case $key in
        -i|--image)
        IMAGE_NAME="$2"
        shift # past argument
        shift # past value
        if [ "" == "$IMAGE_NAME" ]; then
            echo "Please provide an image name to start, or omit the -i argument to use the default."
            exit 1
        fi
        ;;
        -a|--docker_args)
        ADDITIONAL_ARGS="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        echo "Uknown option '$key' for action 'new'. Valid options:"
        echo "-i|--image [image name]"
        echo "-a|--docker_args [additional docker args]"
        exit 1
        ;;
    esac
    done
    ${BASE_RUN_COMMAND} ${ADDITIONAL_ARGS} ${IMAGE_NAME} /opt/android-studio/bin/studio.sh
    exit 0
elif [ "start" == "$1" ]; then
    if [ "" == "$2" ]; then
        echo "Please provide a container to start. Pick one:"
        docker ps --all
        exit 1
    else
        docker start $2
        docker exec -e DISPLAY=$ip:0 $2 /opt/android-studio/bin/studio.sh
        exit 0
    fi
else
    echo "Unknown action, or none provided. Possible:"
    echo "docker_as.sh new -i|--image [image name] -a|--docker_args [additional docker args]"
    echo "docker_as.sh start [container name]"
    exit 1
fi
