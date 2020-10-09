FROM quay.io/rbreslow/garrysmodds:slim

# Download Counter-Strike: Source DS
RUN set -ex \
    && /usr/games/steamcmd +login anonymous \
    +app_update 232330 \
    validate \
    +quit

COPY cfg/mount.cfg garrysmod/cfg/mount.cfg

# Switch to x64 branch
RUN set -ex \
    && /usr/games/steamcmd +login anonymous \
    +app_update 4020 \
    -beta x86-64 \
    validate \
    +quit

USER root

ENV LIBPQ_VERSION 11.9-0+deb10u1
ENV LIBPQXX_VERSION 6.2.5-1

RUN set -ex \
    && deps=" \
        libpq-dev=$LIBPQ_VERSION \
        libpqxx-dev=$LIBPQXX_VERSION \
    " \
    && apt-get update && apt-get install -y $deps \
    && rm -rf /var/lib/apt/lists/*

USER steam

COPY lua/bin/gmsv_pg_linux64.dll garrysmod/lua/bin/gmsv_pg_linux64.dll

ENTRYPOINT ["/var/lib/steam/.steam/SteamApps/common/GarrysModDS/srcds_run_x64"]
