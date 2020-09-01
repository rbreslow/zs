FROM quay.io/rbreslow/garrysmodds:slim

# Download Counter-Strike: Source DS
RUN set -ex \
    && /usr/games/steamcmd +login anonymous \
    +app_update 232330 \
    validate \
    +quit

COPY cfg/mount.cfg garrysmod/cfg/mount.cfg
