# My Ansible Playbook for my Desktops

## Overview

This is just an [Anisble playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html) which I use to setup everything from my Linux Desktop to my macOS. I found an easy way to make sure my desktop has all my dot files and programmes I need + correctly configured. The 

## Roles

### WSL

Make target is `make desktop-wls`.


## How to test a role

The easiest way to test a target is as follows:

  1. [Install Docker](https://docs.docker.com/install/).
  2. `cd` into this directory.
  3. Run `docker pull geerlingguy/docker-ubuntu2204-ansible:latest`
  4. Run ```
  docker run \
  --rm \
  --interactive \
  --tty \
  --privileged \
  --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
  --volume=${HOME}/.ansible_pass:/root/.ansible_pass:ro \
  --volume=`pwd`:/etc/ansible/roles/role_under_test:ro \
  --cgroupns=host \
  --workdir=/etc/ansible/roles/role_under_test \
  geerlingguy/docker-ubuntu2204-ansible:latest /bin/bash```

