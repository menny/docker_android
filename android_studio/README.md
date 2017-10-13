# Dockerfile for Android development with NDK and Android Studio
Docker image for desktop development based on menny/android_ndk image and has Android Studio.


## Contains:

* All the good staff from the [General Android image](https://github.com/menny/docker_android/blob/master/README.md)
* All the good staff from the [NDK Android image](https://github.com/menny/docker_android/blob/master/android_ndk/README.md)
* Android Studio 3.0.0 beta 7

## Accepting licenses
[Read](https://github.com/menny/docker_android/blob/master/README.md#accepting-licenses) about this at the general Android Docker image.

## Common Docker commands
Build image: `docker build -t menny/android_studio:latest .`

Pull from Docker Hub: `docker pull menny/android_studio:latest`

## How To Use
To work with the Android Studio inside this Docker image, you'll need to run it and direct its X11 connection to the local (host) machine X-Server.

_Note:_ The following instructions come from [here](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/) and [here](https://hub.docker.com/r/dlsniper/docker-intellij/).

I assume you have an X-Server, and it accepts network connections. 

### Running on Mac
If you have a Mac, you will need to install `xquartz`. Run:
```
brew cask install xquartz
```
Start `xquartz`:
```
open -a XQuartz
```
And allow network connections in the _Preferences_ window. More details [here](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/).
Add your machine's local IP to `xhost`:
```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
/opt/X11/bin/xhost + $ip
```
And run Android Studio:
```
docker run -d -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix menny/android_studio:1.8.0
```

### Running on Linux -- did not verify
Probably just:
```
docker run -d -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix menny/android_studio:1.8.0
```

### Running on Windows
No idea.

## Pro Tip
The process above will give you a blank installation of Android Studio. It's a nice PoC, but the downside is that every time you start the Docker image, you start in the same blank state.<br/>
My workflow is as follow:

1. Start the Docker image
2. Installation wizard will come up, follow all steps. Let it download what it needs.
3. Checkout your repo using the _Import from source control_ option.
4. Once your repo is loaded, setup Android Studio with everything you need (plugins, settings, code style, etc).
5. You might also want to download the sources for the Android SDK. Maybe compile the app once to make sure everything is fine.
6. Quit Android Studio.
7. In the host machine's terminal run `docker ps --all`. You'll see the Android Studio container (probably the top-most) in exited status. Copy it's name (last column). For example:

```
➜ docker ps --all
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS                         PORTS               NAMES
daffb7bbee3f        menny/android_studio:1.8.0   "/opt/android-stud..."   21 minutes ago      Exited (0) 11 seconds ago                          hardcore_meninsky
```

 8. Commit that container into a new tag (let's say _warm_android_studio_): `docker commit hardcore_meninsky warm_android_studio`. This might take a while.
 9. You're done! Next time, you can run your warm image: `docker run -d -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix warm_android_studio`