FROM ubuntu:14.04

MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install software-properties-common wget

RUN apt-add-repository -y ppa:transmissionbt/ppa \
    && apt-get update && apt-get -y install transmission-daemon

RUN echo "fs.inotify.max_user_watches = 200000" > /etc/sysctl.d/60-max-file-watches.conf

ADD files/settings.json /etc/transmission-daemon/settings.json

ADD files/run.sh /run.sh
RUN chmod +x /run.sh

RUN mkdir -p /srv/downloads
VOLUME /srv/downloads /var/lib/transmission-daemon/info

EXPOSE 9091 51413

CMD ["/run.sh"]
