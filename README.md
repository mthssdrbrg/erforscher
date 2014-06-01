# Erforscher

Erforscher is a poor man's service discovery tool that uses the AWS EC2 APIs to
(optionally) filter instance from a configured set of `tags` and writes
hostnames (derived from a configured `name` tag) and private IP address mappings
to `/etc/hosts` (or any file of your choosing).

By default, Erforscher will look for a configuration file in the following
places (and in the given order);

* `$HOME/.erforscher.yml`
* `/etc/erforscher.yml`

As indicated below it's also possible to give the path to a configuration file
using the `-c|--config` option, and in that case the given path will be used.

Otherwise, Erforscher will use the first file that exists, and will not attempt
to merge settings if there should be files in the above mentioned places.

## Installation

```
gem install erforscher --pre
```

It will be available as `omnibus` packages and most likely a `Chef` cookbook in
the near future.

## Usage

```bash
erforscher --help
erforscher -T|--tags <K1=V1,K2=V2>
erforscher -N|--name <TAG>
erforscher -c|--config <PATH>
```

The configuration file is a simple YAML file, with the following structure:

```yaml
name_tag: 'Name'
region: 'us-east-1'
tags:
  - environment: 'test'
    service: 'web'
  - environment: 'production'
    service: 'database'
```
