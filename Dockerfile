FROM alpine:3.3
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

# Create config directories
ENV CONFIG_DIR    /srv/transmission-daemon
ENV BLOCKLIST_DIR ${CONFIG_DIR}/blocklists
RUN mkdir -pv ${CONFIG_DIR} ${BLOCKLIST_DIR}

# Set download and watch directories
ENV DOWNLOAD_DIR   /srv/downloads
ENV INCOMPLETE_DIR ${DOWNLOAD_DIR}/.incomplete
ENV WATCH_DIR      /srv/watchdir

# Add transmission-daemon settings file
COPY files/settings.json ${CONFIG_DIR}/settings.json

# Set RPC variables
ENV RPC_USER transmission
ENV RPC_PASS transmission

# Install packages and dependencies
RUN apk add --update transmission-cli transmission-daemon wget \
    && rm -rf /var/cache/apk/*

# Install initial blocklist
ENV BLOCKLIST_URL http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz
RUN wget -qO- "${BLOCKLIST_URL}" | gunzip > ${BLOCKLIST_DIR}/bt_level1

# Create bolcklist-update cronjob
COPY files/blocklist-update /etc/periodic/hourly/blocklist-update
RUN chmod +x /etc/periodic/hourly/blocklist-update

# Add docker volumes
VOLUME ${DOWNLOAD_DIR} ${WATCH_DIR}

# Expose ports
EXPOSE 9091 51413

# Run transmission-daemon as default command
CMD transmission-daemon --foreground --log-info --config-dir ${CONFIG_DIR} --lpd \
    --download-dir ${DOWNLOAD_DIR} --incomplete-dir ${INCOMPLETE_DIR} --watch-dir ${WATCH_DIR} \
    --auth --username ${RPC_USER} --password ${RPC_PASS}
