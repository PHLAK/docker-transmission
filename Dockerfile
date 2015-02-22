FROM ubuntu:14.04
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

## Upgrade packages and install dependencies
RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install software-properties-common wget \
    && rm -rf /var/lib/apt/lists/*

## Add transmission-daemon PPA and install
RUN apt-add-repository -y ppa:transmissionbt/ppa \
    && apt-get update && apt-get -y install transmission-daemon

## Add transmission-daemon settings file
ADD files/settings.json /etc/transmission-daemon/settings.json

## Add bolcklist-update cronjob
ADD files/blocklist-update /etc/cron.daily/blocklist-update
RUN chmod +x /etc/cron.daily/blocklist-update

## Increase max file watches
ADD files/60-max-file-watches.conf /etc/sysctl.d/60-max-file-watches.conf

## Add and chmod the run file
ADD files/run.sh /run.sh
RUN chmod +x /run.sh

## Add docker volumes
VOLUME /srv/downloads /var/lib/transmission-daemon/info

## Expose ports
EXPOSE 9091 51413

## Default command
CMD ["/run.sh"]
