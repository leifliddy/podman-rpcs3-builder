#!/bin/bash

set -e

rpcs3_dir='/root/rpcs3'
rpcs3_git_url='https://github.com/RPCS3/rpcs3'

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

cmake -S . -B build -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ 
cmake --build build -j
popd

strip /root/rpcs3/build/bin/rpcs3
rsync -vr --delete --exclude='.gitignore' $rpcs3_dir/build/bin/ /output/
