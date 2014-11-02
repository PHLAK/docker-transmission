FROM ubuntu:14.04

MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install software-properties-common

RUN apt-add-repository -y ppa:transmissionbt/ppa
RUN apt-get update && apt-get -y install transmission-daemon

ADD files/settings.json /etc/transmission-daemon/settings.json
ADD files/run.sh /run.sh

RUN chmod +x /run.sh
RUN mkdir -p /srv/downloads

VOLUME /srv/downloads

EXPOSE 9091 51413

CMD ["/run.sh"]
