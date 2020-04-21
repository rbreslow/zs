FROM quay.io/rbreslow/garrysmodds:slim

# Download Counter-Strike: Source DS with steamcmd for content dependencies
RUN set -ex \
    && /usr/games/steamcmd +login anonymous \
    +app_update 232330 \
    validate \
    +quit
