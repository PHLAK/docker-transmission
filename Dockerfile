FROM alpine:3.8
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

# Define transmission-daemon version
ARG TD_VERSION=2.94-r0

# Define the authentication user and password
ENV TR_AUTH="transmission:transmission"

# Define a healthcheck
HEALTHCHECK --timeout=5s CMD transmission-remote --authenv --session-info

# Create directories
RUN mkdir -pv /etc/transmission-daemon/blocklists /srv/downloads/.incomplete /srv/watchdir

# Add settings file
COPY files/settings.json /etc/transmission-daemon/settings.json

# Install packages and dependencies
RUN apk add --update curl transmission-cli transmission-daemon=${TD_VERSION} tzdata \
    && rm -rf /var/cache/apk/*

# Create bolcklist-update cronjob
COPY files/blocklist-update /etc/periodic/hourly/blocklist-update
RUN chmod +x /etc/periodic/hourly/blocklist-update

# Install initial blocklist
ARG BLOCKLIST_URL="http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz"
RUN curl -sL ${BLOCKLIST_URL} | gunzip > /etc/transmission-daemon/blocklists/bt_level1

# Expose ports
EXPOSE 9091 51413

# Add docker volumes
VOLUME /etc/transmission-daemon

# Run transmission-daemon as default command
CMD transmission-daemon --foreground --log-info --config-dir /etc/transmission-daemon \
    --download-dir /srv/downloads --incomplete-dir /srv/downloads/.incomplete \
    --watch-dir /srv/watchdir --username ${TR_AUTH%:*} --password ${TR_AUTH#*:}
