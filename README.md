# docker

[![Build Status](https://travis-ci.org/pari-/ansible-docker.svg?branch=master)](https://travis-ci.org/pari-/ansible-docker)

An Ansible role which installs and configures Docker

<!-- toc -->

- [Requirements](#requirements)
- [Example](#example)
- [Role Variables](#role-variables)
- [Dependencies](#dependencies)
- [License](#license)
- [Author Information](#author-information)

<!-- tocstop -->

## Requirements

Currently this role is developed for and tested on Debian GNU/Linux (release: jessie). It is assumed to work on other Debian distributions as well.

Ansible version compatibility:

- __2.3.1.0__ (current version in use for development of this role) 
- 2.2.3.0
- 2.1.6.0
- 2.0.2.0

## Example

```yaml
---

- hosts: "{{ hosts_group | default('all') }}"

  vars:

  roles:
    - { role: "{{ role_name | default('ansible-docker') }}", tags: ['docker'] }
```

The following shows a minimal example regarding the usage of `docker_daemon_config_opts`:

```yaml
---

- hosts: "{{ hosts_group | default('all') }}"

  vars:
    docker_daemon_config_opts:
      bip: "10.128.42.5/24"
      fixed-cidr: "10.128.42.0/24"
      mtu: 1500
      default-gateway: "10.128.42.5"
      dns: ["8.8.4.4"]

  roles:
    - { role: "{{ role_name | default('ansible-docker') }}", tags: ['docker'] }
```

## Role Variables

Available variables are listed below, along with default values (see defaults/main.yml). They're generally prefixed with `docker_` (which I deliberately leave out here for better formatting).

variable | default | notes
-------- | ------- | -----
`cache_valid_time` | `3600` | `Update the apt cache if its older than the set value (in seconds)`
`config_file` | `/etc/docker/daemon.json` | `Absolute path to docker's configuration file`
`daemon_config_opts` | `{}` | `Configuration hash that accepts docker daemon configuration optons`
`default_release` | `{{ ansible_distribution_release }}` | `The default release to install packages from.` 
`package_list` | `['docker-ce']` | `The list of packages to be installed`
`repo_list[0]['repo']` | `deb [arch=amd64] https://download.docker.com/linux/{{ ansible_distribution|lower }} {{ ansible_distribution_release }} stable` | `Source string for the repositories`
`repo_list[0]['repo']['key']['id']` | `0EBFCD88` | `Identifier of (the repository) key`
`repo_list[0]['repo']['key']['keyserver']` | `keyserver.ubuntu.com` | `Keyserver to retrieve the key (for the repository) from` |
`service_name` | `docker` | `Name of the service`
`supported_distro_list` | `['jessie', 'trusty']` | `A list of distribution releases this role supports`
`update_cache` | `yes` | `Run the equivalent of apt-get update before the operation`

## Dependencies

None

## License

MIT

## Author Information

* Patrick Ringl
