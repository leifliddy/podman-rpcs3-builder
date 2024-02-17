# podman-rpcs3-build
This project builds the rpcs3 source https://github.com/rpcs3-project/rpcs3 in a **Fedora 39** podman container  
\
**ensure these packages are installed**
```
dnf install libGLEW podman python3-podman python3-termcolor qt6-qtmultimedia qt6-qtsvg   
```

**install ffmpeg from rpmfusion** (not sure if this is needed or not...yet)
```
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf swap ffmpeg-free ffmpeg --allowerasing
```

**build rpcs3**
```
git clone https://github.com/leifliddy/podman-rpcs3-build.git
cd podman-rpcs3-build  

# this will build the image and run the container  
./script-podman.py

# login to the container
podman exec -it rpcs3_builder /bin/bash

# once inside the container, run this script to build rpcs3
/root/scripts/01-build.rpcs3.sh

# use the -r option to perform a clean build (will remove existing source dir and build rpcs3 from scratch)
/root/scripts/01-build.rpcs3.sh -r

# the resulting rpcs3 binary will be copied to the /output directory which is shared with the host system

# exit container
Control+D or exit
```

**script-podman.py options**  
these should be pretty self-explanatory
```
usage: script-podman.py [-h] [--auto] [--debug]
                        [--rebuild | --rerun | --restart | --rm_image | --rm_container | --stop_container]

options:
  -h, --help        show this help message and exit
  --auto            ensure image is built, then run container_script in a non-interactive container
  --debug           display debug messages
  --rebuild         remove podman image and container if they exist, then build (new) podman image and run container
  --rerun           remove container if it exists, then (re-)run it
  --restart         stop the container if it exists, then (re-)run it
  --rm_image        remove podman image and container if they exist
  --rm_container    remove container if it exists
  --stop_container  stop podman container it exists and is running
```
