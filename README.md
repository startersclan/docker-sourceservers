# docker-sourceservers

**Source** / **Goldsource** dedicated server images built through use of [`steamcmd`](https://github.com/startersclan/docker-steamcmd).

| `master` | `build` | `update` |
|:-:|:-:|:-:|
[![pipeline-github-master-badge][]][pipeline-github-master-link] | [![pipeline-travis-build-badge][]][pipeline-travis-build-link] [![pipeline-azurepipelines-build-badge][]][pipeline-azurepipelines-build-link] [![pipeline-circleci-build-badge][]][pipeline-circleci-build-link] [![pipeline-gitlab-build-badge][]][pipeline-gitlab-build-link] | [![pipeline-travis-update-badge][]][pipeline-travis-update-link] [![pipeline-azurepipelines-update-badge][]][pipeline-azurepipelines-update-link] [![pipeline-circleci-update-badge][]][pipeline-circleci-update-link] [![pipeline-gitlab-update-badge][]][pipeline-gitlab-update-link]

[pipeline-travis-build-badge]: https://img.shields.io/travis/com/startersclan/docker-sourceservers/build.svg?label=&logo=travis&style=flat-square
[pipeline-travis-build-link]: https://app.travis-ci.com/startersclan/docker-sourceservers/builds
[pipeline-travis-update-badge]: https://img.shields.io/travis/com/startersclan/docker-sourceservers/update.svg?label=&logo=travis&style=flat-square
[pipeline-travis-update-link]: https://app.travis-ci.com/startersclan/docker-sourceservers/builds

[pipeline-azurepipelines-build-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/2/build.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-build-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=2
[pipeline-azurepipelines-update-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/3/update.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-update-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=3

[pipeline-circleci-build-badge]: https://img.shields.io/circleci/build/gh/startersclan/docker-sourceservers/build.svg?label=&logo=circleci&style=flat-square
[pipeline-circleci-build-link]: https://app.circleci.com/pipelines/github/startersclan/docker-sourceservers?branch=build
[pipeline-circleci-update-badge]: https://img.shields.io/circleci/build/gh/startersclan/docker-sourceservers/update.svg?label=&logo=circleci&style=flat-square
[pipeline-circleci-update-link]: https://app.circleci.com/pipelines/github/startersclan/docker-sourceservers?branch=update

[pipeline-gitlab-build-badge]: https://img.shields.io/gitlab/pipeline-status/startersclan/docker-sourceservers?branch=build&label=&logo=gitlab&style=flat-square
[pipeline-gitlab-build-link]: https://gitlab.com/startersclan/docker-sourceservers/-/pipelines?page=1&scope=all&ref=build
[pipeline-gitlab-update-badge]: https://img.shields.io/gitlab/pipeline-status/startersclan/docker-sourceservers?branch=update&label=&logo=gitlab&style=flat-square
[pipeline-gitlab-update-link]: https://gitlab.com/startersclan/docker-sourceservers/-/pipelines?page=1&scope=all&ref=update

[pipeline-github-master-badge]: https://img.shields.io/github/workflow/status/startersclan/docker-sourceservers/ci-master-pr/master?&label=&logo=github&style=flat-square
[pipeline-github-master-link]: https://github.com/startersclan/docker-sourceservers/actions?query=branch%3Amaster

## Supported Tags

* `latest` [(*/build/Dockerfile*)][dockerfile-build-link], [(*/update/Dockerfile*)][dockerfile-update-link]
* `<version>` [(*/build/Dockerfile*)][dockerfile-build-link]
* `<version>-layered` [(*/update/Dockerfile*)][dockerfile-update-link]

[dockerfile-build-link]: https://github.com/startersclan/docker-sourceservers/blob/master/build/Dockerfile
[dockerfile-update-link]: https://github.com/startersclan/docker-sourceservers/blob/master/update/Dockerfile

## Game Images

Dedicated servers hosted on Steam are usually required to be running the *latest version* of the game in order for clients to connect to them. Simply use the `latest` tag for the latest version of a game.

[![srcds-dockerhub-badge][]][srcds-dockerhub-link] [![hlds-dockerhub-badge][]][hlds-dockerhub-link]

[srcds-dockerhub-badge]: https://img.shields.io/badge/docker-sourceservers-blue.svg?logo=docker&logoColor=FFFFFF&color=F79A10&label=&labelColor=&style=popout-square
[srcds-dockerhub-link]: https://hub.docker.com/u/sourceservers
[hlds-dockerhub-badge]: https://img.shields.io/badge/docker-goldsourceservers-blue.svg?logo=docker&logoColor=FFFFFF&color=FF6917&label=&labelColor=&style=popout-square
[hlds-dockerhub-link]: https://hub.docker.com/u/goldsourceservers

### Source Engine (SRCDS)

| Game | Image | Tag `v<tag>` | Size |
|:-:|:-:|:-:|:-:|
| Counter-Strike: Global Offensive | [`sourceservers/csgo`][srcds-csgo-dockerhub-link] | [![srcds-csgo-version-badge][]][srcds-csgo-metadata-link] | [![srcds-csgo-size-badge][]][srcds-csgo-metadata-link] | [![srcds-csgo-layers-badge][]][srcds-csgo-metadata-link] |
| Counter-Strike: Source | [`sourceservers/cstrike`][srcds-cstrike-dockerhub-link] | [![srcds-cstrike-version-badge][]][srcds-cstrike-metadata-link] | [![srcds-cstrike-size-badge][]][srcds-cstrike-metadata-link] | [![srcds-cstrike-layers-badge][]][srcds-cstrike-metadata-link] |
| Day of Defeat: Source | [`sourceservers/dod`][srcds-dod-dockerhub-link] | [![srcds-dod-version-badge][]][srcds-dod-metadata-link] | [![srcds-dod-size-badge][]][srcds-dod-metadata-link] | [![srcds-dod-layers-badge][]][srcds-dod-metadata-link] |
| Half-Life 2: Deathmatch | [`sourceservers/hl2mp`][srcds-hl2mp-dockerhub-link] | [![srcds-hl2mp-version-badge][]][srcds-hl2mp-metadata-link] | [![srcds-hl2mp-size-badge][]][srcds-hl2mp-metadata-link] | [![srcds-hl2mp-layers-badge][]][srcds-hl2mp-metadata-link] |
| Left 4 Dead | [`sourceservers/left4dead`][srcds-left4dead-dockerhub-link] | [![srcds-left4dead-version-badge][]][srcds-left4dead-metadata-link] | [![srcds-left4dead-size-badge][]][srcds-left4dead-metadata-link] | [![srcds-left4dead-layers-badge][]][srcds-left4dead-metadata-link] |
| Left 4 Dead 2 | [`sourceservers/left4dead2`][srcds-left4dead2-dockerhub-link] | [![srcds-left4dead2-version-badge][]][srcds-left4dead2-metadata-link] | [![srcds-left4dead2-size-badge][]][srcds-left4dead2-metadata-link] | [![srcds-left4dead2-layers-badge][]][srcds-left4dead2-metadata-link] |
| Team Fortress 2 | [`sourceservers/tf`][srcds-tf-dockerhub-link] | [![srcds-tf-version-badge][]][srcds-tf-metadata-link] | [![srcds-tf-size-badge][]][srcds-tf-metadata-link] | [![srcds-tf-layers-badge][]][srcds-tf-metadata-link] |

[srcds-csgo-dockerhub-link]: https://hub.docker.com/r/sourceservers/csgo
[srcds-csgo-version-badge]: https://img.shields.io/docker/v/sourceservers/csgo/latest?label=&style=flat-square
[srcds-csgo-size-badge]: https://img.shields.io/docker/image-size/sourceservers/csgo/latest?label=&style=flat-square
[srcds-csgo-metadata-link]: https://hub.docker.com/r/sourceservers/csgo/tags

[srcds-cstrike-dockerhub-link]: https://hub.docker.com/r/sourceservers/cstrike
[srcds-cstrike-version-badge]: https://img.shields.io/docker/v/sourceservers/cstrike/latest?label=&style=flat-square
[srcds-cstrike-size-badge]: https://img.shields.io/docker/image-size/sourceservers/cstrike/latest?label=&style=flat-square
[srcds-cstrike-metadata-link]: https://hub.docker.com/r/sourceservers/cstrike/tags

[srcds-dod-dockerhub-link]: https://hub.docker.com/r/sourceservers/dod
[srcds-dod-version-badge]: https://img.shields.io/docker/v/sourceservers/dod/latest?label=&style=flat-square
[srcds-dod-size-badge]: https://img.shields.io/docker/image-size/sourceservers/dod/latest?label=&style=flat-square
[srcds-dod-metadata-link]: https://hub.docker.com/r/sourceservers/dod/tags

[srcds-hl2mp-dockerhub-link]: https://hub.docker.com/r/sourceservers/hl2mp
[srcds-hl2mp-version-badge]: https://img.shields.io/docker/v/sourceservers/hl2mp/latest?label=&style=flat-square
[srcds-hl2mp-size-badge]: https://img.shields.io/docker/image-size/sourceservers/hl2mp/latest?label=&style=flat-square
[srcds-hl2mp-metadata-link]: https://hub.docker.com/r/sourceservers/hl2mp/tags

[srcds-left4dead-dockerhub-link]: https://hub.docker.com/r/sourceservers/left4dead
[srcds-left4dead-version-badge]: https://img.shields.io/docker/v/sourceservers/left4dead/latest?label=&style=flat-square
[srcds-left4dead-size-badge]: https://img.shields.io/docker/image-size/sourceservers/left4dead/latest?label=&style=flat-square
[srcds-left4dead-metadata-link]: https://hub.docker.com/r/sourceservers/left4dead/tags

[srcds-left4dead2-dockerhub-link]: https://hub.docker.com/r/sourceservers/left4dead2
[srcds-left4dead2-version-badge]: https://img.shields.io/docker/v/sourceservers/left4dead2/latest?label=&style=flat-square
[srcds-left4dead2-size-badge]: https://img.shields.io/docker/image-size/sourceservers/left4dead2/latest?label=&style=flat-square
[srcds-left4dead2-metadata-link]: https://hub.docker.com/r/sourceservers/left4dead2/tags

[srcds-tf-dockerhub-link]: https://hub.docker.com/r/sourceservers/tf
[srcds-tf-version-badge]: https://img.shields.io/docker/v/sourceservers/tf/latest?label=&style=flat-square
[srcds-tf-size-badge]: https://img.shields.io/docker/image-size/sourceservers/tf/latest?label=&style=flat-square
[srcds-tf-metadata-link]: https://hub.docker.com/r/sourceservers/tf/tags

### Goldsource Engine (HLDS)

| Game | Image | Tag `v<tag>` | Size |
|:-:|:-:|:-:|:-:|
| Counter-Strike 1.6 | [`goldsourceservers/cstrike`][hlds-cstrike-dockerhub-link] | [![hlds-cstrike-version-badge][]][hlds-cstrike-metadata-link] | [![hlds-cstrike-size-badge][]][hlds-cstrike-metadata-link] | [![hlds-cstrike-layers-badge][]][hlds-cstrike-metadata-link] |
| Counter-Strike: Condition Zero | [`goldsourceservers/czero`][hlds-czero-dockerhub-link] | [![hlds-czero-version-badge][]][hlds-czero-metadata-link] | [![hlds-czero-size-badge][]][hlds-czero-metadata-link] | [![hlds-czero-layers-badge][]][hlds-czero-metadata-link] |
| Deathmatch Classic | [`goldsourceservers/dmc`][hlds-dmc-dockerhub-link] | [![hlds-dmc-version-badge][]][hlds-dmc-metadata-link] | [![hlds-dmc-size-badge][]][hlds-dmc-metadata-link] | [![hlds-dmc-layers-badge][]][hlds-dmc-metadata-link] |
| Day of Defeat | [`goldsourceservers/dod`][hlds-dod-dockerhub-link] | [![hlds-dod-version-badge][]][hlds-dod-metadata-link] | [![hlds-dod-size-badge][]][hlds-dod-metadata-link] | [![hlds-dod-layers-badge][]][hlds-dod-metadata-link] |
| Opposing Force | [`goldsourceservers/gearbox`][hlds-gearbox-dockerhub-link] | [![hlds-gearbox-version-badge][]][hlds-gearbox-metadata-link] | [![hlds-gearbox-size-badge][]][hlds-gearbox-metadata-link] | [![hlds-gearbox-layers-badge][]][hlds-gearbox-metadata-link] |
| Ricochet | [`goldsourceservers/ricochet`][hlds-ricochet-dockerhub-link] | [![hlds-ricochet-version-badge][]][hlds-ricochet-metadata-link] | [![hlds-ricochet-size-badge][]][hlds-ricochet-metadata-link] | [![hlds-ricochet-layers-badge][]][hlds-ricochet-metadata-link] |
| Team Fortress Classic | [`goldsourceservers/tfc`][hlds-tfc-dockerhub-link] | [![hlds-tfc-version-badge][]][hlds-tfc-metadata-link] | [![hlds-tfc-size-badge][]][hlds-tfc-metadata-link] | [![hlds-tfc-layers-badge][]][hlds-tfc-metadata-link] |
| Half-Life | [`goldsourceservers/valve`][hlds-valve-dockerhub-link] | [![hlds-valve-version-badge][]][hlds-valve-metadata-link] | [![hlds-valve-size-badge][]][hlds-valve-metadata-link] | [![hlds-valve-layers-badge][]][hlds-valve-metadata-link] |

[hlds-cstrike-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/cstrike
[hlds-cstrike-version-badge]: https://img.shields.io/docker/v/goldsourceservers/cstrike/latest?label=&style=flat-square
[hlds-cstrike-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/cstrike/latest?label=&style=flat-square
[hlds-cstrike-metadata-link]: https://hub.docker.com/r/goldsourceservers/cstrike/tags

[hlds-czero-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/czero
[hlds-czero-version-badge]: https://img.shields.io/docker/v/goldsourceservers/czero/latest?label=&style=flat-square
[hlds-czero-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/czero/latest?label=&style=flat-square
[hlds-czero-metadata-link]: https://hub.docker.com/r/goldsourceservers/czero/tags

[hlds-dmc-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/dmc
[hlds-dmc-version-badge]: https://img.shields.io/docker/v/goldsourceservers/dmc/latest?label=&style=flat-square
[hlds-dmc-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/dmc/latest?label=&style=flat-square
[hlds-dmc-metadata-link]: https://hub.docker.com/r/goldsourceservers/dmc/tags

[hlds-dod-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/dod
[hlds-dod-version-badge]: https://img.shields.io/docker/v/goldsourceservers/dod/latest?label=&style=flat-square
[hlds-dod-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/dod/latest?label=&style=flat-square
[hlds-dod-metadata-link]: https://hub.docker.com/r/goldsourceservers/dod/tags

[hlds-gearbox-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/gearbox
[hlds-gearbox-version-badge]: https://img.shields.io/docker/v/goldsourceservers/gearbox/latest?label=&style=flat-square
[hlds-gearbox-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/gearbox/latest?label=&style=flat-square
[hlds-gearbox-metadata-link]: https://hub.docker.com/r/goldsourceservers/gearbox/tags

[hlds-ricochet-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/ricochet
[hlds-ricochet-version-badge]: https://img.shields.io/docker/v/goldsourceservers/ricochet/latest?label=&style=flat-square
[hlds-ricochet-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/ricochet/latest?label=&style=flat-square
[hlds-ricochet-metadata-link]: https://hub.docker.com/r/goldsourceservers/ricochet/tags

[hlds-tfc-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/tfc
[hlds-tfc-version-badge]: https://img.shields.io/docker/v/goldsourceservers/tfc/latest?label=&style=flat-square
[hlds-tfc-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/tfc/latest?label=&style=flat-square
[hlds-tfc-metadata-link]: https://hub.docker.com/r/goldsourceservers/tfc/tags

[hlds-valve-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/valve
[hlds-valve-version-badge]: https://img.shields.io/docker/v/goldsourceservers/valve/latest?label=&style=flat-square
[hlds-valve-size-badge]: https://img.shields.io/docker/image-size/goldsourceservers/valve/latest?label=&style=flat-square
[hlds-valve-metadata-link]: https://hub.docker.com/r/goldsourceservers/valve/tags

## Image Info

### Game versions & tags

Both a new *clean* and *layered* image of a game are built on each available game update. Due to the immutable nature of Docker image layers, the files within a given image cannot be *updated* in the conventional sense of the word which assumes the possibility of *deletion* and so reclamation of storage space. Instead, changes made to an image involve only *modification* with respect to its newest layer and are committed as incremental layer(s) to the image, thus ever only contributing to an increase in image size.

By design, the `latest` tag of a game is as far as possible made to point to the game's newest *layered* image. By using the `latest` tag, *layered* images are used, circumventing the need to pull entire *clean* images for obtaining game updates. While *layered* images grow in size with increasing update layers, the `latest` tag is made to automatically reference the upcoming *clean* image of a game if its referenced *layered* image is found to have reached **1.75x** its initial size on an available game update.

Clean images are tagged by `<version>`. Layered images are tagged by `<version>-layered`.

### Image size

Image sizes shown above or on [Docker Hub](https://hub.docker.com/) correspond to their *compressed* size. Actual sizes after pulling the images vary, but are approximately **2x** the compressed size.

### Update duration

From the moment Valve issues an update, the time taken before a game's images are built and available for pulling largely depends on the size of the game. For instance, layered and clean images take about **15** and over **40 minutes** respectively for `Counter-Strike: Global Offensive`, but under **5 minutes** each for `Counter-Strike 1.6`.

Build cache is strategically used where possible to minimize update durations.

### Build history

The project uses multiple CI services for its build jobs. You can find the history of past build jobs by clicking on their corresponding [build status badges](#docker-sourceservers).

## Usage

**Disclaimer**: The project assumes knowledge concerning the [`docker`](https://docs.docker.com/) runtime. Instructions on customization and orchestration of containerized game instances are beyond the scope the project.

### Docker

The following are some guidelines on usage of the provided images with `docker`. The same guidelines should also apply to container orchestration tools such as [Kubernetes](https://kubernetes.io/docs/home/), [Docker Swarm Mode](https://docs.docker.com/engine/swarm/), and the standalone tool, [Docker Compose](https://docs.docker.com/compose/).

#### ENTRYPOINT and CMD

The default `ENTRYPOINT` for all game images is [`"bash", "-c"`](build/Dockerfile#L72), and the `CMD` is [`""`](build/Dockerfile#L73). These values make it convenient in development environments wherein the game's command line can simply be appended as the final argument to the `docker run` command. The default entrypoint also allows a string of runtime initialization commands to be executed at runtime, similar to what's typically achieved using entrypoint scripts such as `docker-entrypoint.sh`.

Each of the default values can also be overridden at runtime, a feature well supported by container orchestration tools. Alternatively, they can be modified as part of the build steps in custom images.

In environments supporting use of init containers for provisioning game containers with their necessary configuration before application startup, the recommended approach is to set the *game binary* as the container's `ENTRYPOINT` and its *arguments* as the container's `CMD`, as is documented [here](#starting).

#### WORKDIR

The default work directory for all the images is [`/server`](build/Dockerfile#L70) within which all of a game's files reside.

#### Starting

The following are some examples of how the game servers can be started:

```shell
# Counter-Strike: Global Offensive
## Via default entrypoint (/bin/bash -c)
docker run -it -p 27015:27015/tcp -p 27015:27015/udp sourceservers/csgo:latest 'srcds_linux -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2'
docker run -it -p 27015:27015/tcp -p 27015:27015/udp sourceservers/csgo:latest 'printenv && ls -al && exec srcds_linux -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2'
## Via custom entrypoint (game binary)
docker run -it -p 27015:27015/tcp -p 27015:27015/udp --entrypoint srcds_linux sourceservers/csgo:latest -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2
## Via custom entrypoint (/bin/bash)
docker run -it -p 27015:27015/tcp -p 27015:27015/udp --entrypoint /bin/bash sourceservers/csgo:latest -c 'printenv && ls -al && exec srcds_linux -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2'

# Counter-Strike 1.6
## Via default entrypoint (/bin/bash -c)
docker run -it -p 28015:28015/udp goldsourceservers/cstrike:latest 'hlds_linux -game cstrike +port 28015 +maxplayers 10 +map de_dust2'
docker run -it -p 28015:28015/udp goldsourceservers/cstrike:latest 'printenv && ls -al && exec hlds_linux -game cstrike +port 28015 +maxplayers 10 +map de_dust2'
## Via custom entrypoint (game binary)
docker run -it -p 28015:28015/udp --entrypoint hlds_linux goldsourceservers/cstrike:latest -game cstrike +port 28015 +maxplayers 10 +map de_dust2
## Via custom entrypoint (/bin/bash)
docker run -it -p 28015:28015/udp --entrypoint /bin/bash goldsourceservers/cstrike:latest -c 'printenv && ls -al && exec hlds_linux -game cstrike +port 28015 +maxplayers 10 +map de_dust2'
```

* `-t` for a pseudo-TTY is mandatory; servers may not run correctly without it
* `-i` for `STDIN` for interactive use of the game console
* `-d` for running the container in detached mode

For a declarative approach, define game server environments within container manifests such as [`docker-compose.yml`](docs/samples/docker-compose) which can be used for managing instances:

```shell
# Via docker-compose
docker-compose up
```

#### Attaching

If the game process is running as `PID 1` and `STDIN` is enabled for the container, the game's console can be accessed via:

```shell
docker attach containername
```

#### Debugging

To debug a container or its files:

```shell
# To enter into a container
docker exec -it containername bash

# To issue detached command(s)
docker exec containername ps aux                                     # Single, simple command
docker exec containername bash -c 'printenv && ls -al && ps aux'     # Multiple or advanced commands
```

#### Updating

To update a game server, simply initiate a pull for the game image by the `latest` tag and recreate the container.

There are many ways to detect when a game server needs an update but which are beyond the scope of the project. Here is [an example](https://stackoverflow.com/a/44740429/3891117) for utilizing a `cronjob` for updating a container.

## Important Considerations

Due to the variety of SRCDS and HLDS games and the various ways each of them can or have to be hosted, the images built with this project are kept to be as generic as possible. The following are some important considerations concerning the built images.

### Base images

The game images are [based on](build/Dockerfile#L3) the images built via the project [`startersclan/docker-steamcmd`](https://github.com/startersclan/docker-steamcmd). Issues or pull requests that are potentially applicable across the game images such as those pertaining to the OS, administrative tools, or game dependencies are to be directed to that project instead.

### Entrypoint script

The game images **do not** include an entrypoint script.

Including a generic, conventional `docker-entrypoint.sh` script would unlikely adequately serve operators given the various possible setups that could differ widely across games, game modes, mods, and plugins. Operators would be better off implementing their own custom entrypoint scripts without having to accommodate pre-included ones in the design of their setups.

This leads us to the next and a much related consideration.

### Environment variables

The game images **do not** include support for configuring game instances via environment variables.

Docker images are often packaged with applications designed to comply with the [twelve-factor methodology - Store config in the environment](https://12factor.net/config) where environment variables are read directly as configuration by the application, a case in point being the [Docker Registry](https://docs.docker.com/registry/configuration/#override-specific-configuration-options). Some applications however do not read environment variables as configuration but instead accept command line arguments or read from config files wherein it is common for their docker images to include an entrypoint script which maps environment variables onto command line arguments for invocation.

Source and Goldsource games belong to the group of applications that do not read from environment variables but that are instead configured via parameters (i.e. flags beginning with `-`, e.g. `-usercon`, see [SRCDS parameters](https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-Line_Parameters_6) and [HLDS parameters](https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-Line_Parameters_7)), as well as Cvars (i.e. flags beginning with `+`, e.g. `+sv_lan 0`, see [SRCDS console variables](https://developer.valvesoftware.com/wiki/Command_Line_Options#Console_Variables_2) and [HLDS console variables](https://developer.valvesoftware.com/wiki/Command_Line_Options#Useful_Console_Variables_2)). Although there are many Cvars shared across SRCDS and HLDS games, there are also Cvars that are game-specific (e.g. the many hundreds for `left4dead` and `left4dead2`), as well as mod/plugin-specific (e.g. `sourcemod`, `amxmodx`, `garrysmod`).

Because of the many parameters and Cvars that exist for each game and mod/plugin setup, it does not make sense to map them directly to environment variables for several reasons: First, doing so introduces an unnecessary layer of abstraction which operators would have to learn on top of the numerous available parameters and Cvars; Second, a single change to any envvar-cvar mapping will require a rebuild of the docker image to contain the new `docker-entrypoint.sh` script, introducing a lot of unnecessary builds; Third, the very `docker-entrypoint.sh` script providing the envvar-cvar mapping would also require versioning, introducing yet another burden on top of just keeping the images updated.

As such, the provided images do not support configuration via environment variables. The recommended approach would be to specify all necessary launch parameters and Cvars for a given game server within the container's command, and all other Cvars including those containing secret values within mounted or init-time provisioned configuration file(s) such as [`server.cfg`](https://developer.valvesoftware.com/wiki/Server.cfg).

### Non-root user

The game images **do not** include a non-root user.

The images as aforementioned are meant to be generic. Having a non-root user poses a problem especially when volumes are going to be used by operators. A common `UID` built into the images would unlikely fulfill the requirements of operators whose hosts would then require a matching `UID` in cases where bind mounts are used. A mismatch or missing `UID` within the container or the host would prevent the container user from accessing the data on the volumes, leading to issues pertaining to the game server, and rendering the game images useless unless customized.

Operators who wish to run the game servers under a non-root user can customize the provided images with a non-root user with a `UID` of their choice.

*Note*: A non-root user could be added to the images in the future if the addition is sufficiently requested with good reasons for its implementation. Best practices can change depending on features provided by newer versions of container runtimes and/or orchestrators.

### Invocation via wrapper script vs binary

The official games from Valve come with a wrapper script and a binary as part of the game files, both of which reside in the game's root directory.

The wrapper script, commonly used in non-containerized setups:

* `srcds_run` (Source)
* `hlds_run` (Goldsource)

The game binary:

* `srcds_linux` (Source)
* `hlds_linux` (Goldsource)

Invoking the game binary directly is the recommended choice especially when hosting the game server within containers. Doing so allows the game process to run as `PID 1` which ensures the game's console output is correctly propagated as container logs, and makes attaching of the terminal to the game's console possible for interactive administration.

Some operators may choose to invoke the wrapper script instead as it provides features such as auto-restart and auto-updates. Doing so presents several problems related to container infrastucture: First, invoking the wrapper script alone prevents the game process from being run as `PID 1` which potentially introduces unpredictable behavior pertaining to the container. Second, using the wrapper script auto-restart feature overlaps with restart functionalities already provided by container orchestration tools, introducing the issue of unpredictable restarts to the container. Third, using the wrapper script auto-update feature introduces mutation to the container's supposed game version on available updates, wherein changes would not only be lost upon container deletion, but that would have to be performed for every new container started from outdated game images, contradicting the principle of immutability in container design.

As such, invocation via the wrapper script is strongly discouraged, and support for doing so will not be a priority in this project. The provided game images being generic however should not prevent operators from adopting such approaches should they wish to.
