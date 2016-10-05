docker-transmission
===================

Docker image for Transmission Daemon.

[![](https://images.microbadger.com/badges/image/phlak/transmission.svg)](http://microbadger.com/#/images/phlak/transmission "Get your own image badge on microbadger.com")

Running the Container
---------------------

In order to persist configuration data when upgrading your daemon container you should create a
named data volume. This is not required but is _highly_ recommended.

    docker volume create --name transmission-data

After the data volume has been created run the daemon container with the named data volume:

    docker run -d -v transmission-data:/etc/transmission-data -v /local/downloads:/srv/downloads -p 9091:9091 -p 51413:51413/udp --name transmission-daemon phlak/transmission

**NOTE:** The default RPC web interface username/password is `transmission`/`transmission`.

#### Optional arguments

`-v /local/watchdir:/srv/watchdir` - Map a directory (i.e. /local/watchdir) on the host OS that
                                     Transmission will monitor for .torrent files

`--restart always` - Always restart the container regardless of the exit status. See the Docker
                     [restart policies](https://goo.gl/OI87rA) for additional details.

Modifying Transmission Daemon settings
--------------------------------------

In order to modify the Transmission Daemon settings stop the running container then modify the
`settings.json` file by connecting to the container via an interactive, disposable container:

    docker stop transmission-daemon
    docker run -it --rm --volumes-from transmission-daemon alpine vi /etc/transmission-daemon/settings.json

Seting the Timezone
-------------------

In order for alternative speed schedules to work you may need to set the timezone of your container.
You can do this by [lookin up your timezone](https://goo.gl/uy1J6q) and passing the (case sensitive)
value of the `TZ` column to the set timezone script in your running container.

Here's an example for the `America/Phoenix` timezone:

    docker exec transmission-daemon timezone America/Phoenix


-----

Running the Container Over an OpenVPN Tunnel
--------------------------------------------

Place your OpenVPN client configuration file in a directory anywhere on your host system with the
name `openvpn.conf`. You should also place your client certs/keys in this directory if required.
Then run the OpenVPN container and map your local OpenVPN directory to the container volume:

    docker run -d -v /local/dir:/etc/openvpn -p 9091:9091 --privileged --restart=always --name transmission-vpn phlak/openvpn

Once your OpenVPN container is running, start the Transmission Daemon container with a shared
network stack:

    docker run -d --net container:tranmission-vpn -v transmission-data:/etc/transmission-data -v /local/downloads:/srv/downloads --name transmission-daemon phlak/transmission

Troubleshooting
---------------

Please report bugs to the [GitHub Issue Tracker](https://github.com/PHLAK/docker-transmission/issues).

Copyright
---------

This project is liscensed under the [MIT License](https://github.com/PHLAK/docker-transmission/blob/master/LICENSE).
