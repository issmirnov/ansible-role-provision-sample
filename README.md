# Ansible Provision role

Note: This is a sanitized snapshot of my internal repo, so will be updated less frequently than my private version.

## Overview

This playbook is enough to completely provision a brand new linux or MacOS machine to look exactly like the rest of my fleet.
Paired with the `issmirnov.dotfiles` role the only indication that this is a new machine is a different hostname.

Summary of changes:

- Linux
  - Installs a ton of useful CLI tools, tweaks bootup speed
- MacOS
  - Installs common utils
  - Logs in to mac app store, installs apps
  - Deploys homebrew, installs apps
  - Tweaks system settings via osx.sh for sane dev defaults
  - Uploads preferences for apps.
  - Moves Dock to the left, deletes all bloatware apps, pins chrome and terminal

## Usage

```
- name: install python on instance (only for ubuntu)
  hosts: device
  remote_user: root
  gather_facts: no
  pre_tasks:
    - name: 'install python2'
      raw: sudo apt-get -y install python-simplejson

- name: Provision device
  hosts: device
  vars:
    hostname: device

  roles:
    - ansible-role-provision
    - issmirnov.dotfiles
```

## Testing

- `ansible-role-tester full -t ubuntu1804 --extra-roles /usr/local/etc/ansible/roles`
