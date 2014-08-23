# Erforscher

[![Build Status](https://travis-ci.org/mthssdrbrg/erforscher.svg?branch=master)](https://travis-ci.org/mthssdrbrg/erforscher)
[![Gem Version](https://badge.fury.io/rb/erforscher.svg)](http://badge.fury.io/rb/erforscher)

Erforscher, German for "explorer", is a poor man's service discovery tool that
utilizes the AWS EC2 APIs to filter instances from a configured set of `tags`
and writes hostnames (derived from a configured `name` tag) and private IP address
mappings to `/etc/hosts` (or any file of your choosing).

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
erforscher -h|--help
erforscher -v|--version
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

## Copyright

Released under the [MIT License](http://www.opensource.org/licenses/MIT) :: 2014 Mathias Söderberg.
