# Docker-SourceServers

**Source** / **Goldsource** dedicated server images built through use of [`steamcmd`](https://github.com/startersclan/docker-steamcmd).

|  Build | Update |
|:-:|:-:|
| [![pipeline-travis-build-badge][]][pipeline-travis-build-link] [![pipeline-azurepipelines-build-badge][]][pipeline-azurepipelines-build-link] [![pipeline-circleci-build-badge][]][pipeline-circleci-build-link] | [![pipeline-travis-update-badge][]][pipeline-travis-update-link] [![pipeline-azurepipelines-update-badge][]][pipeline-azurepipelines-update-link] |

[pipeline-travis-build-badge]: https://img.shields.io/travis/startersclan/docker-sourceservers/build.svg?label=&logo=travis&style=flat-square
[pipeline-travis-build-link]: https://travis-ci.org/startersclan/docker-sourceservers/builds
[pipeline-travis-update-badge]: https://img.shields.io/travis/startersclan/docker-sourceservers/update.svg?label=&logo=travis&style=flat-square
[pipeline-travis-update-link]: https://travis-ci.org/startersclan/docker-sourceservers/builds

[pipeline-azurepipelines-build-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/2/build.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-build-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=2
[pipeline-azurepipelines-update-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/3/update.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-update-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=3

[pipeline-circleci-build-badge]: https://img.shields.io/circleci/build/gh/startersclan/docker-sourceservers/build.svg?label=&logo=circleci&style=flat-square
[pipeline-circleci-build-link]: https://circleci.com/gh/startersclan/docker-sourceservers/tree/build

## Supported Tags

* `latest` [(*/build/Dockerfile*)][dockerfile-build-link], [(*/update/Dockerfile*)][dockerfile-update-link]
* `<version>` [(*/build/Dockerfile*)][dockerfile-build-link]
* `<version>-layered` [(*/update/Dockerfile*)][dockerfile-update-link]

[dockerfile-build-link]: https://github.com/startersclan/docker-sourceservers/blob/master/build/Dockerfile
[dockerfile-update-link]: https://github.com/startersclan/docker-sourceservers/blob/master/update/Dockerfile

## Game Images

Dedicated servers hosted on Steam are usually required to be running the *latest version* of the game in order for clients to connect to them. Simply use the `latest` tag for the latest version of a game.

[![srcds-dockerhub-badge][]][srcds-dockerhub-link] [![hlds-dockerhub-badge][]][hlds-dockerhub-link]

[srcds-dockerhub-badge]: https://img.shields.io/badge/docker%20hub-sourceservers-blue.svg?logo=docker&logoColor=2596EC&color=FFA722&label=&labelColor=&style=popout-square
[srcds-dockerhub-link]: https://hub.docker.com/u/sourceservers
[hlds-dockerhub-badge]: https://img.shields.io/badge/docker%20hub-goldsourceservers-blue.svg?logo=docker&logoColor=2596EC&color=FF6917&label=&labelColor=&style=popout-square
[hlds-dockerhub-link]: https://hub.docker.com/u/goldsourceservers

### Source Engine (SRCDS)

| Game | Image | Tag | Size / Layers |
|:-:|:-:|:-:|:-:|
| Counter-Strike: Global Offensive | [`sourceservers/csgo`][srcds-csgo-dockerhub-link] | [![srcds-csgo-version-badge][]][srcds-csgo-metadata-link] | [![srcds-csgo-layers-badge][]][srcds-csgo-metadata-link] |
| Counter-Strike: Source | [`sourceservers/cstrike`][srcds-cstrike-dockerhub-link] | [![srcds-cstrike-version-badge][]][srcds-cstrike-metadata-link] | [![srcds-cstrike-layers-badge][]][srcds-cstrike-metadata-link] |
| Day of Defeat: Source | [`sourceservers/dod`][srcds-dod-dockerhub-link] | [![srcds-dod-version-badge][]][srcds-dod-metadata-link] | [![srcds-dod-layers-badge][]][srcds-dod-metadata-link] |
| Half-Life 2: Deathmatch | [`sourceservers/hl2mp`][srcds-hl2mp-dockerhub-link] | [![srcds-hl2mp-version-badge][]][srcds-hl2mp-metadata-link] | [![srcds-hl2mp-layers-badge][]][srcds-hl2mp-metadata-link] |
| Left 4 Dead | [`sourceservers/left4dead`][srcds-left4dead-dockerhub-link] | [![srcds-left4dead-version-badge][]][srcds-left4dead-metadata-link] | [![srcds-left4dead-layers-badge][]][srcds-left4dead-metadata-link] |
| Left 4 Dead 2 | [`sourceservers/left4dead2`][srcds-left4dead2-dockerhub-link] | [![srcds-left4dead2-version-badge][]][srcds-left4dead2-metadata-link] | [![srcds-left4dead2-layers-badge][]][srcds-left4dead2-metadata-link] |
| Team Fortress 2 | [`sourceservers/tf`][srcds-tf-dockerhub-link] | [![srcds-tf-version-badge][]][srcds-tf-metadata-link] | [![srcds-tf-layers-badge][]][srcds-tf-metadata-link] |

[srcds-csgo-dockerhub-link]: https://hub.docker.com/r/sourceservers/csgo
[srcds-csgo-version-badge]: https://images.microbadger.com/badges/version/sourceservers/csgo.svg
[srcds-csgo-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/csgo.svg
[srcds-csgo-metadata-link]: https://microbadger.com/images/sourceservers/csgo

[srcds-cstrike-dockerhub-link]: https://hub.docker.com/r/sourceservers/cstrike
[srcds-cstrike-version-badge]: https://images.microbadger.com/badges/version/sourceservers/cstrike.svg
[srcds-cstrike-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/cstrike.svg
[srcds-cstrike-metadata-link]: https://microbadger.com/images/sourceservers/cstrike

[srcds-dod-dockerhub-link]: https://hub.docker.com/r/sourceservers/dod
[srcds-dod-version-badge]: https://images.microbadger.com/badges/version/sourceservers/dod.svg
[srcds-dod-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/dod.svg
[srcds-dod-metadata-link]: https://microbadger.com/images/sourceservers/dod

[srcds-hl2mp-dockerhub-link]: https://hub.docker.com/r/sourceservers/hl2mp
[srcds-hl2mp-version-badge]: https://images.microbadger.com/badges/version/sourceservers/hl2mp.svg
[srcds-hl2mp-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/hl2mp.svg
[srcds-hl2mp-metadata-link]: https://microbadger.com/images/sourceservers/hl2mp

[srcds-left4dead-dockerhub-link]: https://hub.docker.com/r/sourceservers/left4dead
[srcds-left4dead-version-badge]: https://images.microbadger.com/badges/version/sourceservers/left4dead.svg
[srcds-left4dead-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/left4dead.svg
[srcds-left4dead-metadata-link]: https://microbadger.com/images/sourceservers/left4dead

[srcds-left4dead2-dockerhub-link]: https://hub.docker.com/r/sourceservers/left4dead2
[srcds-left4dead2-version-badge]: https://images.microbadger.com/badges/version/sourceservers/left4dead2.svg
[srcds-left4dead2-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/left4dead2.svg
[srcds-left4dead2-metadata-link]: https://microbadger.com/images/sourceservers/left4dead2

[srcds-tf-dockerhub-link]: https://hub.docker.com/r/sourceservers/tf
[srcds-tf-version-badge]: https://images.microbadger.com/badges/version/sourceservers/tf.svg
[srcds-tf-layers-badge]: https://images.microbadger.com/badges/image/sourceservers/tf.svg
[srcds-tf-metadata-link]: https://microbadger.com/images/sourceservers/tf

### Goldsource Engine (HLDS)

| Game | Image | Tag | Size / Layers |
|:-:|:-:|:-:|:-:|
| Counter-Strike 1.6 | [`goldsourceservers/cstrike`][hlds-cstrike-dockerhub-link] | [![hlds-cstrike-version-badge][]][hlds-cstrike-metadata-link] | [![hlds-cstrike-layers-badge][]][hlds-cstrike-metadata-link] |
| Counter-Strike: Condition Zero | [`goldsourceservers/czero`][hlds-czero-dockerhub-link] | [![hlds-czero-version-badge][]][hlds-czero-metadata-link] | [![hlds-czero-layers-badge][]][hlds-czero-metadata-link] |
| Deathmatch Classic | [`goldsourceservers/dmc`][hlds-dmc-dockerhub-link] | [![hlds-dmc-version-badge][]][hlds-dmc-metadata-link] | [![hlds-dmc-layers-badge][]][hlds-dmc-metadata-link] |
| Day of Defeat | [`goldsourceservers/dod`][hlds-dod-dockerhub-link] | [![hlds-dod-version-badge][]][hlds-dod-metadata-link] | [![hlds-dod-layers-badge][]][hlds-dod-metadata-link] |
| Opposing Force | [`goldsourceservers/gearbox`][hlds-gearbox-dockerhub-link] | [![hlds-gearbox-version-badge][]][hlds-gearbox-metadata-link] | [![hlds-gearbox-layers-badge][]][hlds-gearbox-metadata-link] |
| Ricochet | [`goldsourceservers/ricochet`][hlds-ricochet-dockerhub-link] | [![hlds-ricochet-version-badge][]][hlds-ricochet-metadata-link] | [![hlds-ricochet-layers-badge][]][hlds-ricochet-metadata-link] |
| Team Fortress Classic | [`goldsourceservers/tfc`][hlds-tfc-dockerhub-link] | [![hlds-tfc-version-badge][]][hlds-tfc-metadata-link] | [![hlds-tfc-layers-badge][]][hlds-tfc-metadata-link] |
| Half-Life | [`goldsourceservers/valve`][hlds-valve-dockerhub-link] | [![hlds-valve-version-badge][]][hlds-valve-metadata-link] | [![hlds-valve-layers-badge][]][hlds-valve-metadata-link] |

[hlds-cstrike-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/cstrike
[hlds-cstrike-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/cstrike.svg
[hlds-cstrike-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/cstrike.svg
[hlds-cstrike-metadata-link]: https://microbadger.com/images/goldsourceservers/cstrike

[hlds-czero-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/czero
[hlds-czero-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/czero.svg
[hlds-czero-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/czero.svg
[hlds-czero-metadata-link]: https://microbadger.com/images/goldsourceservers/czero

[hlds-dmc-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/dmc
[hlds-dmc-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/dmc.svg
[hlds-dmc-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/dmc.svg
[hlds-dmc-metadata-link]: https://microbadger.com/images/goldsourceservers/dmc

[hlds-dod-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/dod
[hlds-dod-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/dod.svg
[hlds-dod-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/dod.svg
[hlds-dod-metadata-link]: https://microbadger.com/images/goldsourceservers/dod

[hlds-gearbox-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/gearbox
[hlds-gearbox-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/gearbox.svg
[hlds-gearbox-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/gearbox.svg
[hlds-gearbox-metadata-link]: https://microbadger.com/images/goldsourceservers/gearbox

[hlds-ricochet-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/ricochet
[hlds-ricochet-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/ricochet.svg
[hlds-ricochet-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/ricochet.svg
[hlds-ricochet-metadata-link]: https://microbadger.com/images/goldsourceservers/ricochet

[hlds-tfc-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/tfc
[hlds-tfc-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/tfc.svg
[hlds-tfc-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/tfc.svg
[hlds-tfc-metadata-link]: https://microbadger.com/images/goldsourceservers/tfc

[hlds-valve-dockerhub-link]: https://hub.docker.com/r/goldsourceservers/valve
[hlds-valve-version-badge]: https://images.microbadger.com/badges/version/goldsourceservers/valve.svg
[hlds-valve-layers-badge]: https://images.microbadger.com/badges/image/goldsourceservers/valve.svg
[hlds-valve-metadata-link]: https://microbadger.com/images/goldsourceservers/valve

## Image Info

### Game versions & tags

Both a new *clean* and *layered* image of a game are built on an available game update. Due to the nature of Docker images, an image cannot exactly be *updated*; any modifications to it adds to its existing layers.

The `latest` tag follows a layered approach to updating. Using it prevents the need to pull the newest clean image of a game on each available update. However, layered images gradually grow in size with increasing update layers. To solve this, the `latest` tag is made to automatically reference the clean image of a game on the next update upon reaching **1.75x** its initial size.

Clean images are tagged by `<version>`. Layered images are tagged by `<version>-layered`.

### Image size

Image sizes shown above or on Docker Hub correspond to an image's *compressed* size. Actual sizes vary, but are approximately **2x** larger after pulling an image.

### Update duration

From the moment Valve issues an update, the time taken before a game's images are built and available for pulling largely depends on the size of the game. For instance, layered and clean images take over **15** and **40 minutes** respectively for `Counter-Strike: Global Offensive`, but under **5 minutes** each for `Counter-Strike 1.6`.

While the use of build cache can help drastically reduce update durations, it cannot be utilized as the game images are built for public use, purposefully done so using public machines.

### Build history

The project uses multiple CI services for its build jobs. You can find the history of past build jobs by clicking on their corresponding build status badges.

## Usage

### Docker

The project assumes knowledge concerning the [`docker`](https://docs.docker.com/) runtime. Instructions on customization and orchestration of containerized game server instances are outside the scope the project.

#### Entrypoint and CMD

Currently, the default **ENTRYPOINT** for all game images is [`"bash", "-c"`](build/Dockerfile#L72), and the **CMD** is [`""`](build/Dockerfile#L73). This makes it convenient especially in development environments in that the game's command line can simply be appended as the final argument of the `docker run` command.

Each of the values can be overridden at runtime which is well supported by container orchestration tools such as [Kubernetes](https://kubernetes.io/) and  [Docker Swarm Mode](https://docs.docker.com/engine/swarm/), and the standalone tool, [Docker Compose](https://docs.docker.com/compose/). Alternatively, they can be modified as part of the build steps in custom images.

#### Workdir

The default working directory for all the images is [`/server`](build/Dockerfile#L70) within which all of a game's dedicated server files reside.

#### Command line

The following are some examples of how the game servers can be run:

```shell
# Counter-Strike: Global Offensive
docker run -it -p 27015:27015/udp sourceservers/csgo:latest 'srcds_linux -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2'

# Counter-Strike 1.6
docker run -it -p 27016:27016/udp goldsourceservers/cstrike:latest 'hlds_linux -game cstrike +port 27016 +maxplayers 10 +map de_dust2'
```

* `-t` for a pseudo-TTY is mandatory; servers may not run correctly without it
* `-i` for STDIN for interactive use of the game console
* `-d` for running the container in detached mode

#### Attaching

If the game process is running as `PID 1` and STDIN is enabled for the container, the game's console can be accessed via:

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

#### Updating gameservers

To update a gameserver, pull the `:latest` docker image again, and then restart the server.

```sh
docker pull sourceservers/csgo:latest 
docker rm -f csgo-server 
docker run --name csgo-server -it -p 27015:27015/udp sourceservers/csgo:latest srcds_linux -game csgo -port 27015 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 
```

There are many ways to detect when a gameserver needs an update, but this is out of the scope of this repository. However here is an [example](https://stackoverflow.com/a/44740429/3891117) of a `cronjob` you may use to update your server. 

## Important considerations

Due to the variety of `SRCDS` and `HLDS` games that can be hosted and the various ways each of the games can and/or have to be hosted, the images built using this project are kept to be as generic as possible. The following are important considerations concerning the images provided by the project.

### Entrypoint script

The game images **do not** include an entrypoint script.

While the conventional `entrypoint.sh` could have been included, having so also takes away flexibility for how the images can be used. Operators wishing to utilize their own entrypoint scripts would have to include removal of pre-existing ones as part of their build or init process, which likely adds unnecessary confusion. It is also unlikely that a generic entrypoint script would be adequate given the various ways server operators could implement the container's initialization process for the game server.

This brings us to the next but a much related consideration.

### Environment variables

The game images **do not** include support for mapped environment variables.

Docker images are often designed with environment variables that are typically mapped onto arguments which are generated within the included entrypoint script as part of the container's initialization process that are then used for invoking the core binary for which the image is built.

While support for them could be made for the provided game images, having so assumes not only the presence of an entrypoint script, but environment variables with names that would likely serve to add only more confusion to server operators due to the sheer number parameters (e.g. `-usercon`) and Cvars (e.g. `+port`) that too differs depending on the game engine (`SRCDS`, `HLDS`) and game. Moreover, the command line of game servers can greatly vary depending on how the servers are hosted, making it difficult to say which parameters or Cvars should be considered mandatory and so be mapped and configurable via environment variables. Such support introduces an unnecessary layer of abstraction that adds more problems than it solves.

As such, the recommended approach would be to specify all runtime parameters and Cvars for the game server right within the container's command alone and other cvars in a mounted [`server.cfg`](https://developer.valvesoftware.com/wiki/Server.cfg).

### Non-root user

The game images **do not** include a non-root user.

The game images as aforementioned are meant to be generic. Having a non-root user poses a problem especially when volumes are going to be used by operators. A common `UID` built into the images would unlikely fulfill the requirements of operators whose host's would then require a matching `UID` in cases where bind mounts are used. A mismatch or missing `UID` within the container and the host would prevent the container user access to data on the volumes, leading to issues pertaining to the game server, which would render the game images useless unless customized.

Operators who wish to run the game servers under a non-root user can customize the provided images with a non-root user with a `UID` of their choice.

*Note*: A non-root user could be added to the images in the future if the addition is sufficiently requested with good reasons for its implementation, or it could continue to be left out. Best practices can change depending on features provided by newer versions of container runtimes and/or orchestrators.

### Invocation via wrapper script vs binary

The official games from Valve come with an wrapper script and a binary as part of the game files, both of which reside in the game's root directory.

The wrapper script, commonly used in non-containerized setups:

* `srcds_run.sh` (Source)
* `hlds_run.sh` (Goldsource)

The game binary:

* `srcds_linux` (Source)
* `hlds_linux` (Goldsource)

Invoking the game binary directly is the recommended choice especially when hosting the game server within containers. Doing allows the game process to run as `PID 1`, which ensures the game's console output are correctly propagated as container logs, and makes attaching of the terminal to the game's console possible for interactive administration.

Some operators may choose to invoke the wrapper script instead as it provides features such as auto-restart and auto-updates. Note that doing so prevents the game process from being run as `PID 1` and introduces unpredictable behavior pertaining to the container, making such an approach an anti-pattern when it comes to containerizing applications. The provided game images being generic however should not prevent operators from adopting such approaches should they wish to.
