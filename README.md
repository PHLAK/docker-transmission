docker-transmission
===================

Docker image for Transmission Daemon.

[![](https://badge.imagelayers.io/phlak/transmission:latest.svg)](https://imagelayers.io/?images=phlak/transmission:latest 'Get your own badge on imagelayers.io')


### Running the container

The most basic command to get a running container (see below for advanced configurations):

    docker run -d -v /local/downloads:/srv/downloads -p 9091:9091 -p 51413:51413/udp --name transmission-daemon phlak/transmission

**NOTE:** The default RPC web interface username/password is `transmission`/`transmission`, however
this can be overridden with optional environment variabe arguments (see below).


##### Optional arguments

`-v /local/watchdir:/srv/watchdir` - Map a directory (i.e. /local/watchdir) on the host OS that
                                     Transmission will monitor for .torrent files

`--restart always` - Always restart the container regardless of the exit status. See the Docker
                     [restart policies](https://goo.gl/OI87rA) for additional details.


##### Modifying Transmission Daemon settings

In order to modify the Transmission Daemon settings stop the running container then modify the
`settings.json` file by connecting to the container via an interactive, disposable container:

    docker stop transmission-daemon
    docker run -it --rm --volumes-from transmission-daemon alpine vi /etc/transmission-daemon/settings.json

**NOTE:** If you are running with a data-only container, target the data-only contiainer (i.e.
`transmission-data`) instead of the daemon container.


##### Seting the timezone

In order for alternative speed schedules to work you may need to set the timezone of your container.
You can do this by [lookin up your timezone](https://goo.gl/uy1J6q) and passing the (case sensitive)
value of the `TZ` column to the set timezone script in your running container.

Here's an example for the `America/Phoenix` timezone:

    docker exec transmission-daemon timezone America/Phoenix


-----

##### Running with a data-only container (recommended)

In order to persist configuration data when upgrading your running daemon container you may create a
data-only container to hold this configuration data. This is _highly_ recommended.

    docker create --name transmission-data phlak/transmission echo "Data-only container for transmission-daemon"

After the data-only container has been created run the daemon container with shared volumes volumes
from the data-only container:

    docker run -d -v /local/downloads:/srv/downloads -p 9091:9091 -p 51413:51413/udp --volumes-from transmission-data --name transmission-daemon phlak/transmission


##### Running the container over an OpenVPN tunnel

Place your OpenVPN client configuration file in a directory anywhere on your host system with the
name `openvpn.conf`. You should also place your client certs/keys in this directory if required.
Then run the OpenVPN container and map your local OpenVPN directory to the container volume:

    docker run -d -v /local/dir:/etc/openvpn -p 9091:9091 --privileged --restart=always --name transmission-vpn phlak/openvpn

Once your OpenVPN container is running, start the Transmission Daemon container with a shared
network stack:

    docker run -d -v /local/downloads:/srv/downloads --net container:tranmission-vpn --name transmission-daemon phlak/transmission

**NOTE:** You can (should) combine this method with the data-only container method above. Just
create the data-only contaner first and be sure to run the daemon container with the
`--volumes-from` parameter as above.


-----

**Copyright (c) 2016 Chris Kankewicz <Chris@ChrisKankiewicz.com>**

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
