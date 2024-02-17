#!/bin/bash

set -e

rpcs3_dir='/root/rpcs3'
rpcs3_git_url='https://github.com/RPCS3/rpcs3'
arch=$(arch)

while getopts :r arg
do
    case "${arg}" in
        r) rebuild=true ;;
    esac
done

[[ $rebuild = true ]] && [[ -d $rpcs3_dir ]] && rm -rf $rpcs3_dir
[[ ! -d $rpcs3_dir ]] && mkdir $rpcs3_dir && rebuild=true

[[ $rebuild = true ]] && git clone --recursive $rpcs3_git_url $rpcs3_dir

# remove build directory
[[ -d $rpcs3_dir/build ]] && rm -rf $rpcs3_dir/build

# build rpcs3
pushd $rpcs3_dir

if [ $arch == 'aarch64' ]; then
echo -e "Compiling for $arch\n"
cmake -S . -B build -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DBUILD_LLVM=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_NATIVE_INSTRUCTIONS=OFF \
    -DUSE_PRECOMPILED_HEADERS=OFF \
    -DUSE_SDL=ON \
    -DUSE_SYSTEM_CURL=ON \
    -DUSE_SYSTEM_FFMPEG=ON \
    -DUSE_SYSTEM_LIBPNG=ON \
    -DUSE_SYSTEM_SDL=ON \
    -DUSE_SYSTEM_ZLIB=ON
elif [ $arch == 'x86_64' ]; then
echo -e "Compiling for $arch\n"
cmake -S . -B build -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DBUILD_LLVM=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_PRECOMPILED_HEADERS=OFF \
    -DUSE_SDL=ON \
    -DUSE_SYSTEM_CURL=ON \
    -DUSE_SYSTEM_LIBPNG=ON \
    -DUSE_SYSTEM_SDL=ON \
    -DUSE_SYSTEM_ZLIB=ON
else
    echo "Architecture $arch is not supported....exiting"
    exit
fi

cmake --build build -j
popd

strip /root/rpcs3/build/bin/rpcs3
rsync -vr --delete --exclude='.gitignore' $rpcs3_dir/build/bin/ /output/
echo -e "\nthe contents of /output are:\n$(ls -l --color /output)"
