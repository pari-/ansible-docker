# docker

[![Build Status](https://travis-ci.org/pari-/ansible-docker.svg?branch=master)](https://travis-ci.org/pari-/ansible-docker)

An Ansible role which installs and configures Docker

<!-- toc -->

- [Requirements](#requirements)
- [Example](#example)
- [Configuration overrides](#configuration-overrides)
  * [add 'live-restore' option](#add-live-restore-option)
  * [override the DNS server(s) to use](#override-the-dns-servers-to-use)
  * [unset a configured option](#unset-a-configured-option)
- [Defaults](#defaults)
- [Dependencies](#dependencies)
- [License](#license)
- [Author Information](#author-information)

<!-- tocstop -->

## Requirements

Currently this role is developed for and tested on Debian GNU/Linux (release: stretch). It is assumed to work on other Debian distributions as well.

Ansible version compatibility: [Dockerfile](https://github.com/pari-/docker-debian-ansible/blob/master/debian/stretch/Dockerfile)

## Example

```yaml
---

- hosts: "all"
  roles:
    - role: "ansible-docker"
      tags:
        - "docker"
  post_tasks:
    - block:
      - include: "tests/test_docker_setup.yml"
      - block:
          - include: "tests/test_docker_tcp_listen.yml"
          - include: "tests/test_docker_http_version.yml"
        when:
          - "docker_daemon_opts | regex_search('tcp://(.*):([0-9]+)')"
      tags:
        - "tests"
```

## Configuration overrides

You can set additional as well as unset already configured options: 

### add 'live-restore' option

```yaml
  docker_daemon_cfg_overrides:
    live-restore: True
```

### override the DNS server(s) to use

```yaml
  docker_daemon_cfg_overrides:
    dns:
      - "8.8.8.8"
```

### unset a configured option

```yaml
  docker_daemon_cfg_overrides:
    mtu: ""
```

## Defaults

Available variables are listed below, along with default values (see defaults/main.yml). They're generally prefixed with `docker_` (which I deliberately leave out here for better formatting).

variable | default | notes
-------- | ------- | -----
`allow_outside_world_communication` | `1` | `Allow communicating to the outside world`
`cache_valid_time` | `3600` | `Update the apt cache if its older than the set value (in seconds)`
`config_file` | `/etc/docker/daemon.json` | `Absolute path to docker's configuration file`
`daemon_cfg_defaults` | `{}` | `Docker daemon configuration options (role defaults)`
`daemon_cfg_overrides` | `{}` | `Docker daemon configuration options (overrides)`
`daemon_cfg` | `{{ docker_daemon_cfg_defaults\|combine(docker_daemon_cfg_overrides) }}` | `Configuration hash containing docker daemon configuration options`
`daemon_opts` | `-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375` | `Daemon opts that can't be overriden via daemon.json`
`default_release` | `{{ ansible_distribution_release\|lower }}` | `The default release to install packages from`
`pre_default_release` | `{{ docker_default_release }}` | `The default release to install packages (pre_package_list) from`
`pre_package_list` | `['apt-transport-https','ca-certificates']` | `The list of prerequisite packages to be installed`
`package_list` | `['docker-ce']` | `The list of packages to be installed`
`repo_list[0]['repo']` | `deb [arch=amd64] https://download.docker.com/linux/{{ ansible_distribution\|lower }} {{ ansible_distribution_release }} stable` | `Source string for the repositories`
`repo_list[0]['repo']['key']['id']` | `0EBFCD88` | `Identifier of (the repository) key`
`repo_list[0]['repo']['key']['keyserver']` | `keyserver.ubuntu.com` | `Keyserver to retrieve the key (for the repository) from`
`service_limitnofile` | `1048576` | `Docker daemons nofile limit`
`service_name` | `docker` | `Name of the service`
`supported_distro_list` | `['jessie', 'stretch']` | `A list of distribution releases this role supports`
`test_container_name` | `{{ ansible_date_time['epoch'] }}` | `The name of the container that is used in tests/`
`update_cache` | `yes` | `Run the equivalent of apt-get update before the operation`

## Dependencies

None

## License

MIT

## Author Information

* Patrick Ringl
