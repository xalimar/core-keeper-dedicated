# Supported tags and respective `Dockerfile` links
-   ['latest' (*buster/Dockerfile*)](https://github.com/xalimar/core-keeper-dedicated/blob/master/buster/Dockerfile)

# What is Core Keeper?
Explore an endless cavern of creatures, relics and resources in a mining sandbox adventure for 1-8 players. Mine, build, fight, craft and farm to unravel the mystery of the ancient Core.

> [Core Keeper](https://store.steampowered.com/app/1621690/Core_Keeper/)

# How to use this image

## Create volumes for persistent storage
```console
docker volume create steamcmd_volume
docker volume create steam_app_volume
docker volume create corekeeper_save_volume
```

## Launch Core Keeper game server

```console
docker run -d --net=host --name=core-keeper-dedicated \
    -v "steamcmd_volume:/home/steam/steamcmd" \
    -v "steam_app_volume:/home/steam/core-keeper-dedicated" \
    -v "corekeeper_save_volume:/home/steam/.config/unity3d/Pugstorm/Core Keeper" \
    xalimar/core-keeper-dedicated
```

## View the container logs to find the Game ID
You'll need this ID to join the game. You can press ctrl-c to stop watching the logfile

```console
docker logs -f core-keeper-dedicated
```

# Copy an existing world to the server
Make sure to connect to the server for a few minutes so an initial `0.world.gzip` save is created in the Docker volume. Then, stop the server container
```console
docker stop core-keeper-dedicated
```
Locate your world file, for example it will be in a similar path to this. I highly recommend backing this up so you don't accidentally overwrite the wrong file.
```
C:\Users\<username>\AppData\LocalLow\Pugstorm\Core Keeper\Steam\<id>\worlds
```

It will be named `0.world.gzip`. Copy that to the docker `corekeeper_save_volume` and overwrite the existing `0.world.gzip`. With docker desktop on windows, you can find it here:
```
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\corekeeper_save_volume\_data\DedicatedServer\worlds
```

On Linux it will probably be located here:
```
/var/lib/docker/volumes/corekeeper_save_volume/_data/DedicatedServer/worlds
```

Finally, restart the container:
```console
docker start core-keeper-dedicated
```
