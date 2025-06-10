# Homelab-Modules

This repository contains a highly opinionated collection of OpenTofu modules for managing my homelab infrastructure.  They are developed for, and against, my specific configuration of hardware.  As they mature I will attempt to make them more generic and generally useful.

## Usage

Operation of this repository assumes MacOS driven by [`brew`](https://brew.sh/) and [`task`](https://taskfile.dev/).

### Installing Dependencies

```sh
brew bundle
```

### Operating

```sh
task
```

## Workflow

![Workflow](https://github.com/ionfury/homelab-modules/blob/main/docs/images/workflow.png)

## License

This project is licensed under the Unlicense. See the [LICENSE](LICENSE) file for details.
