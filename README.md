# AOSP build environment in Docker
A easy to use AOSP build environment provided as a Docker image.

**This is forked from [Trumeet/AOSP-Build-Environment-Docker](https://github.com/Trumeet/AOSP-Build-Environment-Docker) and somewhat "streamlined" with a
focus on building [GrapheneOS](https://grapheneos.org/).**

# Usage

## Notes

The `docker-compose.yml` and thus `docker-compose` is used to simplify handling mounts and environment variables.

You can customize some options in the `docker-compose.yml` to your liking:

The mounted volumes are used to provide outside access to your build dir (the `/aosp`-mount), as well as separate `TMP`- and `CCACHE`-directories.
Those might come in handy if your `/tmp` runs out of space at some point, or if you want to use `ccache` to save some time on subsequent builds.

The environment variables can be used to enable or disable usage of `ccache` and the `$TMPDIR`, as well as to provide custom args to `jack`.

## Building the image

```shell
sudo docker-compose build
```

## Running the image

`$UID` and `$GID` are used to keep permissions in line with your current user (and to avoid running everything as `root`, even inside a somewhat contained environment.)

```shell
UID=${UID} GID=${GID} sudo --preserve-env=UID,GID docker-compose run --rm aosp /bin/bash
```

# Known issues

Currently, the container has to be run with `--privileged` (or rather `privileged: true` in the `docker-compose.yml`), as otherwise `nsjail` will complain.

See:

* https://www.google.com/url?q=https://github.com/google/nsjail%23launching-in-docker
* https://issuetracker.google.com/issues/123210688

It might be possible to work around this with appropriate `seccomp` options.

# License
GPL v3, feel free to contribute it.
