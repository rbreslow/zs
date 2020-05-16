# ZS

This repository contains a fork of JetBoom's Zombie Survival gamemode, as well as scripts to help run SRCDS.

- [Getting Started](#getting-started)
- [Workflow](#workflow)
  - [Starting and Stopping the Server](#starting-and-stopping-the-server)
  - [Accessing the SRCDS Console](#accessing-the-srcds-console)
- [Scripts](#scripts)

## Getting Started

First, we need to accomplish the following tasks:

- Install the latest version of Garry's Mod SRCDS
- Get the latest version of [JetBoom/zombiesurvival](https://github.com/JetBoom/zombiesurvival)
- Update the FastDL server, so that clients will be able to download custom content

The following script automates these tasks:

```bash
$ ./scripts/update
```

## Workflow

### Starting and Stopping the Server

To start the server:

```bash
$ ./scripts/server
```

To stop the server:

```bash
$ ./scripts/server --stop
```

### Accessing the SRCDS Console

```bash
$ ./scripts/console
```

- To detatch from SRCDS, use <kbd>ctrl</kbd> + <kbd>d</kbd>.
- To view previous logs, run `docker-compose logs garrysmod`.

## Scripts

| Name      | Description                                        |
|-----------|----------------------------------------------------|
| `update`  | Build container images and update FastDL.          |
| `server`  | Start or stop SRCDS.                               |
| `console` | Attach to the SRCDS console. Detach with `ctrl-d`. |
