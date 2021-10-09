# AppleReserver

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg)
![Platform info](https://img.shields.io/badge/platform-macOS-lightgrey.svg)

Apple官方预约监控助手

## Overview

```bash
OVERVIEW: Apple 官方预约监控助手

USAGE: applereserver <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  stores                  List all available stores.
  availabilities          List all availabilities for the specific store.
  monitor                 Monitor the availabilities for the specific stores and parts.

  See 'applereserver help <subcommand>' for detailed help
```

## Requirements

- macOS >= 10.11
- Swift 5 Runtime Support

## Install

```bash
$ brew install sunnyyoung/repo/applereserver
```

## Usage

### Stores

```bash
$ applereserver stores

🟢	R320	北京	三里屯
🟢	R359	上海	南京东路
🟢	R388	北京	西单大悦城
...
```

### Availabilities

```bash
$ applereserver availabilities R320 --region CN

🔴	MLH43CH/A
🔴	MLH53CH/A
🔴	MLH63CH/A
...
```

### Monitor

```bash
$ applereserver monitor --interval 1 --store-numbers R320 --part-numbers MLTE3CH/A

Checked for x times.
...
```

## License

The [MIT License](LICENSE).
