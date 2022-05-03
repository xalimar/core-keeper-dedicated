# Supported tags and respective `Dockerfile` links
-   ['latest' (*buster/Dockerfile*)](https://github.com/xalimar/core-keeper-dedicated/blob/master/buster/Dockerfile)

# What is Core Keeper?
Explore an endless cavern of creatures, relics and resources in a mining sandbox adventure for 1-8 players. Mine, build, fight, craft and farm to unravel the mystery of the ancient Core.

> [Core Keeper](https://store.steampowered.com/app/1621690/Core_Keeper/)

# How to use this image

## Build the docker image locally
```console
cd buster
docker build . -t core-keeper-dedicated:latest
```

## Create volumes for persistent storage
```console
docker volume create steamcmd_login_volume
docker volume create steamcmd_volume
docker volume create steam_app_volume
docker volume create corekeeper_save_volume
```

## Authenticate steam user in container
Unfortunately Core Keeper doesn't allow anonymous access to download the game, so we have to authenticate one-time to save this container as a trusted device.

```console
docker run -it --rm \
    -v "steamcmd_login_volume:/home/steam/Steam" \
    -v "steamcmd_volume:/home/steam/steamcmd" \
    core-keeper-dedicated \
    steamcmd/steamcmd.sh +login <steamuser> +quit
```

## Launch Core Keeper game server
Even though we authenticated above, we still have to pass our username and password to authenticate to check for updates. This won't work if you have Steam Guard MFA enabled on your phone, it will prompt for the code on every launch. If you are only using the emailed Steam Guard code, the authentication we did above should have cached the device for future launches.

```console
docker run -d --net=host --name=core-keeper-dedicated \
    -v "steamcmd_login_volume:/home/steam/Steam" \
    -v "steamcmd_volume:/home/steam/steamcmd" \
    -v "steam_app_volume:/home/steam/core-keeper-dedicated" \
    -v "corekeeper_save_volume:/home/steam/.config/unity3d/Pugstorm/Core Keeper" \
    -e STEAMUSER=<steam user> \
    -e STEAMPASS=<steam password> \
    core-keeper-dedicated
```

## View the container logs to find the Game ID
You'll need this ID to join the game. You can press ctrl-c to stop watching the logfile

```
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
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\corekeeper_save_volume\_data\experimental\DedicatedServer\worlds
```

Finally, restart the container:
```
docker start core-keeper-dedicated
```
