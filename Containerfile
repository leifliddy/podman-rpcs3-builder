FROM registry.fedoraproject.org/fedora:39

COPY files/bashrc /root/.bashrc
COPY files/bashrc-default /root/.bashrc.d/default

RUN dnf update -y &&\
    dnf install -y alsa-lib-devel clang cmake findutils git glew glew-devel libatomic libevdev-devel libGLEW libudev-devel llvm-devel openal-devel qt6-qtbase-devel qt6-qtbase-private-devel vulkan-devel pipewire-jack-audio-connection-kit-devel qt6-qtmultimedia-devel qt6-qtsvg-devel rsync vim-enhanced &&\
    find /root/ -type f | grep -E 'anaconda-ks.cfg|anaconda-post-nochroot.log|anaconda-post.log|original-ks.cfg' | xargs rm -f &&\
    echo 'defaultyes=True' >> /etc/dnf/dnf.conf

# set login directory
WORKDIR /root

CMD ["/bin/bash"]
