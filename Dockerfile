FROM ubuntu:14.04
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

## Enable noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

## Apt update and install dependencies
RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install software-properties-common wget

## Add transmission-daemon PPA
RUN apt-add-repository -y ppa:transmissionbt/ppa \
    && apt-get update && apt-get -y install transmission-daemon

## Add transmission settings file
ADD files/settings.json /etc/transmission-daemon/settings.json

## Add bolcklist-update cronjob
ADD files/blocklist-update /etc/cron.daily/blocklist-update
RUN chmod +x /etc/cron.daily/blocklist-update

## Increase max file watches
RUN echo "fs.inotify.max_user_watches = 200000" > /etc/sysctl.d/60-max-file-watches.conf

## Add docker volumes
VOLUME /srv/downloads /var/lib/transmission-daemon/info

## Add and chmod the run file
ADD files/run.sh /run.sh
RUN chmod +x /run.sh

## Perform apt cleanup
RUN apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean

## Expose ports
EXPOSE 9091 51413

## Default command
CMD ["/run.sh"]
