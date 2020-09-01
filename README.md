# Zombie Survival

This repository contains a fork of [JetBoom's Zombie
Survival](https://github.com/jetboom/zombiesurvival) gamemode for the "Hot Dad"
Garry's Mod community.

- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Maps](#maps)
  - [Fast Download](#fast-download)
- [Scripts](#scripts)

## Requirements

- [Docker Engine](https://docs.docker.com/install/) 19.03+
- [Docker Compose](https://docs.docker.com/compose/install/) 1.26+

## Getting Started

First, define a [Steam Game Server Login Token
(GSLT)](https://steamcommunity.com/dev/managegameservers) within the `.env` file
at the root of the repository.

```bash
$ cat .env
STEAM_GSLT=YOURLOGINTOKENHERE
```

Next, create a `server.cfg` file under `src/garrysmod/cfg`.

```bash
$ cd src/garrysmod/cfg
$ cat server.cfg
hostname "Zombie Survival"
```

The following script will provision the rest of the development environment.

```bash
$ ./scripts/update
```

And, volia ✨.

```bash
$ ./scripts/server
. . .
garrysmod_1  | Connection to Steam servers successful.
garrysmod_1  |    Public IP is [redacted].
garrysmod_1  | Assigned anonymous gameserver Steam ID [A-1:3346233348(15470)].
garrysmod_1  | VAC secure mode is activated.
```

Other features of the development environment require additional credentials to
be configured within the `.env` file in the root of the repository.

### Map Files

Some of the map files are larger than 100 MB which is over GitHub's individual
file size limit. As a result, map files are stored in an S3 bucket, not in this
repository.

`scripts/update` will attempt to connect to an S3 bucket to sync map files with
your workspace.

### Fast Download

Fast Download (FastDL) allows Garry's Mod clients to download custom server
content from a web server. Without FastDL, downloads are limited to 30 KB/s.

`scripts/update` will sync content within
`src/garrysmod/gamemodes/zombiesurvival/content` to an S3 bucket configured to
serve as the FastDL endpoint. 

## Scripts

| Name          | Description                                        |
|---------------|----------------------------------------------------|
| `console`     | Attach to the SRCDS console. Detach with `ctrl-d`. |
| `server`      | Start SRCDS.                                       |
| `sync-fastdl` | Push FastDL artifacts to S3.                       |
| `sync-maps`   | Pull map files from from S3.                       |
| `update`      | Build container images and update dependencies.    |
