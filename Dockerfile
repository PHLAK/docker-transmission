FROM alpine:3.11
LABEL maintainer="Chris Kankiewicz <Chris@ChrisKankiewicz.com>"

# Define transmission-daemon version
ARG TD_VERSION=2.94-r3

# Define the authentication user and password
ENV TR_AUTH="transmission:transmission"

# Define a healthcheck
HEALTHCHECK --timeout=5s CMD transmission-remote --authenv --session-info

# Create directories
RUN mkdir -pv /etc/transmission-daemon/blocklists /vol/downloads/.incomplete /vol/watchdir

# Create non-root user
RUN adduser -DHs /sbin/nologin transmission

# Add settings file
COPY files/settings.json /etc/transmission-daemon/settings.json

# Install packages and dependencies
RUN apk add --update curl transmission-cli=${TD_VERSION} transmission-daemon=${TD_VERSION} tzdata \
    && rm -rf /var/cache/apk/*

# Install initial blocklist
ARG BLOCKLIST_URL="http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz"
RUN curl -sL ${BLOCKLIST_URL} | gunzip > /etc/transmission-daemon/blocklists/bt_level1 \
    && chown -R transmission:transmission /etc/transmission-daemon

# Create bolcklist-update cronjob
COPY files/blocklist-update /etc/periodic/hourly/blocklist-update
RUN chmod +x /etc/periodic/hourly/blocklist-update

# Expose ports
EXPOSE 9091 51413

# Set running user
USER transmission

# Add docker volumes
VOLUME /etc/transmission-daemon

# Run transmission-daemon as default command
CMD transmission-daemon --foreground --log-info --config-dir /etc/transmission-daemon \
    --download-dir /vol/downloads --incomplete-dir /vol/downloads/.incomplete \
    --watch-dir /vol/watchdir --username ${TR_AUTH%:*} --password ${TR_AUTH#*:}
