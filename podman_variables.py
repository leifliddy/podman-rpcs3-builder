#!/usr/bin/python3

import os

def create_mounts_dict(host_mount, container_mount, read_only=False, selinux_label=True, selinux_recursive=True):
# if selinux_label=True the container_file_t label will be applied to the source host directory
# it can be set to False if the directory exists on an nfs mount and has the nfs_t label set
# if selinux_recursive=True (and selinux_label=True) the container_file_t label will be recursively applied to the source host directory

    mounts = {
               'type':              'bind',
               'source':            host_mount,
               'target':            container_mount,
               'read_only':         read_only,
               'selinux_label':     selinux_label,
               'selinux_recursive': selinux_recursive
             }

    return mounts


cur_dir                 = os.path.dirname(os.path.realpath(__file__))
bind_volumes            = []

image_name              = 'rpcs3_build_env'
container_name          = 'rpcs3_builder'
container_hostname      = 'rpcs3_builder'
container_script        = '/root/scripts/01-build.rpcs3.sh'

scripts_dir_host        = f'{cur_dir}/build.scripts'
scripts_dir_container   = '/root/scripts'
output_dir_host         = f'{cur_dir}/output'
output_dir_container    = '/output'

bind_volumes.append(create_mounts_dict(scripts_dir_host, scripts_dir_container))
bind_volumes.append(create_mounts_dict(output_dir_host, output_dir_container))

# set privileged mode
privileged = False
